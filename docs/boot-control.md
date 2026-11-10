# A/B boot control

Select android.hardware.boot-service.qti and its .recovery variant, matching
current Lineage OnePlus. The inspected PA hardware/qcom/bootctrl AIDL recipe
provides each image's service RC and common IBootControl/default fragment. Do not
add the HIDL service or a second device manifest declaration. Separate recovery
and boot-header v2 remain unchanged.

The QTI backend uses /dev/block/bootdevice/by-name, ro.boot.slot_suffix, GPT slot
attributes and misc virtual-A/B merge metadata. The existing OnePlus init UFS
bootdevice symlink and fstab misc entry provide the expected paths. It links
librecovery_updater from vendor/qcom/opensource/recovery-ext, whose GPT helpers
must be included in the final source build. No slot or block-device operations
were run during configuration checks.

The Lineage QTI_GPT_UTILS/USE_BSG_FRAMEWORK setting has no consumer in the
inspected PA bootctrl/recovery-ext sources; no ineffective selector is added.
Resolve source differences if the final branch supplies a separate BSG backend.
Build/policy validation and device read-only slot queries must precede testing
slot switching, update-engine success marking, recovery OTA, snapshot merge and
rollback. Selecting services does not establish working or safe OTA behavior.
