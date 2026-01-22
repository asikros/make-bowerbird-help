__PATH_FORMATTING_SORTING_TARGETS := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_SORTING_TARGETS
bowerbird-help.annotation = \#\#\#\#
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-zebra: #### Short description for zebra target

mock-alpha: #### This is a very long description for the alpha target that will require multiple line wraps to display properly when shown in the help output

mock-middle: #### Short description for middle target
endif

define expected-formatting-sorting-targets

Available targets:
  \033[38;5;179mmock-alpha               \033[0m This is a very long description for the alpha target
                            that will require multiple line wraps to display
                            properly when shown in the help output
  \033[38;5;179mmock-middle              \033[0m Short description for middle target
  \033[38;5;179mmock-zebra               \033[0m Short description for zebra target

Optional flags:

endef

test-formatting-sorting-targets:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_SORTING_TARGETS=true \
		bowerbird-help.files=$(__PATH_FORMATTING_SORTING_TARGETS) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-sorting-targets)
