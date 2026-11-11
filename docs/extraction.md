# Unified vendor extraction

`extract-files.py` registers one `kebab` module. The sole active input is
`proprietary-files.txt`: 2,550 merged device/common entries generating
`vendor/oneplus/kebab`. The old common list and producer are removed.

Both TheMuppets lineage-24.0 inputs are already processed. Their existing hashes,
flags, aliases, symlinks and bytes are preserved. No stock-dump binary/config/APK
fixups are implemented or replayed. Extraction from an unprocessed stock dump is
not validated by this workflow. Original list provenance and unported fixup
references remain in extraction-reference.json.

When installed in a full Android source tree, `setup-makefiles.py` invokes the
single producer in regeneration mode. The integration audit regenerates the four
build files in a temporary root using the actual extractor and compares their
contents with the existing vendor repository; it never extracts or patches blobs.

```sh
python3 tools/check-extraction-metadata.py --extract-utils /path/to/tools/extract-utils
python3 tools/check-vendor-integration.py \
  --vendor-root /path/to/vendor/oneplus/kebab \
  --extract-utils /path/to/tools/extract-utils \
  --compat-root /path/to/hardware/lineage/compat \
  --reference-root /path/to/vendor-reference
```

The optional reference-root contains the two original
`proprietary_vendor_oneplus_kebab` and `proprietary_vendor_oneplus_sm8250-common`
clones. With it, the audit compares all 2,550 blob contents. Otherwise it checks
presence and all allowed metadata pins. Generated-module, explicit-copy and
provider checks are static and do not establish complete product/ABI compatibility.
