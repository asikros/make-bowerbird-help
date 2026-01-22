__PATH_FORMATTING_CUSTOM_WIDTHS := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_CUSTOM_WIDTHS
bowerbird-help.annotation = \#\#\#\#
bowerbird-help.width-target = 35
bowerbird-help.width-description = 50

mock-formatting-custom-widths: #### Custom width configuration test
endif

define expected-formatting-custom-widths

Available targets:
  \033[38;5;179mmock-formatting-custom-widths      \033[0m Custom width configuration test

Optional flags:

endef

test-formatting-custom-widths:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_CUSTOM_WIDTHS=true \
		bowerbird-help.files=$(__PATH_FORMATTING_CUSTOM_WIDTHS) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-custom-widths)
