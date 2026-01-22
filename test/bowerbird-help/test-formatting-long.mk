__PATH_FORMATTING_LONG := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_LONG
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-formatting-long: ## This is a very long description that should wrap at the configured width maintaining proper alignment
endif

define expected-formatting-long

Available targets:
  \033[38;5;179mmock-formatting-long     \033[0m This is a very long description that should wrap at the
                           configured width maintaining proper alignment

Optional flags:

endef

test-formatting-long:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_LONG=true \
		bowerbird-help.files=$(__PATH_FORMATTING_LONG) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-long)
