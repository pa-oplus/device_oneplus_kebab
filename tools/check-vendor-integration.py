#!/usr/bin/env python3
# Copyright (C) 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
"""Audit the unified vendor inputs and explicit device/vendor contracts, read-only."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]


def sha(path, algorithm="sha1"):
    h = hashlib.new(algorithm)
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vendor-root", type=Path, required=True)
    parser.add_argument("--extract-utils", type=Path, required=True)
    parser.add_argument("--compat-root", type=Path, required=True,
                        help="PA hardware/lineage/compat source directory")
    parser.add_argument("--reference-root", type=Path,
                        help="directory containing both original TheMuppets vendor clones")
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    vendor = args.vendor_root.resolve()
    sys.path.insert(0, str(args.extract_utils.resolve()))
    from extract_utils.file import FileList
    import extract_utils.module as module_api

    files = FileList(check_elf=True)
    files.add_from_file(str(ROOT / "proprietary-files.txt"))
    seen = set()
    pins = 0
    reference_matches = 0
    for file in files.files:
        if file.dst in seen:
            raise ValueError(f"Duplicate metadata destination: {file.dst}")
        seen.add(file.dst)
        blob = vendor / "proprietary" / file.dst
        if not blob.is_file():
            raise ValueError(f"Missing blob: {file.dst}")
        expected = {x for x in (file.hash, file.fixup_hash) if x}
        digest = sha(blob) if expected or args.reference_root else None
        if expected:
            if digest not in expected:
                raise ValueError(f"Pin mismatch: {file.dst}")
            pins += 1
        if args.reference_root:
            candidates = [args.reference_root / name / "proprietary" / file.dst for name in (
                "proprietary_vendor_oneplus_kebab", "proprietary_vendor_oneplus_sm8250-common")]
            candidates = [p for p in candidates if p.is_file()]
            if len(candidates) != 1 or sha(candidates[0]) != digest:
                raise ValueError(f"Reference content/ownership mismatch: {file.dst}")
            reference_matches += 1
    provenance = json.loads((vendor / "SOURCE_PROVENANCE.json").read_text())
    if len(seen) != provenance["files"] or sha(ROOT / "proprietary-files.txt", "sha256") != \
            provenance["merged_list_sha256"]:
        raise ValueError("Metadata differs from the published vendor provenance")
    if (ROOT / "proprietary-files.txt").read_bytes() != \
            (vendor / "provenance/proprietary-files.txt").read_bytes():
        raise ValueError("Device/vendor metadata copies differ")

    # Generate in an isolated root from the actual extractor; never extract/fix blobs.
    with tempfile.TemporaryDirectory(prefix="kebab-vendor-check-") as name:
        staging = Path(name)
        device = staging / "device/oneplus/kebab"
        device.mkdir(parents=True)
        shutil.copy2(ROOT / "proprietary-files.txt", device / "proprietary-files.txt")
        output = staging / "vendor/oneplus/kebab"
        output.mkdir(parents=True)
        (output / "proprietary").symlink_to(vendor / "proprietary", target_is_directory=True)
        module_api.android_root = str(staging)
        spec = importlib.util.spec_from_file_location("kebab_extract", ROOT / "extract-files.py")
        definition = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(definition)
        if hasattr(definition, "common_module"):
            raise ValueError("Obsolete common producer remains active")
        definition.module.parse(False, None)
        definition.module.write_makefiles(False, False)
        for name in ("Android.bp", "Android.mk", "BoardConfigVendor.mk", "kebab-vendor.mk"):
            if (output / name).read_bytes() != (vendor / name).read_bytes():
                raise ValueError(f"Regenerated file differs: {name}")

    bp = (vendor / "Android.bp").read_text()
    names = re.findall(r'^\s*name:\s*"([^"]+)"', bp, re.M)
    local_names = []
    for path in ROOT.rglob("Android.bp"):
        local_names.extend(re.findall(r'^\s*name:\s*"([^"]+)"', path.read_text(), re.M))
    if len(names) != len(set(names)) or set(names) & set(local_names):
        raise ValueError("Duplicate vendor/local Blueprint modules")
    device_mk = (ROOT / "device.mk").read_text()
    vendor_mk = (vendor / "kebab-vendor.mk").read_text()
    copies = re.compile(r'^\s*(\S+):(\$\(TARGET_COPY_OUT_[A-Z_]+\)/\S+)\s*\\?$', re.M)
    owners = {}
    for owner, text in (("device.mk", device_mk), ("kebab-vendor.mk", vendor_mk)):
        for source, destination in copies.findall(text):
            if destination in owners:
                raise ValueError(f"Duplicate explicit copy: {destination}: {owners[destination]}, {owner}")
            owners[destination] = owner
    if "vendor/oneplus/sm8250-common" in bp + vendor_mk + (ROOT / "extract-files.py").read_text():
        raise ValueError("Obsolete common-vendor import")
    if "$(call inherit-product, vendor/oneplus/kebab/kebab-vendor.mk)" not in device_mk or \
            "\ninclude vendor/oneplus/kebab/BoardConfigVendor.mk" not in (ROOT / "BoardConfig.mk").read_text():
        raise ValueError("Unified vendor includes are not strict")

    compat_bp = (args.compat_root / "Android.bp").read_text()
    for name, flag, source, symbols in (
        ("libcamera_metadata_shim", "vendor: true", "libcamera_metadata/camera_metadata.cpp",
         ["add_camera_metadata_entry", "update_camera_metadata_entry"]),
        ("libcrypto_shim", "vendor_available: true", "libcrypto/cbs.c", ["CBS_init"]),
    ):
        block = next((x for x in re.findall(r'^cc_library(?:_shared)? \{.*?^\}', compat_bp, re.M | re.S)
                      if f'name: "{name}"' in x), "")
        if flag not in block or any(symbol not in (args.compat_root / source).read_text()
                                   for symbol in symbols):
            raise ValueError(f"Missing vendor provider contract: {name}")
    perf_exports = ["perf_lock_acq", "perf_lock_rel", "perf_hint", "perf_get_prop"]
    for libdir in ("lib", "lib64"):
        symbols = subprocess.check_output([
            "readelf", "--dyn-syms", "--wide",
            str(vendor / "proprietary/vendor" / libdir / "libqti-perfd-client.so")], text=True)
        exported = {line.split()[-1].split("@")[0] for line in symbols.splitlines()
                    if line.split() and " UND " not in line}
        if not set(perf_exports) <= exported:
            raise ValueError(f"Missing Power HAL perf entrypoints: {libdir}")
    report = {
        "files": len(seen), "allowed_pins": pins, "reference_content_matches": reference_matches,
        "unique_vendor_modules": len(names), "local_vendor_module_collisions": 0,
        "explicit_copy_collisions": 0, "generated_build_files_identical": 4,
        "compatibility_provider_definitions": ["libcamera_metadata_shim", "libcrypto_shim"],
        "perf_client_exports_checked": {"arm": perf_exports, "arm64": perf_exports},
        "limits": "Static explicit contracts only: no full module graph/variant/symbol-version, product build, ABI, policy or device validation.",
    }
    if args.report:
        args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Vendor integration audit failed: {error}", file=sys.stderr)
        sys.exit(1)
