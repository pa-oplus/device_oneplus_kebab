#
# Copyright (C) 2026 The Paranoid Android Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

# BOARD_PREBUILT_DTBOIMAGE is defined by AndroidBoardCommon.mk and generated
# by vendor/qcom/build/tasks/generate_extra_images.mk.
ifndef BOARD_PREBUILT_DTBOIMAGE
BOARD_PREBUILT_DTBOIMAGE := $(PRODUCT_OUT)/prebuilt_dtbo.img
endif

