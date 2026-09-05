#!/bin/sh

set -eu

ARCH="$(uname -m)"
UDEV="https://raw.githubusercontent.com/M0Rf30/android-udev-rules/refs/heads/main/51-android.rules"
VERSION="$(cat ~/version)"
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:udev-installer.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1 # seems to need both opengl and vulkan

# Deploy dependencies
quick-sharun \
	/usr/bin/uad-ng              \
	/usr/bin/adb                 \
	/usr/lib/libwayland-egl.so*  \
	/usr/lib/libwayland-client.so*

# Add udev rules
mkdir -p ./AppDir/etc/udev/rules.d
wget --retry-connrefused --tries=30 "$UDEV" -O ./AppDir/etc/udev/rules.d/51-android.rules
# We also need to be added to a group after installing udev rules
sed -i "/cp -v '\$_tmp_udev_dir'/a	 groupadd -f adbusers; usermod -a -G adbusers \$(logname)" ./AppDir/bin/*udev-installer.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage
