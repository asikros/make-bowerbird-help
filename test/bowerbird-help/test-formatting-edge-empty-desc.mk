__PATH_FORMATTING_EDGE_EMPTY_DESC := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_EDGE_EMPTY_DESC
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-formatting-edge-empty-desc: ##
endif

define expected-formatting-edge-empty-desc

Available targets:
  \033[38;5;179mmock-formatting-edge-empty-desc\033[0m

Optional flags:

endef

test-formatting-edge-empty-desc:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_EDGE_EMPTY_DESC=true \
		bowerbird-help.files=$(__PATH_FORMATTING_EDGE_EMPTY_DESC) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-edge-empty-desc)
