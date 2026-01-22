__PATH_FORMATTING_SORTING_FLAGS := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_SORTING_FLAGS
bowerbird-help.annotation = \#\#\#\#
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

--zzz-flag: #### Final flag in alphabet

--aaa-flag: #### This is a very long description for the first flag alphabetically that will require multiple line wraps to display properly when shown in the help

--mmm-flag: #### Middle flag description
endif

define expected-formatting-sorting-flags

Available targets:

Optional flags:
  \033[38;5;179m--aaa-flag               \033[0m This is a very long description for the first flag
                            alphabetically that will require multiple line wraps to
                            display properly when shown in the help
  \033[38;5;179m--mmm-flag               \033[0m Middle flag description
  \033[38;5;179m--zzz-flag               \033[0m Final flag in alphabet

endef

test-formatting-sorting-flags:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_SORTING_FLAGS=true \
		bowerbird-help.files=$(__PATH_FORMATTING_SORTING_FLAGS) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-sorting-flags)
