# Power and performance selection

The selected calcite QTI power source (`879bf80`) defines
`android.hardware.power-service`, with its own power V6 VINTF fragment and RC.
Its generic product recipe also selects `android.hardware.power-impl`, which is
not defined by that source. The device sets `TARGET_PROVIDES_POWERHAL` to avoid
that common-product inheritance and explicitly selects the real service and
kona powerhint configuration. `TARGET_USES_QTI_POWER_HAL` enables its Make guard.

The source implements a device mode-extension hook but otherwise reports
DOUBLE_TAP_TO_WAKE unsupported. `PowerModes.cpp` implements that mode using the
OnePlus node recorded in Lineage common.mk, leaving other modes to the common
service. The local init file assigns system ownership. SELinux node labels and
access still need policy integration. The bool hook ABI indicates whether a mode
was handled; write failure is logged but cannot propagate an AIDL error through
that ABI. This has not been tested on hardware.

The generic QTI perf component remains selected and supplies its configuration,
properties and deferred vendor implementation. No stock-blob override is set and
no alioth perf files, 32-bit stub or stock hint values are imported. The power
source loads libqti-perfd-client.so and uses Picard hints; whether the final perf
provider handles them must be tested with its real vendor binaries. This is an
initial consistent source selection, not proof of hint/ADPF compatibility.

The target source must provide display config V12, power V6/common FMQ interfaces,
perf client/provider and kernel support. Their presence in reference clones does
not make the incomplete Android checkout buildable.
