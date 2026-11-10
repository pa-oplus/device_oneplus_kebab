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

## Initial device and framework defaults

KebabSettingsProviderRes preserves kebab's def_device_name_simple = OnePlus 8T,
targeting the actual PA SettingsProvider resource. This seeds Settings' initial
name and does not override a saved user name. The original ODM partition/static
priority are retained with a unique package/module.

The framework RRO also preserves the OnePlus common long-press/virtual-key 10 ms
patterns, proximity suspend, default-disabled always-on display, haptic text-handle
flag and two physical SIM slots. These are supported PA resource names; no
Lineage-only screen-off fingerprint settings or unrelated lid/performance flags
are added. Final resource precedence and hardware/default behavior need testing.
