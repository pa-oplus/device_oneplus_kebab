# Unified kebab vendor integration

The vendor repository is https://github.com/pa-oplus/proprietary_vendor_oneplus_kebab,
branch calcite. One proprietary list and one producer generate vendor/oneplus/kebab,
strictly required by the device product and board configuration.

| Inputs | Provenance | Files |
|---|---|---:|
| TheMuppets kebab, lineage-24.0 | 9ecfe6349188e4f961aa7fc878e478e23cc3a6aa | 107 |
| TheMuppets sm8250-common, lineage-24.0 | e3f6fd86ad47653897753cc2a7a22e80c1b46a18 | 2443 |
| PA common DSP server binary/init supplement | Local reference snapshot; original commit unavailable; exact SHA1/SHA256 pins in vendor SUPPLEMENTAL_INPUTS.json | 2 |

The original 2,550 blob contents are unchanged. The two additional DSP inputs
supply a service needed by the existing DSP clients without importing a conflicting
common RPC stack. The resulting 2,552 entries regenerate four identical build files
and 778 unique named vendor modules. All 34 pins pass; supplemental source bytes
are compared directly with the saved PA reference. No binary/config/APK fixups were
replayed. Fresh stock-dump extraction remains a separate unvalidated workflow.

## Current checks

The fingerprint shim passed host property substitution/forwarding checks. PA's
camera/crypto vendor provider contracts are selected. The stock perf client
exports the four PA Power HAL entrypoints in both architectures. Exact PA system
clients have a HIDL 2.2 fallback for API 30, so no adapter was needed.

Generic common Adreno/alarm/AV/WFD components had 51 overlapping module names
with the unified stock output and are excluded. Their needed device settings are
local. The explicit source powerhint.xml copy was removed in favor of stock vendor.
No duplicate local/vendor module names or explicit device/vendor copy destinations
are found; this is not a complete product-wide install-graph check.

The recorded local/reference-source/vendor VINTF merge passes ownership checks,
minor-version checks, strict reference resolution and assemble_vintf: 34 inputs,
109 unique instances and one preserved fingerprint override. Of 52 legacy records,
51 are declared and one optional subsystem-radio record is explicitly not selected.
Its optional status is verified against the selected PA Oplus matrix. There are
zero unclassified static records, not zero remaining build/runtime tasks.

Detailed provider evidence and test input hashes are in vendor-hal-evidence.json
and vendor-integration-checks.json. The original source/staging audit remains in
vendor-consolidation-audit.json, with a separate current integration summary.

## Unfinished build and runtime gates

See INTEGRATION_STATUS.md. The full PA checkout is missing. The Bluetooth-audio
registration patch, selected IPACM source, kernel warning-quota ABI and all target
variants/headers/ELF symbols/IMS/policy/matrices require actual product validation.
Complete build and device tests have not been run. The earlier 201 external
DT_NEEDED names are provider obligations, not 201 confirmed missing libraries.
