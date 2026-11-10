# Local PA source assembly

The authorized integration checkout is `pa/`. It now contains independent local
Git clones of the selected reference snapshots:

| Build path | Selected repository | Calcite commit |
|---|---|---|
| hardware/oplus | clo-oscaro/hardware_oplus, from aospa-trees | cc126d9 |
| hardware/qcom/thermal | pa-sanji/android_hardware_qcom_thermal | 339ecff |
| hardware/qcom/display | pa-sanji/android_hardware_qcom_display | 86a98ca |
| vendor/qcom/opensource/audio-hal/primary-hal | pa-sanji/android_hardware_qcom_audio | da8e3be |

The original reference folders are unchanged. Cloning used local repositories;
no remote source sync or kernel/vendor acquisition was run. Upstream remotes point
to the selected GitHub repositories. Full hashes and local integration state are
recorded in source-assembly.json.

The old AOSPA thermal checkout at vendor/qcom/opensource/thermal-hal defined the
same service. Its files and tracked history bundle were backed up outside the
build tree before replacement. Original init files are saved alongside them.
The workspace backup location is recorded in source-assembly.json.

The local `.repo/local_manifests/kebab-source-integration.xml` records the four
selected paths/branches and removes the old thermal project. A tracked copy is in
manifests/kebab-source-integration.xml. Repo's complete manifest lists each new
path once and excludes the old thermal path. These are local clones; no repo sync
was run to fetch/register new project object stores.

## Init integration and checks

The prepared patch is applied in system/core and committed locally as eee4afd
on branch kebab-init-hook. It is not pushed to AOSPA upstream. Both modified files
match the prepared patch's output hashes. A future source sync/rebase must retain
or reapply that local integration.

The critical source-readiness checker now passes against the actual pa checkout:
all eleven previous failures are resolved. The VINTF audit checks six local and
thirteen actual source fragments, with 29 unique instances; assemble_vintf merges
them. The thermal RC validates and all four selected repositories plus system/core
have clean worktrees. This does not install the device tree into a product build
or prove full Soong/module, header, interface-version, ABI or policy compatibility.

The remaining 43 vendor/WFD reference records, kernel/header/config integration,
proprietary fixups, complete VINTF/policy, full build and device tests are still
pending. Source-provider checks are a narrower milestone than build readiness.
