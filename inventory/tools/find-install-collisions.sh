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

# Static second pass: AOSP Make modules (LOCAL_PROPRIETARY_MODULE) install via
# base_rules.mk, which never shows up in installs-*.mk. Match their declared
# module/stem names against our dests. These may or may not be in the graph, so
# confirm each against a real build error before dropping.
import os
ours = {}
for d in dests:
    ours.setdefault(os.path.basename(d), []).append(d)
names = {}
for dp, ds, fs in os.walk('.'):
    rel = dp[2:] if dp.startswith('./') else dp
    if any(rel == s or rel.startswith(s + '/') for s in ('vendor/tecno', 'out', '.repo', 'prebuilts')):
        ds[:] = []
        continue
    for fn in ('Android.bp', 'Android.mk'):
        if fn not in fs:
            continue
        path = os.path.join(dp, fn)
        try:
            txt = open(path, errors='ignore').read()
        except OSError:
            continue
        if fn == 'Android.mk':
            for stanza in re.split(r'include\s+\$\(CLEAR_VARS\)', txt):
                if 'LOCAL_PROPRIETARY_MODULE' not in stanza and not re.search(
                        r'LOCAL_VENDOR_MODULE\s*:=\s*true', stanza):
                    continue
                m = re.search(r'LOCAL_MODULE\s*:=\s*([^\s]+)', stanza)
                if not m:
                    continue
                for st in (re.findall(r'LOCAL_MODULE_STEM\s*:=\s*([^\s]+)', stanza) or [m.group(1)]):
                    names.setdefault(st, []).append(path)
        else:
            for name, body in re.findall(
                    r'\b(?:cc_binary|cc_library_shared|prebuilt_executable|prebuilt_etc(?:_xml)?)'
                    r'\s*\{\s*name:\s*"([^"]+)"(.*?)\n\}', txt, re.S):
                if not re.search(r'\b(vendor|proprietary|soc_specific):\s*true', body):
                    continue
                for st in (re.findall(r'stem:\s*"([^"]+)"', body) or [name]):
                    names.setdefault(st, []).append(path)

static = sorted({p for b, ps in ours.items() if b in names for p in ps})
print(f"\nSTATIC (Make/bp module name match; confirm against a build error): {len(static)}")
for p in static:
    base = os.path.basename(p)
    print(f"  {p}  <- {names[base][0]}")

# Third pass: AOSP vintf_fragments (literal .xml or :filegroup) always install
# to vendor/etc/vintf/manifest/. Resolve filegroups first.
import os
fg = {}          # module name -> set of xml basenames
for dp, ds, fs in os.walk('.'):
    rel = dp[2:] if dp.startswith('./') else dp
    if any(rel == s or rel.startswith(s + '/') for s in ('vendor/tecno', 'out', '.repo', 'prebuilts')):
        ds[:] = []
        continue
    if 'Android.bp' not in fs:
        continue
    txt = open(os.path.join(dp, 'Android.bp'), errors='ignore').read()
    for name, body in re.findall(r'filegroup\s*\{\s*name:\s*"([^"]+)"(.*?)\n\}', txt, re.S):
        fg.setdefault(name, set()).update(os.path.basename(x)
                                          for x in re.findall(r'"([^"]+\.xml)"', body))

frag = set()     # manifest basenames AOSP installs
for dp, ds, fs in os.walk('.'):
    rel = dp[2:] if dp.startswith('./') else dp
    if any(rel == s or rel.startswith(s + '/') for s in ('vendor/tecno', 'out', '.repo', 'prebuilts')):
        ds[:] = []
        continue
    for fn in ('Android.bp', 'Android.mk'):
        if fn not in fs:
            continue
        txt = open(os.path.join(dp, fn), errors='ignore').read()
        for m in re.finditer(r'vintf_fragments:\s*\[([^\]]+)\]|LOCAL_VINTF_FRAGMENTS\s*:?\+?=\s*([^\s\\]+)', txt):
            for ref in (re.findall(r'"([^"]+)"', m.group(1) or '') or [m.group(2)]):
                if not ref:
                    continue
                if ref.startswith(':'):
                    for mod in [x.strip() for x in ref[1:].split(':') if x.strip()]:
                        frag |= fg.get(mod, set())
                elif ref.endswith('.xml'):
                    frag.add(os.path.basename(ref))

vman = sorted(p for p in dests if '/etc/vintf/manifest/' in p and os.path.basename(p) in frag)
print(f"\nVINTF FRAGMENT COLLISIONS (must drop ours): {len(vman)}")
for p in vman:
    print(f"  {p}")
PY
