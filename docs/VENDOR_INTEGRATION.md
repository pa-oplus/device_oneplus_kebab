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

## Connectivity ownership established during bring-up

- Bluetooth: OnePlus vendor HIDL 1.0 transport/RC, libbtnv and controller firmware;
  the device declares its baseline HAL instance and PA common owns stack integration.
- Wi-Fi: OnePlus cnss-daemon, vendor supplicant overlays and ODM WCNSS config;
  source AIDL service/qcwcn libraries and generated base config are device-selected.
- GNSS: OnePlus 2.1 service/RC and Android/vendor.qti.gnss manifests, support
  libraries/daemons and vendor configs; the device owns only ODM gps.conf and the
  feature permission. Do not also inherit the generic source GNSS product.

Reconcile extraction and module/manifest ownership before enabling the vendor
includes. The chosen init services and manifests must agree with actual binaries.

## Additional service ownership established

- NFC: source NXP AIDL V1 HAL; OnePlus vendor libnfc configuration/SN100 firmware.
- Secure element: OnePlus ODM QTI HIDL 1.2 backend; local SIM1/SIM2/eSE1 declaration.
- USB and boot control: selected source services install their own manifests/RCs;
  Oplus USB compositions are ODM data from hardware/oplus.
- Radio/IMS: local legacy radio/config declarations and carrier overlay; OnePlus
  vendor RIL/IMS/modem outputs plus PA's common framework/data integration must be
  reconciled together before enabling strict vendor includes.
- DRM: source ClearKey fragment and PA Oplus reference helper; OnePlus ODM Widevine
  1.3 service/OEMCrypto/manifest and QSEECom outputs. WFD/HDCP is still separate.

## Security and audio manifest boundary

The common OnePlus vendor producer owns QTI gatekeeper 1.0 and keymaster libraries;
the kebab producer owns the QTI keymaster 4.1 service/RC. Generic QTI keymaster
vendor inheritance is disabled to avoid competing producers. Their default
instances are declared by manifest-security.xml. Source audio/effect 6.0 and
sound-trigger 2.3 use manifest-audio.xml. Vendor extraction must not add duplicate
fragments for these locally declared instances.
