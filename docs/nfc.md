# NFC and secure element

Select the PA NXP SNxxx AIDL V1 NFC service, matching current Lineage's selected
module. Its own RC/manifest declare INfc/default and the NXP extension. Platform
base products own the NFC app/APEX and SecureElement framework app; the device
adds Tag, NFC extras and the OnePlus NFC/OMAPI permissions. The generic common
NFC component is not enabled because it selects a different NQ NFC source stack.

The OnePlus extraction list supplies the project-19805 SN100 libnfc-nxp.conf,
libnfc-nci.conf and sn100u.bin at vendor destinations. These are deferred vendor
outputs; no alioth tuning, firmware or fabricated defaults are copied here.
The ODM vendor.qti.secure_element@1.2-service and implementation also remain
vendor-owned. The local manifest preserves Lineage's HIDL 1.2 SIM1/SIM2/eSE1
instances. Do not add the source NXP secure-element service alongside that backend.

Verify the actual ODM service registers those instances, its NXP NFC extension
compatibility, firmware/config interpretation and final platform matrices. Policy,
tag reads, HCE, eSE/UICC access, NFC toggle/reboot and payment behavior require a
complete build and hardware testing. Reference selection is not certification.
