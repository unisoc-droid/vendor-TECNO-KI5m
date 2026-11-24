#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=TECNO-KI5m
VENDOR=tecno

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false false

write_headers "" TARGET_DEVICE
write_makefiles "${MY_DIR}/proprietary-files.txt"

# Optional prebuilt vendor image fallback (bring-up only; not default path).
cat << 'EOF' >> "${BOARDMK}"

# Stock inode metadata (uid/gid/mode) for every tracked blob, from the image.
TARGET_FS_CONFIG_GEN += vendor/tecno/TECNO-KI5m/proprietary-fsconfig.txt

# VINTF compatibility matrices (stock V218).
# Build system prohibits these in PRODUCT_COPY_FILES; declare via proper variables.
BOARD_VENDOR_COMPATIBILITY_MATRIX_FILE += vendor/tecno/TECNO-KI5m/proprietary/vendor/etc/vintf/compatibility_matrix.xml
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += vendor/tecno/TECNO-KI5m/proprietary/product/etc/vintf/compatibility_matrix.xml

# VINTF framework manifest (stock V218 system_ext).
# Build system prohibits manifests in PRODUCT_COPY_FILES; declare via proper variable.
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += vendor/tecno/TECNO-KI5m/proprietary/system_ext/etc/vintf/manifest.xml

# Optional prebuilt vendor image fallback. Unset by default so the tracked
# blobs are the build input.
ifeq ($(KI5M_USE_PREBUILT_VENDORIMAGE),true)
BOARD_PREBUILT_VENDORIMAGE := vendor/tecno/TECNO-KI5m/prebuilt/vendor.img
endif
EOF

# HIDL interfaces referenced by stock /vendor/etc/init/*.rc that AOSP does not
# declare. These non-AOSP interfaces lack .hal source in tree; prebuilt_hidl_interfaces
# would fail bootstrap. Omitted until .hal files are extracted from stock.
# cat << 'EOF' >> "${ANDPROIDBP}"
# 
# // HIDL interfaces referenced by stock init scripts (non-AOSP).
# prebuilt_hidl_interfaces {
#     name: "vendor_ki5m_hidl_interfaces",
#     hidl_interface_dirs: [
#         "vendor/transsion/hardware/camera/imgalgoservice/1.0",
#         "vendor/sprd/hardware/ai_engine/1.0",
#         "vendor/sprd/hardware/aprd/1.0",
#         "vendor/sprd/hardware/cplog_svc/1.0",
#         "vendor/sprd/hardware/fingerprintmmi/1.0",
#     ],
#     deprecated: false,
# }
# EOF

# Stock symlinks (generated from inventory, replaces the hand-written block).
cat << 'EOF' >> "${ANDROIDMK}"

include $(LOCAL_PATH)/Android.symlinks.mk
EOF

write_footers

echo "Generated vendor makefiles:"
echo "  ${PRODUCTMK}"
echo "  ${ANDROIDBP}"
echo "  ${ANDROIDMK}"
echo "  ${BOARDMK}"