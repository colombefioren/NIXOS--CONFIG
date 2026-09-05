#!/usr/bin/env bash
set -euo pipefail

ZIP="${1:-$HOME/Downloads/pikachu-cursor-theme.zip}"
REPO="$(pwd)"

if [ ! -f "$ZIP" ]; then
	echo "Can't find $ZIP — pass the path to pikachu-cursor-theme.zip as an argument."
	exit 1
fi
if [ ! -f "$REPO/home.nix" ]; then
	echo "Run this from the root of your NixOS config repo (where home.nix is)."
	exit 1
fi

# 1. Replace the broken hyprcursor theme with the fixed Xcursor theme
TMP=$(mktemp -d)
unzip -q "$ZIP" -d "$TMP"
rm -rf "$REPO/cursors/pikachu/manifest.hl" "$REPO/cursors/pikachu/hyprcursors"
cp "$TMP/pikachu-cursor/index.theme" "$REPO/cursors/pikachu/index.theme"
rm -rf "$REPO/cursors/pikachu/cursors"
cp -r "$TMP/pikachu-cursor/cursors" "$REPO/cursors/pikachu/cursors"
rm -rf "$TMP"

# 2. Patch home.nix
python3 - "$REPO/home.nix" <<'PYEOF'
import sys, re

path = sys.argv[1]
with open(path) as f:
    content = f.read()

# Remove HYPRCURSOR_THEME / HYPRCURSOR_SIZE from sessionVariables
content = content.replace(
    '    XCURSOR_SIZE = "24";\n    HYPRCURSOR_THEME = "pikachu-cursor";\n    HYPRCURSOR_SIZE = "24";\n',
    '    XCURSOR_SIZE = "24";\n'
)

# Remove the HYPRCURSOR_THEME injection block from the activation script
old_block = '''        if ! grep -q 'HYPRCURSOR_THEME' "$HOME/.config/hypr/hyprland/env.lua" 2>/dev/null; then
          printf '\\nhl.env("HYPRCURSOR_THEME", "pikachu-cursor")\\nhl.env("HYPRCURSOR_SIZE", "24")\\n' >> "$HOME/.config/hypr/hyprland/env.lua"
        fi
'''
content = content.replace(old_block, '')

# Add cursor-theme/cursor-size to dconf so GTK apps pick it up
content = content.replace(
    '''      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };''',
    '''      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
        cursor-theme = "pikachu-cursor";
        cursor-size = 24;
      };'''
)

with open(path, 'w') as f:
    f.write(content)

print("home.nix patched.")
PYEOF

echo "Done. Now run: nrs   (then log out of Hyprland fully and back in)"
