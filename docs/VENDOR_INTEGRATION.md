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

**Open contract:** PA's system perf client binaries reference AIDL perf2, while the
stock vendor service registers HIDL 2.2. Preserving their packaging does not bridge
those protocols. This needs a compatible framework client/adapter selection and
runtime validation; no system perf compatibility claim is made here.

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

`assemble_vintf` merges 31 recorded local/reference/vendor fragments into 50
unique instances. Ten legacy reference records are covered and 42 remain open,
including vendor/WFD/common-provider reconciliation. This is not complete product
matrix compatibility, runtime registration or enforcement validation.
