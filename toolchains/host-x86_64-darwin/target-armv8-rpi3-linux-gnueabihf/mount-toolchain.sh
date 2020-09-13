#!/usr/bin/env bash
DMG=../../../../toolchains/armv8-rpi3-linux-gnueabihf.dmg
DEST=/Volumes/toolchain-armv8-rpi3-linux-gnueabihf
HDIUTIL=hdiutil

if [ "$1" = "-u" ]
then
    echo "Unmounting toolchain..."
    $HDIUTIL detach $DEST
else
    echo "Mounting toolchain..."
    $HDIUTIL attach $DMG -readonly -mountpoint $DEST
fi