# Reference source snapshots

These repositories were inspected read-only. Canonical build paths describe the
intended source layout; clones are not automatically installed into a PA checkout.
Kernel/vendor acquisition remains deferred. The stopped frameworks_basepengu
clone is excluded as requested.

| Reference | Branch | Commit |
|---|---|---|
| pa-sanji/android_build_release | `calcite` | `b8badbd159ed5f6a54fb063798c3659078a156df` |
| pa-sanji/android_device_qcom_common | `calcite` | `995303ab9aa7e81da787bd41a85688cda7f7e5bd` |
| pa-sanji/android_device_qcom_sepolicy_vndr | `calcite` | `d6709e1b2b1361b3c0ab94f8a348510fe9dcfb50` |
| pa-sanji/android_frameworks_nativepengu | `calcite` | `eea988c99c9d365b3f41c4f129bc163b606f6654` |
| pa-sanji/android_hardware_qcom_audio | `calcite` | `da8e3bed19be1398964418475e208a86f67bc1c2` |
| pa-sanji/android_hardware_qcom_display | `calcite` | `86a98cacda4e2dc6014bdf69c407f9d29c377af1` |
| pa-sanji/android_hardware_qcom_gps | `calcite` | `e822feb886a59de37fd674a05929477e607e678d` |
| pa-sanji/android_hardware_qcom_media | `calcite` | `96e7eebd6c6b2a722798c88f017d143a6de65bb9` |
| pa-sanji/android_hardware_qcom_thermal | `calcite` | `339ecff03f7509351035c6d33cef2b5768c86f6d` |
| pa-sanji/android_system_bpf | `calcite` | `3960aa2c5fcb2d1b41d93dabba2f4a284dfa6e22` |
| pa-sanji/android_system_libhwbinder | `calcite` | `a76d5def48437a73a1c0e7e7e216a1032311920d` |
| pa-sanji/android_vendor_aospapengu | `calcite` | `087cf18eb8abf796f64ed9f073e611f53960e9ed` |
| pa-sanji/android_vendor_qcom-opensource_usb | `calcite` | `9ae3e810143d005f3fc548ad790921f871e3b11c` |
| pa-sanji/build_make | `calcite` | `08b66c720fbcc3c1871e42d474c59e32aef3fc29` |
| pa-sanji/build_soong | `calcite` | `02938b5924ad259819e0e022194ba0899a3abe2e` |
| pa-sanji/device_qcom_sepolicy | `calcite` | `f074369b27d88089e73a0efa5c04fa63443e4765` |
| pa-sanji/device_xiaomi_aliothCLO | `calcite` | `9d3a6166232757d0633da5286baaa65ddacccfc0` |
| pa-sanji/frameworks_av | `calcite` | `6c91a1be53cf8db90a7d8a567dbbf8969d16f3c4` |
| pa-sanji/hardware_interfaces | `calcite` | `35664468268e87565ffc646773e76e67b40e78c2` |
| pa-sanji/packages_modules_Connectivity | `calcite` | `7989a13dcc898a5caa2b957bd4ea9a62d250fa5c` |
| pa-sanji/vendor_qcom_opensource_power | `calcite` | `879bf805323258eb77f95c0624216ff31144ed4a` |
| https://github.com/clo-oscaro/hardware_oplus | `calcite` | `cc126d9674aa6c3e2661303387498c410cf4b14a` |
| https://github.com/LineageOS/android_hardware_oplus.git | `lineage-24.0` | `0cdf1886748b31baf0825a9f879265a20d143151` |

The PA Oplus tree in aospa-trees is the selected hardware source. The separately
cloned Lineage Oplus tree supplies source reference for the device-local amplifier
and UDFPS adaptation only. Do not replace the selected hardware source wholesale.

## Additional local source checks

Health AIDL/product and qcwcn module interfaces were inspected in aospa-trees;
the supplicant generator was inspected in pa/external/wpa_supplicant_8. The
following content hashes identify those inputs without assuming Git metadata is
available for the copied source folders. These are API checks, not a declaration
of a fully synchronized build manifest.

| Local source | SHA-256 |
|---|---|
| `aospa-trees/vendor/qcom/opensource/healthd-ext/health-vendor-product.mk` | `e5d3955323445001dc81e1da4d5d577e3608f702888369b629f3a685491258f5` |
| `aospa-trees/vendor/qcom/opensource/healthd-ext/aidl/Android.bp` | `d857b0e9eb40cd2d8b5ea0dad1167f4326b251018731606f37890aa025070abf` |
| `aospa-trees/hardware/qcom/wlan/qcwcn/wifi_hal/Android.bp` | `cb47b618d231163f46479a40ecb17fd9a8313860b73507ce35d3b005f9c0e211` |
| `pa/external/wpa_supplicant_8/wpa_supplicant/Android.bp` | `5b601a86d1a3a2ee3154bc961da1280eea7de4e61c54215dd66a042a2b718549` |

Additional source interfaces checked for the NFC/USB/boot/radio/DRM batch:

| Local source | SHA-256 |
|---|---|
| `aospa-trees/hardware/nxp/nfc/snxxx/Android.bp` | `d82716f109cf5e9f0ecbd886fcbf1d58164b41feb13c2b834230a0b7df2b0d30` |
| `aospa-trees/hardware/qcom/bootctrl/aidl/Android.bp` | `4b4ffd27787b712a87bc0836d6aa3fa1d163ef384aa7fcef2b046ae5acc04c1a` |
| `aospa-trees/vendor/qcom/opensource/recovery-ext/oem-recovery/Android.bp` | `a498f42d95168eb58c8bcd151fea0654c0989c202ee7e15c476cb644333c292b` |

USB, ClearKey and the Oplus helper use the pinned calcite repositories above.

The QTI AIDL memtrack provider was additionally verified in
`aospa-trees/device/qcom/vendor-common/memtrack/Android.bp` (SHA-256
`f87d9dd8d551bddeb4e5bd86db8f4c63d27f932b536acac560551901a26d20a0`).
