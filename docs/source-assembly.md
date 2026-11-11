# PA source selection

The earlier `pa/` integration checkout is no longer present. The tracked manifest
now selects only the five reviewed Sanji Kona HAL candidates, the earlier Sanji
thermal source, and PA Oplus from aospa-trees. Applying it to a current PA source
checkout is pending its location.

| Build path | Repository | Selected commit |
|---|---|---|
| `hardware/qcom/gps` | pa-sanji/android_hardware_qcom_gps | `e822feb886a5` |
| `hardware/qcom/display` | pa-sanji/android_hardware_qcom_display | `86a98cacda4e` |
| `hardware/qcom/media` | pa-sanji/android_hardware_qcom_media | `96e7eebd6c6b` |
| `vendor/qcom/opensource/usb` | pa-sanji/android_vendor_qcom-opensource_usb | `9ae3e810143d` |
| `vendor/qcom/opensource/audio-hal/primary-hal` | pa-sanji/android_hardware_qcom_audio | `da8e3bed19be` |
| `hardware/oplus` | clo-oscaro/hardware_oplus | `cc126d9674aa` |
| `hardware/qcom/thermal` | pa-sanji/android_hardware_qcom_thermal | `339ecff03f75` |

The original PA manifest supplies platform/build/framework repositories. Full
findings for the original nineteen Sanji sources, retained candidates and deferred
compatibility ports are in [sanji-source-audit.md](sanji-source-audit.md).

The original PA AV commit `d0cf9d91` is restored as an independent, clean snapshot
at `pa-kona/pa-reviewed/frameworks/av`. Its complete tree and original commit hash
were reconstructed and verified from the saved original files. This is not a
full PA checkout, and no AV feature patches were added.

Original replacements and the user Soong Ninja/RBE patch remain preserved at
`pa-kona/backups/pa-calcite-shared-1cb8m11j`. Most original worktree files survive,
but their repo-managed Git stores pointed into the missing PA checkout. The
system/core init-hook record and 2026-11-10 checks in source-assembly.json are
historical; they do not establish the state of any new checkout.

The live source-provider/init/VINTF checks must be rerun after source restoration.
Full product build, kernel/header integration, vendor activation/ABI, policy and
hardware validation remain pending.


The manifest now also selects a pinned Lineage IPACM control-1.1 provider at
vendor/qcom/opensource/data-ipa-cfg-mgr-legacy. An independent source clone is
staged under pa-kona/pa-reviewed. This is a narrow legacy HAL source selection,
not a PenguinOS/platform replacement; quota-warning kernel/header compatibility
remains unvalidated. The new required source adaptation is the audio-service
QTI Bluetooth factory patch in patches/hardware-interfaces. Current remaining
gates are summarized in INTEGRATION_STATUS.md.
