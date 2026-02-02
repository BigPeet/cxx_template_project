#include <gtest/gtest.h>

#include "greet/greet.h"

TEST(GreetTest, Hello) {
    // expect to see "Hello, Alice!" printed to stdout
    Person const alice{const_cast<char*>("Alice")};
    testing::internal::CaptureStdout();
    greet(HELLO, &alice);
    EXPECT_EQ(testing::internal::GetCapturedStdout(), "Hello, Alice!\n");
}

TEST(GreetTest, Goodbye) {
    // expect to see "Goodbye, Bob!" printed to stdout
    Person const bob{const_cast<char*>("Bob")};
    testing::internal::CaptureStdout();
    greet(GOODBYE, &bob);
    EXPECT_EQ(testing::internal::GetCapturedStdout(), "Goodbye, Bob!\n");
}

TEST(GreetTest, NullPerson) {
    // expect no output when person is null
    testing::internal::CaptureStdout();
    greet(HELLO, nullptr);
    EXPECT_EQ(testing::internal::GetCapturedStdout(), "");
}
