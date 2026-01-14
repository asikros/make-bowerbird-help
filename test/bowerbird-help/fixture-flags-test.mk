# Test fixture for flag display testing
# This file is NOT included in the main test suite - it's invoked separately
# to test flag functionality without polluting the main help output

# Required for help system
# WORKDIR_ROOT is overridden by tests to isolate the build directory
WORKDIR_ROOT ?= $(CURDIR)/.make
WORKDIR_BUILD ?= $(WORKDIR_ROOT)/build

# Directory calculation
_FIXTURE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Include the help system
include $(_FIXTURE_DIR)../../src/bowerbird-help/bowerbird-help.mk

# Define test flags
.PHONY: --verbose
--verbose: ## Enable verbose output

.PHONY: --debug
--debug: ## Enable debug mode

.PHONY: --dry-run
--dry-run: ## Show what would be done without executing

# Define a test target
.PHONY: build
build: ## Build the project
