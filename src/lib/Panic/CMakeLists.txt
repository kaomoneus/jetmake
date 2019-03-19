include("${CMAKE_SOURCE_DIR}/jetmake/common.cmake")
include("${CMAKE_SOURCE_DIR}/jetmake/tools/tools.cmake")

jetmakeProject()

startLibDependencies()
    setLibDependency(StdTypes)
endLibDependencies()

setupLib(Panic)
