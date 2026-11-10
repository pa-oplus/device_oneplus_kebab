#!/usr/bin/env python3
# Copyright (C) 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
"""Audit critical source providers and actual init-hook consumption, read-only."""
import argparse
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def module_present(path, name):
    text = path.read_text()
    if path.suffix == ".bp":
        return re.search(r'\bname:\s*"' + re.escape(name) + r'"', text) is not None
    return re.search(r"^LOCAL_MODULE\s*:?=\s*" + re.escape(name) + r"\s*$", text, re.M) is not None


def init_hook_integrated(source):
    bp = (source / "init/Android.bp").read_text()
    blocks = re.findall(r"^cc_binary \{.*?^\}", bp, re.M | re.S)
    for name in ("init_second_stage", "init_second_stage.recovery"):
        block = next((b for b in blocks if f'name: "{name}"' in b), "")
        defaults = re.search(r"\bdefaults:\s*\[([^]]*)\]", block, re.S)
        if not defaults or '"vendor_init_defaults"' not in defaults[1]:
            return False
    prop = (source / "init/property_service.cpp").read_text()
    start = prop.find("void PropertyLoadBootDefaults()")
    if start < 0:
        return False
    hook = prop.find("::vendor_load_properties();", start)
    identity = prop.find("    property_initialize_ro_product_props();", start)
    return start < hook < identity and "void vendor_load_properties()" in prop


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", type=Path, required=True)
    args = parser.parse_args()
    source = args.source_root.resolve()
    requirements = json.loads((ROOT / "docs/source-requirements.json").read_text())
    gaps = []
    for provider in requirements["module_providers"]:
        path = source / provider["path"]
        if not path.is_file() or not module_present(path, provider["module"]):
            gaps.append(f"provider {provider['module']} at {provider['path']}")
    for path in requirements["required_files"]:
        if not (source / path).is_file():
            gaps.append(f"required source file {path}")
    for provider in json.loads((ROOT / "docs/vintf-ownership.json").read_text())["source_fragments"]:
        if not (source / provider["path"]).is_file():
            gaps.append(f"source VINTF fragment {provider['path']}")
    core = source / "system/core"
    if not all((core / path).is_file() for path in ("init/Android.bp", "init/property_service.cpp")):
        gaps.append("system/core init sources")
    elif not init_hook_integrated(core):
        gaps.append("device init hook not consumed by normal/recovery second-stage init")
        patch = ROOT / "patches/system-core/0001-init-load-device-properties.patch"
        check = subprocess.run(["git", "-C", str(core), "apply", "--check", str(patch)],
                               capture_output=True, text=True)
        print("Staged init patch: " + ("applies cleanly (not applied)" if check.returncode == 0
                                     else "needs adaptation for this source"))
    if gaps:
        for gap in gaps:
            print("MISSING: " + gap)
        print(f"Recorded source audit: BLOCKED by {len(gaps)} gap(s).")
    else:
        print("Recorded source-provider and init-hook checks pass.")
    print("Still deferred; no build-readiness claim:")
    for item in requirements["deferred_checks"]:
        print("  - " + item)
    return 1 if gaps else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"Source audit failed: {error}", file=sys.stderr)
        sys.exit(1)
