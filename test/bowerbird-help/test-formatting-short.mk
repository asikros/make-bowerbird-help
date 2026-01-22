__PATH_FORMATTING_SHORT := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_SHORT
bowerbird-help.annotation = \#\#\#\#
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-formatting-short: #### Short description
endif

define expected-formatting-short

Available targets:
  \033[38;5;179mmock-formatting-short    \033[0m Short description

Optional flags:

endef

test-formatting-short:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_SHORT=true \
		bowerbird-help.files=$(__PATH_FORMATTING_SHORT) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-short)
