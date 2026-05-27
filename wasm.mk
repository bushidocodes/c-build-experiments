WASI_SDK_PATH = ./wasi-sdk-33.0
SYSROOT       = $(WASI_SDK_PATH)/share/wasi-sysroot
CC            = $(WASI_SDK_PATH)/bin/clang --sysroot=$(SYSROOT)
AR            = $(WASI_SDK_PATH)/bin/llvm-ar

# WASI SDK 33 does not bundle llvm-link; combining bitcode requires a compatible
# system install. Set LLVM_VERSION to match the SDK's LLVM (e.g. LLVM_VERSION=22).
LLVM_VERSION ?=
LLVM_SUFFIX  = $(if $(LLVM_VERSION),-$(LLVM_VERSION),)
LLVM_LINK    = llvm-link$(LLVM_SUFFIX)

LIB_BC_OBJS = greet/count.bc greet/greet.bc

include common.mk

.PRECIOUS: %.ll
%.ll: %.i
	$(CC) -S -emit-llvm -o $@ $<

# Convert LLVM IR text to bitcode via clang (llvm-as is not bundled in WASI SDK 33)
.PRECIOUS: %.bc
%.bc: %.ll
	$(CC) -x ir -emit-llvm -c -o $@ $<

# Compile bitcode to a WebAssembly object file
.PRECIOUS: %.o
%.o: %.bc
	$(CC) -c -o $@ $<

# Link WebAssembly object files into a module
link: $(OBJS)
	$(CC) -o hello.wasm $^

libgreet.bc: $(LIB_BC_OBJS)
	$(LLVM_LINK) -o libgreet.bc $^

link_libgreet_bc_direct: hello.bc libgreet.bc
	$(CC) -o hello.wasm $^

# Build WebAssembly using LLVM Bitcode Archive
libgreetbc.a: $(LIB_BC_OBJS)
	$(AR) rcs libgreetbc.a $^

link_libgreetbc_a_direct: hello.bc libgreetbc.a
	$(CC) -o hello.wasm $^

# The LIBRARY_PATH environment variable was ignored, using -L instead
link_libgreetbc_a_indirect: hello.bc libgreetbc.a
	$(CC) -L. -o hello.wasm hello.bc -lgreetbc
