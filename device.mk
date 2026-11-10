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
    audio \
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
