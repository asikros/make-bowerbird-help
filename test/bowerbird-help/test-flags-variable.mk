__PATH_FLAGS_VARIABLE := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FLAGS_VARIABLE
bowerbird-help.annotation = \#\#\#\#
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

FLAG_VAR = production
NESTED_FLAG = $(FLAG_VAR)-mode

--mock-flag-$(FLAG_VAR): #### Flag with $(FLAG_VAR) variable

--mock-nested-$(NESTED_FLAG): #### Flag with $(NESTED_FLAG) nested variable
endif

define expected-flags-variable

Available targets:

Optional flags:
  \033[38;5;179m--mock-flag-production   \033[0m Flag with $(FLAG_VAR) variable
  \033[38;5;179m--mock-nested-production-mode\033[0m Flag with $(NESTED_FLAG) nested variable

endef

test-flags-variable:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FLAGS_VARIABLE=true \
		bowerbird-help.files=$(__PATH_FLAGS_VARIABLE) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-flags-variable)
