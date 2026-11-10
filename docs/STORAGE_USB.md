# Storage and USB integration review

## OnePlus storage contract

The fstab is the Lineage kebab source with only its trailing blank line removed.
It retains the following device-facing interfaces:

| Mount | Backing source / configuration |
|---|---|
| system, system_ext, product | Slot-selected ext4 logical partitions; system AVB chain |
| vendor, odm | Slot-selected EROFS logical partitions |
| `/metadata` | Dedicated ext4 metadata partition, checked/formattable and mounted in first stage |
| `/data` | F2FS with inline encryption, v2 file-encryption policy, wrapped-key support and checkpointing |
| Metadata key directory | `/metadata/vold/metadata_encryption` |
| `/mnt/vendor/persist` | Dedicated persist ext4 partition; not marked formattable |
| `/mnt/vendor/spunvm` | Dedicated FAT partition; mount directory created in `init.target.rc` |
| `/vendor/firmware_mnt` | Slot-selected modem FAT partition |
| `/vendor/dsp` | Slot-selected DSP ext4 partition |
| `/vendor/bt_firmware` | Slot-selected Bluetooth FAT partition |

`vendor.prop` retains the OnePlus dm-default-key metadata method and options
format version 2. The three vendor firmware directory modules are selected from
PA's `device/qcom/common/Android.bp`, matching the mountpoint modules selected by
Lineage. First-stage fstab flags, key paths and filesystem types were checked
against the reference; no alioth userdata or encryption settings were substituted.

`init.target.rc` retains OnePlus's UFS bootdevice symlink and persist handling.
Actual decryption still depends on the final kernel configuration, keymaster,
matching vendor firmware, SELinux policy and recovery integration. No filesystem
was formatted or mounted during this review, and decryption has not been tested.

## USB and charger ownership

The device owns the QTI USB product include directly; `usb` is removed from the
common component list. PRODUCT_HAS_GADGET_HAL is set before that include so the
AIDL port and gadget services are both selected, with their own RC/VINTF files.
The source also supplies init.qcom.usb.rc/sh and generic vendor compositions.
The common product-string init module and accessory/host permissions are kept.

The OnePlus USB property block replaces matching generic keys before PA product
inheritance: qdss instance `qdss`, functionfs MTP and gadget HAL enabled, GSI
RNDIS/RMNET, DPL/DIAG names and MTP batch cancellation. The controller remains
`a600000.dwc3`; target init preserves the OnePlus runtime controller default.
No duplicate property values are used to mask generic kona choices.

The selected PA Oplus module installs usb_compositions.conf in ODM. The actual
calcite UsbGadget loads vendor, ODM, then product maps with insert_or_assign, so
ODM entries override matching vendor compositions. This preserves the OnePlus
VID/PID/function mapping while retaining source-provided fallback entries.
No additional NCM or dual-gadget feature overlays are enabled without kernel
validation. Source gadget service selection does not establish configfs support.

QTI AIDL health, selected separately, defines `vendor.charger`. The existing
OnePlus target init trigger for that service remains valid and starts the common
power-off-alarm service. Offline charging, USB role switching, MTP/PTP/ADB, MIDI,
RNDIS tethering/IPACM, composition switching and SELinux remain device checks.
