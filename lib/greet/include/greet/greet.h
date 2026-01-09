#ifndef GREET_GREET_H_
#define GREET_GREET_H_

typedef enum Greeting {
    HELLO,
    GOODBYE,
} Greeting;

typedef struct Person {
    char* name;
} Person;

void greet(Greeting greeting, Person const* person);

#endif /* ifndef GREET_GREET_H_ */
