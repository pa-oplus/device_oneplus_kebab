# Deferred vendor integration

No proprietary vendor sources are included or fetched at this stage. The new
standalone device tree initially retains the two vendor outputs referenced by
Lineage's kebab and sm8250-common device configuration. Combining device source
configuration does not by itself combine generated vendor outputs.

## Expected interfaces

Paths below are relative to the Android source root, not this repository.

| Producer | Product makefile | Board configuration |
|---|---|---|
| OnePlus sm8250 common extraction | `vendor/oneplus/sm8250-common/sm8250-common-vendor.mk` | `vendor/oneplus/sm8250-common/BoardConfigVendor.mk` |
| OnePlus kebab extraction | `vendor/oneplus/kebab/kebab-vendor.mk` | `vendor/oneplus/kebab/BoardConfigVendor.mk` |

These are recorded interfaces, not active includes. When vendor integration is
implemented, inherit the common product before the device product, matching
Lineage's current effective order, and include the common board configuration
before the kebab board configuration. Resolve duplicate package/copy ownership
with common QTI components before enabling those dependencies. If extraction
later generates a unified vendor tree, update both product and board references
in the same change.

Required vendor dependencies should use strict product/board includes when wired.
Do not hide missing proprietary trees behind optional includes and report a
successful configuration as a complete build.

## Firmware link contract

The two modules in `Android.bp` preserve the OnePlus reference destinations:

| Installed vendor-relative link | Absolute target |
|---|---|
| `firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini` | `/odm/vendor/etc/wifi/WCNSS_qcom_cfg.ini` |
| `firmware/wlan/qca_cld/wlan_mac.bin` | `/mnt/vendor/persist/qca6390/wlan_mac.bin` |

The common Lineage blob list includes `odm/vendor/etc/wifi/WCNSS_qcom_cfg.ini`.
The WLAN MAC file belongs to device persist data, not a file to manufacture or
copy from another handset. Preserve the corresponding mount and provisioning
behavior during OnePlus init integration. Defining a link does not establish
that its target is available at runtime.

## Before enabling vendor integration

- Confirm the chosen proprietary source versions, extraction format and generated paths.
- Compare common QTI package/configuration ownership against both OnePlus blob lists.
- Resolve audio HAL/effects, power/perf and media ABI choices before applying fixups.
- Reconcile manifests, init services, security patch metadata and SELinux policy.
- Wire strict includes and verify missing-dependency failures as well as the complete product.

Kernel/vendor acquisition, extraction and generated vendor makefiles remain
outside the current five-step implementation batch.
