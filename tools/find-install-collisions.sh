#!/bin/bash
# Find every PRODUCT_COPY_FILES destination in TECNO-KI5m-vendor.mk that
# Soong also generates an install rule for in out/soong/installs-*.mk.
# Run from AOSP root after a build reaches "writing build rules" (even a failed
# one leaves installs-*.mk behind). Exits 0 always; prints collisions.
set -u
# Locate AOSP root by walking up until build/make/core/main.mk is found.
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SELF_DIR"
while [ ! -f "$ROOT/build/make/core/main.mk" ]; do
  PARENT="$(dirname "$ROOT")"
  [ "$PARENT" = "$ROOT" ] && { echo "Cannot find AOSP root above $SELF_DIR"; exit 1; }
  ROOT="$PARENT"
done
cd "$ROOT" || exit 1

INSTALLS=$(ls out/soong/installs-*.mk 2>/dev/null | head -1)
if [ -z "$INSTALLS" ]; then
  echo "No out/soong/installs-*.mk found. Run brunch once (it fails fast but leaves the file)."
  exit 0
fi

# Our destinations: PRODUCT_COPY_FILES lines look like
#   src:$(TARGET_COPY_OUT_VENDOR)/path \
MK=vendor/tecno/TECNO-KI5m/TECNO-KI5m-vendor.mk

python3 - "$MK" "$INSTALLS" << 'PY'
import re, sys
mk, installs = sys.argv[1], sys.argv[2]

# Destination paths from PRODUCT_COPY_FILES
dests = set()
with open(mk) as f:
    for line in f:
        line = line.strip().rstrip('\\').strip()
        if not line or line.startswith('#'):
            continue
        if ':' not in line:
            continue
        src, dst = line.split(':', 1)
        if 'proprietary/' not in src:
            continue
        # Expand TARGET_COPY_OUT_* to its partition name
        dst = re.sub(r'\$\(TARGET_COPY_OUT_([A-Z_]+)\)',
                     lambda m: m.group(1).lower().replace('_', '-'), dst)
        if dst.startswith('system/'):
            pass
        dests.add(dst)

# All install targets in the Soong installs file. Two forms appear:
#   out/target/product/<dev>/vendor/...: ...
#   $(PRODUCT_OUT)/vendor/...: ...
txt = open(installs, errors='ignore').read()
soong_paths = set()
for t in re.findall(r'out/target/product/[^/\s:]+/([^\s:]+)', txt):
    soong_paths.add(t)
for t in re.findall(r'\$\(PRODUCT_OUT\)/([^\s:]+)', txt):
    soong_paths.add(t)

collisions = sorted(dests & soong_paths)
print(f"PRODUCT_COPY_FILES dests: {len(dests)}")
print(f"Soong install targets:    {len(soong_paths)}")
print(f"\nCOLLISIONS ({len(collisions)}):")
for p in collisions:
    print(f"  {p}")
if not collisions:
    print("  (none)")
PY
