# Tests for help system with flags
# These tests verify that flags (targets starting with --) are properly
# separated from regular targets in the help output

test-help-with-flags-creates-cache:
	test -f "$(WORKDIR_BUILD)/help/help.cache"

test-help-with-flags-cache-has-targets-section:
	grep -q "Available targets:" "$(WORKDIR_BUILD)/help/help.cache"

test-help-with-flags-cache-has-flags-section:
	grep -q "Optional flags:" "$(WORKDIR_BUILD)/help/help.cache"
