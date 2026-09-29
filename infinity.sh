#!/bin/bash
set -E
trap 'echo "❌ FAILED at line $LINENO"' ERR

rm -rf .repo/local_manifests

# LFS wapas laga diya taaki vendor files miss na hon
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16-QPR1 -g default,-mips,-darwin,-notdefault

git clone https://github.com/imgay6969-cloud/local_manifests.git -b A16 .repo/local_manifests

echo "=================="
echo "Repo init success"
echo "=================="

echo "Sync"
echo "============="

/opt/crave/resync.sh


sudo apt-get update
sudo apt-get install -y patchelf coreutils ccache

# Force-abort any stuck patch sessions and hard-reset to a clean sync state
for repo in frameworks/av frameworks/base hardware/interfaces packages/modules/Bluetooth build/soong system/sepolicy; do
    if [ -d "$repo" ]; then
        git -C "$repo" am --abort 2>/dev/null || true
        git -C "$repo" reset --hard HEAD 2>/dev/null || true
        git -C "$repo" clean -fd 2>/dev/null || true
    fi
done



set -e
source build/envsetup.sh
lunch infinity_blossom-userdebug
m bacon -j$(nproc --all)
