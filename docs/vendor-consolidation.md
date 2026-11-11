# Unified kebab vendor integration

The single vendor repository is
https://github.com/pa-oplus/proprietary_vendor_oneplus_kebab, branch calcite.
Its published baseline is 52d6e8e. It was generated from the matching TheMuppets
lineage-24.0 inputs, preserving 2,550 already-processed blob files.

| Input | Commit | Entries |
|---|---|---:|
| proprietary_vendor_oneplus_kebab | 9ecfe6349188e4f961aa7fc878e478e23cc3a6aa | 107 |
| proprietary_vendor_oneplus_sm8250-common | e3f6fd86ad47653897753cc2a7a22e80c1b46a18 | 2443 |

## Five implementation commits

- [x] Unify the proprietary list and extractor into one kebab producer.
- [x] Require the single vendor product/board outputs through strict includes.
- [x] Add the fingerprint shim and select PA camera/crypto compatibility providers.
- [x] Assign vendor perf ownership and declare its VINTF instance; preserve the
  intentional fingerprint override. System perf client protocol remains open.
- [x] Audit regeneration, input bytes/pins, explicit copies, module names and
  recorded VINTF composition; record the results and integration limits.

The actual extractor regenerates all four vendor build files byte-for-byte.
There are 777 unique named vendor modules, no local/vendor name collisions and
no collisions among explicit device/vendor copy declarations. All 32 allowed
pins match; all 2,550 blobs match the original vendor clones. No binary/config/APK
fixup pass was replayed. The source powerhint.xml copy was removed in favor of
the stock OnePlus file already supplied by vendor.

The fingerprint shim's property substitutions/forwarding pass a host check. PA
camera/crypto provider definitions and required function names were checked.
The original PA Power HAL's four perf client entrypoints are exported in both
stock client architectures. Target library variants, full symbol resolution and
actual Power HAL behavior still require compilation/runtime validation.

Recorded local/reference-source/vendor VINTF composition passes both the ownership
checker and assemble_vintf: 31 inputs, 50 instances, one reviewed fingerprint
override. Forty-two legacy reference records remain unresolved. Input hashes and
check results are in vendor-integration-checks.json; vendor-consolidation-audit.json
preserves the original input/staging audit and links the current integration.

## Remaining gates

- [ ] Locate the current complete PA checkout; the former pa/ directory is absent.
- [ ] Apply reviewed sources, install device/vendor trees and preserve the init hook.
- [ ] Reconcile PA's AIDL perf2 system clients with the OnePlus HIDL 2.2 backend.
- [ ] Complete source/blob module variants, headers, symbol versions and ABI checks.
- [ ] Reconcile the 42 legacy vendor/WFD contracts and full matrices/SELinux policy.
- [ ] Integrate kernel/config/headers, build the product and test on device.
- [ ] Publish the local integration commits when GitHub write access succeeds.

Extraction from a fresh stock dump needs a separately reviewed fixup pipeline.
The previous scan's 201 external DT_NEEDED names are source/platform-provider
obligations, not 201 proven missing libraries. This work does not close that graph.
See VENDOR_INTEGRATION.md for exact service/provider boundaries and extraction.md
for the processed-input workflow. No full-build or boot-readiness claim is made.
