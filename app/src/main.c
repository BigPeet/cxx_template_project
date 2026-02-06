#include "app/config.h"
#include "greet/greet.h"

int main(void) {
    greet(HELLO, &(Person) {.name = PROJECT_NAME});
    return VERSION_MAJOR;
}
