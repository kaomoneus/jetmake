# This is a main rule for full variable name resolution.
macro (getSubVariableFullName varFullName parent varName)
    set(${varFullName} LEVITATION_${parent}_${varName})
endmacro()

macro (getSubVariable varValue parent varName)
    getSubVariableFullName(varFullName ${parent} ${varName})
    # trace("Trying to get ${varFullName}")
    if (DEFINED ${varFullName})
        set(${varValue} ${${varFullName}})
        # trace("${varFullName} is ${${varValue}}.")
    else()
        # trace("${varFullName} is not defined.")
    endif()
endmacro()

macro (setSubVariable parent varName varValue)
    getSubVariableFullName(varFullName ${parent} ${varName})
    # trace("Set ${varFullName} = ${varValue}")
    set(${varFullName} ${varValue})
endmacro()

macro (appendSubVariable parent varName varValue)
    getSubVariableFullName(varFullName ${parent} ${varName})
    set(${varFullName} ${${varFullName}} ${varValue})
endmacro()


macro (copySubVariable dstParent srcParent varName)
    copySubVariableEx(${dstParent} ${varName} ${srcParent} ${varName})
endmacro()

macro (copySubVariableEx dstParent dstVarName srcParent srcVarName)
    getSubVariable(value ${srcParent} ${srcVarName})
    setSubVariable(${dstParent} ${dstVarName} ${value})
endmacro()

macro (exportSubVariable parent varName)
    getSubVariableFullName(varFullName ${dstParent} ${dstVarName})
    if (DEFINED ${varFullName})
        set(${varFullName} ${${varFullName}} PARENT_SCOPE)
    endif()
endmacro()

# Generates full variable name for particular library.
# E.g. I have library "MyLib" and want to know which
# variable should store "include" directories.
# I call getLibVar(VAR_NAME MyLib INCLUDE)
# end it will return something like: LEVITATION_MyLib_INCLUDE
macro(getLibVar libVar libName varName)
    getSubVariableFullName(${libVar} ${libName} ${varName})
endmacro()

# Returns value of variable for particular library.
macro(getLibVarValue libVarValue libName varName)
    getSubVariable(${libVarValue} ${libName} ${varName})
endmacro()

# Generates full variable name for particular tool.
# E.g. I have library "MyTool" and want to know which
# variable should store "include" directories.
# I call getToolVar(VAR_NAME MyTool INCLUDE)
# end it will return something like: LEVITATION_TOOL_MyTool_INCLUDE
macro(getToolVar projectVar projectName varName)
    getSubVariableFullName(${projectVar} ${projectName} ${varName})
endmacro()

macro(getToolVarValue projectVarValue projectName varName)
    getSubVariable(${projectVarValue} ${projectName} ${varName})
endmacro()
