include ("${CMAKE_SOURCE_DIR}/jetmake/common.cmake")
include ("${CMAKE_SOURCE_DIR}/jetmake/lib/libs.cmake")
include ("${CMAKE_SOURCE_DIR}/jetmake/tools/tools.cmake")
include ("${CMAKE_SOURCE_DIR}/jetmake/subproject-utils.cmake")

macro (getLivitationAppRootRel var)
    set(${var} "opt/${CMAKE_PROJECT_NAME}")
endmacro()

macro (getLivitationInstallBin var)
    getLivitationAppRootRel(appRootRel)
    set(${var} "${appRootRel}/bin")
endmacro()

macro (getLivitationInstallScripts var)
    getLivitationAppRootRel(appRootRel)
    set(${var} "${appRootRel}/scripts")
endmacro()

macro (getLivitationInstallResources var)
    getLivitationAppRootRel(appRootRel)
    set(${var} "${appRootRel}/res")
endmacro()

macro (getLivitationInstallService var)
    if (SYSTEMD_PRESENT)
        # TODO: I think that service dir is related only for systems with systemd
        # Services root directory relative to install prefix
        set(${var} "etc/systemd/system")
#    else()
#        error("Services are not supported on target system")
    endif()
endmacro()

macro (getLevitationProjectIncludeSubdir var)
    set(${var} "include")
endmacro()

macro (getLevitationProjectImplSubdir var)
    set(${var} "impl")
endmacro()

macro (getLevitationProjectScriptsSubdir var)
    set(${var} "scripts")
endmacro()

macro (getLevitationProjectResourcesSubdir var)
    set(${var} "res")
endmacro()

macro (getLevitationProjectServiceSubdir var)
    set(${var} "service")
endmacro()

macro (getLevitationCommonLibs var)
    set(${var} ${LEVITATION_COMMON_LIBS})
endmacro()

macro (getLevitationCommonLibsVarName var)
    set(${var} LEVITATION_COMMON_LIBS)
endmacro()

macro (addLevitationCommonLibs var)
    set(LEVITATION_COMMON_LIBS ${LEVITATION_COMMON_LIBS} ${${var}})
endmacro()

macro (setupCompileFlags)

    # TODO: Don't use constants. Easy way, but... use getters and setters.

    set(COMMON_COMPILE_FLAGS)

    option(ENABLE_RPI3_FLAGS "Enables RPI3 related optimizations. Supposed to build faster code." OFF)

    if (PLATFORM_ARM AND ENABLE_RPI3_FLAGS)
        if (CMAKE_BUILD_TYPE MATCHES "Release")
            message("Enabling raspberry related clang optimization flags.")
            set(COMMON_COMPILE_FLAGS "${COMMON_COMPILE_FLAGS} -mcpu=cortex-a53 -march=armv8 -mtune=cortex-a53 -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard -ftree-vectorize")
            set(COMMON_COMPILE_FLAGS "${COMMON_COMPILE_FLAGS} -funsafe-math-optimizations -flto")
        endif()
    endif()

    set(COMMON_COMPILE_DEFINITIONS
            "ENABLE_STL;INSTALL_PREFIX_FOR_RUNTIME=${INSTALL_PREFIX_FOR_RUNTIME};${PLATFORM_COMPILE_DEFS}")

    set(COMMON_COMPILE_DEFINITIONS_DEBUG
            "DEBUG=1;${COMMON_COMPILE_DEFINITIONS}")

    set_directory_properties(PROPERTIES COMPILE_DEFINITIONS "${COMMON_COMPILE_DEFINITIONS}")
    set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG "${COMMON_COMPILE_DEFINITIONS_DEBUG}")

    option(ENABLE_PROFILER "Add profiler information" OFF)

    if (ENABLE_PROFILER)
        if (CMAKE_BUILD_TYPE EQUAL "Release")
            set(CMAKE_BUILD_TYPE "RelWithDebInfo")
        endif()

        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pg")
    endif()

endmacro()

macro (setupCommonIncludes)
    set(COMMON_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/include)
endmacro()

# Looks for external libs
macro(findLibs libsFound osLibraries)

    info("Looking for common libs...")

    foreach(LIB ${${osLibraries}})
        set(LIB_FOUND LIB_FOUND-NOTFOUND) #f..n hack :-\
        find_library(LIB_FOUND
                ${LIB}
                PATHS
                )
        info("${LIB}... ${LIB_FOUND}")
        list(APPEND ${libsFound} ${LIB_FOUND})
    endforeach(LIB)
endmacro()

macro (setupCommonLibraries)
    if (PLATFORM_LINUX_X86_64)
        # set(PLATFORM_SUFFIX "linux-x86_64")
        set (OS_LIBRARIES ${OS_LIBRARIES}
            rt
            m
            pthread
        )

    elseif(PLATFORM_DARWIN_X86_64)
        # set(PLATFORM_SUFFIX "darwin-x86_64")
        set (OS_LIBRARIES ${OS_LIBRARIES}
            m
            pthread
        )
    elseif(PLATFORM_ARM)
        # set(PLATFORM_SUFFIX "arm")
        set (OS_LIBRARIES ${OS_LIBRARIES}
            librt.a
            libm.a
            pthread
        )
    else()
        error(
            "Undefined platform. Sorry I still need it to be known " 
            "Please use sample in 'toolchains' directory or create your own."
        )
    endif()

    getLevitationCommonLibsVarName(commonLibsVarName)
    findLibs(${commonLibsVarName} ${OS_LIBRARIES})

    # FIXME: We perhaps don't need this section at all
    # getLevitationProjectExternalLibsDir(externalLibsDir)
    # addLevitationCommonLibs(${externalLibsDir}/libjsoncpp.a)

endmacro()

macro (createLevitationPackages)
    if(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")
    include(InstallRequiredSystemLibraries)

    set(CPACK_SET_DESTDIR "on")

    set(CPACK_PACKAGE_VENDOR "Stepan Dyatkovskiy")
    set(CPACK_PACKAGE_CONTACT "Stepan Dyatkovskiy (you can contact me in facebook)")
    set(CPACK_PACKAGE_VERSION_MAJOR "${BIGE_MAJOR_VERSION}")
    set(CPACK_PACKAGE_VERSION_MINOR "${BIGE_MINOR_VERSION}")
    set(CPACK_PACKAGE_VERSION_PATCH "${BIGE_PATCH_VERSION}")
    # SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${BIGE_MAJOR_VERSION}.${BIGE_MINOR_VERSION}.${BIGE_PATCH_VERSION}")
    # SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_SOURCE_PACKAGE_FILE_NAME}")

    set(CPACK_DEBIAN_PACKAGE_DEPENDS "libraspberrypi-bin (>= 1.20180417-1), bash (>= 4.4-5)")

    set(CPACK_DEBIAN_PACKAGE_PRIORITY "extra")
    set(CPACK_DEBIAN_PACKAGE_SECTION "misc")

    getTargetArch(TARGET_ARCH)
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE ${TARGET_ARCH})
    set(CPACK_DEB_COMPONENT_INSTALL ON)

    include(CPack)

    # FIXME: add unified way to register subproject as a component
    #
    cpack_add_component(${TEXT_OSD_COMPONENT_NAME}
        DISPLAY_NAME "Bird OSD"
        DESCRIPTION "${TEXT_OSD_DESCRIPTION}"
    )

    endif(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")

endmacro()
