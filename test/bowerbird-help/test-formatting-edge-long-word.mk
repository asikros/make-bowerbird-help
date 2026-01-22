__PATH_FORMATTING_EDGE_LONG_WORD := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_EDGE_LONG_WORD
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-formatting-edge-long-word: ## supercalifragilisticexpialidocious description
endif

define expected-formatting-edge-long-word

Available targets:
  \033[38;5;179mmock-formatting-edge-long-word\033[0m supercalifragilisticexpialidocious description

Optional flags:

endef

test-formatting-edge-long-word:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_EDGE_LONG_WORD=true \
		bowerbird-help.files=$(__PATH_FORMATTING_EDGE_LONG_WORD) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-edge-long-word)
