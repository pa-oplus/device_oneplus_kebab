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
