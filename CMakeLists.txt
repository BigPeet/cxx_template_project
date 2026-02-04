cmake_minimum_required(VERSION 3.24)
project(
  cxx_template_project
  VERSION 0.0.1
  DESCRIPTION ""
  LANGUAGES CXX C
  )

# for correct library locations across platforms
include(GNUInstallDirs)
# prevent in-source builds
include(cmake/PreventInSourceBuilds.cmake)
# Populate git related variables
include(cmake/Git.cmake)
# Static global settings that should not be changed by the user and apply to all targets
include(cmake/StaticGlobalSettings.cmake)
# Various options that can be configured by the user
include(cmake/Options.cmake)
# Dependencies
include(cmake/Dependencies.cmake)

# Setup project options and flags
setup_options()
print_options()

# Set global options that apply to all targets
set_global_options()

# Add interface library for project options
add_library(project_options INTERFACE) # should this be namespaced? What about regular libraries?
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

# Dependencies
fetch_dependencies()

# Testing
if (${ENABLE_TESTS})
  enable_testing()
  add_subdirectory(tests)
endif()

add_subdirectory(lib)
add_subdirectory(app)
