# C Compiler Playground

This repo includes a number of Makefiles to demonstrate various build techniques targeting native ELF binaries/libraries and WebAssembly modules.

If you are unfamiliar with the traditional C build pipeline or how preprocessors, compilers, and assemblers differ, please see [the concepts page](./build_concepts.md).

The assets in `greet` represent a library with two translation units. This library is used by the application represented by `hello.c`. Different build scenarios demonstrate different techniques for linking into ELF and WebAssembly executables.

All rules should be run with `-r` to ignore the Make's built-in rules and force use of the additional intermediate rules defined here

`make -r`

Also be sure to run `make clean` between jobs to purge all intermediate output.

The default `Makefile` uses `gcc.mk`.

`gcc.mk` uses gcc and is configured to use separate preprocess, compile, assemble, and link steps, keeping all intermediate assets to allow for inspection using various tools. It also includes rules to demonstrate the creation and use of static libraries (`*.a` archives) and dynamic libraries (`*.so`). This is a good baseline for understanding the traditional UNIX compiler toolchain.

`clang.mk` adds LLVM-specific build steps that generate LLVM's intermediate representation in text *.ll and binary *.bc forms. It also provides rules to show how to build static LLVM bitcode libraries using two alternate techniques. The first combines all translation units into a single `*.bc` file. The second creates an LLVM bitcode archive that can be linked directly or indirectly just as with archives containing native ELF object files. On Debian/Ubuntu, LLVM tools are versioned — pass `LLVM_VERSION=18` (or your installed version) to `make` if the unversioned names are not on your PATH.

`wasm.mk` uses LLVM to generate WebAssembly modules using WASI. Run `install_wasi_sdk.sh` first to download WASI SDK 33 into the repo directory. All LLVM tools (llvm-as, llc, llvm-link, llvm-ar) are sourced from the SDK bundle to avoid version mismatches with the host system. The rules demonstrate use of LLVM bitcode libraries (`*.bc` files) and LLVM Bitcode Archives.

The resulting WebAssembly module can be run with [wasmtime](https://github.com/bytecodealliance/wasmtime):

```
make clean && make -r -f wasm.mk link && wasmtime run hello.wasm Sean
```

## Tools to inspect various intermediate files
- `ldd` can look at shared libraries needed at runtime
- `nm` lists the symbols in an object file
- `readelf` dumps detailed information about native ELF object files, libraries, and executables

## TODO
- Consider compiling the greet library as a WebAssembly module to show dynamic linking
- Add a list of suggested tools for inspection the various intermediate output files produced by these makefiles
- Tools to inspect LLVM bitcode?
- Add instructions/script or Dockerfile to help install expected tools.

## Resources Consulted
- https://00f.net/2019/04/07/compiling-to-webassembly-with-llvm-and-clang/
- https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html
- https://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html
- https://linuxhint.com/understanding_elf_file_format/
- https://linux-audit.com/elf-binaries-on-linux-understanding-and-analysis/
- https://en.wikipedia.org/wiki/Executable_and_Linkable_Format
