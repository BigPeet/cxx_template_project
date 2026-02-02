include(GoogleTest)

add_executable(greet_tests src/greet_test.cpp)
target_link_libraries(greet_tests PRIVATE GTest::gtest_main greet)
gtest_discover_tests(greet_tests)
