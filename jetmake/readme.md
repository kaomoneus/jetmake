# About
JetMake is a simple cmake infrastructure which is
indented to simplify compound C++ projects development.
While using poor cmake methods you should collect sources manually,
add includes and libs, control linker and compile flags, think about directories structure.
With Jetmake you just put sources into folder with you lib or tool name and it
recognizes it as a project.
The only thing you need is to follow jetmake directories structure.

## How to use
As you could notice current repo contains some demo project. Everything related to
jetmake is placed in subdirectory with same name. And this is the only thing you need to
deploy your own project.
When we say "project" we mean project tree with subprojects included.
 
### What should you do on top level?
1. Create folder for your project.
2. Copy jetmake directory into it.
3. From jetmake subdir copy CMakeLists-example.txt into your project root dir, and
   rename it into CMakeLists.txt.
   
### Tools and libs
In jetmake all executable sub-projects are called "tools".
While all library projects
are "libs".
* Tools are located in "tools" subdirectory.
* Libs are located in "lib" subdirectory.
   
### How to add executable subproject (tool)

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
    
#### CMakeLists.txt for tool
TODO

### How to add library subproject (lib)

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

#### CMakeLists.txt for lib
TODO
 
 
