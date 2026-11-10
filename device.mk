#
# Copyright (C) 2018-2025 The LineageOS Project
# Copyright (C) 2026 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/oneplus/kebab

# A/B: kebab has a dedicated recovery partition and no vendor_boot partition.
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Platform: product configuration is evaluated before BoardConfig.mk.
TARGET_BOARD_PLATFORM := kona
TARGET_KERNEL_VERSION := 4.19

# QTI: consumed by device/qcom/common/common.mk through the PA product config.
# Do not inherit common.mk a second time here. Hardware-specific overrides follow
# in subsequent bring-up commits, before the PA product configuration is inherited.
TARGET_COMMON_QTI_COMPONENTS := \
    adreno \
    alarm \
    av \
    bt \
    charging \
    display \
    gps \
    init \
    keymaster \
    media \
    overlay \
    perf \
    telephony \
    usb \
    wfd \
    wlan

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 30
BOARD_SHIPPING_API_LEVEL := 30

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Wi-Fi firmware links: preserve the OnePlus persist and ODM locations.
PRODUCT_PACKAGES += \
    firmware_WCNSS_qcom_cfg.ini_symlink \
    firmware_wlan_mac.bin_symlink

# OnePlus init; generic Qualcomm init remains owned by the common QTI component.
PRODUCT_PACKAGES += \
    init.oplus.hw.rc \
    init.oplus.hw.recovery.rc \
    init.oplus.rc \
    init.oplus.sh \
    init.target.rc \
    ueventd.kebab.rc

# Fstab: vendor for late mounts and boot ramdisk for first-stage mounts.
# Recovery receives the same source through TARGET_RECOVERY_FSTAB.
PRODUCT_PACKAGES += \
    fstab.qcom \
    fstab.qcom.ramdisk

# OTA postinstall: keep filesystem types aligned with BoardConfig and fstab.
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

# Firmware mount directories used by the OnePlus fstab.
PRODUCT_PACKAGES += \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint

# Device-owned source audio configuration.
KEBAB_AUDIO_CONFIG_PATH := device/oneplus/kebab/configs/audio
KEBAB_AUDIO_HAL_PATH := vendor/qcom/opensource/audio-hal/primary-hal

# Own audio locally: retain source kona feature flags without inheriting the
# common audio component a second time. The source checkout must provide this.
include $(KEBAB_AUDIO_HAL_PATH)/configs/kona/kona.mk

# Use one HIDL 6.0 service/implementation, matching the OnePlus baseline.
# The generic kona recipe also selects older services and implementations.
PRODUCT_PACKAGES := $(filter-out \
    android.hardware.audio@2.0-service \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio@4.0-impl \
    android.hardware.audio.effect@4.0-impl \
    android.hardware.audio@5.0-impl \
    android.hardware.audio.effect@5.0-impl \
    android.hardware.soundtrigger@2.1-impl \
    android.hardware.soundtrigger@2.2-impl \
    audio.a2dp.default \
    $(AUDIO_HAL_TEST_APPS),$(PRODUCT_PACKAGES))

PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.audio.service \
    android.hardware.bluetooth.audio-impl \
    android.hardware.soundtrigger@2.3-impl \
    audio.bluetooth.default \
    audio.primary.kona \
    audio.r_submix.default \
    audio.usb.default \
    audio_amplifier.qcom \
    liba2dpoffload \
    libbatterylistener \
    libcomprcapture \
    libexthwplugin \
    libhdmiedid \
    libhfp \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libsndmonitor \
    libspkrprot \
    libssrec \
    libvolumelistener

# Match the common QTI tinycompress integration for a 4.19 source HAL.
$(call soong_config_set,tinycompress,enable_extended_compress_format,true)
$(call soong_config_set,tinycompress,loop_compress_read,true)
AUDIO_FEATURE_ENABLED_DYNAMIC_LOG := false
BOARD_SUPPORTS_OPENSOURCE_STHAL := false

# Replace generic kona copy destinations in this directly included recipe.
# PA searches /vendor/etc/audio before /vendor/etc, so both primary-policy
# destinations must resolve to the same OnePlus configuration.
kebab_audio_copy_destinations := \
    $(TARGET_COPY_OUT_VENDOR)/etc/audio_io_policy.conf \
    $(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_policy_configuration.xml \
    $(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info_intcodec.xml \
    $(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths.xml \
    $(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml
PRODUCT_COPY_FILES := $(filter-out $(foreach dest,$(kebab_audio_copy_destinations),%:$(dest)),$(PRODUCT_COPY_FILES))

PRODUCT_COPY_FILES += \
    $(KEBAB_AUDIO_CONFIG_PATH)/audio_io_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_io_policy.conf \
    $(KEBAB_AUDIO_CONFIG_PATH)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_policy_configuration.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/audio_policy_configuration_a2dp_offload_disabled.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_a2dp_offload_disabled.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/audio_platform_info_intcodec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info_intcodec.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_ODM)/etc/sound_trigger_mixer_paths.xml \
    $(KEBAB_AUDIO_CONFIG_PATH)/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_ODM)/etc/sound_trigger_platform_info.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml
