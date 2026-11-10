# OnePlus 8T (kebab) — Paranoid Android CLO

Standalone device configuration for the OnePlus 8T, intended for
`device/oneplus/kebab` in a Paranoid Android source checkout.

## Status

Initial skeleton. This repository currently contains documentation only and is
not buildable. Board configuration, product registration and hardware integration
will be added incrementally.

The target PA branch and Android version remain to be confirmed. Kernel and
proprietary vendor tree work is deferred.

## Reference sources

- LineageOS `android_device_oneplus_kebab`, branch `lineage-24.0`.
- LineageOS `android_device_oneplus_sm8250-common`, branch `lineage-24.0`.
- CLO `device_xiaomi_aliothCLO`, branch `calcite`, reviewed at commit
  `80408ea4537a7f625e37cb27d0dcd15809656c72`.

OnePlus references supply device-specific hardware configuration. The alioth
reference supplies examples of PA/CLO integration. Each subsystem will be adapted
to kebab with its dependencies and configuration ownership reviewed explicitly.

## Development record

The workspace-level `../ROADMAP.md` tracks implementation and validation.
`../ALIOTH_FILE_REVIEW.md` records the reviewed alioth snapshot file by file.
These planning documents live outside this repository.

Preserve applicable source copyright and license notices when importing or
adapting implementation files.
