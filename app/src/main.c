#include "app/config.h"
#include "greet/greet.h"

int main(void)
{
    greet(PROJECT_NAME);
    return VERSION_MAJOR;
}
