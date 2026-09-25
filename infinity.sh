#!/bin/bash

set -E
trap 'echo "❌ FAILED at line $LINENO"' ERR

# Clean working tree parameters
rm -rf .repo/local_manifests

# Initialize ROM manifest without duplicate commands
repo init -u https://github.com/ProjectInfinity-X/manifest.git -b 16-QPR1 --no-repo-verify --git-lfs --depth=1 -g default,-mips,-darwin,-notdefault

# Cloning local manifest 
git clone https://github.com/imgay6969-cloud/local_manifests.git -b A16 .repo/local_manifests

echo "=================="
echo "Repo init success"
echo "=================="

# Installing required packages BEFORE sync
sudo apt-get update && sudo apt-get install patchelf coreutils -y 

echo "============="
echo "packages done"
echo "============="

echo "Sync"
echo "============="

# Execute workspace sync pipeline once cleanly
/opt/crave/resync.sh

# ─── BUILD ────────────────────────────────────────────────
set -e
source build/envsetup.sh
lunch infinity_blossom-userdebug
m bacon -j$(nproc --all)
# ──────────────────────────────────────────────────────────
