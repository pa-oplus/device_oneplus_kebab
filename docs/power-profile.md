# Battery power estimates

KebabFrameworksRes includes the unchanged Lineage kebab power_profile.xml,
preserving its BSD notice. It describes a 4500 mAh battery and 4+3+1 CPU clusters,
with per-cluster speed/current tables and device power estimates. The table is
framework battery-accounting data, separate from Power HAL hints or charging
control. It is not substituted from alioth or measured anew during this work.

The input's own comments describe estimate/measurement limitations. Preserving
reference values does not establish calibrated battery attribution on this PA
kernel/vendor combination. Table cardinalities, numeric values and source bytes
are checked; full RRO linking and battery/current-accounting behavior need build
and device validation.
