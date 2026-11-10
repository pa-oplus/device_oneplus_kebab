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
    gps \
    init \
    keymaster \
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
    audio_amplifier.kebab \
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

# OnePlus vendor audio properties.
kebab_audio_vendor_properties := \
    aaudio.hw_burst_min_usec=2000 \
    aaudio.mmap_exclusive_policy=2 \
    aaudio.mmap_policy=2 \
    audio.deep_buffer.media=true \
    persist.vendor.audio.ambisonic.auto.profile=false \
    persist.vendor.audio.ambisonic.capture=false \
    persist.vendor.audio.apptype.multirec.enabled=false \
    persist.vendor.audio.avs.afe_api_version=2 \
    persist.vendor.audio.fluence.speaker=true \
    persist.vendor.audio.fluence.tmic.enabled=false \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicecomm=true \
    persist.vendor.audio.fluence.voicerec=false \
    persist.vendor.audio.ras.enabled=false \
    persist.vendor.audio.spv3.enable=true \
    persist.vendor.audio.voicecall.speaker.stereo=true \
    ro.vendor.audio.sdk.fluencetype=none \
    ro.vendor.audio.sdk.ssr=false \
    vendor.audio.adm.buffering.ms=2 \
    vendor.audio.dolby.ds2.enabled=false \
    vendor.audio.dolby.ds2.hardbypass=false \
    vendor.audio.enable.mirrorlink=false \
    vendor.audio.feature.a2dp_offload.enable=true \
    vendor.audio.feature.afe_proxy.enable=true \
    vendor.audio.feature.anc_headset.enable=false \
    vendor.audio.feature.audiozoom.enable=false \
    vendor.audio.feature.battery_listener.enable=true \
    vendor.audio.feature.compr_cap.enable=false \
    vendor.audio.feature.compr_voip.enable=false \
    vendor.audio.feature.compress_in.enable=true \
    vendor.audio.feature.compress_meta_data.enable=true \
    vendor.audio.feature.concurrent_capture.enable=true \
    vendor.audio.feature.custom_stereo.enable=true \
    vendor.audio.feature.deepbuffer_as_primary.enable=false \
    vendor.audio.feature.display_port.enable=true \
    vendor.audio.feature.dsm_feedback.enable=false \
    vendor.audio.feature.dynamic_ecns.enable=true \
    vendor.audio.feature.ext_hw_plugin.enable=false \
    vendor.audio.feature.external_dsp.enable=false \
    vendor.audio.feature.external_speaker.enable=false \
    vendor.audio.feature.external_speaker_tfa.enable=false \
    vendor.audio.feature.fluence.enable=true \
    vendor.audio.feature.fm.enable=true \
    vendor.audio.feature.hdmi_edid.enable=true \
    vendor.audio.feature.hdmi_passthrough.enable=true \
    vendor.audio.feature.hfp.enable=true \
    vendor.audio.feature.hifi_audio.enable=false \
    vendor.audio.feature.hwdep_cal.enable=false \
    vendor.audio.feature.incall_music.enable=true \
    vendor.audio.feature.keep_alive.enable=true \
    vendor.audio.feature.kpi_optimize.enable=true \
    vendor.audio.feature.maxx_audio.enable=false \
    vendor.audio.feature.multi_voice_session.enable=true \
    vendor.audio.feature.ras.enable=true \
    vendor.audio.feature.record_play_concurency.enable=false \
    vendor.audio.feature.snd_mon.enable=true \
    vendor.audio.feature.spkr_prot.enable=true \
    vendor.audio.feature.src_trkn.enable=true \
    vendor.audio.feature.ssrec.enable=true \
    vendor.audio.feature.usb_offload.enable=true \
    vendor.audio.feature.usb_offload_burst_mode.enable=true \
    vendor.audio.feature.usb_offload_sidetone_volume.enable=false \
    vendor.audio.feature.vbat.enable=true \
    vendor.audio.feature.wsa.enable=false \
    vendor.audio.flac.sw.decoder.24bit=true \
    vendor.audio.hal.boot.timeout.ms=20000 \
    vendor.audio.hal.output.suspend.supported=true \
    vendor.audio.hw.aac.encoder=true \
    vendor.audio.offload.buffer.size.kb=32 \
    vendor.audio.offload.gapless.enabled=true \
    vendor.audio.offload.multiaac.enable=true \
    vendor.audio.offload.multiple.enabled=false \
    vendor.audio.offload.passthrough=false \
    vendor.audio.offload.track.enable=true \
    vendor.audio.parser.ip.buffer.size=262144 \
    vendor.audio.safx.pbe.enabled=false \
    vendor.audio.tunnel.encode=false \
    vendor.audio.use.sw.alac.decoder=true \
    vendor.audio.use.sw.ape.decoder=true \
    vendor.audio.use.sw.mpegh.decoder=true \
    vendor.audio.volume.headset.gain.depcal=true \
    vendor.audio_hal.in_period_size=144 \
    vendor.audio_hal.period_multiplier=3 \
    vendor.audio_hal.period_size=192 \
    vendor.voice.path.for.pcm.voip=true

# OnePlus odm audio properties.
kebab_audio_odm_properties := \
    ro.audio.monitorRotation=true \
    ro.config.media_vol_steps=30 \
    ro.config.vc_call_vol_steps=9 \
    ro.vendor.audio.sdk.fluencetype=fluence \
    ro.vendor.qti.va_odm.support=1

# OnePlus system_ext audio properties.
kebab_audio_system_ext_properties := \
    audio.offload.min.duration.secs=30 \
    persist.vendor.audio_hal.dsp_bit_width_enforce_mode=24

# Remove only properties replaced by this device from the directly included
# generic recipe. Keep each device override in its original OnePlus partition.
kebab_audio_property_names := $(foreach prop,$(kebab_audio_vendor_properties) $(kebab_audio_odm_properties) $(kebab_audio_system_ext_properties),$(word 1,$(subst =, ,$(prop))))
PRODUCT_PROPERTY_OVERRIDES := $(filter-out $(addsuffix =%,$(kebab_audio_property_names)),$(PRODUCT_PROPERTY_OVERRIDES))

PRODUCT_VENDOR_PROPERTIES += $(kebab_audio_vendor_properties)
PRODUCT_ODM_PROPERTIES += $(kebab_audio_odm_properties)
PRODUCT_SYSTEM_EXT_PROPERTIES += $(kebab_audio_system_ext_properties)

# OnePlus power extension and common perf ownership.
# The inspected calcite source defines the service, not power-impl from its
# generic product recipe. Select the actual service explicitly.
TARGET_PROVIDES_POWERHAL := true
TARGET_USES_QTI_POWER_HAL := true
TARGET_POWERHAL_MODE_EXT := device/oneplus/kebab/power/PowerModes.cpp

PRODUCT_PACKAGES += \
    android.hardware.power-service \
    init.kebab.power.rc

PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/power/config/kona/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml

# Perf stays owned by the common QTI perf component. Do not set the stock-blob
# override until a complete OnePlus perf ABI/configuration set has been verified.

# OnePlus display properties and framework calibration overlay.
# Include the common recipes once, locally, so device properties can replace
# generic source defaults before the PA product inheritance is resolved.
QCOM_COMMON_PATH := device/qcom/common
TARGET_USE_AIDL_QTI_MEMTRACK := true
include $(QCOM_COMMON_PATH)/system/display/qti-display.mk
include $(QCOM_COMMON_PATH)/vendor/display/qti-display.mk

PRODUCT_PACKAGES += KebabFrameworksRes

kebab_display_properties := \
    vendor.display.disable_hw_recovery_dump=1 \
    vendor.display.disable_offline_rotator=1 \
    vendor.display.disable_system_load_check=1 \
    vendor.display.enable_async_powermode=0 \
    vendor.display.enable_camera_smooth=1 \
    vendor.display.not_switch_qhd_120hz=1 \
    vendor.display.primary_mixer_stages=9 \
    vendor.display.show_memc_tomast=true \
    vendor.display.smomo_camera_support=1 \
    vendor.display.smomo_game_support=0 \
    vendor.display.use_layer_ext=1 \
    vendor.display.use_smooth_motion=1

kebab_display_property_names := $(foreach prop,$(kebab_display_properties),$(word 1,$(subst =, ,$(prop))))
PRODUCT_PROPERTY_OVERRIDES := $(filter-out $(addsuffix =%,$(kebab_display_property_names)),$(PRODUCT_PROPERTY_OVERRIDES))
PRODUCT_VENDOR_PROPERTIES := $(filter-out $(addsuffix =%,$(kebab_display_property_names)),$(PRODUCT_VENDOR_PROPERTIES))
PRODUCT_VENDOR_PROPERTIES += $(kebab_display_properties)

# Optical fingerprint wrapper, geometry and composition extension.
# Use the wrapper supplied by aospa-trees/hardware/oplus (calcite).
PRODUCT_SOONG_NAMESPACES += hardware/oplus
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.3-service.oplus

# The inspected calcite CompositionEngine uses this Soong selector directly.
$(call soong_config_set,surfaceflinger,udfps_lib,//device/oneplus/kebab:libudfps_extension.kebab)

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.fingerprint.sensor_type=optical \
    persist.vendor.qfp=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# OnePlus legacy camera provider.
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service_64

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

PRODUCT_VENDOR_PROPERTIES += \
    vendor.camera.aux.packageexcludelist=org.telegram.messenger,org.thunderdog.challegram,us.zoom.videomeetings

# OnePlus alert slider calibration and device key handling.
PRODUCT_PACKAGES += tri-state-key-calibrate

PRODUCT_PACKAGES += KebabKeyHandler

# SSC and OnePlus synthetic sensors through the AIDL multihal bridge.
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.multihal \
    sensors.oplus \
    init.kebab.sensors.rc

PRODUCT_COPY_FILES += \
    device/oneplus/kebab/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

# OnePlus Codec2 configuration and vendor codec ownership.
# The selected OnePlus baseline uses vendor Codec2 and disables source OMX.
# Own these configs locally rather than inheriting the generic OMX product.
TARGET_SUPPORTS_OMX_SERVICE := false
PRODUCT_SOONG_NAMESPACES += device/qcom/common/vendor/media
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.2.vendor \
    libavservices_minijail.vendor

PRODUCT_COPY_FILES += \
    device/oneplus/kebab/configs/media/media_codecs_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml \
    device/oneplus/kebab/configs/media/media_codecs_performance_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance_c2.xml \
    device/oneplus/kebab/configs/media/media_codecs_performance_kona_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance_kona.xml \
    device/oneplus/kebab/configs/media/video_system_specs.json:$(TARGET_COPY_OUT_VENDOR)/etc/media/video_system_specs.json \
    device/qcom/common/vendor/seccomp/codec2.software.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.software.ext.policy \
    device/qcom/common/vendor/seccomp/codec2.vendor.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.vendor.ext.policy \
    device/qcom/common/vendor/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/common/vendor/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_VENDOR_PROPERTIES += ro.mediaserver.64b.enable=true
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    media.settings.xml=/vendor/etc/media_profiles_vendor.xml \
    media.stagefright.thumbnail.prefer_hw_codecs=true \
    ro.media.recorder-max-base-layer-fps=60
PRODUCT_ODM_PROPERTIES += \
    ro.odm.build.media_performance_class=30

# Kona thermal reporting through the QTI AIDL service.
PRODUCT_PACKAGES += android.hardware.thermal-service.qti

# Match the 4.19 common QTI path: sysfs/uevent monitoring, not netlink.
$(call soong_config_set,qti_thermal,netlink,false)

# QTI AIDL health and offline charging, without generic charger-monitor blobs.
# Own health here: the generic charging component also installs a proprietary
# charger-monitor RC not selected by the OnePlus baseline.
$(call inherit-product, vendor/qcom/opensource/healthd-ext/health-vendor-product.mk)

# OnePlus LED/sysfs vibrator through PA hardware/oplus.
# Supplied by the selected PA hardware/oplus tree, including RC and AIDL VINTF.
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service.oplus \
    init.kebab.vibrator.rc

PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/vibrator/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml

# Kebab uses the LED/sysfs backend; do not enable the optional effect streamer.
$(call soong_config_set,OPLUS_LINEAGE_VIBRATOR_HAL,USE_EFFECT_STREAM,false)
