# OnePlus source audio integration

Audio is owned by `device.mk`, not `TARGET_COMMON_QTI_COMPONENTS`, to control
the packages and destination files selected by the generic kona recipe. The
recipe is included directly before PA product inheritance. Its source feature
flags are retained; older competing HAL implementations and generic test apps
are removed. The chosen HIDL 6.0 audio/effects service, 2.3 sound trigger wrapper,
source `audio.primary.kona` and source `libvolumelistener` follow Lineage's
OnePlus baseline. Common QTI init continues to own the audio service RC.

The implementation requires `vendor/qcom/opensource/audio-hal/primary-hal` in the
final PA source. That directory is absent from the inspected `pa/` checkout; the
kona recipe and HAL build rules were inspected read-only in the existing
`aospa/` checkout. No source or proprietary repositories were fetched. Selecting
packages does not establish that their dependencies are available or buildable.

`audio_amplifier.qcom` is selected as in Lineage and the external-amplifier flag
is preserved. The inspected secondary source tree does not provide that module;
locate/adapt the corresponding OnePlus implementation before building. Do not
replace it with an arbitrary amplifier or disable speaker protection to conceal
the dependency. Audio DLKM names/configuration also need the deferred kernel check.

No Xiaomi stock primary HAL, stock volume listener, no-op perf client, Dolby
stack or audio input-probe workaround is imported.

## Configuration ownership

The local policy, offload-disabled policy and audio I/O configuration come from
Lineage sm8250-common. The mixer, intcodec platform information and sound-trigger
configuration come from Lineage kebab. Their source contents and notices are
preserved. The generic source recipe continues to provide base platform info,
audio effects, volumes and non-device-specific supporting configuration.

The local recipe removes generic entries for the seven destinations it replaces
before adding the OnePlus files. This operates on a directly included source
recipe, not on unresolved `inherit-product` markers. Both preferred
`vendor/etc/audio/audio_policy_configuration.xml` and root vendor policy paths
use the OnePlus policy. The alternative A2DP-offload-disabled policy is installed
under the standard filename used by the inspected framework.

Sound-trigger files are installed to ODM as in Lineage and also replace the
source recipe's generic vendor copies. This keeps fallback copies consistent;
final proprietary sound-trigger lookup/ABI behavior still needs blob validation.
The Bluetooth policy include is supplied from the framework; volume tables and
remote-submix policy remain supplied by the generic source recipe.

Configuration checks parsed all copied XML files, checked policy route endpoints
and XInclude destinations, and compared all seven local inputs byte for byte
against the Lineage references. The combined copy-map check passed using the
available source recipe at `des/hardware/qcom-caf/sm8250/audio` (`399ade94`), whose
kona file uses the same CLO config destination scheme. The previously inspected
`aospa/` audio directory disappeared during this work; it was not recreated.
The final target PA source and its transitive dependencies still need validation.
