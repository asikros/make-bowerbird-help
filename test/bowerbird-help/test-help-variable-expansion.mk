# Test fixture with variable-based target name
TEST_FIXTURE_VAR = $(CURDIR)/test/bowerbird-help/fixture-variable-expansion.mk
TEST_WORKDIR_VAR = $(CURDIR)/.make/test/fixture-variable-expansion

test-help-variable-expansion-flag:
	$(MAKE) -f $(TEST_FIXTURE_VAR) WORKDIR_ROOT=$(TEST_WORKDIR_VAR) help | grep -q -- '--my-custom-flag.*Custom flag from variable'

test-help-variable-expansion-not-literal:
	! $(MAKE) -f $(TEST_FIXTURE_VAR) WORKDIR_ROOT=$(TEST_WORKDIR_VAR) help | grep -q '$$('

test-help-variable-expansion-target:
	$(MAKE) -f $(TEST_FIXTURE_VAR) WORKDIR_ROOT=$(TEST_WORKDIR_VAR) help | grep -q 'custom-build.*Build with custom variable'

test-help-variable-expansion-nested:
	$(MAKE) -f $(TEST_FIXTURE_VAR) WORKDIR_ROOT=$(TEST_WORKDIR_VAR) help | grep -q -- '--nested-flag.*Flag from nested variable'
