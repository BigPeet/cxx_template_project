# This Makefile is only for convenience.
# The actual build is enabled solely by CMake.

ifeq (, $(shell command -v ninja))
	GENERATOR ?= Unix Makefiles## CMake generator to use (Ninja, Unix Makefiles, etc.)
else
	GENERATOR ?= Ninja
endif

# if clang is available, use it as the default compiler
ifneq (, $(shell command -v clang))
	COMPILER ?= clang## Compiler to use (clang, gcc, etc.), overrides CC and CXX if set
else ifneq (, $(shell command -v gcc))
	COMPILER ?= gcc
else
	COMPILER ?=
endif

# If CC is not specified, it will be populated by make to "cc" (and CXX to "g++").
# Override that only if the a specific compiler is requested.
# To override the automatic selection, set CC and CXX directly when invoking make and leave COMPILER empty.
ifeq (clang, $(COMPILER))
	# compiler specified, overwrite CC and CXX
	CC := clang## C compiler to use (overridden by COMPILER if set)
	CXX := clang++## C++ compiler to use (overridden by COMPILER if set)
else ifeq (gcc, $(COMPILER))
	# compiler specified, overwrite CC and CXX
	CC := gcc
	CXX := g++
else ifneq (, $(COMPILER))
	# compiler specified, overwrite CC and CXX
	CC := $(COMPILER)
	CXX := $(COMPILER)
endif


# Default build type
BUILD_TYPE ?= Release## Build type (Debug, Release, etc.)

# Default build and source directories
BUILD_DIR ?= build## Build directory
APP_DIR ?= app## Application source directory
LIB_DIR ?= lib## Library source directory
TEST_DIR ?= tests## Test source directory
BINDINGS_DIR ?= ## Language bindings source directory

# Default clang-format/-tidy binaries/wrappers
CLANG_FORMAT ?= clang-format-18## clang-format binary or wrapper
CLANG_TIDY ?= run-clang-tidy-18## clang-tidy binary or wrapper

# Arguments for running executable
ARGS ?= ## Arguments to pass when running the application

# Misc. settings
DEV_MODE ?= ## Development mode (ON/OFF)

# Find all CMake files (except those in build dir)
CMAKE_FILES = $(shell find . \
  -path ./$(BUILD_DIR) -prune -o \
  \( -name CMakeLists.txt -o -name "*.cmake" \) -print)

# Find all source files
SRC_FILES = $(shell find $(APP_DIR) $(LIB_DIR) $(BINDINGS_DIR) -name "*.c" -o -name "*.cpp" -o -name "*.cc")
HEADER_FILES = $(shell find $(APP_DIR) $(LIB_DIR) $(BINDINGS_DIR) -name "*.h" -o -name "*.hpp")
TEST_SRC_FILES = $(shell find $(TEST_DIR) -name "*.c" -o -name "*.cpp" -o -name "*.cc")
TEST_HEADER_FILES = $(shell find $(TEST_DIR) -name "*.h" -o -name "*.hpp")

# Stamp file to indicate when configuration was done
CONFIGURED := $(BUILD_DIR)/CMakeFiles/cmake.check_cache

# Setup binary targets
APP_TARGETS := cxx_template_project
LIB_TARGETS := libgreet.a
BINDINGS_TARGETS :=

# Determine the main executable name
EXE := $(word 1, $(APP_TARGETS))

.PHONY: build
build: $(CONFIGURED) ## Configure and build the project (default target)
	@cmake --build $(BUILD_DIR) --parallel

$(CONFIGURED): $(CMAKE_FILES)
	@echo "Configuring project in $(BUILD_DIR) with '$(GENERATOR)' using CC=$(CC), CXX=$(CXX) and BUILD_TYPE=$(BUILD_TYPE)"
	@cmake -S . -B $(BUILD_DIR) -G "$(GENERATOR)" \
		-DCMAKE_C_COMPILER=$(CC) \
		-DCMAKE_CXX_COMPILER=$(CXX) \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-DDEV_MODE=$(DEV_MODE)

.PHONY: install
install: all ## Install the built targets
	@cmake --install $(BUILD_DIR)

# Various (sub)sets of build targets
.PHONY: all
all: build bindings ## Build all targets (app, lib, bindings, etc.)

.PHONY: app
app: $(CONFIGURED) ## Build the application
	@cmake --build $(BUILD_DIR) --target $(APP_TARGETS) --parallel

.PHONY: lib
lib: $(CONFIGURED) ## Build the library
	@cmake --build $(BUILD_DIR) --target $(LIB_TARGETS) --parallel

.PHONY: bindings
bindings: $(CONFIGURED) ## Build the language bindings (if any)
	@if [ -n "$(BINDINGS_TARGETS)" ]; then \
		cmake --build $(BUILD_DIR) --target $(BINDINGS_TARGETS) --parallel; \
	fi

.PHONY: run
run: app ## Run the built application with ARGS
	./$(BUILD_DIR)/$(APP_DIR)/$(EXE) $(ARGS)

# Configuration specific targets
.PHONY: configure
configure: ## Configure the project with CMake
	@BUILD_TYPE=$(BUILD_TYPE) \
		DEV_MODE=$(DEV_MODE) \
		$(MAKE) --no-print-directory -B $(CONFIGURED)

.PHONY: enable-debug
enable-debug:
	$(eval BUILD_TYPE := Debug)

.PHONY: debug
debug: enable-debug configure app lib ## Configure and build in Debug mode

.PHONY: enable-release
enable-release:
	$(eval BUILD_TYPE := Release)

.PHONY: release
release: enable-release configure all ## Configure and build in Release mode

.PHONY: enable-dev-mode
enable-dev-mode:
	$(eval DEV_MODE := ON)
	$(eval BUILD_TYPE := )

.PHONY: dev
dev: enable-dev-mode configure all ## Configure and build in Dev mode

# Clean up
.PHONY: clean
clean: ## Clean the build directory and binaries
	@if [ -d $(BUILD_DIR) ]; then rm -rf $(BUILD_DIR); fi
	@if [ -d bin/ ]; then rm -rf bin; fi
	@if [ -f a.out ]; then rm a.out; fi

.PHONY: clean-build
clean-build: ## Clean the build artifacts
	@cmake --build $(BUILD_DIR) --target clean

# Formatting and linting
.PHONY: check-format
check-format: ## Check code formatting
	@$(CLANG_FORMAT) --dry-run -Werror $(SRC_FILES) $(HEADER_FILES) $(TEST_SRC_FILES) $(TEST_HEADER_FILES)
	@echo "SUCCESS: No formatting errors found."

.PHONY: format
format: ## Format code
	@$(CLANG_FORMAT) -i $(SRC_FILES) $(HEADER_FILES) $(TEST_SRC_FILES) $(TEST_HEADER_FILES)

.PHONY: lint
lint: ${CONFIGURED} ## Run code linting
	@$(CLANG_TIDY) -quiet -p $(BUILD_DIR) -use-color 1 $(SRC_FILES)

.PHONY: fixes
fixes: ${CONFIGURED} ## Apply suggested code fixes
	@$(CLANG_TIDY) -quiet -p $(BUILD_DIR) -use-color 1 -fix $(SRC_FILES)

.PHONY: test
test: $(CONFIGURED) ## Run tests
	@echo "Test target not implemented yet."

.PHONY: help
help: ## Show this help message
	@echo "Convenience Makefile for C/C++ Project wrapping CMake"
	@echo ""
	@echo "Convenience targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables that can be set when invoking make:"
	@grep -E '^[[:space:]]*[a-zA-Z_-]+ \?= .*?## .*$$' $(MAKEFILE_LIST) \
		| awk '{gsub(/^[[:space:]]*/, ""); print}' \
		| awk 'BEGIN {FS = " \\?= .*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
