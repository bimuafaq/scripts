#!/usr/bin/env bash
set -e

wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb &>/dev/null && rm -f libtinfo5_6.3-2_amd64.deb
wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb &>/dev/null && rm -f libncurses5_6.3-2_amd64.deb

repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1

rm -rf .repo/local_manifests external/chromium-webview rom
mkdir -p .repo/local_manifests

git clone -q https://github.com/bimuafaq/local_manifests rom
mv rom/lineageos-18.1/*.xml .repo/local_manifests

for i in 1 2; do /opt/crave/resync.sh; done
rom/lineageos-18.1/patches/patches_apply.sh

rm -rf external/chromium-webview
git clone -q https://github.com/LineageOS/android_external_chromium-webview external/chromium-webview -b master --depth=1

rm -rf vendor/extra
git clone -q https://github.com/bimuafaq/android_vendor_extra vendor/extra

rm -rf vendor/lineage-priv/keys
git clone -q https://github.com/bimuafaq/keys vendor/lineage-priv/keys

source build/envsetup.sh
lunch lineage_RMX2185-user
cmka bacon