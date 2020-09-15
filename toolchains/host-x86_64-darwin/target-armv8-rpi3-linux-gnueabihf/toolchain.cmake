SET(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)


SET(HOST x86_64-darwin)
SET(TARGET armv8-rpi3-linux-gnueabihf)

SET(HOST_FOLDER host-${HOST})
SET(TARGET_FOLDER target-${TARGET})

SET(PIROOT /Volumes/rootfs-${TARGET})
SET(TOOLROOT /Volumes/toolchain-${TARGET})
set(COMPILER_SYSROOT "${TOOLROOT}/${TARGET}/sysroot")

SET(LLVM_DIR /Users/stepan/projects/shared/toolchains/llvm.darwin-x86_64)
SET(CLANG ${LLVM_DIR}/bin/clang)
SET(CLANGXX ${LLVM_DIR}/bin/clang++)

# specify the cross compiler
SET(CMAKE_C_COMPILER   ${CLANG})
SET(CMAKE_CXX_COMPILER ${CLANGXX})

# SET(CMAKE_SYSROOT ${PIROOT})
# SET(CMAKE_FIND_ROOT_PATH ${PIROOT})

set(TOOLCHAIN_DIR /Volumes/xtool-build-env/armv8-rpi3-linux-gnueabihf)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Todo add -mfpu=neon-vfpv4
# set(CMAKE_C_FLAGS "-mcpu=cortex-a7" CACHE STRING "Flags for Raspberry Pi 2")
set(CROSS_FLAGS "--target=armv8-rpi3-linux-gnueabihf --sysroot=/Volumes/toolchain-armv8-rpi3-linux-gnueabihf/armv8-rpi3-linux-gnueabihf/sysroot --gcc-toolchain=/Volumes/toolchain-armv8-rpi3-linux-gnueabihf -fuse-ld=lld")
set(RASP_FLAGS "-D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} ${CROSS_FLAGS} ${RASP_FLAGS}")

# For easier testing with qemu-arm.
# set(CMAKE_EXE_LINKER_FLAGS "-static" CACHE STRING "Flags to generate static
# executables")

set(PLATFORM_ARM "1")
set(SYSTEMD_PRESENT "1")

set(PLATFORM_COMPILE_DEFS "COMPILE_GLES;PLATFORM_ARM;BOARD_RPI")
