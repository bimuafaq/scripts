#!/usr/bin/env bash
set -e

wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb &>/dev/null && rm -f libtinfo5_6.3-2_amd64.deb
wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb &>/dev/null && rm -f libncurses5_6.3-2_amd64.deb

export OWN_KEYS_DIR="$PWD/vendor_keys"
sudo ln -sf "$OWN_KEYS_DIR/releasekey.pk8" "$OWN_KEYS_DIR/testkey.pk8"
sudo ln -sf "$OWN_KEYS_DIR/releasekey.x509.pem" "$OWN_KEYS_DIR/testkey.x509.pem"

repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1

rm -rf .repo/local_manifests
[ -L external/chromium-webview/Android.mk ] && rm -rf external/chromium-webview
git clone -q https://github.com/bimuafaq/local_manifests .repo/local_manifests
git -C .repo/manifests am "$(pwd)/.repo/local_manifests/patches/0001-manifest-switch-to-old-chromiun-webview.patch"

for i in 1 2; do /opt/crave/resync.sh; done
.repo/local_manifests/patches/patches_apply.sh

source build/envsetup.sh
lunch lineage_RMX2185-user
cmka bacon
