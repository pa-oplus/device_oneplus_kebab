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
