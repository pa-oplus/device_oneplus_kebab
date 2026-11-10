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
| QTI ownership | Select the same initial component list as alioth. PA's `vendor/aospa/target/product/aospa-target.mk` already inherits `device/qcom/common/common.mk`; avoid a second inheritance. |
| Audio/perf | Initial common component selection only. No stock Xiaomi HAL, stub perf client, blob overrides, Dolby or framework workaround is imported. Final OnePlus implementations remain pending. |
| Init/fstab | Fstab currently supplies the recovery reference. Its normal-boot and ramdisk modules, device init and boot control are not implemented yet. |
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

- PA product registration, identity, root Soong namespace and image generation.
- Normal boot/ramdisk fstab installation, OnePlus libinit and init services.
- OnePlus audio flags/configuration, UDFPS, touch, slider, sensors and other HALs.
- Device manifests, property files, overlays and SELinux policies.
- Vendor includes and extraction interfaces once their layout is decided.

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
