function(
    fetch_dependencies)
  include(FetchContent)

  # See:
  # - https://cmake.org/cmake/help/latest/guide/using-dependencies/index.html
  # - https://cmake.org/cmake/help/latest/module/FetchContent.html
  # - https://cmake.org/cmake/help/latest/module/ExternalProject.html

  # Notably, FetchContent_Declare will try "find_package" if FIND_PACKAGE_ARGS is provided by default.
  # This can be customized with FETCHCONTENT_TRY_FIND_PACKAGE_MODE.

  # GoogleTest
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        v1.17.0
    FIND_PACKAGE_ARGS NAMES GTest
  )
  # For Windows: Prevent overriding the parent project's compiler/linker settings
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

  # Make unconditional dependencies available
  # - NONE -

  # Conditional dependencies
  if(${ENABLE_TESTS})
    FetchContent_MakeAvailable(googletest)
  endif()
endfunction()
