#
# Copyright (C) 2026 The Paranoid Android Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

# Android 17 no longer includes QCOM's generate_extra_images.mk, but
# build/core/Makefile still needs BOARD_PREBUILT_DTBOIMAGE when
# BOARD_KERNEL_SEPARATED_DTBO is set. Generate it from the DTBOs that
# the kernel build produces.
ifeq ($(strip $(BOARD_KERNEL_SEPARATED_DTBO)),true)
MKDTIMG := $(HOST_OUT_EXECUTABLES)/mkdtimg$(HOST_EXECUTABLE_SUFFIX)

$(BOARD_PREBUILT_DTBOIMAGE): $(MKDTIMG) $(PRODUCT_OUT)/kernel
	$(hide) $(MKDTIMG) create $@ \
	    --page_size=$(BOARD_KERNEL_PAGESIZE) \
	    $$(find $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/arch/arm64/boot/dts -name '*.dtbo')
	$(hide) chmod a+r $@
endif
