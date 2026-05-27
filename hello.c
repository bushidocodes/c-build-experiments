#include <stdio.h>
#include "greet/greet.h"

int main(int argc, char *argv[])
{
	if (argc < 2)
	{
		printf("Use: %s name\n", argv[0]);
		return 0;
	}

	return greet(argv[1]);
}
