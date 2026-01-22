# Constants
.DEFAULT_GOAL := help

#Targets
.PHONY: check
check: ## Runs the repository tests
check: private_check

.PHONY: clean
clean: ## Deletes all files created by Make
clean: private_clean

# Includes
include make/private.mk
