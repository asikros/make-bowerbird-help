__PATH_FORMATTING_EDGE_LONG_TARGET := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_EDGE_LONG_TARGET
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

mock-formatting-edge-long-target: ## Description text
endif

define expected-formatting-edge-long-target

Available targets:
  \033[38;5;179mmock-formatting-edge-long-target\033[0m Description text

Optional flags:

endef

test-formatting-edge-long-target:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_EDGE_LONG_TARGET=true \
		bowerbird-help.files=$(__PATH_FORMATTING_EDGE_LONG_TARGET) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-formatting-edge-long-target)
