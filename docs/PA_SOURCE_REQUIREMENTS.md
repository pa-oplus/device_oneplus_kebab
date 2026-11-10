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
