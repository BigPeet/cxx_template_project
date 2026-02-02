#ifndef GREET_GREET_H_
#define GREET_GREET_H_

#ifdef __cplusplus
extern "C" {
#endif

typedef enum Greeting {
    HELLO,
    GOODBYE,
} Greeting;

typedef struct Person {
    char* name;
} Person;

void greet(Greeting greeting, Person const* person);

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* ifndef GREET_GREET_H_ */
