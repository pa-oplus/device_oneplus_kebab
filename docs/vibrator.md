# OnePlus vibrator

Select vendor.qti.hardware.vibrator.service.oplus from the user-selected PA
hardware/oplus tree. It supplies its own service RC and AIDL V1 manifest. Both
Lineage common and historical opkona select this service name; their source/API
versions differ, so no duplicate device-local implementation is imported.

The selected implementation detects /sys/class/leds/vibrator/activate and uses
LED/sysfs operations on kebab. Its RC owns rtp, vmax and waveform_index. The local
RC grants system access to its remaining activate/state/duration/brightness nodes.
The generic QTI vibrator component is not selected. The QTI excluded-input list
also excludes the OnePlus aw8697_haptic input device from framework key handling.

The optional Oplus effect streamer stays disabled; no effect configuration or
new waveform/voltage values are introduced here. The selected source's existing
LED timings/waveforms, kernel nodes, capabilities/callbacks and SELinux access
still require build and device validation. AIDL V1 compatibility must be checked
against the final platform matrix.
