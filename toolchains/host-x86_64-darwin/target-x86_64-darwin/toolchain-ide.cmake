# Deprecetad
# Don't use toolchain, when performing host-host compilations

SET(CMAKE_SYSTEM_NAME Darwin)

set(PLATFORM_DARWIN_X86_64 "1")
set(PLATFORM_COMPILE_DEFS "DARWIN;COMPILE_GL;IDE_MODE")

set(NO_CROSS_COMPILING)

#set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} /usr/local/lib)

#message("Darwin CMAKE_LIBRARY_PATH variable: ${CMAKE_LIBRARY_PATH}")

# Add Brew
#INCLUDE_DIRECTORIES(/usr/local/include)
#LINK_DIRECTORIES(/usr/local/lib)