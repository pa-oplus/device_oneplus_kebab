# Gatekeeper and keymaster ownership

The OnePlus common extraction list supplies the QTI gatekeeper 1.0 service/RC and
64-bit implementation, plus keymaster libraries. Kebab's own extraction list adds
the QTI keymaster 4.1 service/RC. The device manifest declares exactly those default
HIDL instances, matching the common PA manifest versions and Lineage gatekeeper.

Remove keymaster from the generic QTI component list: that component also imports
its own gatekeeper/keymaster binaries and libraries, overlapping the OnePlus
producers. Do not select a second source service, KeyMint conversion, StrongBox or
an unrelated Qualcomm keymaster blob set. The OnePlus vendor includes remain
explicitly deferred until the vendor integration phase.

Keymaster, gatekeeper, QSEECom, trusted applications and device firmware must form
a compatible set. VINTF syntax checks establish declaration structure only, not
that services register or that existing credentials/decryption work. Full matrix,
ABI, policy, enrollment/authentication, keystore and recovery decryption validation
remain pending. No keystore data or block devices were accessed by these checks.
