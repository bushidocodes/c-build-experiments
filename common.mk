APP_OBJS = hello.o
LIB_OBJS = greet/count.o greet/greet.o
OBJS = $(APP_OBJS) $(LIB_OBJS)

all: link

clean:
	rm -rf *.i *.S *.ll *.o *.bc *.a *.so *.wasm **/*.i **/*.S **/*.o **/*.ll **/*.bc **/*.bca hello

# Expands to C source code after the preprocessor runs to completion 
.PRECIOUS: %.i 
%.i: %.c
	$(CC) $(CFLAGS) -E -o $@ $<
