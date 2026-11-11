#!/usr/bin/env python3
# Copyright (C) 2026 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
"""Check the single producer and unique merged metadata destinations."""
import argparse
import importlib.util
from pathlib import Path
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--extract-utils", type=Path, default=ROOT.parents[2] / "tools/extract-utils")
    args = parser.parse_args()
    sys.path.insert(0, str(args.extract_utils))
    from extract_utils.file import FileList

    spec = importlib.util.spec_from_file_location("kebab_extraction", ROOT / "extract-files.py")
    definition = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(definition)
    modules = [definition.module]
    assert [m.device for m in modules] == ["kebab"]
    assert all(m.device_rel_path == "device/oneplus/kebab" for m in modules)
    assert not hasattr(definition, "common_module")
    assert not (ROOT / "proprietary-files-common.txt").exists()
    destinations = {}
    total = 0
    for name in ("proprietary-files.txt",):
        files = FileList(check_elf=True)
        files.add_from_file(str(ROOT / name))
        count = 0
        for file in files.files:
            if file.dst in destinations:
                raise ValueError(f"Duplicate destination {file.dst}: {destinations[file.dst]}, {name}")
            destinations[file.dst] = name
            count += 1
        total += count
        print(f"{name}: {count} parsed entries")
    print(f"{total} unique destinations; one vendor producer; no extraction or makefile generation run.")
    print("Reference fixups and final ABI/module ownership remain unvalidated.")


if __name__ == "__main__":
    main()
