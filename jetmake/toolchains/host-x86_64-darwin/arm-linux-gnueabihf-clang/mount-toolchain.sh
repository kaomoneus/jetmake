#!/usr/bin/env bash
DMG=../../../../toolchains/arm-linux-gnueabihf.dmg
DEST=/Volumes/toolchain-arm-linux-gnueabihf
HDIUTIL=hdiutil

if [ "$1" = "-u" ]
then
    echo "Unmounting toolchain..."
    $HDIUTIL detach $DEST
else
    echo "Mounting toolchain..."
    $HDIUTIL attach $DMG -readonly -mountpoint $DEST
fi