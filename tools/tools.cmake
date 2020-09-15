include("${CMAKE_SOURCE_DIR}/jetmake/variables.cmake")
macro (setupToolDirs)
    # Application root directory, relative to install prefix.
    set(APP_ROOT_REL "opt/${CMAKE_PROJECT_NAME}")

    # Directory where all binaries will be installed.
    set(RUNTIME_ROOT "${APP_ROOT_REL}/bin")

    # Directory where all scripts will be installed.
    set(SCRIPTS_ROOT "${APP_ROOT_REL}/scripts")

    # Directory where all resources will be installed.
    set(RESOURCES_ROOT "${APP_ROOT_REL}/res")

    if (SYSTEMD_PRESENT)
        # TODO: I think that service dir is related only for systems with systemd
        # Services root directory relative to install prefix
        set(SYSTEMD_SERVICE_ROOT "etc/systemd/system")
    endif()

    # This is used bu applications to find out where they are relative to installation root.
    # So if runtime root is "{installation root}/bin"
    # then eveything lying in that "bin" dir should change dir to ".." to get "installation root"
    # in this case INSTALL_PREFIX_FOR_RUNTIME should be ".."
    set(INSTALL_PREFIX_FOR_RUNTIME ../../..)

endmacro()



macro(setupTool projectName)

    project (${projectName})

    setupTargetCompileDefinitions(${projectName})

    setupTargetIncludeDirs(TOOLS ${projectName})

    setupTargetExecutableSourceFiles(${projectName})

    setupTargetCompileFlags(${projectName})

    setupTargetExecutableLinkFlags(${projectName})

    setupTargetExecutableLibraries(${projectName})

    setupPackageComponent(${projectName})
    
endmacro()

macro(addTool toolName toolPath)

    if (EXISTS "${toolPath}/CMakeLists.txt")
        info("Adding tool ${toolName}")
        add_subdirectory(${toolPath} ${CMAKE_BINARY_DIR}/tool/${toolName})
    else()
        # If we don't have CMakeLists.txt inside, then
        # we add headers only tool, and thus generally do nothing.
        info("Adding headers-only toolrary ${toolName}")
    endif()
endmacro(addTool)

macro(addLevitationTools)

    setupToolDirs()

    getProjectTypeDir(toolsRoot TOOLS)

    message("Scanning levitation tools: ${toolsRoot}")

    string(LENGTH ${toolsRoot}/ prefixLength)

    subDirListMask(dirs ${toolsRoot} *)

    foreach(dir ${dirs})

        string(LENGTH ${dir} dirLength)
        math(EXPR toolNameLength "${dirLength} - ${prefixLength}")

        string(SUBSTRING ${dir} ${prefixLength} ${toolNameLength} toolName)

        addTool(${toolName} ${dir})
    endforeach()

endmacro(addLevitationTools)
