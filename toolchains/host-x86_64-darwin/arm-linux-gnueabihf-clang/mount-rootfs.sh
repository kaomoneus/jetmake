#!/usr/bin/env bash
SRC="pi@192.168.1.200:/"
DEST="/Volumes/rootfs-arm-linux-gnueabihf"

MOUNT=sshfs
UMOUNT=umount

if [ "$1" = "-u" ]
then
    echo "Unmounting toolchain..."
    $UMOUNT $DEST
else
    echo "Mounting toolchain..."
    $MOUNT $SRC $DEST
fi