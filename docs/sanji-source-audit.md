# Sanji source selection review

This review covers all 19 repositories originally selected on 2026-11-10.
A repository name without `pengu` does not establish that its contents are
limited to Kona compatibility. Decisions below use source differences and
the current kebab declarations.

The previous `pa/` checkout no longer exists. This is a prepared source selection,
not a completed restoration in a live PA build tree. The original PA AV snapshot
is reconstructed at `pa-kona/pa-reviewed/frameworks/av`: commit `d0cf9d91`,
tree `517fd7638a18a3e91620c8c1882af978c77d84d9`, with a clean worktree.

| Path | Selection | Findings |
|---|---|---|
| `hardware/qcom/gps` | Keep legacy GNSS HAL candidate | Legacy GNSS implementation and compiler-warning fixes. No PenguinOS product markers found in reviewed build/C++/XML files. The local upstream/uvite-8550 comparison differs in 239 files and is not a matching legacy baseline; exact legacy upstream comparison remains pending. |
| `hardware/qcom/display` | Keep Kona HAL candidate | Same commit as the previously selected device source; zero diff from the local upstream/calcite-865 snapshot. No product feature additions found in that comparison. |
| `hardware/qcom/media` | Keep Kona HAL candidate | One-file delta from local upstream/calcite-865: conf_files/kona/media_codecs.xml, 97 additions and 1 deletion, adding vendor OMX AAC declarations. Runtime codec validation remains pending. |
| `vendor/qcom/opensource/usb` | Keep Kona HAL candidate | Only vendor_product.mk differs: selects FunctionFS MTP for kernel 4.19. Requires the selected kernel to enable matching FunctionFS/MTP options; no kernel verification was performed. |
| `vendor/qcom/opensource/audio-hal/primary-hal` | Keep Kona HAL candidate | Same snapshot as the earlier approved source. Optional stock-primary-HAL selection is a hardware integration switch, not a product app feature. Zero diff from the earlier selected baseline does not establish equality with upstream PA. |
| `build/make` | Use original PA | Eight-file delta mixes a Wi-Fi build switch with BuildBuddy paths, release-key reporting, build ID, UFFD-GC defaults, a PRODUCT_COPY_FILES reset, and Traceur packaging. Do not take the complete fork. Wi-Fi switch is not enabled by the current kebab tree. |
| `build/soong` | Use original PA and preserve user edits | Seven-file delta against PA after subtracting saved user Ninja/RBE edits: BuildBuddy wrapper/default paths, canonical working directories, disabled filesystem creator, and removal of AOSPA_VERSION from dumpvars. Preserve the separate soong-workspace.patch; these local user edits are not Sanji additions. |
| `device/qcom/common` | Use original PA; isolate future compatibility fixes | 39-file mixed delta includes Laminar KGSL policy, perf config/tuning and stock-perf selection, extra audio packages, legacy lights/media discovery, and unrelated platform policy removal. Do not import it wholesale. Legacy media header discovery and lights providers need product/dependency evidence before porting. |
| `hardware/samsung-ext/interfaces` | Omit unverified extra project | No original PA checkout and no surviving local reference clone. The retry via gh failed with HTTP 403, so the source contents could not be audited. Current kebab source declarations and generated vendor Android.bp have no Samsung debug-interface dependency; omit until an actual dependency is identified. |
| `device/qcom/sepolicy_vndr` | Use original PA; isolate Kona policy later | 39-file delta adds a Kona policy subtree plus generic USB, diagnostic context and privileged-app perf rules. Kona policy is hardware-related, but generic changes and duplicate context removal need validation against kebab ownership. Do not blanket-import alioth policy. |
| `system/libhwbinder` | Use original PA | One-file delta replaces the fatal shrinking-threadpool assertion with a log and continues configuration. It changes a global binder invariant; retain as a candidate only if a kebab backend demonstrates the failure. |
| `frameworks/av` | Use original PA | 108 files differ: per-app audio APIs, Bluetooth/wired co-play, Dolby integration, Xiaomi/Oplus camera changes and upstream platform/media changes. Exact original PA snapshot d0cf9d91 reconstructed locally. No additional AV patch is selected: current kebab does not enable a camera-service extension or import the Xiaomi camera apps, and there is no reproduced recording failure yet. |
| `frameworks/base` | Use original PA; previously excluded | Explicit PenguinOS framework fork, already removed from the manifest in fde7457. Original PA commit is known from installed.json, but its original checkout/object store is no longer available. No new complete baseline diff claimed. |
| `frameworks/native` | Use original PA; previously excluded | Explicit PenguinOS native framework fork, already removed in fde7457. Original PA commit is known, but the original checkout/object store is no longer available. No new complete baseline diff claimed. |
| `build/release` | Use original PA | Ten-file delta changes lockscreen-blur, native zygote/framework and Wi-Fi ranging flags. These are ROM feature choices rather than Kona HAL requirements. |
| `device/qcom/sepolicy` | Use original PA; port policy with its service | Eight-file delta adds qtiaudiohalvendorextn policy/service labels, mediaserver perf access, MIUI-camera TCM access and broadens a camera property owner rule. Port only rules required by the final kebab service set. |
| `hardware/interfaces` | Use original PA; isolate legacy interface providers later | 45-file delta restores legacy configstore/light HIDL interfaces, adjusts FCM kernel-config selections, and adds Wi-Fi behavior/tests and CAS changes. Legacy declarations may be needed, but matrix/kernel changes and Wi-Fi toggles must not be imported without the corresponding kebab contracts. |
| `packages/modules/Connectivity` | Use original PA; review kernel backports separately | 14-file delta combines VPN tethering, connectivity/DNS/firewall features, larger BPF maps, and relaxed kernel-version checks. For 4.19, identify required BPF backports and loader compatibility together; simply bypassing version checks is not sufficient. |
| `vendor/qcom/opensource/power` | Use original PA | 21-file delta adds Laminar.cpp/h and KGSL/uclamp behavior, session changes, power interface-version changes and unrelated platform configs. Kebab already has its own double-tap mode extension; do not import an unrelated controller. |

## Selected sources

Five of the original nineteen Sanji repositories remain manifest selections:
GPS, display, media, USB and audio. The existing thermal source from Sanji and
PA Oplus source from aospa-trees remain selected separately. The original PA
manifest supplies build, frameworks, power, Connectivity and general policy.

No additional AV patch is selected without a demonstrated kebab requirement.
The camera-service extension variable is not enabled in this tree; Xiaomi camera
apps are not imported. OMX/AAC recording, camera metadata compatibility and stock
OnePlus camera behavior remain validation work, not assumed requirements for a
wholesale framework replacement.

## Compatibility work to revisit

- Legacy HIDL configstore/light definitions: identify actual consumers first.
- Kona policy: merge against kebab labels, attributes and service ownership.
- Common media/light discovery: check selected module providers and variants.
- Kernel 4.19 networking: verify BPF features/backports and loader requirements;
  do not treat version-check removal as a complete compatibility port.
- Perf and power: retain PA and the local device mode extension; reconcile the
  stock OnePlus perf ABI before selecting a different implementation.

## Evidence and limits

Full path lists, selected/original revisions and raw-diff hashes are recorded in
sanji-source-audit.json. Raw comparison patches are saved outside the device repo
under `pa-kona/backups/sanji-scope-audit/`. For missing Git objects, comparisons
use saved original file snapshots. The Soong comparison subtracts the saved
Ninja/RBE workspace patch so user changes are not attributed to Sanji.

GitHub fetches returned HTTP 403. The Samsung interface source is unavailable
and was omitted without claiming a code audit. The GPS local upstream branch is
a different generation; it does not establish an exact legacy delta. The two
already-excluded PenguinOS framework forks lack their original PA checkouts.

The local manifest parses and its project selection is checked against the
original effective manifest, but no live repo manifest expansion, product build,
SELinux compilation, complete VINTF merge or hardware test was possible. The
previous source-provider/VINTF pass is historical and must be rerun after applying
this selection to the current PA checkout. Existing references/backups and the
user’s saved Soong workspace patch are preserved.
