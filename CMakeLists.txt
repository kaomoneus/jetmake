cmake_minimum_required (VERSION 2.6)
cmake_policy(SET CMP0054 NEW)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project (levitation)

include("jetmake/log.cmake")
include("jetmake/levitation-top-level.cmake")

# TODO: Move to project related file

set(LEVITATION_MAJOR_VERSION 1)
set(LEVITATION_MINOR_VERSION 1)
set(LEVITATION_PATCH_VERSION 2)

set(LEVITATION_VERSION "${LEVITATION_MAJOR_VERSION}.${LEVITATION_MINOR_VERSION}.${LEVITATION_PATCH_VERSION}")

set(LEVITATION_LOG_LEVEL ${LEVITATION_TRACE_LEVEL})

# TODO: End of "Move to project related file"

info (" |  =====================================  | ")
info ("-L-              Levitation               -L-")
info (" |  =====================================  | ")
info ("    Started build for version: ${LEVITATION_VERSION}")

setupCompileFlags()

setupCommonIncludes()

setupCommonLibraries()

addLevitationLibs()
addLevitationTools()

createLevitationPackages()
