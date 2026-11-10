# PA alert slider integration

The old opkona tree records the OnePlus hall device name, state node, 1/2/3
positions and persist calibration path. This tree uses that behavior with PA's
current `DeviceKeyHandler` interface, not the old Zephyrus DeviceExtras UI or a
missing Lineage touch service.

KebabKeyHandler is an installed system-ext Java library, loaded by PA's
config_deviceKeyHandlerLibs/config_deviceKeyHandlerClasses arrays. It implements
the actual platform interface with a public Context constructor. The framework
loads those arrays independently of its generic config_enableKeyHandler flag;
the latter is not enabled merely to load this device handler.

Only events from `oplus,hall_tri_state_key` are consumed. A non-repeated key-down
reads the current position and applies silent/vibrate/normal for 1/2/3. Key-up
is consumed without applying the mode again. Unknown devices pass through and
malformed, missing or out-of-range node contents do not change the current mode.
The boot-completed receiver restores the physical slider position after startup.
No Zephyrus broadcast, custom Settings dependency or slider animation is assumed.

The calibration service restores non-empty persist data with semicolon-to-comma
conversion and no appended newline. It does not manufacture calibration data.
Permissions and targeted persist restorecon actions are set in init. Local
SELinux policy now labels the script, calibration data and separate proc leaves;
system_server has read-only state access and a dedicated domain writes calibration. The PA framework hooks,
actual hall device events, boot ordering, current-user ringer behavior and device
calibration still need a full product/device test.

Gesture customization is separate: opkona's HIDL Lineage touch@1.0 interface is
not supplied by the selected PA Oplus tree. Its nodes/keycode mapping remain
reference material for a later PA-compatible implementation.
