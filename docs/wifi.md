# OnePlus Wi-Fi

Use the source AIDL Wi-Fi service, qcwcn HAL/control libraries, hostapd and
supplicant, matching current Lineage service ownership. The older opkona HIDL
Wi-Fi service is not selected. Preserve OnePlus NL80211, /dev/wlan ON/OFF, Wi-Fi
Aware/RTT/Passpoint and dual-interface configuration. PA's AIDL HAL still consumes
the legacy-named Aware and dual-interface build flags. Private driver libraries
use PA's explicit qcwcn namespace syntax.

The inspected PA supplicant source exposes wpa_supplicant_conf_gen rather than
an installed generic wpa_supplicant.conf module. KebabWpaSupplicantConf installs
its output under vendor/etc/wifi with a unique module name. The two supplicant
overlays, cnss-daemon and ODM WCNSS configuration remain OnePlus vendor outputs;
existing firmware links point to that configuration and the device persist MAC.

The generic common wlan component is removed: its kona include selects both
qca6390 and qca6490 driver builds and generic configuration. No driver modules,
INI calibration, dual-STA or bridged/dual-AP combinations are invented here.
Kernel driver/module integration and the generic component's IPACM replacement
must be resolved alongside kernel and USB/tethering bring-up. Validate vendor HAL
ABI, firmware, persistent MAC, scan/connect, WPA3, hotspot/P2P concurrency, Aware,
RTT, suspend and policy on the final source/kernel/vendor combination.
