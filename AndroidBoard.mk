#
# Copyright (C) 2026 The Paranoid Android Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

# BOARD_PREBUILT_DTBOIMAGE is normally defined by
# vendor/qcom/opensource/core-utils/build/AndroidBoardCommon.mk. Define it
# here as well so the QCOM image generation rules below always have a target.
ifndef BOARD_PREBUILT_DTBOIMAGE
BOARD_PREBUILT_DTBOIMAGE := $(PRODUCT_OUT)/prebuilt_dtbo.img
endif

# QCOM image generation (dtbo, dtb, etc.) from the kernel build output.
include vendor/qcom/build/tasks/generate_extra_images.mk
