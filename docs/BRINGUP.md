> Current state: see [INTEGRATION_STATUS.md](INTEGRATION_STATUS.md). The milestones below include historical checks against the former PA checkout, which is now absent.

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
| Init/fstab | OnePlus init and normal-boot/ramdisk fstab modules are defined. Recovery uses the same source through BoardConfig. QTI AIDL boot control is selected; build/runtime validation remains pending. |
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
  slider, sensors and other HALs. Their initial configuration does not establish
  working hardware.
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
Update-engine and QTI AIDL boot-control packages are selected; vendor integration,
service/policy and OTA runtime checks remain prerequisites for a working flow.

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

## Calcite hardware continuation

The selected PA Oplus tree is now confirmed at `aospa-trees/hardware/oplus`
(clo-oscaro/hardware_oplus calcite, `cc126d9`). It supplies the fingerprint wrapper
but no amplifier, UDFPS library or Lineage touch/KeyHandler modules. Device-local
amplifier/UDFPS implementations use the verified source interfaces; touch and
slider work must follow PA APIs rather than importing absent Lineage modules.

The power selection avoids the source recipe's undefined power-impl package and
implements the OnePlus double-tap mode through its supported extension hook.
Display recipes are device-owned so conflicting generic properties can be
replaced before inheritance. The RRO preserves kebab panel/brightness resources.
Camera uses the Lineage legacy provider declaration and excludes alioth torch code.

Combined GNU Make parsing used real calcite audio/display recipes in an isolated
source-path map: 68 direct copy destinations had no competing sources, vendor
property overrides did not conflict, and power/UDFPS selectors and selected
packages agreed. External product/vendor inheritance was recorded, not expanded.
AAPT2 compiled the overlay resources; XML/source checks and host init verification
passed. UDFPS compiled/linked against the real calcite extension header and passed
fallback-behavior assertions. The power hook passed host tests with mocked Android
APIs. None of these checks establish a complete Android build or hardware behavior.

## Alert slider, sensors, media and thermal continuation

The historical opkona tree supplies the OnePlus slider calibration contract and
physical state mapping. Calibration is a vendor oneshot after persist mounts;
the device-local Java handler uses PA's actual DeviceKeyHandler interface and
framework overlay arrays. It applies the physical position at boot and on slider
events. Gesture customization remains pending. Initial slider SELinux rules are now
defined, with full-product and enforcing-device checks still required.

Sensors select the platform AIDL multihal bridge with PA Oplus and SSC libraries.
The UDFPS long-press sensor name matches the selected source. The optional SSC
vtable modification is not enabled without vendor ABI evidence. Media removes
the generic QTI media component and preserves four OnePlus Codec2 inputs, with
vendor services/profiles deferred. Thermal selects the existing QTI kona reporter;
the proprietary thermal controller remains a vendor dependency.

Combined isolated Make checks now cover 84 unique direct copy destinations and
check conflicting vendor, system-ext and ODM properties, package choices and
selectors. External product inheritance is still recorded rather than expanded.
The slider host harness compiles the real PA interface with mocked Android APIs;
state mappings, event filtering and invalid inputs passed. Calibration shell
checks, overlay AAPT2 compilation, source/XML comparisons and host init checks
passed. Media performance entries were checked against both vendor and platform
software Codec2 declarations. None establishes an Android build, SELinux access,
vendor ABI compatibility or hardware behavior.

## Health, vibrator and connectivity continuation

Health owns the QTI AIDL boot/recovery product, replacing the generic charging
component and its unselected charger-monitor RC. The selected PA Oplus source
already supplies the OnePlus LED vibrator, so it is selected without copying the
historical implementation. Local init covers the additional sysfs nodes used by
that backend; effect streaming stays disabled.

Bluetooth retains PA common stack integration and adds the OnePlus Hastings/NV,
profile, offload and BQR configuration plus the legacy HIDL transport declaration.
Wi-Fi owns the OnePlus qcwcn flags and service selection, with an installed config
from the platform supplicant generator. It avoids generic kona multi-chip driver
selection; kernel modules and IPACM/tethering integration remain pending. GNSS
preserves the OnePlus ODM file byte for byte and leaves services/manifests with
the deferred OnePlus vendor producer. No generic QCC declaration is added.

Combined Make checks expanded the real QTI health product and common Bluetooth
recipes in addition to device/board and calcite audio/display. They found 96
unique direct copy destinations with no competing sources or conflicting
vendor/system-ext/ODM values. New service packages, selectors, OnePlus Bluetooth
VINTF/properties, Wi-Fi flags/permissions and the supplicant generator passed
source/configuration checks. Blueprint formatting and health/vibrator init checks
passed. Other external inheritance remains recorded rather than expanded. These
checks do not compile the Android product or establish firmware, vendor ABI,
offline charging, radio connectivity, haptic behavior or enforcing policy.

## NFC, USB, boot control, telephony and DRM continuation

NFC selects the PA NXP AIDL V1 HAL with its own extension/manifest, preserving
OnePlus vendor SN100 configuration and the QTI secure-element backend. The local
secure-element declaration matches Lineage's SIM1/SIM2/eSE1 instances. Platform
base products retain NFC app/APEX ownership.

USB directly includes the QTI product with the gadget HAL enabled before recipe
evaluation, normalizes OnePlus property ownership and selects Oplus ODM compositions.
Boot control selects QTI AIDL normal/recovery services and relies on their own
manifest/RC plus the existing OnePlus misc/UFS paths. No block or slot operations
were executed during these checks.

Telephony directly includes the existing common PA recipes before applying
OnePlus network/DPM/IMS values. Radio instances and the unchanged common OnePlus
carrier XML are installed locally. PA resource names for SA/NSA and WFC exist.
The missing Lineage-specific Java recipes are documented rather than selecting
unavailable modules; vendor IMS/framework API reconciliation remains open.
DRM selects source ClearKey and the PA Oplus reference helper, with Widevine and
its manifest kept vendor-owned. The helper's conditional L3 fallback is documented
in drm.md; no working L1/certification result is implied.

Combined Make checks now also expand QTI health/USB and common Bluetooth/telephony
recipes: 110 unique direct copy destinations, no competing copy sources or
conflicting vendor/system-ext/ODM values, correct package/selector ownership and
legacy IPACM selection for 4.19. Source service/fragments and OnePlus manifest/data
comparisons passed. AAPT2 compiled carrier/framework resources, Blueprint formatting
passed, and NFC/USB/boot/ClearKey/helper RCs passed host init verification. Other
external inheritance remains recorded, not expanded. Full Android compilation,
RRO linking, VINTF compatibility, vendor ABI, policy and device tests are pending.

## Security/audio manifests and user-interface resources

Keymaster is removed from the common component dispatcher to avoid a second
Qualcomm blob producer. The OnePlus common/device vendor contracts supply
respectively gatekeeper 1.0 and keymaster 4.1, declared in the device security
manifest. The selected platform audio service supplies an RC but no manifest;
local audio/effect 6.0 and sound-trigger 2.3 declarations now match that ownership.

The Wi-Fi RRO preserves the OnePlus reference's four capability values and targets
PA's WifiCustomization group. Settings combines OnePlus color-mode/scan/refresh
resources with kebab enrollment progress radius. The color values agree with the
framework mode list. SystemUI combines the common icon vibration setting with
unchanged kebab corner masks, status-bar dimensions and portrait/landscape padding.
Modules/packages are unique and original resource partitions are preserved.

assemble_vintf parses and merges all six local device manifest files at target
level 7. This is a local merge check, not a final compatibility result: source
service fragments, vendor manifests and device/framework matrices still need a
complete-product check. All five RRO package names are unique. New RRO inputs
compile with AAPT2, resource names exist in the inspected PA targets, and Blueprint
formatting passes. Named OnePlus inputs are compared to their original source
files; no resource-link/idmap or hardware outcome is claimed. Combined Make
checks retain 110 unique direct copy destinations, select the new RRO packages
and exclude the generic keymaster vendor producer. External inheritance limits
from the previous checks still apply.

## Power estimates, defaults, matrix and initial policy

The unchanged kebab framework power profile adds the reference 4500 mAh and
4+3+1 CPU accounting tables. SettingsProvider seeds OnePlus 8T as the initial
name; supported OnePlus framework haptic/proximity/AOD/SIM defaults are preserved.
Power-profile/table checks and AAPT2 compilation pass. No new measurements or
runtime default/overlay-precedence result is claimed.

BoardConfig selects the actual PA Oplus framework matrix. assemble_vintf parses
that optional contract file; complete QTI/framework/device/vendor compatibility
still requires final product assembly. The common QTI matrix selection remains
conditional on its own source product flags.

The first device policy slice is selected through BOARD_VENDOR_SEPOLICY_DIRS.
A dedicated slider domain reads the exact persist file and writes its calibration
leaf, while system_server only reads the state leaf. Init restores the targeted
persist labels before starting calibration. Separate labels grant the Power HAL
write access to double-tap and sensors multihal read access to fingerprint state.
Executable contexts for those existing HALs come from CLO/platform policy.

Local policy expands with PA macros and compiles with neverallow checks in an
existing different-device reference policy universe; checkfc validates local file
contexts there. Colliding reference genfs entries are replaced only in a temporary
harness. This is not a kebab build: final PA/QTI composition, mappings, backend
policies and runtime labels/access remain pending. Common type/path searches,
source node contracts, host init verification and standalone Make selection checks
also pass. No reference source/build outputs or device data were modified.

## Fingerprint/vibrator/init policy and extraction interfaces

The next policy slice covers executable and node labels for the selected optical
fingerprint wrapper/backend, Oplus LED vibrator and the device-owned ODM script.
Exact fingerprint/radio property contexts and system-ext project-property policy
are selected. The init script remains an explicit synchronous early-boot oneshot.
Reference-policy compile/neverallow checks, file/hwbinder/property context checks,
source-path matching and host init/shell checks pass; full target policy is pending.

The VINTF audit records all 52 Lineage legacy records and twelve known source
fragment providers. Eighteen local/source inputs merge with 28 declared instances;
nine reference records are covered and 43 remain for vendor/WFD/provider review.
The memtrack provider was initially unidentified; the continuation below verifies
its device/qcom/vendor-common source and fragment. Duplicate
injection and strict incomplete-coverage checks fail as intended. This replaces
an assumption of completeness with a concrete unresolved inventory.

Extraction now hosts kebab and sm8250-common modules in the standalone tree.
Their unchanged lists parse as 107 and 2,443 entries, with no overlapping
destinations. Setup help/API registration and Python syntax pass without vendor
output generation. Only reference library module-name suffix handling is adapted;
binary/config/APK fixups are recorded for review rather than applied without
inputs. No vendor/kernel checkout, dump or firmware was acquired.

## Memtrack, DRM/storage policy and init source integration

The QTI memtrack module is verified in device/qcom/vendor-common, with its own
AIDL fragment and RC. Thirteen known source-service fragments plus six local
manifests now merge to 29 instances; the earlier unidentified provider is removed
from the audit. The 43 remaining vendor/WFD reference obligations are unchanged.

The selected Widevine recovery helper now has a DRM-client domain and exact
boolean property, without backend/TEE or generic restart privileges. Fingerprint
persist calibration and ordinary enrollment paths have separate labeling/access.
The reference-policy compile keeps neverallow checks enabled and now explicitly
sets the target's full-Treble/property-owner flags when expanding local macros.
No target-policy/mapping or DRM/fingerprint hardware result is claimed.

A patch staged under patches/system-core wires PA's existing vendor-init defaults
into the final normal/recovery second-stage binaries and calls the optional device
hook after loading properties, before deriving product identity/fingerprint.
It applies to the recorded PA source and temporary copies with exact expected
output hashes. Host tests cover optional weak/no-provider and whole-archive
provider retention; the device RF/DDR hook tests also pass. Reference source is
unchanged and the patch is not yet integrated into a real build.

The source-readiness tool checks critical module/file providers, recorded VINTF
artifacts and hook consumption. It rejects an unpatched isolated source view and
passes those recorded checks after patching temporary copies. The actual pa
checkout currently reports 11 source-integration gaps, including the unapplied
hook. This is a concrete blocker report, not a complete Soong graph/build test.
Kernel/vendor acquisition, header/config merge, fixups, ABI, complete VINTF/policy
and build/device validation remain deferred.

## Authorized local PA source assembly

The selected PA Oplus repository is installed at hardware/oplus; Sanji calcite
thermal/display/audio snapshots are installed at the canonical paths recorded in
source-assembly.json. Independent local Git clones preserve the reference sources.
The previous thermal checkout at vendor/qcom/opensource/thermal-hal is backed up
outside the build tree to avoid duplicate service definitions. A local repo
manifest records the replacements and excludes that old thermal project.

The init patch is now applied and committed in pa/system/core on kebab-init-hook
at eee4afd. Both patched-file hashes match the prepared outputs. The actual pa
source-provider/hook audit passes, replacing the previous eleven reported gaps.
Nineteen actual source/local manifests merge to 29 instances; selected snapshot
hashes and source worktrees are clean. The 43 vendor/WFD reference records remain
unresolved. No full product configuration/build, kernel/vendor fetch or device
validation was performed. See source-assembly.md for the current scope.
