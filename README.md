# vendor/tecno/TECNO-KI5m — LineageOS 20 (KI5m / UMS9230)

Conventional LineageOS 20 vendor tree, following the same tracked-blob
convention used by the Redmi A5 / POCO C71 (`serenity`) vendor tree.

## Clean-checkout state (tracked)

- `proprietary/` — **351 tracked files** (346 `PRODUCT_COPY_FILES` sources plus
  5 VINTF manifest XML modules), ~76 MiB total, largest file 20.3 MiB. No
  extraction step is needed on the build server.
- `proprietary-files.txt` — 351 blob paths from the verified stock V218 image
  (SHA-256 `fed3cf42811d3ddde84d558e1abb916e292cac4d56e8bd9beb1b69947ffb7207`).
- `extract-files.sh` / `setup-makefiles.sh` — retained for audit and
  regeneration from authorized stock firmware (EROFS image or pre-extracted
  dump). Not part of the routine build.
- Generated `TECNO-KI5m-vendor.mk`, `Android.bp`, `Android.mk`,
  `BoardConfigVendor.mk` — current and reproducible.
- `prebuilt/inspection/` — VINTF/SELinux metadata evidence only.

## Not tracked

- `prebuilt/vendor.img` (841748480 B, EROFS). It is **not** needed for the
  normal build; the raw image stays out of GitHub. The optional
  `KI5M_USE_PREBUILT_VENDORIMAGE=true` fallback requires staging it manually
  and is mutually exclusive with the tracked blobs.

## Routine build (no provisioning)

```bash
source build/envsetup.sh
lunch lineage_ki5m-userdebug
mka bacon
```

## Regeneration (optional, owner with authorized stock image)

```bash
cd vendor/tecno/TECNO-KI5m
./extract-files.sh /path/to/stock/vendor.img
# or: ./extract-files.sh /path/to/pre-extracted/vendor-dump
```

This rewrites `proprietary/` and the four generated makefiles. Stock XML on
line 1 is preserved by the `fix_xml()` override.

No build, flash, or boot has been performed from this repository.
