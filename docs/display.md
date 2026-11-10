# Kebab display configuration

The device includes the calcite common display system/vendor recipes directly,
so `display` is removed from the common component list to prevent a second pass.
The source display product supplies mapper/composer/allocator and related modules.
AIDL QTI memtrack is selected, as supported by the inspected display product.
OnePlus display properties replace conflicting generic source defaults, including
asynchronous power mode and recovery-dump behavior; no duplicate scalar override
is used to mask a conflict.

KebabFrameworksRes preserves the target's brightness tables, cutout, 120 Hz peak,
status-bar dimensions and rounded corners, plus common OnePlus color modes and
double-tap/power-decoupling flags. Fingerprint geometry is added separately.
Resources are copied by name from Lineage, not from alioth's panel calibration.
The initial BoardConfig's OnePlus gralloc setting is retained, but binary handle
layout, display-config interfaces, HDR/color behavior, UDFPS/HBM and calibration
still require verification against final vendor binaries and the source revision.

The RRO can be resource-compiled independently; a complete overlay link, final
product resource precedence and runtime panel behavior have not been validated.
