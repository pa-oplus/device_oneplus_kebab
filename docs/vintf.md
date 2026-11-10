# VINTF integration boundaries

BoardConfig selects the framework-side device matrix supplied by the selected PA
hardware/oplus source. This is the same integration point used by the Lineage
OnePlus common tree and corresponds to the actual Oplus/Pixelworks hardware tree.
Its optional vendor interfaces accept advertised services; they do not install,
require or enable every optional HAL listed. No Xiaomi or Dolby matrix is added.

assemble_vintf parses this matrix, and optional OnePlus interface names can be
compared with the vendor reference manifest. This does not prove compatibility of
the complete product. The common PA QTI product adds QTI matrices/framework
manifest only under TARGET_FWK_SUPPORTS_FULL_VALUEADDS; do not unconditionally
copy Lineage CAF paths or add duplicate QTI matrices to conceal source-layout gaps.

Local manifests cover the selected device-owned audio, Bluetooth, camera, radio,
secure-element and security instances. Source HAL modules own their own fragments,
and remaining OnePlus vendor fragments remain deferred outputs. Final compatibility
must assemble all fragments, actual framework/device matrices, shipping FCM/kernel
requirements and SELinux versions. That check still needs the final PA product,
source providers and vendor output; the local level-7 merge is only a syntax and
local ownership check. In particular, optional entries are not a VINTF bypass.

## Recorded ownership audit

Run `python3 tools/check-vintf-ownership.py` from the repository root. The JSON
inventory preserves every record in the pinned Lineage common manifest and lists
thirteen known selected source-service fragment providers. `--source-root PATH`
checks those fragments in a canonical Android source layout; missing files fail.
Duplicate concrete HAL instances fail, including HIDL same-major instance clashes.
`--require-reference-coverage` fails while reference/provider obligations remain.
Without it, success means only that the supplied declarations have no detected
conflicts; unresolved counts are always printed.

The current audit covers nine of the 52 reference records locally and leaves 43
for vendor/WFD/common-provider reconciliation. The memtrack source provider is now verified in device/qcom/vendor-common. Do not copy those 43 registrations blindly:
some are supplied by eventual vendor fragments, some differ from source providers,
and WFD remains separate. The thirteen recorded source-service fragments plus local
manifests merge with assemble_vintf, but this is still not the final vendor product.
The tool does not infer module installation, start services or fetch any sources.
