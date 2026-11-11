#!/usr/bin/env python3
# Copyright (C) 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
"""Check declared instance ownership; report unresolved reference contracts."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]


def records(element):
    return {
        "format": element.get("format", "hidl"),
        "name": element.findtext("name"),
        "versions": [e.text for e in element.findall("version")],
        "fqnames": [e.text for e in element.findall("fqname")],
        "interfaces": [
            {"name": i.findtext("name"), "instances": [e.text for e in i.findall("instance")]}
            for i in element.findall("interface")
        ],
    }


def instances(record):
    kind, name = record["format"], record["name"]
    if kind not in ("hidl", "aidl") or not name:
        raise ValueError(f"Unsupported or unnamed HAL: {record}")
    found = set()
    for fqname in record["fqnames"]:
        if kind == "hidl":
            match = re.fullmatch(r"@(\d+)\.(\d+)::([^/]+)/(.+)", fqname)
            if not match:
                raise ValueError(f"Malformed HIDL instance: {fqname}")
            major, _, interface, instance = match.groups()
        else:
            interface, instance = fqname.split("/", 1)
            major = "aidl"
        found.add((kind, name, major, interface, instance))
    for interface in record["interfaces"]:
        versions = record["versions"] or (["1"] if kind == "aidl" else [])
        for version in versions:
            major = version.split(".", 1)[0] if kind == "hidl" else "aidl"
            for instance in interface["instances"]:
                found.add((kind, name, major, interface["name"], instance))
    if not found:
        raise ValueError(f"No concrete instance in {name}")
    return found


def version_floors(record):
    """Required/provided minor for HIDL, interface version for AIDL."""
    values = {}
    for fqname in record["fqnames"]:
        if record["format"] == "hidl":
            match = re.fullmatch(r"@(\d+)\.(\d+)::([^/]+)/(.+)", fqname)
            if not match:
                raise ValueError(f"Malformed HIDL instance: {fqname}")
            major, minor, interface, instance = match.groups()
            key = ("hidl", record["name"], major, interface, instance)
            values[key] = max(values.get(key, -1), int(minor))
        else:
            interface, instance = fqname.split("/", 1)
            key = ("aidl", record["name"], "aidl", interface, instance)
            values[key] = max(int(v) for v in record["versions"] or ["1"])
    for interface in record["interfaces"]:
        for version in record["versions"] or (["1"] if record["format"] == "aidl" else []):
            if record["format"] == "hidl":
                major, minor = version.split(".", 1)
                floor = int(minor)
            else:
                major, floor = "aidl", int(version)
            for instance in interface["instances"]:
                key = (record["format"], record["name"], major, interface["name"], instance)
                values[key] = max(values.get(key, -1), floor)
    if values.keys() != instances(record):
        raise ValueError(f"Versionless or malformed record: {record}")
    return values


def covered(record, provided):
    return all(provided.get(key, -1) >= floor for key, floor in version_floors(record).items())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", type=Path, help="also check recorded source-service fragments")
    parser.add_argument("--extra-manifest", type=Path, action="append", default=[])
    parser.add_argument("--require-reference-coverage", "--require-reference-resolution",
                        dest="require_reference_coverage", action="store_true")
    args = parser.parse_args()
    data = json.loads((ROOT / "docs/vintf-ownership.json").read_text())
    paths = sorted((ROOT / "configs/vintf").glob("manifest-*.xml"))
    if args.source_root:
        paths += [args.source_root / p["path"] for p in data["source_fragments"]]
    paths += args.extra_manifest
    owners = {}
    provided_versions = {}
    override_count = 0
    for path in paths:
        root = ET.parse(path).getroot()
        if root.tag != "manifest" or root.get("type") != "device":
            raise ValueError(f"Not a device manifest: {path}")
        for hal in root.findall("hal"):
            record = records(hal)
            if hal.get("override") == "true":
                allowed = next((o for o in data.get("allowed_vendor_overrides", [])
                                if path.as_posix().endswith("/" + o["path"])
                                and record["name"] == o["name"]), None)
                if not allowed or record["format"] != allowed["format"] or \
                        record["versions"] != allowed["versions"] or \
                        record["interfaces"] != allowed["interfaces"] or record["fqnames"]:
                    raise ValueError(f"Unreviewed vendor override: {path}: {record['name']}")
                keys = instances(record)
                groups = {key[:3] for key in keys}
                for key in list(owners):
                    if key[:3] in groups:
                        del owners[key]
                        del provided_versions[key]
                override_count += 1
            for key in instances(record):
                if key in owners:
                    raise ValueError(f"Duplicate HAL instance {key}: {owners[key]} and {path}")
                owners[key] = str(path)
                provided_versions[key] = version_floors(record)[key]
    retired = {}
    unverified_retirements = []
    for item in data.get("retired_reference_records", []):
        reference = data["reference_hal_records"][item["index"]]
        if reference["name"] != item["name"]:
            raise ValueError(f"Retired reference index/name mismatch: {item}")
        if args.source_root:
            matrix_path = args.source_root / item["matrix_path"]
            if hashlib.sha256(matrix_path.read_bytes()).hexdigest() != item["matrix_sha256"]:
                raise ValueError(f"Optional matrix source changed; review retirement: {matrix_path}")
            candidates = [records(hal) for hal in ET.parse(matrix_path).getroot().findall("hal")
                          if hal.findtext("name") == item["name"]
                          and hal.get("format", "hidl") == reference["format"]
                          and hal.get("optional") == "true"]
            if not any(covered(reference, version_floors(record)) for record in candidates):
                raise ValueError(f"Retired interface is not optional in source: {item['name']}")
        else:
            unverified_retirements.append(item["name"])
        retired[item["index"]] = item
    unresolved = [record for index, record in enumerate(data["reference_hal_records"])
                  if index not in retired and not covered(record, provided_versions)]
    print(f"Checked {len(paths)} manifest inputs; {len(owners)} unique declared instances.")
    print(f"Reference records: {len(data['reference_hal_records']) - len(unresolved) - len(retired)} covered; "
          f"{len(retired)} explicitly not selected; {len(unresolved)} unresolved.")
    for item in retired.values():
        print(f"Not selected: {item['name']}: {item['reason']}")
    if unverified_retirements:
        print("Optional-matrix retirement evidence needs --source-root verification.")
    for provider in data["unresolved_providers"]:
        print(f"Unresolved provider: {provider['module']}: {provider['reason']}")
    print(f"Reviewed vendor override declarations: {override_count} (input order matters).")
    print("This checks recorded declarations, not the complete product or runtime registration.")
    if args.require_reference_coverage and (unresolved or data["unresolved_providers"] or unverified_retirements):
        return 1
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, ET.ParseError) as error:
        print(f"VINTF ownership check failed: {error}", file=sys.stderr)
        sys.exit(1)
