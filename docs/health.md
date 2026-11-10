# Health and offline charging

Use QTI AIDL health for both normal boot and separate recovery, matching current
Lineage OnePlus. The PA health-vendor-product.mk selects both binaries and vendor
charger images. Its normal service owns the health VINTF fragment and defines
vendor.charger with --charger, matching the existing init.target.rc trigger.
No extra HIDL health service or duplicate charger RC is installed.

The generic charging component is removed: its proprietary charger-monitor RC
and companion blobs are not part of the current OnePlus health selection.
The historical opkona HIDL 2.1 setup is superseded. Lineage's separate charging
control service is not selected because PA does not supply that interface.

The inspected PA AIDL implementation uses BatteryMonitor power-supply discovery
and probes /sys/class/power_supply/battery/capacity before starting. It does not
link the old healthd_board_msm.cpp implementation. Final power-supply discovery,
OnePlus dual-cell values, charger animation/display, suspend, power-key boot,
recovery readings and SELinux access require kernel/vendor and device checks.
No charge limits, fast-charge protocol or thermal behavior is altered here.
