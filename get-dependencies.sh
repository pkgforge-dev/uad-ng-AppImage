#!/bin/sh

set -eux
ARCH="$(uname -m)"
BINARY="https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest/download/uad-ng-noselfupdate-linux"
EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

echo "Installing dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	android-tools     \
	base-devel        \
	curl              \
	git               \
	libx11            \
	libxrandr         \
	libxss            \
	pulseaudio        \
	pulseaudio-alsa   \
	wget              \
	xorg-server-xvfb  \
	zsync

if ! wget --retry-connrefused --tries=30 "$BINARY" -O /usr/bin/uad-ng 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
else
	awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
fi
chmod +x /usr/bin/uad-ng

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-common --prefer-nano


