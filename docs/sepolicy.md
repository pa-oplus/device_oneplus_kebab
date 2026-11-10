# Device policy integration

BoardConfig selects sepolicy/vendor. Common QTI policy remains owned by PA's
BoardConfigQcom integration. The entire hardware/oplus policy product is not
included: its platform-directory assumptions differ from this CLO layout and it
contains unrelated service/Lineage policy dependencies. Local types have the
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
