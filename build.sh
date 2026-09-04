#!/usr/bin/env bash
set -e

wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb && sudo dpkg -i libtinfo5_6.3-2_amd64.deb &>/dev/null && rm -f libtinfo5_6.3-2_amd64.deb
wget -q https://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb && sudo dpkg -i libncurses5_6.3-2_amd64.deb &>/dev/null && rm -f libncurses5_6.3-2_amd64.deb

source build/envsetup.sh
lunch lineage_RMX2185-user
cmka bacon && {
    export PATH=$PWD/out/host/linux-x86/bin:$PATH
    sign_target_files_apks -d vendor/lineage-priv/keys out/target/product/*/obj/PACKAGING/*-target_files-*.zip out/target/product/*/signed-target_files.zip
    ota_from_target_files -k vendor/lineage-priv/keys/releasekey out/target/product/*/signed-target_files.zip out/target/product/*/signed-ota.zip
}