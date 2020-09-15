include("${CMAKE_SOURCE_DIR}/jetmake/variables.cmake")
include("${CMAKE_SOURCE_DIR}/jetmake/subproject-utils.cmake")

macro(addLib libName libPath)

    if (EXISTS "${libPath}/CMakeLists.txt")
        info("Adding library ${libName}")
        add_subdirectory(${libPath} ${CMAKE_BINARY_DIR}/lib/${libName})
    else()
        # If we don't have CMakeLists.txt inside, then
        # we add headers only lib, and thus generally do nothing.
        info("Adding headers-only library ${libName}")
    endif()
endmacro(addLib)

macro(addLevitationLibs)

    getProjectTypeDir(libsRoot LIB)

    message("Scanning levitation libraries: ${libsRoot}")

    string(LENGTH ${libsRoot}/ prefixLength)

    subDirListMask(dirs ${libsRoot} *)
    foreach(dir ${dirs})

        string(LENGTH ${dir} dirLength)
        math(EXPR libNameLength "${dirLength} - ${prefixLength}")

        string(SUBSTRING ${dir} ${prefixLength} ${libNameLength} libName)

        addLib(${libName} ${dir})
    endforeach()
endmacro(addLevitationLibs)

macro(setupLib projectName)

    project (${projectName})

    setupTargetCompileDefinitions(${projectName})

    setupTargetIncludeDirs(LIB ${projectName})

    setupTargetLibrarySourceFiles(${projectName})

    setupTargetCompileFlags(${projectName})

    debug("library ${projectName} added")
    debug("")

endmacro(setupLib)