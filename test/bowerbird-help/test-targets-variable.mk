__PATH_TARGETS_VARIABLE := $(lastword $(MAKEFILE_LIST))

ifdef TEST_TARGETS_VARIABLE
bowerbird-help.annotation = \#\#\#\#
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55

TARGET_VAR = staging
NESTED_TARGET = $(TARGET_VAR)-server

mock-deploy-$(TARGET_VAR): #### Deploy to $(TARGET_VAR) environment

mock-restart-$(NESTED_TARGET): #### Restart $(NESTED_TARGET) service

mock-literal-dollar: #### Target with $$VAR literal
endif

define expected-targets-variable

Available targets:
  \033[38;5;179mmock-deploy-staging      \033[0m Deploy to $(TARGET_VAR) environment
  \033[38;5;179mmock-literal-dollar      \033[0m Target with $$VAR literal
  \033[38;5;179mmock-restart-staging-server\033[0m Restart $(NESTED_TARGET) service

Optional flags:

endef

test-targets-variable:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_TARGETS_VARIABLE=true \
		bowerbird-help.files=$(__PATH_TARGETS_VARIABLE) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/help/help.cache,expected-targets-variable)
