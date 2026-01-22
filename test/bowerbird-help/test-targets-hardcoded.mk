__PATH_TARGETS_HARDCODED := $(lastword $(MAKEFILE_LIST))

ifdef TEST_TARGETS_HARDCODED
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-build: ## Build the project

mock-test: ## Run tests

mock-clean: ## Clean build artifacts

mock-deploy: ## Deploy to production
endif

define expected-targets-hardcoded

Available targets:
  \033[38;5;179mmock-build               \033[0m Build the project
  \033[38;5;179mmock-clean               \033[0m Clean build artifacts
  \033[38;5;179mmock-deploy              \033[0m Deploy to production
  \033[38;5;179mmock-test                \033[0m Run tests

Optional flags:

endef

test-targets-hardcoded:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_TARGETS_HARDCODED=true \
		bowerbird-help.files=$(__PATH_TARGETS_HARDCODED) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-targets-hardcoded)
