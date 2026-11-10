# Recorded source-readiness audit

Run `python3 tools/check-source-readiness.py --source-root ANDROID_ROOT` to check
the critical provider/file list in source-requirements.json, the recorded source
VINTF files, and actual consumption of the device init hook. It reads source files
and runs only git apply --check for the staged patch when the hook is missing.
It does not apply patches, sync repositories, fetch kernel/vendor files or run
extractors. The device configuration being audited is this repository's tree.

Missing files/providers or missing normal/recovery hook integration produce a
nonzero exit status. A matching module name is a source-presence check, not proof
of module variants, installed packages, transitive dependencies or library ABI.
Passing this audit is not a complete Soong/Make graph or a build-readiness claim.
The report always lists the remaining kernel/vendor/interface/policy/build gates.

The checker was exercised against an isolated canonical view of the selected
reference sources: it rejected the original missing hook, reported the staged
patch applicable, and passed the recorded checks after patching temporary init
copies. The actual pa checkout remains blocked/unpatched; no reference checkout
was changed. Use the tool against the eventual assembled source checkout rather
than interpreting the temporary reference view as a bootable Android product.

The memtrack provider is now identified at device/qcom/vendor-common/memtrack.
Thirteen recorded source-service fragments plus the six local manifests merge to
29 declared instances. The separate VINTF checker still reports 43 legacy
reference records requiring vendor/WFD/common-provider reconciliation; a found
source file does not settle those declarations or runtime registration.
