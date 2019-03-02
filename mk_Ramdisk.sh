#!/bin/bash

rm -rf ramdisk*

dd if=/dev/zero of=ramdisk bs=1k count=8192

mkfs.ext4 -F ramdisk

mkdir -p ./initrd
mount -t ext4 ramdisk ./initrd

cp rootfs/* ./initrd -raf

mknod initrd/dev/console c 5 1
mknod initrd/dev/null c 1 3

umount ./initrd

gzip --best -c ramdisk > ramdisk.gz

mkimage -n "ramdisk" -A arm -O linux -T ramdisk -C gzip -d ramdisk.gz ramdisk.img

rm ramdisk ramdisk.gz initrd -rf

