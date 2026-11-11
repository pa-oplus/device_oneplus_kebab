#
# Copyright (C) 2018-2025 The LineageOS Project
# Copyright (C) 2026 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oneplus/kebab

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo385

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := kona

# Display
TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE := true
TARGET_SCREEN_DENSITY := 450

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_kebab

# Kernel
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3 \
    cgroup.memory=nokmem,nosocket \
    loop.max_part=7 \
    lpm_levels.sleep_disabled=1 \
    msm_rtb.filter=0x237 \
    reboot=panic_warm \
    service_locator.enable=1 \
    swiotlb=2048
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_RAMDISK_USE_LZ4 := true

# Kernel source and configuration
TARGET_KERNEL_VERSION := 4.19
TARGET_KERNEL_SOURCE := kernel/oneplus/sm8250
TARGET_KERNEL_CONFIG := vendor/kebab-perf_defconfig
KERNEL_DEFCONFIG := vendor/kebab-perf_defconfig
KERNEL_LLVM_SUPPORT := true
KERNEL_CLANG_VERSION := r563880c

# Metadata
BOARD_USES_METADATA_PARTITION := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 100663296
BOARD_USERDATAIMAGE_PARTITION_SIZE := 236009631744
BOARD_FLASH_BLOCK_SIZE := 262144

BOARD_SUPER_PARTITION_SIZE := 7516192768
BOARD_SUPER_PARTITION_GROUPS := oneplus_dynamic_partitions
BOARD_ONEPLUS_DYNAMIC_PARTITIONS_SIZE := 3753902080
BOARD_ONEPLUS_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_ext vendor

BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor

# Retain kebab's vanilla product reserve using PA's GMS selection convention.
ifeq ($(TARGET_DISABLES_GMS),true)
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 800000000
endif

# Platform
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := kona
TARGET_USES_BLUR := true

# Recovery
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_NO_RECOVERY := false
BOARD_USES_RECOVERY_AS_BOOT := false
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/init/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 103
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_verification_disabled_flag
BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# Device properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Audio
# Preserve OnePlus's source-HAL features rather than alioth's stock-HAL path.
AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_EXT_AMPLIFIER := true
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_SSR := true
AUDIO_FEATURE_ENABLED_SVA_MULTI_STAGE := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true

# Camera provider declaration; this service does not install a VINTF fragment.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-camera.xml

# OnePlus vendor Bluetooth transport; vendor baseline has no HAL fragment.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-bluetooth.xml

# OnePlus qcwcn Wi-Fi driver/HAL build flags.
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := //hardware/qcom/wlan/qcwcn/wpa_supplicant_8_lib:lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := $(BOARD_HOSTAPD_PRIVATE_LIB)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_EVENT := "ON"
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_FEATURE_HOSTAPD_11AX := true
WIFI_HIDL_FEATURE_AWARE := true
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# OnePlus ODM secure-element service; NFC source HAL supplies its own fragment.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-secure-element.xml

# OnePlus vendor RIL registers legacy dual-SIM radio/SAP and radio-config instances.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-radio.xml

# OnePlus vendor gatekeeper/keymaster; no source or generic-QTI duplicate backend.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-security.xml

# The selected HIDL audio service has RC but no service-owned manifest fragment.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-audio.xml

# Framework-side optional Oplus/Pixelworks contracts from the selected PA hardware.
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    hardware/oplus/vintf/device_framework_matrix.xml

# Device-owned OnePlus nodes/services; common QTI policy is selected by PA.
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Export only the OnePlus platform-facing config property type to vendor policy.
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private

# Fail product configuration if the unified vendor output is missing.
include vendor/oneplus/kebab/BoardConfigVendor.mk

# The stock perf binary ships RC but no service-owned VINTF fragment.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-perf.xml

# Provider-backed legacy OnePlus services not carrying packaged fragments.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-oneplus-vendor.xml

# The selected IPACM registers config 1.0/control 1.1 without a bundled fragment.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-tetheroffload.xml

# The supplemental DSP server registers the legacy dspservice instance.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-dsp.xml

# Vendor media codec and Widevine DRM services.
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest-media.xml
