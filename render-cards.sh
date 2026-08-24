#!/usr/bin/env bash
# Rasterize the committed social-card / cover SVGs to PNGs.
#
# These PNGs are committed assets (like the pre-rendered mermaid SVGs), so CI
# never runs this — regenerate locally only when a card/cover SVG changes.
#
# The book's typeface is EB Garamond (a Google webfont, not installed on most
# machines). We fetch the TTFs into a local cache and render through fontconfig
# WITHOUT touching the user's font library. On macOS, pangocairo defaults to the
# CoreText backend, which ignores FONTCONFIG_FILE — so force the fontconfig
# backend with PANGOCAIRO_BACKEND=fc, or the serif silently falls back to sans.
#
# Requires: rsvg-convert, curl. Usage: ./render-cards.sh
set -euo pipefail
cd "$(dirname "$0")"
FIG=first-principles-figures
CACHE="${TMPDIR:-/tmp}/fp-card-fonts"
mkdir -p "$CACHE"

base="https://github.com/google/fonts/raw/main/ofl/ebgaramond"
[ -f "$CACHE/EBGaramond.ttf" ]        || curl -fsSL -o "$CACHE/EBGaramond.ttf"        "$base/EBGaramond%5Bwght%5D.ttf"
[ -f "$CACHE/EBGaramond-Italic.ttf" ] || curl -fsSL -o "$CACHE/EBGaramond-Italic.ttf" "$base/EBGaramond-Italic%5Bwght%5D.ttf"

CONF="$CACHE/fonts.conf"
cat > "$CONF" <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <cachedir>$CACHE/fccache</cachedir>
  <dir>$CACHE</dir>
  <include ignore_missing="yes">/opt/homebrew/etc/fonts/fonts.conf</include>
  <include ignore_missing="yes">/usr/local/etc/fonts/fonts.conf</include>
  <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
</fontconfig>
EOF
export FONTCONFIG_FILE="$CONF" PANGOCAIRO_BACKEND=fc
fc-cache -f "$CACHE" >/dev/null 2>&1 || true

render() {  # name width height
  if [ -f "$FIG/$1.svg" ]; then
    rsvg-convert -w "$2" -h "$3" "$FIG/$1.svg" -o "$FIG/$1.png"
    echo "rendered $FIG/$1.png (${2}x${3})"
  fi
}
render social-card 1200 630
render cover 1600 2560
