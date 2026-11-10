# PA source integration requirements

The device configuration is being prepared against the reference trees and the
local `pa/` checkout. This file records gaps outside the device repository; it
is not a claim that the source patches have been implemented.

## Vendor property initialization

`BoardConfig.mk` selects `//device/oneplus/kebab:libinit_kebab` using
`TARGET_INIT_VENDOR_LIB`, matching the alioth integration contract.

The inspected PA source exports that setting through
`vendor/aospa/target/board/BoardConfigSoong.mk`. Its
`vendor/aospa/soong/Android.bp` defines `vendor_init_defaults`, but the inspected
`system/core/init/Android.bp` does not consume those defaults and
`system/core/init/property_service.cpp` does not call `vendor_load_properties()`.
Consequently, the selector alone will not link or invoke the device library.

Before a full build, verify the final PA branch links the selected library into
normal and recovery init and invokes its property hook after loading partition
properties and before deriving the final `ro.product.*` identity. This needs a
source change outside this tree if the inspected implementation is retained.
Do not mark regional model detection functional until this is checked.

The device hook preserves Lineage's five kebab RF-to-model mappings and DDR
property extraction. Unknown or malformed RF versions leave the product's default
model in place. Other sm8250 OnePlus model branches are excluded from this
kebab-only library.

## Platform dependency selection

Use the calcite sources recorded in `docs/REFERENCE_SOURCES.md` for QTI common,
audio, display, power and PA interfaces. The audio source is expected at
`vendor/qcom/opensource/audio-hal/primary-hal`; the local amplifier adaptation
now supplies the missing device implementation. Its kernel-header provider,
private audio interfaces and dependencies still need complete build validation.

The PA Oplus source selected by the user is `aospa-trees/hardware/oplus`, remote
`clo-oscaro/hardware_oplus`, branch calcite (`cc126d9`). Integrate it at
`hardware/oplus`; it imports `hardware/google/interfaces`. Its fingerprint wrapper
is selected. Its tree has no amplifier, UDFPS extension, KeyHandler package or
Lineage touch HAL; do not assume the newer Lineage hardware checkout is a drop-in
replacement. The amplifier and UDFPS extension are device-local; touch/slider
integration remains pending a compatible PA implementation.

The inspected native calcite CompositionEngine consumes
`surfaceflinger/udfps_lib` through a direct Soong select; the device uses that API.
The local UDFPS library currently expects `generated_kernel_headers`. Resolve
that provider and the OnePlus DRM header definitions during kernel integration.

The power source requires its power V6/common interfaces and display-config V12.
Only its actual service is selected; its undefined generic power-impl package is
not inherited. Perf ABI/ADPF support remains dependent on the actual perf provider.
The camera source needs QTI camera interfaces and the final OnePlus vendor HAL.

No dependency is silently skipped by the device-owned audio include. Reference
configuration checks are not a completed Android build or compatibility result.
