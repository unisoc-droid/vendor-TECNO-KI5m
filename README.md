# vendor/tecno/TECNO-KI5m — LineageOS 20 (KI5m / UMS9230)

Conventional LineageOS 20 vendor tree. Proprietary blobs are **not**
redistributed here; they are provisioned once from authorized stock firmware.

## Clean-checkout state (tracked)

- `proprietary-files.txt` — 346 OEM blobs (vendor paths, SHA-256 pinned by the
  stock V218 inventory during extraction).
- `extract-files.sh` — LineageOS 20 `extract-utils` wrapper with EROFS support
  (`fsck.erofs --extract`) and a safe `fix_xml()` override. Accepts either a
  pre-extracted vendor dump directory or a raw `vendor.img`.
- `setup-makefiles.sh` — regenerates `TECNO-KI5m-vendor.mk`,
  `BoardConfigVendor.mk`, `Android.bp`, `Android.mk`.
- Generated: `TECNO-KI5m-vendor.mk` (346 `PRODUCT_COPY_FILES` entries to
  `$(TARGET_COPY_OUT_VENDOR)`, 5 VINTF manifest modules in `PRODUCT_PACKAGES`,
  `PRODUCT_SOONG_NAMESPACES`), `Android.bp` (`soong_namespace`, five
  `prebuilt_etc_xml`, `prebuilt_hidl_interfaces` for 6 non-AOSP HIDL interfaces),
  `Android.mk` (device guard, 19 stock symlinks), `BoardConfigVendor.mk`
  (optional prebuilt-image fallback).
- `prebuilt/inspection/` — VINTF/SELinux metadata extracted from the stock
  image: source-level evidence only, not a runtime check.

`proprietary/` and `prebuilt/vendor.img` are gitignored. A clean checkout does
**not** contain blobs or an 803 MiB image.

## One-time provisioning (owner, authorized stock firmware)

From the ROM root, after `repo sync`:

```bash
cd vendor/tecno/TECNO-KI5m
./extract-files.sh /path/to/stock/vendor.img        # EROFS image
# or: ./extract-files.sh /path/to/pre-extracted/vendor-dump
cd ../../..
```

The script generates the four makefiles and populates `proprietary/` (346
files). After that, normal builds need no extraction or makefile generation.

Verified stock V218 image (do not substitute V133):

```
size   841748480 bytes
sha256 fed3cf42811d3ddde84d558e1abb916e292cac4d56e8bd9beb1b69947ffb7207
type   EROFS (LZ4_0PADDING), unsigned AVB footer
```

Optional bring-up fallback: stage the verified image at
`prebuilt/vendor.img` and build with `KI5M_USE_PREBUILT_VENDORIMAGE=true`. This
path is mutually exclusive with the extracted blobs; the device tree skips the
vendor product fragment in that mode.

## Guard

`device.mk` fails with an actionable message when neither the blobs nor the
prebuilt image are present, so `mka bacon` never silently builds an empty
vendor partition.

No build, flash, or boot has been performed from this repository.
