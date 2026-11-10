# Init ownership

This device configuration uses the selected QTI `init` component for generic
Qualcomm behavior and keeps OnePlus actions in the device tree.

| Configuration | Owner / installation |
|---|---|
| `init.qcom.rc`, common shell scripts and legacy audio/QCRIL/QRTR services | PA `device/qcom/common/vendor/init` |
| `init.recovery.qcom.rc` | PA common recovery configuration |
| `init.target.rc` | This tree; `/vendor/etc/init/hw/`, imported by common `init.qcom.rc` |
| `init.oplus.rc`, `init.oplus.hw.rc`, `init.oplus.sh` | This tree; ODM init directory and binary directory |
| Recovery RF region actions | This tree; recovery copy of `init.oplus.hw.rc` |
| Qualcomm ueventd baseline | PA common `/vendor/etc/ueventd.rc` |
| OnePlus ueventd delta | This tree; `/odm/etc/ueventd.rc`, imported after vendor rules by the platform configuration |

Generic OnePlus-reference copies of `init.qcom.rc`, Qualcomm shell scripts and
`ueventd.qcom.rc` are not installed by this tree. The local ueventd file contains
only the ten additions/differences from the inspected common QTI file; retain
those differences when updating the common source. It preserves the original
Qualcomm license header and adds the OnePlus-specific charger, reserve and Wi-Fi
firmware-directory rules from Lineage's `ueventd.oplus.rc`.

Explicit `start logd`, `start hwservicemanager` and `start vold` actions were
removed from `init.target.rc`: the inspected platform root `init.rc` owns those
starts. Device filesystem actions and firmware mounts remain local. The
`dcvs-sh` service/trigger was removed because neither the Lineage init directory
nor the recorded OnePlus blob lists provides its `init.qti.dcvs.sh`. Alioth's
script is not imported as a substitute for OnePlus kernel tuning.

OnePlus module-loading requests, USB properties, peripheral/modem services,
optional shared OnePlus sensor services and node paths originate in the Lineage
common configuration. Their kernel/blob availability and applicable variant
behavior still require later dependency and hardware validation. Host init
verification checks syntax and known command arguments; it does not prove these
executables, kernel modules, properties or SELinux permissions exist at runtime.

The selected common scripts and the local scripts have been checked for duplicate
service names. Vendor-generated init fragments are not available yet, so their
service ownership remains a separate integration check.

## Device-owned ODM script policy

init.oplus.sh has a dedicated vendor_kebab_init transition. It may execute the
vendor shell/toybox, read proc_cmdline and set the common CLO radio property type;
its exact vendor.radio.multisim.config mapping uses that existing type. The
script does not receive generic vendor-init or filesystem write privileges.
The service is disabled for automatic class starts and still runs synchronously
through the existing early-boot exec_start before the persist.radio copy action.

ro.separate.soft and ro.boot.hardware.revision are legacy OnePlus configuration
properties used by retained init actions. Their exact contexts live in device
system-ext private policy with a public system_vendor_config_prop type; that
macro limits setters to init/vendor-init/device-config domains. They are not
misclassified as vendor-owned names, and read-only property semantics remain.
Bootloader-preseeded values and final cross-partition property/mapping rules
require target validation. The platform's radio_control_prop already covers the
persist.radio destination; no replacement context is added for it.

Other vendor-script/service nodes, reserved partitions and platform properties
must still be reconciled with the actual vendor/common policy. This change does
not grant the retained ODM sensor daemon or generic QTI scripts blanket access.
