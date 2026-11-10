# Extraction interfaces and staged metadata

The standalone device repository hosts both extraction modules. Install it at
`device/oneplus/kebab` in the Android checkout with `tools/extract-utils` present.
The scripts use that checkout's Python helper API, not alioth's shell helper or
a sibling Lineage common device tree. The common module explicitly points its
metadata path back to this standalone tree.

| Input list | Generated vendor producer |
|---|---|
| proprietary-files.txt | vendor/oneplus/kebab |
| proprietary-files-common.txt | vendor/oneplus/sm8250-common |

Both lists are unchanged reference inputs, including source-version comments,
pins, renames, module flags and explicit symlinks. Their original repositories,
commits and SHA-256 values are in extraction-reference.json. The default source
version stated by both lists is KB2005_14.0.0.603(EX01), with separately pinned
exceptions retained. Metadata is not evidence that blobs were obtained or tested.

`extract-files.py` registers both modules; `setup-makefiles.py` delegates to it
with `--regenerate_makefiles`. Run them from the installed device directory only
when the required source dump/extracted inputs and helper dependencies are ready.
No vendor checkout, dump extraction, firmware download or generated makefiles were
created during this step. Existing device product/board vendor includes remain
deferred as described in VENDOR_INTEGRATION.md.

## Fixups and build boundary

Only the reference library module-name suffix mappings are adapted. Actual binary,
configuration and APK fixups are not ported without their input files and matching
PA API requirements. The original common extractor's target list is recorded in
extraction-reference.json for review: fingerprint manifest/backend shims, camera,
Widevine, WFD/APK/API changes, NFC configuration and IRQ settings require distinct
validation. No binary NOP, patched APK, debug reduction or speculative ABI rename
is applied by these scripts. Default helper ELF checking remains enabled.

Raw extraction/generation is not a build-ready vendor implementation: unported
fixups/pins can fail processing or leave incompatible outputs. Reconcile source
HAL/provider ownership, the duplicate manifest obligations in vintf-ownership.json,
module dependencies and required fixups before enabling strict vendor includes.
Do not remove pin failures or disable ELF checking merely to make generation pass.

## Read-only metadata check

`python3 tools/check-extraction-metadata.py --extract-utils PATH` imports the real
helper API, checks both module registrations and parses both lists without running
extraction or generating files. PATH is the checkout's tools/extract-utils folder;
it defaults to that canonical location when this tree is installed normally.
The current inputs contain 107 device and 2,443 common entries, with 2,550 unique
destinations. The setup wrapper's help path and Python syntax were also checked.
This does not resolve input pin/fixup hashes, ELF dependencies or generated-module
correctness, which need actual proprietary inputs and a complete source graph.

## Selected unified-vendor migration

The subsequent authorized planning step cloned both matching TheMuppets branches
and verified the DES helper. A combined-list candidate and a single-producer
staging output now exist, with all 2,550 blob contents preserved. See
[vendor-consolidation.md](vendor-consolidation.md) for audited inputs and the
five-commit migration plan. The two-producer script above is still the active
contract until that migration is executed; no vendor include has been enabled.
