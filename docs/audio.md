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

## ABI and property decisions

`device.mk` preserves the audio sections of Lineage's vendor, ODM and
system-ext properties in their respective partitions. Device property names are
removed from the directly included generic recipe's legacy vendor property list
before adding the OnePlus values. Remaining generic properties are retained;
they still need final product-level duplicate/property-context checks when all
components and vendor makefiles are present.

The OnePlus references use different Fluence values in vendor and ODM. Both
partition-specific values are retained rather than silently collapsing them.
Effective runtime property resolution must be checked on the final product.

The intended primary HAL and volume listener are built from the same audio
source tree. Do not install alioth's prebuilt primary HAL or volume listener,
rename its audio dependencies, or add its 32-bit no-op performance client. The
Lineage blob list records `vendor/lib/hw/sound_trigger.primary.kona.so`; its
interaction with the source audio HAL, sound-trigger wrapper and OnePlus
configuration remains an explicit ABI check for the deferred vendor integration.

No audio-specific binary shim or fixup is established by the current references.
That does not prove none is needed: before claiming compatibility, inspect the
actual ELF dependencies/symbols, 32/64-bit variants, source/prebuilt ownership,
amplifier interface, ACDB/calibration data and sound-trigger vendor interface.
The WFD audio-types replacement in Lineage's extraction helper applies to WFD,
not to the primary audio HAL, and is deferred to media/WFD integration.

The generic effects XML references software effects, Qualcomm effects and
proprietary effect libraries. Check that each named library has a real provider
in the final source/vendor graph; selecting the XML does not supply its binaries.
Likewise, `audio_amplifier.qcom` and audio DLKMs are unresolved prerequisites,
not validated implementations in the current target checkout.

Alioth's input-profile probe bypass, SSREC workaround, diagnostic watchdog/log
settings, stock perf client and Dolby additions are excluded. No speaker or
microphone behavior is inferred from passing configuration checks. Calls,
Bluetooth/SCO, capture, camcorder audio, hotword/sound trigger, headphone/USB audio,
effects, calibration and speaker protection require separate hardware testing.

## Calcite reference reconciliation

The checked-out pa-sanji `android_hardware_qcom_audio` calcite source at
`da8e3bed` now supplies the exact recipe used for configuration validation.
It retains the source-HAL route and stock-HAL switch used by the alioth reference.

The OnePlus amplifier implementation was located in LineageOS hardware/oplus
lineage-24.0 (`0cdf188`). Its original Blueprint hardcodes CAF SM8250 include paths.
This tree carries its C source unchanged and uses CLO primary-HAL include paths.
The local module is named `audio_amplifier.kebab` and installs with the expected
`audio_amplifier.qcom.so` filename, avoiding a module-name collision if hardware/oplus
is exported later. The six functions it resolves from the primary HAL are present
as non-static source definitions in the inspected calcite audio source. Header,
32/64-bit, vendor ELF and calibration compatibility still require a complete build
and device testing. Earlier missing-source notes describe the target `pa/` checkout;
reference clones alone do not install platform dependencies into that checkout.
