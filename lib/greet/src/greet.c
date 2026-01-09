#include "greet/greet.h"

#include <stdio.h>

void greet(Greeting greeting, Person const* person) {
    if (!person) {
        return;
    }
    switch (greeting) {
        case HELLO:   printf("Hello, %s!\n", person->name); break;
        case GOODBYE: printf("Goodbye, %s!\n", person->name); break;
    }
}
