# About
## What for?
For C++ developers who want to create new project at easy. Or just add new subproject.
CMake is very powerful and yet sometimes... a bit complicated.

## So what is jetmake about?
JetMake is a simple cmake macros infrastructure which is
indented to simplify compound C++ projects development.

While using poor cmake methods you should do a lot of things manually:
* collect sources manually (the is aux_source_directory, but it is not recursive)
* add includes and libs (lib + include = dependency, we usually add them together) 
* control linker and compile flags
* develop directories structure

With Jetmake you just put sources into folder with your lib or tool name and it
recognizes it as a project.

The only thing you need is to follow jetmake directories structure.

# How to use
As you could notice current repo contains some demo project. Everything related to
jetmake is placed in "jetmake" subdirectory. "jetmake" subdir is the only thing you need to
deploy your own project.

## "Project" is a project tree
When we say "project" we mean project tree with subprojects included.
 
## What should you do on top level?
1. Create folder for your project.
2. Copy jetmake directory into it.
3. From jetmake subdir copy CMakeLists-example.txt into your project root dir, and
   rename it into CMakeLists.txt.
   
## Tools and libs
In jetmake all executable sub-projects are called "tools".
While all library projects
are "libs".
* Tools are located in "tools" subdirectory.
* Libs are located in "lib" subdirectory.
   
## How to add executable subproject (tool)

1. In "tools" directory create a directory with exact name of your tool. E.g. "Foo"
2. From jetmake subdirectory copy "CMakeLists-tools-example.txt" into it,
   and rename into CMakeLists.txt.
3. Put all sources and private headers in "impl" subfolder.
4. Put all public headers in "include" subfolder.

So after all we have following directories structure

    <project-root>
    |-jetmake       <dir>
    |-lib           <dir>
    |-tools         <dir>
    | |-include     <dir>   # contains public .h files
    | |-impl        <dir>   # contains .cpp, and private .h files
    | |-CMakeLists.txt      # cmake tool project file, with set of jetmake macros.
    |
    |-CMakeLists.txt        # cmake root project file, with set of jetmake macros.
    
## How to add library subproject (lib)

Steps are very similar/

1. In "lib" directory create a directory with exact name of your tool. E.g. "Panic"
2. From jetmake subdirectory copy "CMakeLists-lib-example.txt" into it,
   and rename into CMakeLists.txt.
3. Put all sources and private headers in "impl" subfolder.
4. Put all public headers in "include" subfolder.

So, after all we have following directories structure

    <project-root>
    |-jetmake       <dir>
    |-lib           <dir>
    | |-include     <dir>   # contains public .h files
    | |-impl <dir>          # contains .cpp, and private .h files
    | |-CMakeLists.txt      # cmake tool project file, with set of jetmake macros.
    |
    |-tools         <dir>
    |
    |-CmakeLists.txt        # cmake root project file, with set of jetmake macros.

## CMakeLists.txt for tools and libs

### Header

In the beginning of file you should include jetmake macros, and run jetmake initializer macro.

For tools:

    include("${CMAKE_SOURCE_DIR}/jetmake/common.cmake")
    include("${CMAKE_SOURCE_DIR}/jetmake/tools/tools.cmake")

    jetmakeProject()

For lib (almost same):

    include("${CMAKE_SOURCE_DIR}/jetmake/common.cmake")
    include("${CMAKE_SOURCE_DIR}/jetmake/lib/lib.cmake")

    jetmakeProject()

### Subproject body: dependencies and other properies

In subproject body you may define dependencies list, compiler definitions list and so on.
Features set will be probably extendend. Ideally it would be good to customize next things:

* Dependencies to other subrojects (libs) (done)
* Dependencies to external libs (done)
* Compiler definitions (done)
* Other compiler flags (TODO)
* Linker flags (done)

It is better to look into example CMakeLists files in jetmake subdirectory for details.
Here we just put example of dependcies list. Just to demonstrate how simple it should
be for the rest of project properties.

#### Dependencies

    startLibDependencies()                  # Dependencies open tag
        setHeadersLibDependency(StdTypes)   # Dependency to headers only lib
        setLibDependency(Panic)             # Dependency to static library
        setExternalLibDependency(jsoncpp)   # Dependency to external library
    endLibDependencies()                    # Dependencies close tag

### Subproject close tag

Once you defined your project it is necessary to instruct jetmake that you're done with it.

For tool:

    setupTool(<ProjectName>)


For lib:

    setupLib(<ProjectName>)

### Subproject example

Below we take a look at simple CMakeLists.txt file for "tool" subproject.

#### Tool subproject CMakeLists.txt example

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

## Toolchains
Jetmake considers everything as a cross builds. So in order to configure build directory
you should pick proper toolchain file.

Toolchain files are located in "jetmake/toolchains" directory.

### Example of cmake command:

    cmake <path-to-project>
    -DCMAKE_TOOLCHAIN_FILE=<path-to-project>/jetmake/toolchains/host-x86_64-darwin/target-x86_64-darwin/toolchain.cmake
    -DCMAKE_INSTALL_PREFIX=$PWD/install
    -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug

# What else?

Currently we would recommend reader to look into code or send requests to the author.
So far there is only only jetmake user. Guess who? ;-) And thus it is extended in
very narrow direction.

Hopefully it will help somebody else as well!

Cheers!
