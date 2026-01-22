__PATH_FORMATTING_MULTIPLE_LINES := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_MULTIPLE_LINES
bowerbird-help.annotation = \#\#\#\#
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-formatting-multiple-lines: #### This is an extremely long description that will require multiple line wraps to display properly because it exceeds the configured maximum description width by a significant amount
endif

define expected-formatting-multiple-lines

Available targets:
  \033[38;5;179mmock-formatting-multiple-lines\033[0m This is an extremely long description that will require
                            multiple line wraps to display properly because it
                            exceeds the configured maximum description width by a
                            significant amount

Optional flags:

endef

test-formatting-multiple-lines:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_MULTIPLE_LINES=true \
		bowerbird-help.files=$(__PATH_FORMATTING_MULTIPLE_LINES) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-multiple-lines)
