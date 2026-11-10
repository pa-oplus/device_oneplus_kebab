# Bluetooth ownership

Keep PA's common bt component for its stack integration, Bluetooth/LE permission
files and 4.19 return-delay selector. The OnePlus vendor transport is HIDL 1.0;
its service/implementation, RC, libbtnv and firmware are deferred vendor outputs.
The local VINTF entry matches Lineage common, whose extraction list includes the
service RC but no transport fragment. Reconcile it if the final vendor tree adds
one. The audio product already selects the platform Bluetooth audio implementation
and audio.bluetooth.default; this file does not add a competing audio service.

Preserve Lineage's Hastings controller, modem-NV support, profile defaults, power
estimates, offload flags/capabilities and BQR values in their original partitions.
Matching generic source-audio property keys are removed before the OnePlus values
are installed. These flags describe the reference configuration, not validated
codec support with the eventual PA stack/vendor combination.

No Xiaomi MAC-provisioning script is used: neither OnePlus baseline defines that
contract. Validate the NV/persist source with the final controller service, then
test persistent address, pairing, SCO calls, A2DP/offload/codec negotiation, hearing
aids, reconnect/suspend and enforcing policy. PA common external stack inheritance
and OnePlus legacy transport compatibility remain full-build/runtime checks.
