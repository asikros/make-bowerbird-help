# Config
.SUFFIXES:
MAKEFLAGS += --jobs
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --shuffle
MAKEFLAGS += --warn-undefined-variables

# Constants
NAME := bowerbird-help
VERSION := $(shell git describe --always --dirty --broken 2> /dev/null)
WORKDIR_ROOT := $(CURDIR)/.make
WORKDIR_BUILD = $(WORKDIR_ROOT)/build
WORKDIR_DEPS = $(WORKDIR_ROOT)/deps
WORKDIR_TEST = $(WORKDIR_ROOT)/test/$(NAME)/$(VERSION)

# Includes
include bowerbird.mk
include make/deps.mk

 # Targets
.PHONY: private_clean
private_clean:
	@echo "INFO: Cleaning directories:"
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo "INFO: Cleaning complete."
	@echo

ifdef bowerbird::test::suite
$(call bowerbird::test::suite,private_test,test/bowerbird-help,test*.mk,test*)
endif
