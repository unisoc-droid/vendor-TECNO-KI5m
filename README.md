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

The `prebuilt/inspection/` tree contains VNDK/VINTF/SELinux metadata extracted
from that image; it is source-level evidence only, not a runtime check.

## Status

- AVB layout: Option A (separate `vbmeta_system_ext` / `vbmeta_product`).
- Debug default: `KI5M_DEBUG_PERMISSIVE ?= true` in the device tree.
- No build, device, or OTA operation has been run from this repository.

See `device-TECNO-KI5m`, branch `lineage-20.0`, for the matching BoardConfig,
fstab and kernel build rules.
