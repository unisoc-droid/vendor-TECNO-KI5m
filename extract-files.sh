#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Required!
DEVICE=TECNO-KI5m
VENDOR=tecno

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper for vendor
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false true

# Extract from stock vendor dump (EROFS) or pre-extracted directory
# Usage: ./extract-files.sh /path/to/vendor_dump
#        ./extract-files.sh /path/to/vendor.img
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-vendor-dump-or-image>"
    exit 1
fi

SRC="${1}"
if [ ! -e "${SRC}" ]; then
    echo "Source ${SRC} does not exist"
    exit 1
fi

# Override fix_xml to only rewrite XML if <?xml version appears after line 1
# Stock KI5m /vendor XML files already have <?xml on line 1 (or no declaration)
# and stock extract_utils.sh fix_xml() would otherwise append a trailing newline
# to 9 XML files including etc/vintf/manifest/memtrack.xml
function fix_xml() {
    local XML="${1}"
    # Only fix if XML declaration is NOT on line 1
    if ! head -1 "${XML}" | grep -q '^<?xml version'; then
        local TEMP_XML="${EXTRACT_TMP_DIR}/$(basename "${XML}").temp"
        grep -a '^<?xml version' "${XML}" > "${TEMP_XML}"
        grep -av '^<?xml version' "${XML}" >> "${TEMP_XML}"
        mv "${TEMP_XML}" "${XML}"
    fi
}

# Override extract_img_data to support EROFS via fsck.erofs --extract
# The stock vendor.img is EROFS, not ext4, so debugfs-based extraction fails.
function extract_img_data() {
    local IMAGE="${1}"
    local DEST="${2}"

    if [ ! -f "${IMAGE}" ]; then
        echo "Image ${IMAGE} not found"
        return 1
    fi

    local FSTYPE
    FSTYPE=$(file -b "${IMAGE}" | awk '{print tolower($1)}')

    case "${FSTYPE}" in
        linux*)
            # ext4/f2fs - use debugfs (original behavior)
            mkdir -p "${DEST}"
            debugfs -R "rdump / ${DEST}" "${IMAGE}" 2>/dev/null
            ;;
        android*)
            # sparse image - convert first
            local RAW="${IMAGE}.raw"
            "${SIMG2IMG}" "${IMAGE}" "${RAW}"
            extract_img_data "${RAW}" "${DEST}"
            rm -f "${RAW}"
            ;;
        erofs*)
            # EROFS - use fsck.erofs --extract (prebuilts/kernel-build-tools/linux-x86/bin/fsck.erofs)
            mkdir -p "${DEST}"
            local FSCK_EROFS="${ANDROID_ROOT}/prebuilts/kernel-build-tools/linux-x86/bin/fsck.erofs"
            if [ ! -f "${FSCK_EROFS}" ]; then
                echo "ERROR: fsck.erofs not found at ${FSCK_EROFS}"
                echo "Install prebuilts/kernel-build-tools or use a pre-extracted dump directory."
                return 1
            fi
            "${FSCK_EROFS}" --extract="${DEST}" "${IMAGE}"
            ;;
        directory)
            # Pre-extracted directory - just copy
            cp -a "${IMAGE}/." "${DEST}/"
            ;;
        *)
            echo "Unsupported image type: ${FSTYPE}"
            return 1
            ;;
    esac
}

# Default to current directory if no source specified (for setup-makefiles.sh)
if [ -z "${SRC}" ]; then
    SRC="${MY_DIR}/proprietary"
fi

# Accept a raw vendor.img (EROFS/ext4/sparse) as well as a pre-extracted dump.
if [ -f "${SRC}" ]; then
    local_dump="${EXTRACT_TMP_DIR}/vendor_dump"
    mkdir -p "${local_dump}"
    echo "Extracting ${SRC} to ${local_dump}"
    extract_img_data "${SRC}" "${local_dump}"
    SRC="${local_dump}"
fi

if [ ! -d "${SRC}" ]; then
    echo "Source must be a vendor dump directory or a vendor filesystem image"
    exit 1
fi

# The stock vendor dump has files directly under it (bin/, etc/, lib/, etc.)
# but extract_utils.sh expects a full system dump with vendor/ subdirectory.
# Create a temporary wrapper directory with vendor/ symlink to make paths match.
VENDOR_WRAPPER="${EXTRACT_TMP_DIR}/vendor_wrapper"
mkdir -p "${VENDOR_WRAPPER}"
ln -sf "${SRC}" "${VENDOR_WRAPPER}/vendor"

# Use the wrapper as source for extraction
extract "${MY_DIR}/proprietary-files.txt" "${VENDOR_WRAPPER}"

# Generate vendor makefiles
"${MY_DIR}/setup-makefiles.sh"