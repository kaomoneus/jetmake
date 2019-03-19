macro(jetmakeProject)
    cmake_minimum_required (VERSION 2.6)
    cmake_policy(SET CMP0054 NEW)
    cmake_policy(SET CMP0043 NEW)
endmacro()

macro(subDirList result curdir)
  file(GLOB children ${curdir} ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${child})
        list(APPEND dirlist ${child})
    endif()
  endforeach()
  list(REMOVE_ITEM dirlist "${curdir}")
  set(${result} ${dirlist})
endmacro()

macro(subDirListMask result curdir mask)
  file(GLOB children ${curdir} ${curdir}/${mask})
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${child})
        list(APPEND dirlist ${child})
    endif()
  endforeach()
  list(REMOVE_ITEM dirlist "${curdir}")
  set(${result} ${dirlist})
endmacro()

macro(filesListMask result curdir mask)
  file(GLOB children ${curdir} ${curdir}/${mask})
  set(dirlist "")
  foreach(child ${children})
    if(NOT (IS_DIRECTORY ${child}))
        list(APPEND dirlist ${child})
    endif()
  endforeach()
  list(REMOVE_ITEM dirlist "${curdir}")
  set(${result} ${dirlist})
endmacro()

macro(subDirListRecursive result curdir)
  set(dirlist "")
  set(dirlist2 "")
  subDirList(dirlist ${curdir})
  list(LENGTH dirlist current)
  list(LENGTH dirlist2 new)
  set(${result} ${dirlist})
  while(NOT (${current} EQUAL ${new}))
      set(dirlist2 "")
      foreach(d ${dirlist})
          if (NOT (${d} EQUAL ${curdir}))
              subDirList(newDirList ${d})
              set(dirlist2 ${dirlist2} ${newDirList})
          endif()
      endforeach()
      set(tmp ${dirlist2})
      set(dirlist2 ${dirlist})
      set(dirlist ${tmp})
      list(LENGTH dirlist current)
      list(LENGTH dirlist2 new)
      set(${result} ${${result}} ${dirlist})
  endwhile()
endmacro()

macro(auxSources dir sourcesVar)
    set(newSources "")
    aux_source_directory(${dir} newSources)
    trace("Scanning sources at ${dir}")
    trace("Found sources: ${newSources}")
    set (${sourcesVar} ${${sourcesVar}} ${newSources})
endmacro()

macro(auxSourcesRecursive dir sourcesVar)
    auxSources(${dir} ${sourcesVar})
    subDirListRecursive(subDirs ${dir})
    foreach(d ${subDirs})
        auxSources(${d} ${sourcesVar})
    endforeach()
endmacro()

macro(getTargetArch destVar)
    if (PLATFORM_LINUX_X86_64)
        set(${destVar} "amd64")
    elseif(PLATFORM_DARWIN_X86_64)
        set(${destVar} "darwin-x86_64")
    elseif(PLATFORM_ARM)
        set(${destVar} "armhf")
    else()
        message( FATAL_ERROR "Undefined platform. Sorry I still need it to be known." )
    endif()
endmacro()