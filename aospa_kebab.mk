#
# Copyright (C) 2018 The LineageOS Project
# Copyright (C) 2026 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit the base product before the device and PA configuration.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Preserve the Lineage baseline until media integration is reviewed.
TARGET_SUPPORTS_OMX_SERVICE := false

$(call inherit-product, device/oneplus/kebab/device.mk)
$(call inherit-product, vendor/aospa/target/product/aospa-target.mk)

# Boot animation
TARGET_BOOT_ANIMATION_RES := 1080

PRODUCT_NAME := aospa_kebab
PRODUCT_DEVICE := kebab
PRODUCT_MANUFACTURER := OnePlus
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := KB2005

PRODUCT_GMS_CLIENTID_BASE := android-oneplus

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceName=OnePlus8T \
    DeviceProduct=OnePlus8T \
    SystemDevice=OnePlus8T \
    SystemName=OnePlus8T
