# Device policy integration

BoardConfig selects sepolicy/vendor. Common QTI policy remains owned by PA's
BoardConfigQcom integration. The entire hardware/oplus policy product is not
included: its platform-directory assumptions differ from this CLO layout and it
contains unrelated service/Lineage policy dependencies. Local vendor types have the
vendor_kebab prefix; do not select an overlapping slider genfs policy later.

The slider policy follows the OnePlus/PA Oplus node contract but splits state,
calibration and proc-directory labels. The key handler in system_server gets
read-only state access. A dedicated init-transitioned vendor script domain may
read only the persisted calibration file and write the calibration proc node;
it may execute the vendor shell/toybox and traverse the existing persist paths.
The calibration file retains the common vendor_persist_type attribute. Targeted
restorecon actions normalize existing persist labels before starting the oneshot.
No wildcard engineermode file access, permissive domain or audit suppression is
added. DAC ownership/modes remain in the existing service RC.

This is an initial policy slice, not complete OnePlus vendor policy. Full PA/QTI
macro/type integration, neverallow checks, platform mapping and file-context
validation must pass in the final product. Runtime init transition, persist
labeling and slider access require enforcing-device validation. Other OnePlus
services/property/devices still need policies with reference/runtime evidence.

## Reference policy check

Local TE is expanded with the inspected PA public macros and compiled, including
neverallow checks, against the existing des build's different-device policy.conf.
Colliding reference-device genfs entries are replaced only in that temporary
harness; no reference source/build output is modified. checkfc validates the local
file contexts against the resulting temporary policy. This catches syntax/type
and some permission conflicts, not final kebab policy compatibility. Rebuild the
actual PA/QTI/vendor composition and run its full checks before device use.

## Power and sensor leaves

The Power HAL's existing OnePlus mode extension writes double_tap_enable; only
that proc leaf receives a local label and write permission. The PA Oplus synthetic
sensor opens fp_state read-only in the platform multihal process; only that sysfs
leaf is labeled and granted read access. Parent touchpanel/display trees retain
their common labels. Existing init RCs supply system ownership and 0660/0440 modes.

The common CLO file contexts map android.hardware.power-service to
hal_power_default_exec, and platform vendor contexts map sensors-service.multihal
to hal_sensors_default_exec. No duplicate executable contexts are added. The
source domains/transition rules and parent traversal must still be checked in
the actual PA/QTI product; local rules do not complete fingerprint, sensors or
power policy. Runtime labels, enforcing access, wake behavior and the remaining
backend policies are device-validation work.

## Fingerprint, vibrator and ODM-script additions

Local policy now labels the PA fingerprint wrapper, OnePlus backend/display node,
Oplus vibrator binary and reference physical LED paths. Fingerprint backend
hwservice and exact optical/version properties have explicit contexts; the LED
backend uses the platform sysfs_vibrator type. Full backend data/TEE/driver and
vendor property requirements still need actual source/vendor integration.

The ODM init script has a dedicated domain and exact radio mapping. A system-ext
public config type plus private exact contexts handle retained legacy project/
revision properties; vendor policy is not used to own non-vendor property names.
Both system-ext policy directories are selected in BoardConfig. The reference
compile includes these types, and property_info_checker/checkfc validate property,
file and hwbinder contexts against that temporary policy. This remains a different-
device reference check, not a final kebab compile or runtime authorization result.
