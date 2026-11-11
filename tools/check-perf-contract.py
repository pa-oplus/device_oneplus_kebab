#!/usr/bin/env python3
# Copyright (C) 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
"""Verify configuration and exact client/interface snapshots reviewed for stock perf."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--system-perf-root", type=Path, required=True)
    parser.add_argument("--interfaces-root", type=Path, required=True)
    parser.add_argument("--vendor-root", type=Path, required=True)
    args = parser.parse_args()
    contract = json.loads((ROOT / "docs/perf-client-contract.json").read_text())
    device = (ROOT / "device.mk").read_text()
    if not re.search(r'^PRODUCT_SHIPPING_API_LEVEL\s*:=\s*30\s*$', device, re.M):
        raise ValueError("Review perf version selection before changing the shipping API")
    components = re.search(r'^TARGET_COMMON_QTI_COMPONENTS\s*:=((?:[^\n]*\\\n)*[^\n]*)', device, re.M)
    if not components or "perf" in components[1].replace("\\", " ").split():
        raise ValueError("Generic common vendor perf must remain excluded")
    if "include device/qcom/common/system/perf/qti-perf.mk" not in device:
        raise ValueError("PA system perf clients are no longer selected")
    for expected in contract["clients"]:
        path = args.system_perf_root / expected["path"]
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected["sha256"]:
            raise ValueError(f"Client changed; re-review its protocol dispatch: {path}")
        symbols = subprocess.check_output(["readelf", "--dyn-syms", "--wide", str(path)], text=True)
        demangled = subprocess.check_output(["c++filt"], input=symbols, text=True)
        for name in ("AServiceManager_isDeclared", "V2_2::IPerf::tryGetService", "get_perf_hal_ver", "isHalTypeAidl()"):
            if name not in demangled:
                raise ValueError(f"Missing reviewed client entrypoint {name}: {path}")
    for expected in contract["interfaces"]:
        path = args.interfaces_root / expected["path"]
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected["sha256"]:
            raise ValueError(f"Perf interface changed; review its ABI/variants: {path}")
    paths = list((ROOT / "configs/vintf").glob("manifest-*.xml"))
    paths += list((args.vendor_root / "proprietary").glob("*/etc/vintf/manifest/*.xml"))
    perf = []
    for path in paths:
        for hal in ET.parse(path).getroot().findall("hal"):
            if hal.findtext("name") == "vendor.qti.hardware.perf2":
                raise ValueError(f"AIDL perf2 declaration changes the client dispatch: {path}")
            if hal.findtext("name") == "vendor.qti.hardware.perf":
                perf.append(hal)
    if len(perf) != 1 or perf[0].findtext("version") != "2.2" or \
            perf[0].findtext("interface/name") != "IPerf" or perf[0].findtext("interface/instance") != "default":
        raise ValueError("Expected exactly one recorded HIDL 2.2/default declaration")
    print("PASS: exact reviewed arm/arm64 dual-protocol clients, interface snapshots, API 30 and HIDL-only recorded backend.")
    print("Runtime dispatch, linker variants, full-product declarations and SELinux remain untested.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, ET.ParseError, subprocess.CalledProcessError) as error:
        print(f"Perf contract check failed: {error}", file=sys.stderr)
        sys.exit(1)
