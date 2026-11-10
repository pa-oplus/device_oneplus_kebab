// Copyright (C) 2026 Paranoid Android
// SPDX-License-Identifier: Apache-2.0

#include <unistd.h>

#include <aidl/android/hardware/power/Mode.h>
#include <android-base/file.h>
#include <android-base/logging.h>

using aidl::android::hardware::power::Mode;

#ifndef KEBAB_DT2W_NODE
#define KEBAB_DT2W_NODE "/proc/touchpanel/double_tap_enable"
#endif

bool isDeviceSpecificModeSupported(Mode type, bool* supported) {
    if (type != Mode::DOUBLE_TAP_TO_WAKE) return false;
    *supported = access(KEBAB_DT2W_NODE, W_OK) == 0;
    return true;
}

bool setDeviceSpecificMode(Mode type, bool enabled) {
    if (type != Mode::DOUBLE_TAP_TO_WAKE) return false;
    if (!android::base::WriteStringToFile(enabled ? "1" : "0", KEBAB_DT2W_NODE)) {
        PLOG(ERROR) << "Failed to set kebab double-tap-to-wake";
    }
    return true;
}
