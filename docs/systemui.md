# SystemUI resources

KebabSystemUIRes combines the OnePlus common icon-animation vibration boolean
with kebab-specific SystemUI resources. Corner masks, 97 px mask size, pixel pitch,
portrait/landscape status-bar padding, keyguard dimensions and physical power-button
position are unchanged from Lineage kebab. The original target ODM partition and
static priority 350 are preserved under a unique module/package.

All value names and corner drawable targets exist in the inspected PA SystemUI
source. The PA rounded-corner renderer reads the named top/bottom drawables.
Framework cutout/status-bar resources remain in KebabFrameworksRes; this module
supplies the SystemUI side without importing Xiaomi masks or a generic Oplus
SystemUI overlay product. Common and target source files have no duplicate value
names within a resource configuration; landscape qualifiers are retained.

AAPT2 compiles these inputs and source comparisons preserve their bytes. Final
RRO linking/idmap policy, precedence, mask scaling at different densities, cutout
padding, keyguard layout and haptic behavior still need full build/device checks.
