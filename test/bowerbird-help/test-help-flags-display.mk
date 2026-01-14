# Test that flag targets display correctly in help output
# This test verifies that hardcoded flag targets (starting with --)
# appear in the "Optional flags" section with their descriptions
#
# NOTE: This test uses a separate fixture makefile (fixture-flags-test.mk)
# to avoid polluting the main help output with test flags.
#
# NOTE: This test uses hardcoded flag names. For variable-based flag names,
# see test-help-variable-expansion.mk

# Helper variable for the test fixture
# Use CURDIR to ensure we get the right path even when invoked through test framework
TEST_FIXTURE = $(CURDIR)/test/bowerbird-help/fixture-flags-test.mk
TEST_WORKDIR = $(CURDIR)/.make/test/fixture-flags

# Tests to verify flags appear in help output with correct descriptions
test-help-flags-display-verbose:
	$(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | grep -q -- '--verbose.*Enable verbose output'

test-help-flags-display-debug:
	$(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | grep -q -- '--debug.*Enable debug mode'

test-help-flags-display-dry-run:
	$(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | grep -q -- '--dry-run.*Show what would be done without executing'

test-help-flags-in-flags-section:
	$(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | awk '/Optional flags:/,/^$$/' | grep -q -- '--verbose'

test-help-flags-not-in-targets-section:
	! $(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | awk '/Available targets:/,/Optional flags:/' | grep -q -- '--verbose'

test-help-flags-sorted:
	$(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | sed -n '/Optional flags:/,/^$$/p' | grep -o '^[[:space:]]*[^ ]*--[a-z-]*' | head -1 | grep -q -- '--debug'

test-help-flags-count:
	test "$$($(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | sed -n '/Optional flags:/,/^$$/p' | grep -- '--' | wc -l | tr -d ' ')" = "3"

test-help-flags-build-in-targets:
	$(MAKE) -f $(TEST_FIXTURE) WORKDIR_ROOT=$(TEST_WORKDIR) help | sed -n '/Available targets:/,/Optional flags:/p' | grep -q 'build'
