# Oplus sensors

Select the calcite hardware/interfaces AIDL sensors multihal service and the
`sensors.oplus` library from the user-selected PA hardware/oplus tree. The service
installs its own AIDL V3 manifest fragment and RC, so do not add a second default
sensors instance to the later device manifest.

The two-line HAL configuration is identical in old opkona and current Lineage:
`sensors.ssc.so` plus `sensors.oplus.so`. The bridge's loader explicitly reads
vendor/etc/sensors/hals.conf. The SSC library and proprietary sensor configuration
remain deferred OnePlus vendor outputs; the source Oplus library adds synthetic
sensors including the UDFPS wake-up sensor. Its string type matches the new
framework overlay, and its fp_state node is granted read access in local init.
No barometer feature is advertised for kebab; Lineage's barometer SKUs belong to
other devices in the common family.

The PA tree also contains sensors.ssc_custom_flag, which modifies an SSC vtable.
It is not selected without matching binary/ABI evidence. Do not substitute alioth's
MIUS proximity configuration or infer that source registration verifies sensors.
Full interface/SSC ABI, event conversion, node availability, SELinux, wake-up,
proximity, UDFPS and suspend behavior remain full-build/device checks.
