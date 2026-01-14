# Fixture for testing variable expansion in help output

# Constants
.DEFAULT_GOAL := help
WORKDIR_ROOT ?= $(CURDIR)/.make
WORKDIR_BUILD ?= $(WORKDIR_ROOT)/build

# Test variables
MY_CUSTOM_FLAG := --my-custom-flag
CUSTOM_BUILD_TARGET := custom-build
NESTED_VAR := nested-flag
NESTED_FLAG := --$(NESTED_VAR)

# Include help system
_FIXTURE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(_FIXTURE_DIR)../../src/bowerbird-help/bowerbird-help.mk

# Target using variable
$(CUSTOM_BUILD_TARGET): ## Build with custom variable
$(CUSTOM_BUILD_TARGET):
	@echo "Building..."

# Flag using variable
$(MY_CUSTOM_FLAG): ## Custom flag from variable
$(MY_CUSTOM_FLAG):
	@:

# Flag using nested variable
$(NESTED_FLAG): ## Flag from nested variable
$(NESTED_FLAG):
	@:
