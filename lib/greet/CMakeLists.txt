# GREET library

set (GREET_SOURCE_FILES
  src/greet.c
  )

add_library(greet STATIC ${GREET_SOURCE_FILES})

target_link_libraries(greet
  PRIVATE
  project_warnings
  project_options
  )
target_include_directories(greet PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
# Clarify if this is required
# target_compile_features(lib_greet PUBLIC c_std_99)

if (MSVC)
  # Add define to disable MSVC security warnings.
  # MSVC will warn about using "unsafe" functions like strcpy.
  # But the suggested alternative (strcpy_s) is not available in C99.
  target_compile_definitions(greet PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()
