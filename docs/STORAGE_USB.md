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

The device kernel command line and normal-boot target script use
`a600000.dwc3`, as in Lineage kebab. The USB product string is preserved from
Lineage. The selected common QTI USB component supplies the controller service,
USB init scripts, accessory/host permissions and common properties. OnePlus
retains the runtime controller override for
`persist.vendor.usb.controller.default` in `init.target.rc`.

The review found unresolved differences to handle in the later USB HAL step:

| Setting | OnePlus reference | Inspected common QTI default for kona/4.19 |
|---|---|---|
| `vendor.usb.qdss.inst.name` | `qdss` | `qdss_sw`; target init later sets `qdss` |
| `vendor.usb.use_ffs_mtp` | `1` | `0` |
| `vendor.usb.use_gadget_hal` | `1` | `0` unless `PRODUCT_HAS_GADGET_HAL` is set |
| Gadget service / compositions | QTI gadget service plus Oplus ODM compositions | Selected only when gadget HAL is enabled; generic composition file |

Do not add duplicate product properties to mask these differences. Final USB
integration must choose property ownership, gadget service and compositions
together and check the actual OnePlus configfs/functions available in the kernel.
The existing generic choice is not claimed to reproduce the complete OnePlus USB
behavior yet. `hardware/oplus` is absent from the inspected `pa/` checkout; its
composition module was inspected read-only in `aospa/` as a dependency reference.
No generic USB copies or hardware dependencies were fetched for this review.

The default common `charging` component selects the QTI AIDL health service,
whose RC defines `vendor.charger` with class `charger`. The OnePlus target script
responds to `init.svc.vendor.charger=running`, starts the common
`vendor.power_off_alarm` service and sets charger-mode USB configfs/controller
properties. This matches the selected AIDL service name. If health integration
later switches to the HIDL charger path (`service charger`), this trigger must
be updated with it. Battery HAL behavior, offline charging, power-off alarm,
USB role switching and charging policy still require device validation.
