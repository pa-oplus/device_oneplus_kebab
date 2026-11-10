# OnePlus GNSS

The ODM gps.conf is unchanged from current Lineage sm8250-common; historical
opkona also puts its OnePlus override in ODM. Preserve that partition and the
reference NTP fallback. The vendor baseline separately supplies vendor/etc/gps.conf,
GNSS 2.1 service/RC, its android.hardware.gnss manifest and vendor.qti.gnss 4.0
manifest, location libraries and supporting daemons/configurations. Those outputs
remain deferred vendor dependencies, not duplicate source packages here.

The generic common gps component is removed. Its legacy variant adds a QCC
manifest not present in the OnePlus baseline and can inherit a source GNSS service
alongside the vendor service. Do not select LOC_HIDL_VERSION=4.3 or a source GPS
product merely because kona falls into a common kernel-family branch. The newer
OnePlus vendor extraction list is the selected ownership reference; historical
opkona's source-service choice is not mixed with it.

No alioth assistance servers, emergency flags, location app or carrier packages
are imported. The copied configuration includes reference protocol/server settings;
final GNSS configuration precedence is vendor-library behavior and must be checked
with the actual binaries. Validate VINTF versions, cold/warm fixes, assistance,
measurements, geofencing, suspend, emergency/carrier behavior and policy on device.
