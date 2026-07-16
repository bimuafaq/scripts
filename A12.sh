#!/usr/bin/env bash
set -e

wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb &>/dev/null && rm -f libtinfo5_6.3-2_amd64.deb
wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb &>/dev/null && rm -f libncurses5_6.3-2_amd64.deb

repo init -u https://github.com/LineageOS/android.git -b lineage-19.1 --depth=1

rm -rf .repo/local_manifests
git clone -q https://github.com/bimuafaq/local_manifests -b s .repo/local_manifests

[ -L external/chromium-webview/Android.mk ] && rm -rf external/chromium-webview
git -C .repo/manifests am "$(pwd)/.repo/local_manifests/patches/0001-manifest-switch-to-old-chromiun-webview.patch"

for i in 1 2; do /opt/crave/resync.sh; done

rm -rf packages/apps/FMRadio
git clone -q https://github.com/bimuafaq/android_packages_apps_FMRadio packages/apps/FMRadio -b lineage-18.1 --depth=1

source build/envsetup.sh
lunch lineage_RMX2185-userdebug
mka bacon
