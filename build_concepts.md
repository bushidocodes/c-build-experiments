# Key Build Concepts

## Scope in C
A C program has multiple forms of scope:

- Program Scope. Global with External Linkage
- Translation Unit Scope. Global with Internal Linkage
- Function Scope.

## Linkage and Translation Units in C Programs

A C program is composed of one or more `translation units`, which are functionally equivalent to a `*.c` source file after preprocessing such and text substitution of include header files. Functions and variables can have either `internal linkage`, which means that they are visible only within the same translation unit, or `external linkage`, which means that they are globally visible across translation units. A function or variable with external linkage can only be defined in a single translation unit, but it must be declared within each translation unit that uses it. This is typically accomplished by declaring the function or variable with external linkage in a `*.h` header file that is text substituted into each translation unit that uses it via the preprocessor. The C compiler (technically a C compiler and an assembler) is responsible for turning the source file of each translation unit into an `object module`, which contains machine code and and information about symbols with external linkage that it provides and symbols with external linkage that it requires. It is the job of the linker to combine the various translation units into an executable. It ensures that there are no conflicting or missing symbols. A program can only be run when all required symbols with external linkage can be resolved.

Assorted Notes:

- In C, storage classes determine linkage. The `extern` storage class signifies external linkage and the `static` storage class indicates internal linkage

## C Preprocessor

The C preprocessor is a text processor that acts on `*.c` source code. It is called a preprocessor because it is executed on source code as a preprocessing step before being passed to the compiler. It performs actions based on directives that start with the `#` pragma symbol. The preprocessor replaces the `#include` directive with the full text of `*.h` header files that it references. (add info on the path used to find headers...) Preprocessor macros provide primitive techniques to perform textual substitution and generate source code. However, the preprocessor does not understand C syntax. Similarly, the C compiler does not understand preprocessor directives or `*.h` header files.

Key Takeaways:

- Header files are a preprocessor abstraction. They are not part of the C language itself.
- Header files are used to centralize the public interface of a translation unit. This public interface includes `extern` declarations and function prototype declarations and is text substituted into users of these globals (variables and functions with external linkage)

## Higher Level Abstractions built on the linker

In the simplest case, the linker is provided all required translation units directly, and it directly outputs an executable containing all required code. However, in practice, developers seek to speed up development by reusing third-party libraries. C has no concept of libraries or modules. These are provided by the linker and the host environment and have been separately standardized over time. As such, the techniques differ. For simplicity, this section focused on traditional UNIX standards to illustrate the concepts.

A library is a logical grouping of pre-compiled translation units, which commonly have a mix of functions and variables with internal and external linkage. The library typically exposes a public API that can be included via a \*.h header, which is commonly prefixed to prevent namespace collisions / pollution. None of these translation units should contain a `main` function.

The file containing the pre-compiled translation units takes the form of a `*.a` archive, which is statically linked at compile-time or a `*.so` shared library, which is dynamically linked at runtime. The differences between these techniques will be detailed further later. In either case, the file is prefixed by `lib` prefix. Thus, the C standard library is `libc.so` or `libc.a`, the C math library is `libm.so` or `libm.a`, and the ncurses library is `libncurses`. `/usr/lib` is the traditional directory for storing these files, but the search path is determined by the environment variable `LD_LIBRARY_PATH`. A third-party module is linked by dropping the lib prefix and using the `-l` argument with the compiler or linker. For example, `-lncurses` would search the paths in `LD_LIBRARY_PATH` for `libncurses.so` and link it.

As mentioned above, each translation unit must provide `extern` declarations for all function or variable with external linkage that it does not define. This includes the public API of libraries. Given that the compiler needs these declarations to generate object code, and that compilation occurs before linking, these headers cannot be packaged in shared libraries or archives. Instead, a library typically places its `*.h` headers in a known systems path, such as `/usr/include`, and other paths defined in the environment variable `CPATH`. The preprocessor searches these paths when it encounters a `#include` directive. Additionally, the preprocessor can be manually directed to search an alternate custom directory through the `-I/my/fav/directory` flag

Given all of these steps, installing third party C libraries is tedious compared to languages that include the concept of packages and package managers. One typically has several options for installing a library:

- Downloading the source repository and building the library. Sometimes the library has some sort of script or `make install` command to handle placing the `*.h` and `*.so` files in the proper directories. Sometimes a library standardizes on a build tool such as `CMake`.
- Downloading the package from a language package manager like `vcpkg` or `conan`
- Downloading the package from an operating system package manager, such as `apt` or `yum`.

## Dynamic Libraries

Shared libraries are dynamic. In Linux, these are `*.so` files. They contain concrete symbols. Applications that use the library link dynamically at runtime. 

For example, using `-lm` with `gcc` without using `-static` results in `libmath` being linked dynamically at runtime

In ELF executables, the dynamic linker/loader (`ld.so`, e.g. `ld-linux-x86-64.so.2`) is listed in the `PT_INTERP` segment. The kernel transfers control to this loader at program startup; the loader resolves and loads required shared libraries before jumping to `main()`. The separate `ldd` utility displays which shared libraries an executable depends on, but does not itself perform the linking.
