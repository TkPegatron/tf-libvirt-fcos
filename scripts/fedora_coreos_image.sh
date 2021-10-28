#!/usr/bin/env bash
set -euo pipefail
IMAGE_CACHE="${PROJECT_DIR}/.terraform/image_cache"

if [ ! -d $IMAGE_CACHE ]; then
  mkdir -p $IMAGE_CACHE
fi

echo "Image Cache Location: "
echo $IMAGE_CACHE
echo
echo "Project Directory: "
echo $PROJECT_DIR
echo

cd $IMAGE_CACHE

if [ ! -e "fedora-coreos-${FCOS_VERSION}-qemu.x86_64.qcow2" ]; then
    if [ ! -e "fedora-coreos-${FCOS_VERSION}-qemu.x86_64.qcow2.xz" ]; then
        echo "Disk image not cached, downloading..."
        wget "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/${FCOS_VERSION}/x86_64/fedora-coreos-${FCOS_VERSION}-qemu.x86_64.qcow2.xz"
    fi
    unxz -v "fedora-coreos-${FCOS_VERSION}-qemu.x86_64.qcow2.xz"
else
    echo "Disk image found, uploading...."
fi

cd $PROJECT_DIR
