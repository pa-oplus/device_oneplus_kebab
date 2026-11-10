# OnePlus camera provider

Select Lineage's HIDL 2.4 provider implementation and 64-bit service. The calcite
hardware/interfaces reference defines both modules and its service RC. The
provider defaults do not install a VINTF fragment, so BoardConfig includes the
same legacy/0 declaration used by Lineage. The target-level 7 baseline comes from
Lineage sm8250-common and must be reconciled with the final assembled vendor
manifest; this is not a passed framework compatibility check.

Camera feature permissions and the auxiliary-camera exclusion list follow the
OnePlus reference. Device sensor/tuning/calibration files remain vendor outputs:
Lineage kebab lists OnePlus sensor modules and tuning for IMX586/IMX481/IMX471,
GC5035 and GC02M1B, plus CFR/ASHDR components. Do not replace them with alioth's
sensor binaries, CamX overrides or MIUI camera/license material.

The actual PA Oplus tree in aospa-trees supplies Oplus interfaces, not these
sensor binaries. Final provider dependencies include the Qualcomm camera device
interface and the vendor camera implementation. OnePlus's extraction reference
adds libcamera_metadata_shim.so to com.qti.chi.override.so; apply and validate that
only when the corresponding proprietary input/version is available. Other
camera/remote-handle fixups must be reviewed against those same inputs.

Alioth's torch-strength extension writes Xiaomi LED nodes with fixed limits.
It is deliberately not selected: OnePlus torch nodes and supported strength
semantics have not been established. Standard provider torch behavior remains
the baseline. Additional postprocessing/Oplus manifest declarations, blob shims,
SELinux policy, photo/video recording, auxiliary cameras and torch behavior are
still pending vendor/build/device validation.
