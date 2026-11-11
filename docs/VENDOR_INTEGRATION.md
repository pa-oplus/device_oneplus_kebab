# Device/vendor ownership

The product strictly inherits `vendor/oneplus/kebab/kebab-vendor.mk` and includes
its BoardConfigVendor.mk. There is one proprietary producer and one Soong vendor
namespace. This is activated in the device configuration, but no complete PA
checkout is currently available for a product build.

The source selection remains PA Oplus, source audio, sensors, power, display,
thermal, health, USB, boot control and AIDL NXP NFC. The unified vendor owns the
OnePlus camera/ISP, radio/modem/IMS, fingerprint backend, Widevine, secure element,
gatekeeper/keymaster and other stock proprietary services/libraries. Final source
module variants and the complete install graph still require a product build.

## Compatibility libraries

- `libshims_fingerprint.oplus` is supplied locally under compat/fingerprint with
  the original Lineage source notice preserved. It returns unlocked/orange for
  the fingerprint backend's two verified-boot property reads; other properties
  are forwarded. It does not change the platform property store. Both APIs and
  forwarding were host-tested. Target symbol versioning/interposition is pending.
- `libcamera_metadata_shim` comes from PA hardware/lineage/compat. Its vendor
  library filters SYSTEM_CAMERA capability from metadata insertion/update calls.
  The camera blob already names it as a dependency.
- `libcrypto_shim.vendor` selects the vendor variant of PA's existing compatibility
  module. The Widevine inputs require CBS_init; its source exports that function.
  No duplicate device-local camera or crypto provider is introduced.

The PA reference provider definitions and required source functions were checked.
These are not compiled target-library or full undefined-symbol-resolution tests.

## Perf and power

OnePlus owns vendor perf HIDL 2.2, its RC, six perf config files and both-architecture
client/backend libraries. `perf` is removed from TARGET_COMMON_QTI_COMPONENTS,
which avoids importing the generic common vendor perf stack and its configs.
The common system/perf recipe remains explicitly included for PA framework clients.
The vendor properties select perf HAL 2.2 and libqti-perfd-client.so.

The stock client exports perf_lock_acq, perf_lock_rel, perf_hint and perf_get_prop
in both architectures, matching the dlsym entrypoints of the original PA Power HAL.
The source Power HAL and kebab double-tap mode extension remain selected. The
vendor output supplies OnePlus powerhint.xml, avoiding the previous source/vendor
copy collision. Runtime hint behavior and enum/resource compatibility are untested.

**Reviewed client dispatch:** the PA system client supports both protocols.
The earlier inference that its AIDL dependency established a protocol mismatch
was incorrect. For the exact reviewed arm/arm64 binaries, isHalTypeAidl checks
whether the perf2 instance is declared, then permits HIDL fallback. With no AIDL
perf2 service declared and the shipping API at 30, the reviewed path selects
HIDL 2.2. No bridge or replacement client is selected.

HIDL 2.0/2.1/2.2/2.3 interface providers are explicitly recorded as source
requirements. The 2.3 and AIDL libraries must remain available at load time even
when dispatch selects 2.2. The source/interface variants and actual device policy,
registration, hint/resource behavior and optional system-perf components still
need validation. See perf-client-review.md for byte-identifiable evidence.

## VINTF

The stock perf service has no packaged fragment, so manifest-perf.xml declares
vendor.qti.hardware.perf@2.2::IPerf/default locally. The existing local radio,
secure-element, gatekeeper/keymaster and audio declarations remain in place.

The ODM fingerprint fragment intentionally overrides the standard fingerprint 2.3
entry with the same interface/instance supplied by the PA wrapper, while declaring
the separate Oplus backend. Its bytes and override=true are preserved. The
ownership checker accepts only this recorded override shape; other duplicates or
unreviewed overrides fail. Reference source fragments are processed before vendor
then ODM fragments, matching the relevant override direction.

`assemble_vintf` merges 34 recorded local/reference/vendor fragments into 109
unique instances. Fifty-one legacy records are declared and one unsupported
optional subsystem-radio interface is explicitly not selected. The selected Oplus
matrix verifies its optional status. No service was fabricated for that entry.
Source/provider evidence is in vendor-hal-evidence.json. This is not complete
product matrix compatibility, runtime registration or enforcement validation.

## Legacy provider completion

The provider-backed OnePlus vendor declarations are in manifest-oneplus-vendor.xml.
QCRIL/IMS, CNE, Bluetooth, security, calibration, camera postprocessing and WFD
retain the interface/instance definitions from the matching Lineage manifest.
The evidence ties entries to installed RCs, binaries or loaded implementations;
registration imports are recorded where available. Runtime behavior remains open.

PA's audio service lacked QTI Bluetooth factory registration. A narrow source patch
adds the existing vendor 2.0 passthrough factory to its optional list. This patch
is staged and source-readiness requires it; it is not applied to a live PA tree.

The source manifest pins a Lineage IPACM implementation with control 1.1 and real
quota-warning forwarding. It replaces only the old PA legacy IPACM source path.
Its kernel/header quota-warning compatibility and runtime behavior remain gates.

The missing DSP server binary and RC are pinned supplements from the local PA
common reference snapshot, recorded in vendor SUPPLEMENTAL_INPUTS.json. All 21
DSP interface imports resolve by symbol name against the original stock DSP 1.0
library. This does not establish complete target ABI/runtime compatibility.
