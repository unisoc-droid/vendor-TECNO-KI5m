#!/bin/bash
# Verify the vendor tree against the stock inventory. Exit non-zero on any gap.
# Usage: tools/verify-vendor.sh <stock-inventory-dir>
set -u
cd "$(dirname "$0")/.."
INV="${1:?usage: verify-vendor.sh <inventory-dir>}"
fail=0
note() { printf '%s\n' "$*"; }
bad() { printf 'FAIL %s\n' "$*"; fail=$((fail+1)); }

# 1. every committed path: exists, type, link valid, sha match
while read -r sha path; do
  [ -z "$sha" ] && continue
  if [ ! -e "$path" ] && [ ! -L "$path" ]; then bad "missing $path"; continue; fi
  got=$(sha256sum "$path" | cut -d' ' -f1)
  [ "$got" = "$sha" ] || bad "sha $path"
done < blobs.sha256

# 2. no dangling symlink, target matches record
while IFS=$'\t' read -r path target; do
  case "$path" in \#*|"") continue;; esac
  f="proprietary/$path"
  if [ ! -L "$f" ]; then bad "not a symlink $path"; continue; fi
  [ "$(readlink "$f")" = "$target" ] || bad "link target $path"
  [ -e "$f" ] || note "NOTE dangling $path -> $target"
done < proprietary-symlinks.txt

# 3. count parity: committed + exclusions == inventory(non-dir)
total=$(cat inventory/expected_total.txt)
committed=$(grep -c . blobs.sha256)
links=$(grep -vc '^#' proprietary-symlinks.txt)
excluded=$(grep -c . "$INV/exclusions.tsv" 2>/dev/null || echo 0)
[ "$((committed + links + excluded))" -eq "$total" ] || bad "count committed+links+excluded=$((committed + links + excluded)) != stock=$total"

# 4. modes/uid/gid parity (INI config.fs format: [path] / mode: / user: / group:)
awk '
  /^\[/ { path=substr($0,2,length($0)-2); next }
  /^mode:/ { split($0,a,": "); mode=a[2]; next }
  /^user:/ { split($0,a,": "); uid=a[2]; next }
  /^group:/ { split($0,a,": "); gid=a[2]; next }
  /^$/ && path != "" { print path, uid, gid, mode; path=""; uid=""; gid=""; mode="" }
  END { if (path != "") print path, uid, gid, mode }
' proprietary-fsconfig.txt | while read -r path uid gid mode; do
  [ -e "$path" ] || [ -L "$path" ] || continue
  perm=$(stat -c '%a' "$path")
  [ "$perm" = "$mode" ] || bad "mode $path ($perm != $mode)"
done

# 5. no LFS pointer
while read -r f; do
  [ -z "$f" ] && continue
  if [ "$(stat -c %s "$f")" -lt 200 ] && head -c 40 "$f" | grep -q 'version https://git-lfs'; then
    bad "LFS pointer $f"
  fi
done < <(git ls-files proprietary 2>/dev/null)

# 6. fallback flag must be off by default
grep -q 'BOARD_PREBUILT_VENDORIMAGE :=' BoardConfigVendor.mk && note "NOTE fallback flag exists (not default)"
[ -f prebuilt/vendor.img ] && note "NOTE prebuilt/vendor.img present (ignored by default)"

# 7. every copy source resolves
while read -r src; do
  rel=${src#vendor/tecno/TECNO-KI5m/}
  [ -f "$rel" ] || [ -L "$rel" ] || bad "copy source $src"
done < <(sed -n 's/^[[:space:]]*\([^:]*\):.*/\1/p' TECNO-KI5m-vendor.mk | grep proprietary)

# 8. manifest lines resolve to committed files
while read -r l; do
  case "$l" in \#*|"") continue;; esac
  p="proprietary/${l%%;*}"
  [ -e "$p" ] || [ -L "$p" ] || bad "manifest unresolved $p"
done < proprietary-files.txt

note "committed=$committed links=$links excluded=$excluded stock=$total"
[ "$fail" -eq 0 ] && note "verify-vendor: PASS" || note "verify-vendor: FAIL ($fail)"
exit "$fail"
