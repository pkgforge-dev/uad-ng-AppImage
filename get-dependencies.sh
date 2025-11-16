#!/bin/sh

set -eu
ARCH="$(uname -m)"
BINARY="https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest/download/uad-ng-noselfupdate-linux"

echo "Installing dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm android-tools

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Getting '$BINARY'..."
echo "---------------------------------------------------------------"
if ! wget --retry-connrefused --tries=30 "$BINARY" -O /usr/bin/uad-ng 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
chmod +x /usr/bin/uad-ng
