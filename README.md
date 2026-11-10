# OnePlus 8T (kebab) — Paranoid Android CLO

Standalone device configuration for the OnePlus 8T, intended for
`device/oneplus/kebab` in a Paranoid Android source checkout.

## Status

Initial board and product foundation. This repository registers `aospa_kebab`
and contains board/device configuration, a baseline recovery fstab, firmware
symlink modules and Qualcomm image-generation integration. OnePlus variant
libinit, boot/init scripts, fstab installation and OTA postinstall configuration
are defined. Device-owned source audio configuration is in [docs/audio.md](docs/audio.md).
Power, display, optical fingerprint and legacy camera configuration are also
defined. Alert slider calibration/PA key handling, the PA Oplus sensor multihal,
OnePlus Codec2 configuration and QTI kona thermal reporting are now selected.
QTI AIDL health/recovery, PA Oplus vibrator, OnePlus Bluetooth settings, qcwcn
Wi-Fi and the ODM GNSS configuration are also defined.
Remaining hardware integration, complete manifests/policy and proprietary
dependencies are pending, so the product is not buildable yet.

See [BRINGUP.md](docs/BRINGUP.md) for source comparisons, checks and remaining work,
[INIT_OWNERSHIP.md](docs/INIT_OWNERSHIP.md) for boot/init ownership,
[PA_SOURCE_REQUIREMENTS.md](docs/PA_SOURCE_REQUIREMENTS.md) for the missing PA init hook,
[STORAGE_USB.md](docs/STORAGE_USB.md) for storage and USB review findings,
and [VENDOR_INTEGRATION.md](docs/VENDOR_INTEGRATION.md) for deferred vendor interfaces.

The target PA branch and Android version remain to be confirmed. Kernel and
proprietary vendor tree work is deferred.

## Reference sources

See [REFERENCE_SOURCES.md](docs/REFERENCE_SOURCES.md) for exact source snapshots,
including the PA Oplus tree in `aospa-trees/hardware/oplus`.

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
