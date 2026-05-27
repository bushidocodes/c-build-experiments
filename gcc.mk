CC = gcc
AR = ar
AS = as

include common.mk

# Compile preprocessed C source code into native assembly
# -fPIC is required for objects that will be linked into shared libraries
.PRECIOUS: %.S
%.S: %.i
	$(CC) -S -fPIC -o $@ $<

# Assemble native assembly into native ELF object files
%.o: %.S
	$(AS) -o $@ $<

# Link the native object files of the application and library into and executable
link: $(OBJS)
	$(CC) -o hello $^

############################
### Static Archive Rules ###
############################

# Create static archive libgreet.a from its component *.o object files
libgreet.a: $(LIB_OBJS)
	$(AR) rcs libgreet.a $^

# Link native object files with the static archive libgreet.a, forming an executable
# Note: the archive has to come last
link_libgreet_a_direct: $(APP_OBJS) libgreet.a
	$(CC) -o hello $^

# Link native object files with the static archive libgreet.a, forming an executable
# In this context, indirect means that the -lgreet forces the linker to search for libgreet.a
# The search path includes the current directory because of -L.
link_libgreet_a_indirect: $(APP_OBJS) libgreet.a
	$(CC) -L. -o hello $(APP_OBJS) -lgreet

############################
### Shared Library Rules ###
############################

# Create dynamic shared library libgreet.so from its component *.o object files
libgreet.so: $(LIB_OBJS)
	$(CC) -shared -o libgreet.so $^

# Link native object files with the shared library, forming an executable
# The libgreet symbols are not in the resulting executable and have to be loaded dynamically at runtime 
link_libgreet_so: $(APP_OBJS) libgreet.so
	$(CC) -L. -o hello $(APP_OBJS) -lgreet

# Example of running the resulting binary. We need to set LD_LIBRARY_PATH to the directory of libgreet.so
# or the executable will not be able to dynamically link to libgreet.so at runtime
hello_so: link_libgreet_so
	LD_LIBRARY_PATH=. ./hello
