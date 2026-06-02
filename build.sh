#!/usr/bin/env bash
set -e

wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb &>/dev/null && rm -f libtinfo5_6.3-2_amd64.deb
wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb &>/dev/null && rm -f libncurses5_6.3-2_amd64.deb

export OWN_KEYS_DIR="$PWD/vendor_keys"
sudo ln -sf "$OWN_KEYS_DIR/releasekey.pk8" "$OWN_KEYS_DIR/testkey.pk8"
sudo ln -sf "$OWN_KEYS_DIR/releasekey.x509.pem" "$OWN_KEYS_DIR/testkey.x509.pem"

repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --git-lfs

rm -rf .repo/local_manifests
git clone -q https://github.com/bimuafaq/local_manifests .repo/local_manifests

/opt/crave/resync.sh || /opt/crave/resync.sh
.repo/local_manifests/patches/patches_apply.sh

source build/envsetup.sh
brunch RMX2185 user
