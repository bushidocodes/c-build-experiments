#include "count.h"
#include "greet.h"
#include <stdio.h>
#include <string.h>

int greet(const char *name)
{
    for (int i = 0; i < strlen(name); i++)
        print_count();
    return printf("Hello, %s!\n", name);
}
