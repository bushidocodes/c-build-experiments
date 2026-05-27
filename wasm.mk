WASI_SDK_PATH = ./wasi-sdk-24.0
SYSROOT       = $(WASI_SDK_PATH)/share/wasi-sysroot
CC            = $(WASI_SDK_PATH)/bin/clang --sysroot=$(SYSROOT)
AR            = $(WASI_SDK_PATH)/bin/llvm-ar
LLVM_AS       = $(WASI_SDK_PATH)/bin/llvm-as
LLC           = $(WASI_SDK_PATH)/bin/llc
LLVM_LINK     = $(WASI_SDK_PATH)/bin/llvm-link
LIB_BC_OBJS   = greet/count.bc greet/greet.bc

include common.mk

.PRECIOUS: %.ll
%.ll: %.i
	$(CC) -S -emit-llvm -o $@ $<

# Generate llvm bitcode from the text representation
.PRECIOUS: %.bc
%.bc: %.ll
	$(LLVM_AS) -o $@ $<

# Assemble into WebAssembly object file
.PRECIOUS: %.o
%.o: %.bc
	$(LLC) -march=wasm32 -filetype=obj -o $@ $<

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
