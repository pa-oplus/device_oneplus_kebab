# OnePlus source audio integration

Audio is owned by `device.mk`, not `TARGET_COMMON_QTI_COMPONENTS`. The
calcite kona recipe is included directly before PA product inheritance; local
rules remove competing legacy HAL implementations, generic test applications,
and replaced configuration/property destinations. The chosen HIDL 6.0 audio and
effects service, 2.3 sound-trigger wrapper, source `audio.primary.kona` and source
`libvolumelistener` follow the Lineage OnePlus baseline. Common QTI init owns the
audio service RC.

The exact source reference is pa-sanji/android_hardware_qcom_audio calcite at
`da8e3bed`, checked out under `pa-kona/pa-alioth`. It must be integrated into the
final Android source at `vendor/qcom/opensource/audio-hal/primary-hal`. A reference
clone does not install that dependency into the build checkout.

## Amplifier

The user-specified PA hardware tree is `aospa-trees/hardware/oplus`, from
clo-oscaro/hardware_oplus calcite at `cc126d9`. That tree has no amplifier module.
The device therefore carries the amplifier C implementation from LineageOS
hardware/oplus lineage-24.0 (`0cdf188`), preserving its source and license.
Its local Blueprint uses the selected CLO HAL's private headers instead of the
original CAF SM8250 paths. The module `audio_amplifier.kebab` installs as
`audio_amplifier.qcom.so`; its name avoids collisions with external namespaces.

The six functions resolved by that amplifier have non-static source definitions
in the inspected calcite HAL. This is a source-interface check, not proof of ELF
visibility, structure layout, successful compilation or calibration behavior.
Final kernel headers, 32/64-bit build behavior and speaker protection remain
checks for the complete source/vendor graph. Do not replace missing dependencies
with stubs or disable speaker protection to hide them.

## Configuration and properties

The local policy, offload-disabled policy and audio I/O configuration come from
Lineage sm8250-common. Mixer, intcodec platform information and sound-trigger
configuration come from Lineage kebab. All seven inputs and their notices are
preserved. The generic source recipe supplies base platform information, effects,
volume tables and non-device-specific supporting configuration.

Both preferred `vendor/etc/audio/audio_policy_configuration.xml` and root vendor
policy paths use the OnePlus policy. The alternate A2DP policy uses the standard
framework filename. Sound-trigger files are installed to ODM as in Lineage and
replace generic vendor fallback copies. Bluetooth policy is supplied from the
framework; remote-submix policy and volume tables come from the generic recipe.

`device.mk` preserves Lineage audio properties in vendor, ODM and system-ext.
It removes replaced legacy vendor keys from the directly included generic recipe.
The different vendor/ODM Fluence values are preserved; effective runtime property
resolution needs final-product testing. Future vendor includes must be checked
for duplicate properties and copy destinations again.

## ABI and validation

The OnePlus blob list records `vendor/lib/hw/sound_trigger.primary.kona.so`.
Its source-wrapper ABI, effects providers, ACDB/calibration data and proprietary
interfaces need review when actual vendor inputs are available. No audio-specific
binary fixup is established yet. The extraction helper's WFD audio-types fixup
belongs to later WFD integration, not the primary HAL.

Checks passed against the cloned calcite recipe: XML parsing, route endpoints,
XInclude destinations, source-file comparisons, package selection and direct
copy/property ownership. The combined device/board check also includes display,
power, fingerprint and camera settings. Full Android inheritance, ELF linking,
VINTF, SELinux and hardware audio are not validated.

No Xiaomi stock HAL/volume listener, no-op perf client, Dolby stack, input-probe
bypass, SSREC workaround or diagnostic watchdog/log overrides are imported.
Calls, Bluetooth/SCO, capture/video audio, hotword, wired/USB audio, effects and
speaker calibration require separate device tests.
