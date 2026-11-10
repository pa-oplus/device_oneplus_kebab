# Foundation decisions

This is an incremental configuration, not a buildable product yet. The local
`pa/` checkout was used read-only to check PA build interfaces; its manifest
selects `calcite` and `android-17.0.0_r1`. Selecting that checkout as the final
build target remains open.

| Area | Decision and evidence |
|---|---|
| Architecture | Preserve Lineage sm8250-common's arm64 + arm configuration and runtime CPU variants. Alioth's compiler tuning is not a hardware requirement. |
| Boot/recovery | Preserve Lineage kebab header v2, separate recovery, DTB-in-boot and DTBO sizes. Do not add alioth's vendor_boot partition. |
| Dynamic partitions | Preserve kebab's super size, OnePlus group size and partition list. The group is sized per A/B slot; do not substitute alioth's full-super-sized group. |
| Filesystems | Preserve Lineage's ext4 system/product/system_ext and EROFS vendor/odm. Recovery fstab is copied from kebab with only its trailing blank line removed, retaining its license. |
| AVB | Preserve Lineage's RSA4096 system chain and rollback location 1, including its bring-up verification-disable flags. Production signing is not configured. |
| Product reserve | Preserve kebab's 800,000,000-byte vanilla product reserve, gated by PA's `TARGET_DISABLES_GMS`. Reassess image fit when the final product is assembled. |
| QTI ownership | Start from alioth's component list, then remove `audio` because its source recipe and configuration are now device-owned. PA's `vendor/aospa/target/product/aospa-target.mk` already inherits `device/qcom/common/common.mk`; avoid a second inheritance. |
| Audio/perf | Source audio is device-owned with OnePlus configuration; see `docs/audio.md`. Performance integration remains pending. No stock Xiaomi HAL, stub perf client, Dolby or framework workaround is imported. |
| Init/fstab | OnePlus init and normal-boot/ramdisk fstab modules are defined. Recovery uses the same source through BoardConfig. Boot control HAL integration and runtime validation remain pending. |
| Kernel | Record 4.19, `kernel/oneplus/sm8250`, base defconfig `vendor/kona-perf_defconfig` and LLVM support. No compiler version is selected without kernel evidence. |

## Kernel configuration blocker for later build integration

Lineage uses `vendor/kona-perf_defconfig vendor/oplus.config` through its kernel
build system. The inspected CLO `kernel_definitions.mk` passes `KERNEL_DEFCONFIG`
as a shell assignment to `buildkernel.sh`; a space-separated list cannot be
assumed to work. `device/qcom/kernelscripts/legacy_definitions.mk` maps
`TARGET_KERNEL_CONFIG` directly to that variable. For this foundation, record the
base defconfig only and leave merging `vendor/oplus.config` explicitly pending.
Before any kernel build, establish a supported merge or a combined defconfig and
check the resulting configuration. Do not build this baseline without that step.

## Remaining integration

- Complete hardware integration behind the registered PA product.
- External PA libinit hook integration and validation of init dependencies against
  kernel/vendor outputs; see [INIT_OWNERSHIP.md](INIT_OWNERSHIP.md).
- Source-audio dependencies, ABI/VINTF/policy and runtime checks; UDFPS, touch,
  slider, sensors and other HALs.
- Device manifests, property files, overlays and SELinux policies.
- Vendor includes and extraction implementation; expected interfaces are recorded in
  [VENDOR_INTEGRATION.md](VENDOR_INTEGRATION.md).

## Verification limits

Foundation checks compare evaluated Make variables against both Lineage board
files, check the fstab filesystem map, A/B group capacity, AVB chain and the CLO
component list. They also verify the inspected PA sources contain the documented
integration interfaces. These are configuration checks, not Android product
configuration, compilation, recovery/decryption, OTA or boot validation.

Checks performed for this foundation:

- Standalone GNU Make evaluation: 61 shared board values match Lineage after
  external includes are excluded. External product inheritance was not evaluated.
- Separate vanilla/GMS reserve conditions and A/B group capacity checks passed.
- Recovery fstab matches Lineage kebab apart from the removed trailing blank line and its five logical
  partition filesystem types agree with BoardConfig.
- The 17 common QTI selections match alioth and exist in the inspected PA
  component dispatcher. No second common-product inheritance was introduced.
- Platform, kernel-version and shipping-API declarations are consistent.

## Product and build integration

`aospa_kebab.mk` uses the inspected PA alioth/OnePlus product inheritance order:
64-bit-with-32-bit-support base, telephony base, kebab device configuration, then
PA configuration. It retains Lineage's initial OMX-disable choice pending media
integration. Identity uses Lineage's KB2005 default and OnePlus8T property names;
regional handling is in the device libinit, with external hook requirements
recorded in [PA_SOURCE_REQUIREMENTS.md](PA_SOURCE_REQUIREMENTS.md).

`AndroidProducts.mk` registers `aospa_kebab` locally so this repository is
self-contained. Do not also register the same product in `vendor/aospa/products`.
The two-field common lunch choice follows the inspected PA product registry.
For the inspected Android 17 shell, the explicit invocation is
`lunch aospa_kebab trunk_staging userdebug`; this is a configuration target, not
a claim that the incomplete device configuration can build or boot.

The root Soong namespace currently has no imports: the two firmware link modules
have no dependencies on external namespaces. Add hardware imports when selected
OnePlus modules actually require them.

`AndroidBoard.mk` follows the alioth image-generation entry point. A GNU Make
check parsed the real local CLO rules using temporary output paths and verified
separate recovery, the DTBO kernel/tool dependencies, and preservation of an
already-defined `BOARD_PREBUILT_DTBOIMAGE`. No image was generated and no kernel
build was invoked.

Product checks evaluated local identity, registration and nested device
inheritance while recording external base/PA inheritance calls. Their entry paths
exist in the inspected PA checkout; their full transitive configuration was not
evaluated. Blueprint formatting passed with the local prebuilt `bpfmt`.

## Boot/init and OTA configuration

The device libinit maps RF versions 11–15 to the same kebab model names as
Lineage. A host compilation with mocked Android APIs tested all five mappings,
invalid/missing RF versions, property add/update, and DDR input handling. This is
not an Android init build or a device execution test. The inspected PA init lacks
the hook wiring described in `docs/PA_SOURCE_REQUIREMENTS.md`.

Normal boot uses the common QTI init plus OnePlus ODM actions and a target script.
The local ueventd delta contains ten differences from the inspected QTI baseline.
See `docs/INIT_OWNERSHIP.md` for ownership, removed duplicate starts and deferred blob
and kernel checks. Host init verification passed for the local RC files; shell
syntax checking passed for `init.oplus.sh`.

Fstab is installed through the same vendor/ramdisk module definition as Lineage
kebab; recovery receives it through `TARGET_RECOVERY_FSTAB`. Encryption and mount
options are preserved. Postinstall uses Lineage's system ext4/vendor EROFS
configuration with optional otapreopt/checkpoint steps and matching packages.
Update-engine packages are selected; boot control HAL and vendor integration
remain prerequisites for a working OTA flow.

Filesystem consistency and source/module checks passed. No decryption, image
build, OTA update, hardware service behavior or enforcing-policy validation has
been performed.

## Storage, USB and source audio

Storage encryption properties and firmware mount-directory modules preserve the
OnePlus references. `docs/STORAGE_USB.md` records the reviewed filesystem/encryption
contract and unresolved common-QTI versus OnePlus USB gadget/composition settings.
The selected AIDL charger service name matches the device trigger; no offline
charging or USB behavior has been tested.

Audio is now device-owned, so `audio` is removed from the common QTI component
list. The directly included source kona recipe supplies feature flags, while the
local audio configuration normalizes competing HAL packages and copy/property
ownership before PA product inheritance. The OnePlus mixer/platform/policy and
sound-trigger inputs are preserved, including the offload-disabled policy.

The seven local configuration inputs match Lineage byte for byte. XML, route
endpoints, XInclude destinations and copy-map checks passed. Device audio property
sections preserve their original vendor/ODM/system-ext partitions, with replaced
generic legacy-vendor keys removed. The initial source-recipe evaluation used the
then-available `aospa/` checkout. After that source directory disappeared, combined
checks used the existing SM8250 source recipe at
`des/hardware/qcom-caf/sm8250/audio` (`399ade94`) read-only. No checkout was recreated
or fetched. These checks do not validate the missing target audio source graph,
amplifier implementation, final vendor effects/sound-trigger ABI or runtime audio.
