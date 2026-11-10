#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
"""Two OnePlus vendor producers hosted by the standalone kebab device tree."""
from pathlib import Path
import sys

# When installed at device/oneplus/kebab, use that Android checkout's helper.
sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "tools/extract-utils"))

from extract_utils.fixups_lib import lib_fixups as default_lib_fixups
from extract_utils.main import ExtractUtils, ExtractUtilsModule


def lib_fixup_vendor_suffix(lib, partition, *args, **kwargs):
    return f"{lib}_vendor" if partition in ("odm", "vendor") else None


# Preserve reference module-name aliases, not unverified binary patches.
common_lib_fixups = {
    **default_lib_fixups,
    (
        "com.qti.stats.pdlib",
        "com.qualcomm.qti.dpm.api@1.0",
        "libmmosal",
        "vendor.qti.hardware.wifidisplaysession@1.0",
        "vendor.qti.imsrtpservice@3.0",
    ): lib_fixup_vendor_suffix,
}

module = ExtractUtilsModule(
    "kebab",
    "oneplus",
    namespace_imports=["vendor/oneplus/sm8250-common"],
)

common_module = ExtractUtilsModule(
    "sm8250-common",
    "oneplus",
    device_rel_path="device/oneplus/kebab",
    skip_main_proprietary_file=True,
    lib_fixups=common_lib_fixups,
    namespace_imports=[
        "device/oneplus/kebab",
        "hardware/oplus",
        "hardware/qcom/wlan/qcwcn",
    ],
)
common_module.add_proprietary_file("proprietary-files-common.txt")

if __name__ == "__main__":
    # No automatic common-device checkout or vendor download is performed here.
    ExtractUtils(module, [common_module]).run()
