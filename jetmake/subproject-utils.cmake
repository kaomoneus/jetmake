macro(startLibDependencies)
    set (EXTRA_INCLUDE_DIRS)
    set (LEVITATION_DEPENDENCY_LIBS)
endmacro()

macro(endLibDependencies)
    # Do nothing
endmacro()

# Includes

macro (getProjectIncludes var projectName)
    getSubVariable(${var} ${projectName} INCLUDE)
endmacro()

macro (setProjectIncludes projectName var)
    setSubVariable(${projectName} INCLUDE ${var})
endmacro()

# Link Flags

macro (getProjectLinkFlags var projectName)
    getSubVariable(${var} ${projectName} LINK_FLAGS)
endmacro()

macro (setProjectLinkFlags projectName var)
    setSubVariable(${projectName} LINK_FLAGS ${var})
endmacro()

# Compile Definitions

macro (getProjectCompileDefinitions var projectName)
    getSubVariable(${var} ${projectName} COMPILE_DEFINITIONS)
endmacro()

macro (setProjectCompileDefinitions projectName var)
    setSubVariable(${projectName} COMPILE_DEFINITIONS ${var})
endmacro()

# Compile Definitions Debug

macro (getProjectCompileDefinitionsDebug var projectName)
    getSubVariable(${var} ${projectName} COMPILE_DEFINITIONS_DEBUG)
endmacro()

macro (setProjectCompileDefinitionsDebug projectName var)
    setSubVariable(${projectName} COMPILE_DEFINITIONS_DEBUG ${var})
endmacro()

# Libraries

macro (getProjectLibraries var projectName)
    getSubVariable(${var} ${projectName} LIBS)
endmacro()

macro (setProjectLibraries projectName var)
    setSubVariable(${projectName} LIBS ${var})
endmacro()

macro (getProjectTypeSubDir dir projectType)
    if ("${projectType}" STREQUAL "LIB")
        set(${dir} "lib")
    elseif("${projectType}" STREQUAL "TOOLS")
        set(${dir} "tools")
    endif()
endmacro()

macro (getProjectTypeDir dir projectType)
    getProjectTypeSubDir(subDir ${projectType})
    set(${dir} ${CMAKE_SOURCE_DIR}/src/${subDir})
endmacro()

macro (getProjectSrcRootDir projectType dir projectName)
    getProjectTypeDir(typeDir ${projectType})
    set(${dir} ${typeDir}/${projectName})
endmacro()

# Component Name

macro (getProjectComponentName var projectName)
    getSubVariable(${var} ${projectName} COMPONENT_NAME)
endmacro()

macro (setProjectComponentName projectName var)
    setSubVariable(${projectName} COMPONENT_NAME ${var})
endmacro()

# Include Directory

macro (getProjectIncludeDir projectType var projectName)
    getProjectSrcRootDir(${projectType} srcRoot ${projectName})
    getLevitationProjectIncludeSubdir(includeSubDir)
    set(${var} ${srcRoot}/${includeSubDir})
endmacro()


# Impl Directory

macro (getProjectImplDir projectType var projectName)
    getProjectSrcRootDir(${projectType} srcRoot ${projectName})
    getLevitationProjectImplSubdir(implSubDir)
    set(${var} ${srcRoot}/${implSubDir})
endmacro()

# Scripts Directory

macro (getProjectScriptsDir projectType var projectName)
    getProjectSrcRootDir(${projectType} srcRoot ${projectName})
    getLevitationProjectScriptsSubdir(scriptsSubDir)
    set(${var} ${srcRoot}/${scriptsSubDir})
endmacro()

# Resources Directory

macro (getProjectResourcesDir projectType var projectName)
    getProjectSrcRootDir(${projectType} srcRoot ${projectName})
    getLevitationProjectResourcesSubdir(resourcesSubDir)
    set(${var} ${srcRoot}/${resourcesSubDir})
endmacro()

# Service Directory

macro (getProjectServiceDir projectType var projectName)
    getProjectSrcRootDir(${projectType} srcRoot ${projectName})
    getLevitationProjectServiceSubdir(serviceSubDir)
    set(${var} ${srcRoot}/${serviceSubDir})
endmacro()

##

macro(setLibDependency dependencyLib)
    debug("Set lib dependency ${dependencyLib}")
    getProjectIncludeDir(LIB NEW_INCLUDE ${dependencyLib})
    trace("Added include (as dependency): ${NEW_INCLUDE}")
    set (EXTRA_INCLUDE_DIRS ${EXTRA_INCLUDE_DIRS} ${NEW_INCLUDE})
    set (LEVITATION_DEPENDENCY_LIBS ${LEVITATION_DEPENDENCY_LIBS} ${dependencyLib})
endmacro()

macro(setHeadersLibDependency dependencyLib)
    debug("Set headers lib dependency ${dependencyLib}")
    getProjectIncludeDir(LIB NEW_INCLUDE ${dependencyLib})
    trace("Added include (as dependency): ${NEW_INCLUDE}")
    set (EXTRA_INCLUDE_DIRS ${EXTRA_INCLUDE_DIRS} ${NEW_INCLUDE})
endmacro()

macro (setupTargetCompileDefinitions projectName)

    getProjectCompileDefinitions(compileDefinitions ${projectName})
    getProjectCompileDefinitionsDebug(compileDefinitionsDebug ${projectName})

    if (DEFINED ${compileDefinitions})
        debug("Setting additional definitions for ${projectName}: ${compileDefinitions}")
        set_directory_properties(PROPERTIES COMPILE_DEFINITIONS "${COMMON_COMPILE_DEFINITIONS};${compileDefinitions};")
    endif()

    if(DEFINED ${compileDefinitionsDebug})
        debug("Setting additional DEBUG definitions for ${projectName}: ${compileDefinitionsDebug}")
        set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG "${COMMON_COMPILE_DEFINITIONS_DEBUG};${compileDefinitionsDebug};")
    endif()

endmacro()

macro (setupTargetCompileFlags projectName)
    if (COMMON_COMPILE_FLAGS)
        set_target_properties(${projectName} PROPERTIES COMPILE_FLAGS ${COMMON_COMPILE_FLAGS})
    endif()
endmacro()

macro (setupTargetIncludeDirs projectType projectName)

    set(includeList ${EXTRA_INCLUDE_DIRS})

    getProjectIncludeDir(${projectType} projectIncludeDir ${projectName})
    set (INCLUDE_DIRS ${COMMON_INCLUDE_DIRS}
        ${projectIncludeDir}
        ${includeList}
    )

    include_directories(${INCLUDE_DIRS})

    foreach(extraInclude ${INCLUDE_DIRS})
        debug("Include ${extraInclude}")
    endforeach(extraInclude)

endmacro()

macro (setupTargetLibrarySourceFiles projectName)

    getProjectImplDir(LIB projectImplDir ${projectName})

    auxSourcesRecursive(${projectImplDir} sourceFiles)

    debug("Adding subtarget ${projectName}")
    add_library(${projectName} ${sourceFiles})

endmacro()


macro(setupTargetExecutableSourceFiles projectName)

    getProjectImplDir(TOOLS projectImplDir ${projectName})
    auxSourcesRecursive(${projectImplDir} sourceFiles)

    debug("Adding subtarget ${projectName}")
    add_executable(${projectName} ${sourceFiles})

endmacro()

macro(setupTargetExecutableLinkFlags projectName)
    getProjectLinkFlags(linkFlags ${projectName})
    if (linkFlags)
        set_target_properties(${projectName} PROPERTIES LINK_FLAGS
            ${linkFlags}
        )
    endif()
endmacro()

macro(setupTargetExecutableLibraries projectName)
    getProjectLibraries(libs ${projectName})
    target_link_libraries(${projectName}
        ${libs}
        ${LEVITATION_COMMON_LIBS}
        ${LEVITATION_DEPENDENCY_LIBS}
    )
endmacro()

macro(setupPackageComponent projectName)

    # componentName = Project[${projectName}]->ComponentName
    getProjectComponentName(componentName ${projectName})

    # This is something like
    # srcScripts = Project[${projectName}]->getScriptsDir()
    getProjectScriptsDir(TOOL srcScripts ${projectName})
    getProjectResourcesDir(TOOL srcResources ${projectName})
    getProjectServiceDir(TOOL srcService ${projectName})

    # installBin = Levitation::Install::getBin()
    getLivitationInstallBin(installBin)
    getLivitationInstallScripts(installScripts)
    getLivitationInstallResources(installResources)
    getLivitationInstallService(installService)

    set(COMPONENTS_ALL ${COMPONENTS_ALL} ${componentName})

    install(TARGETS ${projectName} DESTINATION ${installBin}
            COMPONENT ${componentName})

    if (srcScripts AND (EXISTS ${srcScripts}))
        trace("Found scripts dir: ${srcScripts}")
        install(
            DIRECTORY ${srcScripts}/
            DESTINATION ${installScripts}
            COMPONENT ${componentName}
        )
    endif()

    if (srcResources AND (EXISTS ${srcResources}) AND
        installResources)
        trace("Found resources dir: ${srcScripts}")
        install(
            DIRECTORY ${srcResources}/
            DESTINATION ${installResources}
            COMPONENT ${componentName}
        )
    endif()

    if (srcService AND installService)
        trace("Found service dir: ${srcScripts}")
        debug("Processing service template files for ${projectName}")
        file(GLOB files "${srcService}/*.service.in")
        foreach(file ${files})

            debug("Found service template file '${file}'")

            string(REGEX MATCH "^.*\\/([^\\]*)\\.[^.]*$" dummy ${file})
            set(outFile ${CMAKE_MATCH_1})

            debug("Making service '${outFile}'")
            configure_file(${file} ${outFile})

            debug("Service will be installed into '${installService}'")
            install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${outFile}
                DESTINATION ${installService}
                COMPONENT ${componentName}
            )
        endforeach()
    endif()

endmacro()

