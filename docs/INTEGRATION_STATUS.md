# Current integration status

The static device/vendor integration is prepared. It is not a completed PA build
or a tested release. The previous `/serverhive4/lostsignal502/pa` checkout is absent;
`des` and `edi_des` are DescartesOS checkouts and were not repurposed.

## Completed and checked

- One extractor/list generates one required vendor output, with 2,552 files and
  778 unique named vendor modules. All four generated build files reproduce exactly.
- All original 2,550 TheMuppets blob contents match their input clones. Two pinned
  DSP server inputs match the local PA common reference. All 34 pins are valid.
- Fingerprint shim substitutions and forwarding passed host checks; the existing
  PA camera/crypto vendor provider definitions are selected.
- Stock vendor perf HIDL 2.2 is the sole vendor perf stack. Exact PA system-client
  snapshots support HIDL fallback for API 30; a replacement/bridge was not needed.
- Generic Adreno, alarm, AV and WFD components that conflicted with stock modules
  are excluded. Stock blobs remain selected; required graphics/WFD settings are local.
- Thirty-four recorded local/reference-source/vendor fragments merge into 109
  unique instances with assemble_vintf, preserving the fingerprint override.
- All 52 legacy reference records have explicit static dispositions: 51 declared,
  one optional Oplus subsystem-radio interface not selected, zero unclassified.
  The optional omission is verified against the selected PA Oplus matrix and is
  not a claim that subsystem-radio is implemented.
- HIDL minor-version checks reject a 1.0 provider for a 1.1 requirement.
- The narrow Qualcomm Bluetooth-audio factory-registration patch applies to the
  saved PA service source. The source-readiness check requires it in the live tree.
- A pinned Lineage IPACM source implementing control 1.1 and quota warnings is
  selected in the prepared manifest and staged under pa-kona/pa-reviewed.

The HAL evidence, input hashes and narrower test scopes are recorded in
vendor-hal-evidence.json and vendor-integration-checks.json.

## Required before a build/boot claim

1. Identify or initialize the full PA source checkout. Apply the source manifest,
   install the device/vendor trees at canonical paths, and preserve user Soong edits.
2. Apply patches/system-core/0001-init-load-device-properties.patch and
   patches/hardware-interfaces/0001-audio-register-legacy-qti-bluetooth-factory.patch.
   Rerun source-provider/init/patch checks on that actual checkout.
3. Integrate the OnePlus kernel/defconfigs/generated headers. Verify IPACM's
   WAN_IOC_SET_DATA_QUOTA_WARNING ABI and all kernel interfaces used by the HALs.
4. Complete the real Soong/module/variant/install graph and undefined-symbol,
   linker namespace, IMS/framework, media/display and policy/matrix validation.
5. Build the product, then test registration, radio/data/IMS, audio/Bluetooth,
   camera, display/UDFPS, sensors, charging, USB, suspend, perf and tethering on device.

These require a real source/kernel build and hardware results. Manifest coverage
and reference snapshots cannot substitute for them. No device was flashed.
