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
