# DRM ownership and compatibility

Select the source android.hardware.drm-service.clearkey module from calcite
frameworks/av. It installs its own RC and AIDL V2 IDrmFactory/clearkey fragment;
no additional local ClearKey manifest is added. Do not also select its lazy or
APEX service variants. Preserve Lineage's vendor drm.service.enabled property.

The OnePlus vendor producer owns the ODM Widevine HIDL 1.3 service, its RC/VINTF
fragment, libwvdrmengine and liboemcrypto. QSEECom, trusted applications and firmware
remain deferred vendor/kernel dependencies. Do not replace them with alioth DRM
blobs/shims or declare an AIDL Widevine instance for the legacy service.

The selected PA hardware/oplus supplies wvmkiller, also selected by current
Lineage OnePlus. This oneshot opens the Widevine plugin, reads systemId and sets
vendor.wvm.disable_l1=1 when that string exceeds five characters. Its property
trigger exports FORCE_LEVEL3_OEMCRYPTO and restarts the known Widevine services.
That is the source's conditional L3 recovery behavior; selection does not establish
that a particular unit needs fallback or that L1 provisioning works. Validate the
actual vendor service name/property policy and inspect the helper logs on device.

Final framework matrices must accept both source ClearKey and the vendor Widevine
instance, with no duplicate fragments. The base Lineage manifest's wfdhdcp DRM
instances belong to the still-pending WFD integration and are not asserted here.
Secure decoding, provisioning, playback, suspend/resume, service restarts and DRM
compatibility tests remain required. No security-level/certification claim is made.

## Helper domain

The selected wvmkiller binary now has a dedicated init-transitioned vendor domain,
DRM client attributes and the HIDL manager property access used by the PA Oplus
reference. Its single vendor.wvm.disable_l1 boolean has an exact vendor-internal
context and is writable by the helper. No direct TEE, keybox, OEMCrypto file or
Widevine-server domain permissions are added for this client.

The source RC handles the property event and service restarts; the helper does
not receive a generic ctl.restart capability. This preserves the reference's
conditional L3 recovery behavior rather than forcing a level unconditionally.
Validate the real Widevine service names, property/event behavior and policy in
the final product. The reference-policy compile is not proof of DRM provisioning.
