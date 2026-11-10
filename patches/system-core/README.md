# PA init vendor hook

Apply 0001-init-load-device-properties.patch to the final `system/core` repository
when preparing the PA source checkout. This patch is staged here and has not been
applied to the read-only reference checkout. The original commit and input/output
hashes are recorded in reference.json; re-check newer source versions before use.

The patch adds vendor_init_defaults to normal and recovery second-stage init
binaries, using PA's existing target_init_vendor_lib whole-static-library selector.
It deliberately does not add the provider only to the libinit archive: a weak
undefined reference alone need not extract a provider object from an archive.
Nor is it linked into first-stage init or the microdroid binary.

The global optional vendor_load_properties symbol is called after property files
are installed and before derived product identity/build fingerprint. Unselected
products retain the no-hook path. The device's libinit_kebab remains the provider.
Keep this timing and global C++ symbol ABI when adapting other PA source versions.

Validation: git apply --check against the recorded source; application to temporary
copies; normal/recovery target and hook-order checks; host weak/no-provider and
whole-archive/provider linkage tests; existing device-hook RF/DDR tests. These are
not an Android init/recovery build. Full Soong linking, partition property precedence,
recovery and device execution remain integration checks.
