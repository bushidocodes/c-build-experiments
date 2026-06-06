#include "count.h"
#include "greet.h"
#include <stdio.h>
#include <string.h>

int greet(const char *name)
{
    size_t len = strlen(name);
    for (size_t i = 0; i < len; i++)
        print_count();
    int result = printf("Hello, %s!\n", name);
    return (result < 0) ? result : 0;
}
