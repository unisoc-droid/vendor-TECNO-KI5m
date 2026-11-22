# vendor/tecno/TECNO-KI5m (KI5m / LineageOS 20)

Standard LineageOS vendor-tree shape for TECNO KI5m.

## Build input

`BoardConfigVendor.mk` expects the stock V218 vendor image at:

```
vendor/tecno/TECNO-KI5m/prebuilt/vendor.img
```

That binary is **not committed** here (803 MB exceeds GitHub's 100 MB per-file
limit). Stage the verified stock image at that path on the build server before
running `lunch lineage_ki5m-userdebug && mka`.

Verified stock V218 image:

```
size   841748480 bytes
sha256 fed3cf42811d3ddde84d558e1abb916e292cac4d56e8bd9beb1b69947ffb7207
type   EROFS (LZ4_0PADDING), with an unsigned AVB footer
```

The build strips the old AVB footer and re-signs the image; `avbtool
add_hashtree_footer` is idempotent for this case. Do not replace the file with a
raw filesystem dump, because the vendor tree's VINTF/SELinux metadata was
extracted from this exact image.

The `prebuilt/inspection/` tree contains VNDK/VINTF/SELinux metadata extracted
from that image; it is source-level evidence only, not a runtime check.

## Status

- AVB layout: Option A (separate `vbmeta_system_ext` / `vbmeta_product`).
- Debug default: `KI5M_DEBUG_PERMISSIVE ?= true` in the device tree.
- No build, device, or OTA operation has been run from this repository.

See `device-TECNO-KI5m`, branch `lineage-20.0`, for the matching BoardConfig,
fstab and kernel build rules.
