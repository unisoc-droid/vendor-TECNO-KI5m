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

# Initialize the helper for vendor (no extraction, just makefile generation)
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false false

# write_headers() resets all four outputs, adds the Android.mk device guard,
# the Soong namespace and PRODUCT_SOONG_NAMESPACES to the product fragment.
write_headers "" TARGET_DEVICE

# Parse proprietary-files.txt and generate copy-file + blueprint modules.
write_makefiles "${MY_DIR}/proprietary-files.txt"

# Optional prebuilt vendor image fallback.
cat << 'EOF' >> "${BOARDMK}"

# Optional prebuilt vendor image fallback (mutually exclusive with the
# extracted proprietary blobs). Set KI5M_USE_PREBUILT_VENDORIMAGE=true and
# stage the verified stock V218 image at the path below to use it.
ifeq ($(KI5M_USE_PREBUILT_VENDORIMAGE),true)
BOARD_PREBUILT_VENDORIMAGE := vendor/tecno/TECNO-KI5m/prebuilt/vendor.img
endif
EOF

# prebuilt_hidl_interfaces for the 6 non-AOSP vendor HIDL interfaces referenced
# by interface lines in /vendor/etc/init/*.rc.
cat << 'EOF' >> "${ANDROIDBP}"

// HIDL interfaces referenced by stock /vendor/etc/init/*.rc that are not
// declared by AOSP/LineageOS. host_init_verifier needs these in an exported
// Soong namespace.
prebuilt_hidl_interfaces {
    name: "vendor_ki5m_hidl_interfaces",
    hidl_interface_dirs: [
        "vendor/transsion/hardware/camera/imgalgoservice/1.0",
        "vendor/sprd/hardware/ai_engine/1.0",
        "vendor/sprd/hardware/aprd/1.0",
        "vendor/sprd/hardware/cplog_svc/1.0",
        "vendor/sprd/hardware/fingerprintmmi/1.0",
    ],
    deprecated: false,
}
EOF

# 19 non-toolbox symlinks from stock V218 /vendor.
cat << 'EOF' >> "${ANDROIDMK}"

# 19 vendor symlinks from stock V218 /vendor.
ifeq ($(BUILDING_VENDOR_IMAGE),true)

$(call symlink-file,,vendor/bin/teecd.sh,vendor/bin/teecd)
$(call declare-0p-target,vendor/bin/teecd)
ALL_DEFAULT_INSTALLED_MODULES += vendor/bin/teecd

$(call symlink-file,,toolbox,vendor/bin/teecd.sh)
$(call declare-0p-target,vendor/bin/teecd.sh)
ALL_DEFAULT_INSTALLED_MODULES += vendor/bin/teecd.sh

$(call symlink-file,,toolbox,vendor/bin/telephony_debug)
$(call declare-0p-target,vendor/bin/telephony_debug)
ALL_DEFAULT_INSTALLED_MODULES += vendor/bin/telephony_debug

$(call symlink-file,,toolbox,vendor/bin/wl)
$(call declare-0p-target,vendor/bin/wl)
ALL_DEFAULT_INSTALLED_MODULES += vendor/bin/wl

$(call symlink-file,,libdrmclearkey.so,vendor/lib/drm/libdrmclearkeyplugin.so)
$(call declare-0p-target,vendor/lib/drm/libdrmclearkeyplugin.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib/drm/libdrmclearkeyplugin.so

$(call symlink-file,,audio.primary.default.so,vendor/lib/libaudio.primary.default.so)
$(call declare-0p-target,vendor/lib/libaudio.primary.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib/libaudio.primary.default.so

$(call symlink-file,,audio.usb.default.so,vendor/lib/libaudio.usb.default.so)
$(call declare-0p-target,vendor/lib/libaudio.usb.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib/libaudio.usb.default.so

$(call symlink-file,,audio.r_submix.default.so,vendor/lib/libaudio.r_submix.default.so)
$(call declare-0p-target,vendor/lib/libaudio.r_submix.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib/libaudio.r_submix.default.so

$(call symlink-file,,audio.bluetooth.default.so,vendor/lib/libaudio.bluetooth.default.so)
$(call declare-0p-target,vendor/lib/libaudio.bluetooth.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib/libaudio.bluetooth.default.so

$(call symlink-file,,libmedia.so,vendor/lib/libmedia.so)
$(call declare-0p-target,vendor/lib/libmedia.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib/libmedia.so

$(call symlink-file,,libdrmclearkey.so,vendor/lib64/drm/libdrmclearkeyplugin.so)
$(call declare-0p-target,vendor/lib64/drm/libdrmclearkeyplugin.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/drm/libdrmclearkeyplugin.so

$(call symlink-file,,audio.primary.default.so,vendor/lib64/libaudio.primary.default.so)
$(call declare-0p-target,vendor/lib64/libaudio.primary.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libaudio.primary.default.so

$(call symlink-file,,audio.usb.default.so,vendor/lib64/libaudio.usb.default.so)
$(call declare-0p-target,vendor/lib64/libaudio.usb.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libaudio.usb.default.so

$(call symlink-file,,audio.r_submix.default.so,vendor/lib64/libaudio.r_submix.default.so)
$(call declare-0p-target,vendor/lib64/libaudio.r_submix.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libaudio.r_submix.default.so

$(call symlink-file,,audio.bluetooth.default.so,vendor/lib64/libaudio.bluetooth.default.so)
$(call declare-0p-target,vendor/lib64/libaudio.bluetooth.default.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libaudio.bluetooth.default.so

$(call symlink-file,,libmedia.so,vendor/lib64/libmedia.so)
$(call declare-0p-target,vendor/lib64/libmedia.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libmedia.so

$(call symlink-file,,libEGL.so,vendor/lib64/libEGL.so)
$(call declare-0p-target,vendor/lib64/libEGL.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libEGL.so

$(call symlink-file,,libGLESv1_CM.so,vendor/lib64/libGLESv1_CM.so)
$(call declare-0p-target,vendor/lib64/libGLESv1_CM.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libGLESv1_CM.so

$(call symlink-file,,libGLESv2.so,vendor/lib64/libGLESv2.so)
$(call declare-0p-target,vendor/lib64/libGLESv2.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libGLESv2.so

$(call symlink-file,,libGLESv3.so,vendor/lib64/libGLESv3.so)
$(call declare-0p-target,vendor/lib64/libGLESv3.so)
ALL_DEFAULT_INSTALLED_MODULES += vendor/lib64/libGLESv3.so

endif
EOF

# Close the Android.mk device guard.
write_footers

echo "Generated vendor makefiles:"
echo "  ${PRODUCTMK}"
echo "  ${ANDROIDBP}"
echo "  ${ANDROIDMK}"
echo "  ${BOARDMK}"