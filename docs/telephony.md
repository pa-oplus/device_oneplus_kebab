# Telephony and IMS baseline

The device directly includes the common PA system/vendor telephony recipes once,
with telephony removed from the dispatcher list. This keeps PA's dataservices,
legacy 4.19 IPACM, dual-SIM flags, feature permissions and external framework/vendor
integration. Matching generic property keys are then replaced, preserving OnePlus
network mode 33,33, DPM feature 9, radio values and IMS/data properties in their
original vendor/system-ext partitions. These settings do not establish network
provisioning or working IMS. No modem/carrier data is manufactured.

Local VINTF preserves Lineage's radio 1.5 slot1/slot2, SAP 1.2 slot1/slot2 and
radio-config 1.1 declarations for the vendor RIL. Reconcile these against the final
vendor services/fragments. KebabCarrierConfig carries Lineage common vendor.xml
unchanged, with a unique package/module and the original product partition/priority.
The framework overlay enables the reference SA/NSA and carrier-dependent WFC
capabilities using resource names present in the inspected PA framework.

OnePlus vendor owns its IMS app/libraries/daemons, RIL and modem configuration.
The common PA stack also has external system framework/app outputs. Lineage's
telephony-ext/extphonelib/ims-ext-common Java module recipes are absent from the
inspected PA source layout, so they are not selected as nonexistent packages or
silently substituted. Their APIs, boot-classpath/shared-library ownership and
OnePlus IMS dependencies must be reconciled when final sources/vendor are wired.
The large carrier XML retains reference Oplus-specific keys; applicability depends
on the eventual framework/IMS clients. No carrier-specific MMS identity from a
different OnePlus model is copied into framework resources.

Full build/RRO linking, VINTF/policy and real dual-SIM data/calls/SMS, NR, VoLTE,
VoWiFi, handover and carrier provisioning tests remain pending. Emergency behavior
requires dedicated validation; XML values do not establish carrier certification.
