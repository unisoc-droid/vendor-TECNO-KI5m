# vendor/tecno/TECNO-KI5m — LineageOS 20 (KI5m / UMS9230)

Full stock vendor payload, published. `git clone` → `lunch` → `mka bacon` needs
no extraction, no image, no manual step.

## What is here

- `proprietary/` — 2088 files + 200 symlinks from stock V218 `vendor.img`
  (plus the 71 non-build `system_ext`/`product` artifacts listed below).
- `proprietary-files.txt` (sections per partition), `proprietary-symlinks.txt`,
  `proprietary-fsconfig.txt` (stock uid/gid/mode).
- `inventory/` — build-independent provenance/audit data: `stock.tsv`,
  `committed.tsv`, `dirs.txt`, `exclusions.tsv`, `expected_total.txt`,
  `blobs.sha256`, `provenance.json`, `NOTICE`, `inspection/`, `tools/`.
- Generated `TECNO-KI5m-vendor.mk`, `Android.bp`, `Android.mk`,
  `Android.symlinks.mk`, `BoardConfigVendor.mk`.
- `vendor.prop` — stock `/vendor/build.prop` content (the file itself is
  build-generated, so it is carried as a property file instead).
- `inventory/tools/verify-vendor.sh` — re-checks the tree against the inventory.

Regeneration is maintainer-only: `extract-files.sh <image|dump>`.

## Scope

- `vendor` full, including `vendor/odm` and `vendor/odm_dlkm` (subdirectories of
  `vendor.img`; neither is a mounted partition).
- `system_ext`/`product`: only non-build artifacts — media extractors, VINTF
  fragments, init scripts, permission XMLs, sysconfig, default-permissions,
  camera models.
- **Not included:** APKs (80 files, 1915 MiB, 10 above GitHub's 100 MiB limit —
  they would need >1 GiB LFS beyond the free quota). Build does not need them.
  `system` partition likewise (rebuildable by LineageOS).

## Storage

10 files ≥25 MiB (450 769 400 B) are in Git LFS via explicit `.gitattributes`
entries. A clone must run `git lfs pull` (or not clone with
`GIT_LFS_SKIP_SMUDGE=1`). Largest non-LFS file is 22.4 MiB.

## Verify

```bash
inventory/tools/verify-vendor.sh inventory   # exits non-zero on any gap
```

## Build

```bash
source build/envsetup.sh
lunch lineage_ki5m-userdebug
mka bacon
```

Nothing to provision. `prebuilt/vendor.img` is optional fallback only
(`KI5M_USE_PREBUILT_VENDORIMAGE=true`).

No build, flash or boot has been performed from this tree.
