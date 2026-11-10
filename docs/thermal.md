# Thermal reporting

Select android.hardware.thermal-service.qti from the inspected calcite
hardware/qcom/thermal source. Its module installs the RC and AIDL V1 manifest
fragment; no duplicate IThermal/default instance is declared locally.

The source has kona/common and kona/specific sensor configurations for SoC ID 356
and uses the SoC/platform sysfs identifiers to choose them. The 4.19 selection
uses the supported qti_thermal/netlink=false path, compiling sysfs/uevent monitoring
rather than the netlink implementation. This matches the common QTI kernel-family
selection; it is not a test that every OnePlus sensor name/temperature scale matches.

The reporting HAL is distinct from the proprietary thermal-engine control daemon.
Lineage records thermal-engine, init_thermal-engine.rc, thermal-engine.conf and
thermalclient libraries as vendor outputs. Preserve their matched OnePlus versions
when integrating vendor files. No Xiaomi thermald, per-app performance map or
custom thermal thresholds are imported or generated here.

Actual thermal nodes, trip-point units, cooling devices, policy permissions,
callback behavior and throttling must be checked on hardware. Building or selecting
this reporting service alone does not validate the device's thermal control.
