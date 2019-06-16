#
# Copyright (C) 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/motorola/clark

TARGET_SPECIFIC_HEADER_PATH := $(DEVICE_PATH)/include

# Arch
BOARD_VENDOR := motorola-qcom
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53.a57
TARGET_NO_BOOTLOADER := true

# Assert
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt
TARGET_OTA_ASSERT_DEVICE := clark

# Audio
BOARD_USES_ALSA_AUDIO := true
AUDIO_FEATURE_ENABLED_ACDB_LICENSE := true
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := true
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_FLAC_OFFLOAD := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_HFP := true
AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
AUDIO_FEATURE_ENABLED_LOW_LATENCY_CAPTURE := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_MULTIPLE_TUNNEL := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD_24 := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_SPKR_PROTECTION := true
AUDIO_USE_LL_AS_PRIMARY_OUTPUT := true
USE_CUSTOM_AUDIO_POLICY := 1

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth
BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED := false
BOARD_HAVE_BLUETOOTH_QCOM := true
QCOM_BT_USE_BTNV := true

# Camera
TARGET_CAMERASERVICE_CLOSES_NATIVE_HANDLES := true
TARGET_USES_MEDIA_EXTENSIONS := true
USE_DEVICE_SPECIFIC_CAMERA := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
    /system/vendor/bin/mm-qcamera-daemon=23

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true

# Crypto
TARGET_HW_DISK_ENCRYPTION := true

# Filesystems
BOARD_BOOTIMAGE_PARTITION_SIZE := 41943040
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 805306368
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 42024960
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

TARGET_FS_CONFIG_GEN += \
    $(DEVICE_PATH)/fs_config/file_caps.fs \
    $(DEVICE_PATH)/fs_config/mot_aids.fs \
    $(DEVICE_PATH)/fs_config/qcom_aids.fs

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# GPS
USE_DEVICE_SPECIFIC_GPS := true
USE_DEVICE_SPECIFIC_LOC_API := true
TARGET_NO_RPC := true

# Graphics
HAVE_ADRENO_SOURCE:= false
OVERRIDE_RS_DRIVER:= libRSDriver_adreno.so
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 5000000
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_HWC2 := true
TARGET_USES_ION := true
VSYNC_EVENT_PHASE_OFFSET_NS := 7500000

# Gralloc
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x02000000

# HIDL
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml

# IPA
USE_DEVICE_SPECIFIC_DATA_IPA_CFG_MGR := true

# Kernel
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := console=none androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x37 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 earlyprintk=msm_hsl_uart,0xf991e000 utags.blkdev=/dev/block/platform/soc.0/f9824900.sdhci/by-name/utags utags.backup=/dev/block/platform/soc.0/f9824900.sdhci/by-name/utagsBackup boot_cpus=0-5 androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE :=  4096
BOARD_KERNEL_SEPARATED_DT := true
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET     := 0x01000000
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_CONFIG := clark_defconfig
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/motorola/msm8992

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Peripheral manager
TARGET_PER_MGR_ENABLED := true

# Platform
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := msm8992
TARGET_BOOTLOADER_BOARD_NAME := clark
TARGET_NO_RADIOIMAGE := true
TARGET_USES_64_BIT_BINDER := true
BOARD_USES_QC_TIME_SERVICES := true

# Power
TARGET_HAS_LEGACY_POWER_STATS := true
TARGET_HAS_NO_WlAN_STATS := true
TARGET_USES_INTERACTION_BOOST := true

# Protobuf-c is supported in this build
PROTOBUF_SUPPORTED := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/fstab.qcom

# Releasetools
TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_motorola
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)/releasetools

# Ril
TARGET_RIL_VARIANT := caf

# SDClang
TARGET_USE_SDCLANG := true

# SELinux
#include device/qcom/sepolicy/sepolicy.mk
include device/qcom/sepolicy-legacy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy

# Sensors
BOARD_USES_MOT_SENSOR_HUB := true

# Shims
TARGET_LD_SHIM_LIBS := \
    /system/vendor/lib64/lib-imsvt.so|libshims_ims.so \
    /system/lib64/libandroid.so|libshim_ril.so \
    /system/lib/libjustshoot.so|libshims_camera.so \
    /system/vendor/lib64/libril-qc-qmi-1.so|rild_socket.so \
    /system/vendor/lib64/libizat_core.so|libshims_get_process_name.so \
    /system/lib/libmdmcutback.so|libqsap_shim.so \
    /system/lib64/libmdmcutback.so|libqsap_shim.so

# TWRP Support - Optional
ifeq ($(WITH_TWRP),true)
-include device/motorola/clark/twrp.mk
endif

# Vendor Init
TARGET_INIT_VENDOR_LIB := libinit_clark
TARGET_RECOVERY_DEVICE_MODULES := libinit_clark

# Wifi
BOARD_HAS_QCOM_WLAN              := true
BOARD_HAS_QCOM_WLAN_SDK          := true
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE                := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
TARGET_USES_QCOM_WCNSS_QMI       := true
TARGET_USES_WCNSS_MAC_ADDR_REV   := true
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
WPA_SUPPLICANT_VERSION           := VER_0_8_X
