# Local PA source assembly

The integration checkout is `pa/`. Shared Kona dependencies follow the alioth
manifest in `pa-sanji/android_vendor_aospapengu` at calcite commit `087cf18e`.
The following independent local clones are installed; full hashes are recorded
in source-assembly.json.

| Build path | Repository | Calcite commit |
|---|---|---|
| hardware/qcom/gps | pa-sanji/android_hardware_qcom_gps | e822feb886a5 |
| hardware/qcom/display | pa-sanji/android_hardware_qcom_display | 86a98cacda4e |
| hardware/qcom/media | pa-sanji/android_hardware_qcom_media | 96e7eebd6c6b |
| vendor/qcom/opensource/usb | pa-sanji/android_vendor_qcom-opensource_usb | 9ae3e810143d |
| vendor/qcom/opensource/audio-hal/primary-hal | pa-sanji/android_hardware_qcom_audio | da8e3bed19be |
| build/make | pa-sanji/build_make | 08b66c720fbc |
| build/soong | pa-sanji/build_soong | 02938b5924ad |
| device/qcom/common | pa-sanji/android_device_qcom_common | 995303ab9aa7 |
| hardware/samsung-ext/interfaces | pa-sanji/hardware_samsung-extra_interfaces | 697f9cb76911 |
| device/qcom/sepolicy_vndr | pa-sanji/android_device_qcom_sepolicy_vndr | d6709e1b2b13 |
| system/libhwbinder | pa-sanji/android_system_libhwbinder | a76d5def4843 |
| frameworks/av | pa-sanji/frameworks_av | 6c91a1be53cf |
| build/release | pa-sanji/android_build_release | b8badbd159ed |
| device/qcom/sepolicy | pa-sanji/device_qcom_sepolicy | f074369b27d8 |
| hardware/interfaces | pa-sanji/hardware_interfaces | 35664468268e |
| packages/modules/Connectivity | pa-sanji/packages_modules_Connectivity | 7989a13dcc89 |
| vendor/qcom/opensource/power | pa-sanji/vendor_qcom_opensource_power | 879bf8053232 |
| hardware/oplus | clo-oscaro/hardware_oplus | cc126d9674aa |
| hardware/qcom/thermal | pa-sanji/android_hardware_qcom_thermal | 339ecff03f75 |

## Kebab selections

The PA Oplus source from aospa-trees remains selected. Thermal stays at
hardware/qcom/thermal; the old vendor/qcom/opensource/thermal-hal path is absent
to avoid duplicate modules. The current AIDL NXP NFC stack is retained instead
of importing alioth’s legacy HIDL NFC projects. Xiaomi camera, device, hardware,
vendor and kernel projects are excluded. No kernel source was acquired.

The existing PA vendor/aospa configuration is retained. Sanji’s PenguinOS vendor
product adds its own apps and defaults, so it is a reference rather than a
replacement. Its camera extension bridge and updater perf policy are not applied
by this source setup; enabling those features requires a separate kebab review.
The original PA frameworks/base and frameworks/native checkouts are retained.
The PenguinOS framework forks were excluded after scope correction; their clones
are preserved under excluded-penguin in the alignment backup. The 17 selected
shared repositories still require complete product dependency/build validation.

## Local changes and backups

The original Soong Ninja/RBE edits were saved and reapplied without conflicts.
Only ui/build/config.go and ui/build/rbe.go differ from the selected Soong commit.
A reverse-apply check verifies that the saved patch is present.

Replaced working trees and the previous manifests are preserved outside PA at
`pa-kona/backups/pa-calcite-shared-1cb8m11j`.
The installed.json file there records previous commits/status and selected
revisions. Original repo-managed Git stores remain under pa/.repo.

The earlier thermal backup remains at `pa-kona/backups/pa-source-assembly-lqks196g`.
The device init hook remains committed in system/core as `eee4afd` on
`kebab-init-hook`; this alignment did not modify system/core.

## Manifest and verification

The local .repo/local_manifests/kebab-source-integration.xml records the selected
repositories and branch overrides. A matching tracked copy is in
manifests/kebab-source-integration.xml. Build entrypoint links are preserved.
Repo manifest expansion confirms one project at each selected path. Existing
vendor/aospa translations and prebuilt projects remain intact.

These are standalone clones rather than newly synced repo object stores. No
repo sync or force-sync was run. Future synchronization must account for those
clones and preserve the local Soong edits and system/core init-hook commit.

Source hashes, manifest path uniqueness, links and working-tree state were
verified. The critical source-provider/init-hook check passes. The recorded VINTF
check passes for 19 fragments and 29 unique instances, with 43 legacy reference
records still unresolved. These checks do not prove complete product dependency,
ABI, policy, VINTF or runtime compatibility.

Kernel/header integration, vendor activation and compatibility work, complete
product build and device validation remain pending.
