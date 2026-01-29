cmake_minimum_required(VERSION 3.24)
project(cxx_template_project VERSION 0.0.1)

# for correct library locations across platforms
include(GNUInstallDirs)
# prevent in-source builds
include(cmake/PreventInSourceBuilds.cmake)
# Populate git related variables
include(cmake/Git.cmake)
# Various options
include(cmake/Options.cmake)
# Common settings
include(cmake/CommonSettings.cmake)

# Setup project options and flags
setup_options()
print_options()

# Add interface library for various options
add_library(project_options INTERFACE)
set_project_options(project_options)

# Add interface library for compiler warnings
include(cmake/CompilerWarnings.cmake)
add_library(project_warnings INTERFACE)
set_project_warnings(project_warnings WARNINGS_AS_ERRORS "" "" "" "")

# Sanitizers
if(${ENABLE_SANITIZERS})
  include(cmake/Sanitizers.cmake)
  enable_sanitizers(project_options
    ${ENABLE_SANITIZER_ADDRESS}
    ${ENABLE_SANITIZER_LEAK}
    ${ENABLE_SANITIZER_UNDEFINED_BEHAVIOR}
    ${ENABLE_SANITIZER_THREAD}
    ${ENABLE_SANITIZER_MEMORY}
    )
endif()

# Testing
if (${ENABLE_TESTS})
  enable_testing()
  add_subdirectory(tests)
endif()

add_subdirectory(lib)
add_subdirectory(app)
