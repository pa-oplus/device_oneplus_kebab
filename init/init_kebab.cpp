/*
 * Copyright (C) 2022-2023 The LineageOS Project
 * Copyright (C) 2026 Paranoid Android
 * SPDX-License-Identifier: Apache-2.0
 */

#include <cstring>

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android-base/strings.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

namespace {

void OverrideProperty(const char* name, const char* value) {
    auto* pi = const_cast<prop_info*>(__system_property_find(name));
    if (pi != nullptr) {
        __system_property_update(pi, value, std::strlen(value));
    } else {
        __system_property_add(name, std::strlen(name), value, std::strlen(value));
    }
}

}  // namespace

void vendor_load_properties() {
    const auto rf_version = android::base::GetIntProperty<int>("ro.boot.rf_version", 0);
    const char* model = nullptr;
    switch (rf_version) {
        case 11: model = "KB2000"; break;  // CN
        case 12: model = "KB2007"; break;  // TMO
        case 13: model = "KB2001"; break;  // IN
        case 14: model = "KB2003"; break;  // EU
        case 15: model = "KB2005"; break;  // NA
        default:
            LOG(WARNING) << "Unknown kebab RF version: " << rf_version;
            break;
    }
    if (model != nullptr) {
        OverrideProperty("ro.product.product.model", model);
    }

    std::string content;
    if (android::base::ReadFileToString("/proc/devinfo/ddr_type", &content)) {
        const auto value = android::base::Trim(content);
        if (!value.empty()) {
            const auto fields = android::base::Split(value, "\t");
            OverrideProperty("ro.boot.ddr_type", fields.back().c_str());
        }
    }
}
