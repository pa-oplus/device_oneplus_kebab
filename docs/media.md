# OnePlus Codec2 baseline

The current Lineage OnePlus baseline disables OMX and records a proprietary
vendor.qti.media.c2@1.0-service, libraries and a pinned vendor manifest/RC.
This device therefore owns media configuration locally and removes `media` from
the common component list. It does not inherit hardware/qcom/media/product.mk,
which selects OMX implementations and generic kona configuration/profile copies.

The four local inputs are unchanged Lineage common files. Codec2InfoBuilder in
the inspected framework reads the software-codec APEX first, then explicitly
reads media_codecs_c2.xml and media_codecs_performance_c2.xml, then default XML.
No speculative master XML or old Google OMX audio list is added. Software codecs
remain owned by the platform APEX. The hardware service and its VINTF fragment
remain deferred vendor outputs; no duplicate default service is declared here.
Media profiles also remain OnePlus vendor outputs, not generic or alioth profiles.

Common seccomp extension files are selected at the same destinations as the QTI
component. Final vendor base/architecture policies and service sandbox arguments
still need reconciliation with the real binaries. Performance metadata is the
OnePlus baseline and does not establish achieved performance or CTS compliance.

Source OMX is intentionally disabled consistently with the product/audio baseline.
If recording, WFD or proprietary libraries require OMX, resolve the actual service,
codec lists, packages and manifest together rather than importing alioth's mixed
setup. The Lineage thumbnail-block-model flag is not set because the inspected
calcite framework does not expose that selector. Final library ABIs, codec
registration, secure playback, recording/AAC, thumbnails, WFD and video performance
remain build/device validation work.
