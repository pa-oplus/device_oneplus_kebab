# One unified kebab vendor producer

The user selected the TheMuppets kebab and sm8250-common repositories as inputs.
Both are cloned on lineage-24.0 under pa-kona/vendor-reference. This plan replaces
the earlier two-producer layout with one vendor/oneplus/kebab producer when
activated. No new GitHub vendor repository or PA vendor include is activated yet.

## Why there were two proprietary lists

Lineage shares sm8250-common across several OnePlus devices and keeps kebab-only
files separately. The initial extractor preserved those original boundaries.
Android does not require that split for this standalone device tree. One combined
proprietary-files.txt can generate one vendor tree while retaining all source
pins, module suffixes, partition destinations and symlink directives.

## Reviewed inputs and staging result

| Input | Branch | Commit | Files |
|---|---|---|---:|
| TheMuppets/proprietary_vendor_oneplus_kebab | lineage-24.0 | 9ecfe6349188e4f961aa7fc878e478e23cc3a6aa | 107 |
| TheMuppets/proprietary_vendor_oneplus_sm8250-common | lineage-24.0 | e3f6fd86ad47653897753cc2a7a22e80c1b46a18 | 2443 |

- [x] All 2,550 metadata destinations exist in the supplied repositories.
- [x] No destination overlap between the two input lists.
- [x] All 32 pinned entries match an allowed hash (four match their fixup hash).
- [x] Existing generated trees have 777 module names without cross-input collisions.
- [x] DES helper parses one merged-list candidate containing all 2,550 entries.
- [x] Isolated regeneration produces one vendor/oneplus/kebab tree, four generated
  build files and 777 unique Blueprint modules, with no common-vendor/CAF imports.
- [x] All staged proprietary bytes still match the reference clones; no blob
  extraction/fixup pass was rerun. The input repositories remain clean.

The candidate list is at
pa-kona/vendor-reference/merge-review/proprietary-files.merged.txt. The prototype
output is at pa-kona/vendor-reference/merge-review/staging/vendor/oneplus/kebab.
It is a generation proof, not a production/vendor build or a published repository.
The current device extractor still has two producers until execution step 1.
Detailed machine-readable results are in vendor-consolidation-audit.json.

## Tools found in des

DES tools/extract-utils at 78ba5d58c4b06712e18bb387a2a72eac8fbc8d70 supplies the
Python FileList/parser/module/generation APIs and templates. Its metadata and
single-producer generation paths have been exercised successfully. Patchelf 0.18,
ota_extractor, stripzip and LLVM objdump/readobj are present and executable.
No additional vendor-generation tool is currently missing. The prototype uses
an isolated output root; it does not write into DES's vendor directories.

## Issues to resolve before activation

1. The fingerprint backend already depends on libshims_fingerprint.oplus.so.
   A reference implementation exists in DES hardware/oplus/fingerprint/shims,
   but not the selected PA Oplus tree. Decide/provide a compatible local module
   while retaining the selected hardware/oplus source. This shim intercepts the
   backend's verified-boot state property reads; it is not a generic ABI rename.
2. Camera metadata and crypto shim dependencies already exist in the vendor
   inputs. Providers are present in PA hardware/lineage/compat; verify their
   vendor variants, visibility and required symbols before wiring the tree.
3. The vendor fingerprint manifest already has an intentional override=true for
   the standard 2.3 instance, overlapping the source wrapper declaration. Preserve
   or adapt that behavior with actual libvintf ordering/ownership validation;
   don't strip it or misreport it as an ordinary accidental duplicate.
4. The inputs contain OnePlus's HIDL perf 2.2 stack and client libraries. Reconcile
   it with the generic PA perf producer/configs and the selected Power HAL instead
   of installing competing perf stacks. The common recipe has a stock-blob
   selection flag, which must be used only after the complete ownership review.
5. Eleven vendor VINTF fragments contain 21 declared instances. They do not settle
   the 43 legacy common-manifest records already tracked for vendor/WFD/provider
   reconciliation. Source/vendor/service selection must determine their owners.
6. The ELF scan read 620 arm64 and 152 arm objects without parser errors and found
   201 needed library names outside the blob set. These are not 201 confirmed
   missing libraries: many are platform/source interfaces. Resolve actual providers,
   versions, variants and symbols, including WFD/display-related interfaces.

The existing Lineage outputs are already processed inputs. Regeneration must not
reapply binary/config/APK patches blindly. Keep origin hashes and the source list
pins; future extraction from a stock dump remains a separate validated workflow.

## Execution roadmap: five commits

- [ ] **1 — Unify metadata/extractor.** Promote the reviewed candidate to the sole
  proprietary-files.txt, change the extractor to one kebab module, remove the
  common-list/module contract and update metadata checks/provenance. Regenerate
  the vendor tree; do not concatenate the old generated Android.bp/Make files.
- [ ] **2 — Resolve compatibility providers.** Supply the fingerprint shim and
  verify the camera/crypto providers, using preserved source notices and actual
  symbol/variant checks. Do not replace the whole selected Oplus hardware tree.
- [ ] **3 — Resolve stack and VINTF ownership.** Reconcile OnePlus perf, source
  audio/media/display ownership, fingerprint override and required legacy service
  declarations. Keep WFD decisions explicit and preserve functional dependencies.
- [ ] **4 — Wire one vendor output.** Use vendor/oneplus/kebab/kebab-vendor.mk and
  its single BoardConfigVendor.mk. Remove two-producer imports/references from
  active metadata and use strict includes after the actual output exists.
- [ ] **5 — Validate and publish the reviewed output.** Check module/copy/manifest
  collisions, ELF/provider/pin results, namespace paths and generated syntax;
  record limitations and source provenance. Then create the dedicated vendor
  repository from the reviewed output, rather than publishing the staging proof.

Full product compilation, kernel/header integration, enforcing policy and hardware
validation remain later gates. Kernel acquisition is still deferred.
