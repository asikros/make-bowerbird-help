__PATH_FLAGS_HARDCODED := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FLAGS_HARDCODED
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

--mock-verbose: ## Enable verbose output

--mock-debug: ## Enable debug mode

--mock-dry-run: ## Show what would be done without executing

mock-build: ## Build the project
endif

define expected-flags-hardcoded

Available targets:
  \033[38;5;179mmock-build               \033[0m Build the project

Optional flags:
  \033[38;5;179m--mock-debug             \033[0m Enable debug mode
  \033[38;5;179m--mock-dry-run           \033[0m Show what would be done without executing
  \033[38;5;179m--mock-verbose           \033[0m Enable verbose output

endef

test-flags-hardcoded:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FLAGS_HARDCODED=true \
		bowerbird-help.files=$(__PATH_FLAGS_HARDCODED) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-flags-hardcoded)
