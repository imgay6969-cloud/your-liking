#!/bin/bash

set -E
trap 'echo "❌ FAILED at line $LINENO"' ERR

# Clean working tree parameters
rm -rf .repo/local_manifests

# Initialize ROM manifest
repo init -u https://github.com/ProjectInfinity-X/manifest.git repo init --no-repo-verify --git-lfs --depth=1 \
  -u https://github.com/ProjectInfinity-X/manifest.git \
  -b 16-QPR1 \
  -g default,-mips,-darwin,-notdefault-b 16-QPR1 --depth=1 --git-lfs

# Cloning local manifest 
git clone https://github.com/imgay6969-cloud/local_manifests.git -b A16 .repo/local_manifests

echo "=================="
echo "Repo init success"
echo "=================="

echo "Sync"
echo "============="

# Execute workspace sync pipeline once cleanly
/opt/crave/resync.sh

# Installing required packages
sudo apt-get update && sudo apt-get install patchelf coreutils -y 

echo "============="
echo "packages done"
echo "============="


# ─── BUILD ────────────────────────────────────────────────
set -e
source build/envsetup.sh
lunch infinity_${DEVICE}-${BUILD_TYPE}
m bacon -j$(nproc --all)
# ──────────────────────────────────────────────────────────


