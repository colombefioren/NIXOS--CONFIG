#!/bin/bash

THEME_NAME="polishcow"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"

mkdir -p "$THEME_DIR/images"
cp "$THEME_NAME.plymouth" "$THEME_DIR/"
cp "$THEME_NAME.script" "$THEME_DIR/"
cp images/*.png "$THEME_DIR/images/"

plymouth-set-default-theme -R "$THEME_NAME"

echo "Tylko jedno w głowie mam, koksu 5 gram. Enjoy!"