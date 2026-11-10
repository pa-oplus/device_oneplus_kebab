# Settings resources

KebabSettingsRes combines current Lineage OnePlus common Settings configuration
with kebab's fingerprint enrollment radius. Resource files are preserved unchanged:
Vivid/Natural/Cinematic/Brilliant map to 0/256/258/259, Smooth Display is exposed,
network scan timeout is 254 seconds and enrollment progress radius is 100 dp.
The module/package is unique; the original ODM partition and static priority are
retained. All resource names exist in the inspected PA Settings source.

The color-mode value array agrees with the framework's selected available modes.
This only controls which choices Settings exposes; display HAL modes and actual
panel output still need runtime confirmation. Enrollment radius is a UI resource,
separate from framework optical sensor geometry. No Lineage-only Settings resources
or a complete Oplus generic overlay product are inherited.

AAPT2 resource compilation and source/value checks passed; linking/idmap policy,
overlay precedence, enrollment scaling and Settings behavior require the full
platform build and device. These checks do not validate HBM or fingerprint auth.
