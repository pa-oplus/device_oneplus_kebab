# PA source integration requirements

The device configuration is being prepared against the reference trees and the
local `pa/` checkout. This file records gaps outside the device repository; it
is not a claim that the source patches have been implemented.

## Vendor property initialization

`BoardConfig.mk` selects `//device/oneplus/kebab:libinit_kebab` using
`TARGET_INIT_VENDOR_LIB`, matching the alioth integration contract.

The inspected PA source exports that setting through
`vendor/aospa/target/board/BoardConfigSoong.mk`. Its
`vendor/aospa/soong/Android.bp` defines `vendor_init_defaults`, but the inspected
`system/core/init/Android.bp` does not consume those defaults and
`system/core/init/property_service.cpp` does not call `vendor_load_properties()`.
Consequently, the selector alone will not link or invoke the device library.

Before a full build, verify the final PA branch links the selected library into
normal and recovery init and invokes its property hook after loading partition
properties and before deriving the final `ro.product.*` identity. This needs a
source change outside this tree if the inspected implementation is retained.
A concrete patch is now staged in patches/system-core; it passes apply checks
against the recorded PA source but has not been applied there. It links the
provider into normal/recovery second-stage binaries and calls the hook at that
point. Do not mark regional detection functional before final build/device checks.

The device hook preserves Lineage's five kebab RF-to-model mappings and DDR
property extraction. Unknown or malformed RF versions leave the product's default
model in place. Other sm8250 OnePlus model branches are excluded from this
kebab-only library.

## Platform dependency selection

Use the calcite sources recorded in `docs/REFERENCE_SOURCES.md` for QTI common,
audio, display, power and PA interfaces. The audio source is expected at
`vendor/qcom/opensource/audio-hal/primary-hal`; the local amplifier adaptation
now supplies the missing device implementation. Its kernel-header provider,
private audio interfaces and dependencies still need complete build validation.

The PA Oplus source selected by the user is `aospa-trees/hardware/oplus`, remote
`clo-oscaro/hardware_oplus`, branch calcite (`cc126d9`). Integrate it at
`hardware/oplus`; it imports `hardware/google/interfaces`. Its fingerprint wrapper
is selected. Its tree has no amplifier, UDFPS extension, KeyHandler package or
Lineage touch HAL; do not assume the newer Lineage hardware checkout is a drop-in
replacement. The amplifier, UDFPS extension and alert slider handler are
device-local. The slider uses the inspected PA DeviceKeyHandler hook; touch
gestures still need a compatible implementation. Sensors use the selected PA
Oplus module through the platform AIDL multihal bridge.

The inspected native calcite CompositionEngine consumes
`surfaceflinger/udfps_lib` through a direct Soong select; the device uses that API.
The local UDFPS library currently expects `generated_kernel_headers`. Resolve
that provider and the OnePlus DRM header definitions during kernel integration.

The power source requires its power V6/common interfaces and display-config V12.
Only its actual service is selected; its undefined generic power-impl package is
not inherited. Perf ABI/ADPF support remains dependent on the actual perf provider.
The camera source needs QTI camera interfaces and the final OnePlus vendor HAL.

No dependency is silently skipped by the device-owned audio include. Reference
configuration checks are not a completed Android build or compatibility result.

## Health and connectivity dependencies

Provide QTI healthd-ext at vendor/qcom/opensource/healthd-ext, including its AIDL
boot/recovery services, product recipe and charger images. The selected PA Oplus
source also supplies the vibrator service and its AIDL V1 fragment. Its optional
effect-stream implementation is disabled for the initial kebab LED backend.

Wi-Fi requires hardware/qcom/wlan/qcwcn with libwifi-hal-ctrl and its private
driver-command library, the platform AIDL Wi-Fi service and the existing
wpa_supplicant_conf_gen module in external/wpa_supplicant_8. The device installs
that generator output; a legacy installed wpa_supplicant.conf module is not
assumed. Resolve the OnePlus kernel driver and IPACM/tethering provider separately.

Bluetooth still uses PA common stack inheritance with a OnePlus vendor HIDL 1.0
transport. GNSS uses the OnePlus vendor 2.1 service and vendor.qti.gnss 4.0
fragment. Reconcile those deferred vendor producers and final platform matrices
before treating the selected source APIs as a working combination.

## NFC, A/B and radio dependencies

Provide the inspected NXP SNxxx NFC AIDL V1 service/extension at hardware/nxp/nfc,
with OnePlus SN100 firmware/configuration and QTI secure-element service from the
vendor producer. Do not replace that secure-element backend with the source NXP
service without reconciling instances, config, firmware and API contracts.

QTI hardware/qcom/bootctrl supplies both AIDL boot services and links the GPT
helpers from vendor/qcom/opensource/recovery-ext. The selected calcite USB product
and its AIDL port/gadget services are in vendor/qcom/opensource/usb; PA Oplus
supplies ODM compositions. Validate the final 4.19 kernel configfs/functions.

Common PA telephony recipes require dataservices and legacy IPACM plus external
framework/vendor outputs. Lineage's Java extension modules were not found in the
inspected PA layout; see telephony.md for the remaining IMS API/classpath work.
Do not claim successful standalone Make parsing as resolution of that dependency.
ClearKey is supplied by frameworks/av; the PA Oplus wvmkiller helper requires the
legacy Widevine instance and its restart/property policy. Widevine remains a
OnePlus ODM producer with its own VINTF fragment.

## Security backend and overlays

Gatekeeper/keymaster now belong exclusively to the OnePlus vendor producer, with
local HIDL 1.0/4.1 declarations. The common keymaster component is not inherited;
do not reintroduce its overlapping generic binaries during vendor integration.
Audio 6.0/effect 6.0/sound-trigger 2.3 also have a local manifest because the
selected source service installs its RC without a service-owned fragment.

The new RROs target PA Wi-Fi resources, Settings and SystemUI. Resource name and
input compilation checks do not replace target APK linking, overlayable/idmap
policy or runtime precedence checks. The Wi-Fi values must still agree with the
actual source HAL/firmware capabilities, and panel/enrollment UI needs device
validation at supported densities. Final source/vendor VINTF assembly and complete
matrices remain prerequisites for a full build.

## Initial policy ownership

Device vendor policy now supplies initial slider/power/sensor, fingerprint,
vibrator and ODM-script integrations; it remains incomplete. PA's BoardConfigQcom must still select the
common QTI policy correctly; it provides vendor_persist_type/vendor_persist_file
and the Power HAL executable mapping. Platform policy supplies vendor shell/toybox,
system_server, sensor executable and standard domain macros.

Do not include the entire Oplus policy product without adapting its policy layout
and resolving overlapping genfs labels/Lineage-specific dependencies. A successful
reference-policy compile is not the final product policy test. Complete remaining
service/property/device rules and validate with actual source/vendor policy and
an enforcing device before considering SELinux integration complete.

## Extraction and outstanding interface inventory

The local Python extractor expects the inspected ExtractUtilsModule API, including
device_rel_path and skip_main_proprietary_file, to host both vendor producers
without a sibling common device checkout. Unported fixups and input pins are
explicit dependencies, not verified by metadata parsing. No generated vendor
makefiles are inherited yet.

tools/check-vintf-ownership.py validates recorded declarations and prints unresolved
reference/provider counts. Its strict coverage mode currently fails by design
because vendor/WFD/common-provider reconciliation is unfinished. The selected memtrack provider/fragment is now identified in
device/qcom/vendor-common/memtrack; full ABI/build validation remains pending. See extraction.md and vintf.md for command scope.

## Reproducible source checks

See source-readiness.md and tools/check-source-readiness.py for critical source
providers and init-hook consumption checks. The staged system/core patch is
reviewable and apply-checked, not automatically applied to reference sources.
Normal/recovery binaries require whole-static provider linkage; adding the device
library only to a libinit archive is insufficient for the optional weak hook.
The current pa checkout still needs assembly/integration before a real build.
