cmake_minimum_required (VERSION 2.6)
cmake_policy(SET CMP0054 NEW)

include("${CMAKE_SOURCE_DIR}/jetmake/lib/libs.cmake")

startLibDependencies()
    setLibDependency(StdTypes)
endLibDependencies()

setupLib(Panic)
