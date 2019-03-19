include("${CMAKE_SOURCE_DIR}/jetmake/common.cmake")
include("${CMAKE_SOURCE_DIR}/jetmake/tools/tools.cmake")

jetmakeProject()

startLibDependencies()
    setHeadersLibDependency(StdTypes)
    setLibDependency(Panic)
    setExternalLibDependency(jsoncpp)
endLibDependencies()

setProjectCompileDefinitions(Foo TEST_COMPILE_DEFINITION)

setupTool(Foo)