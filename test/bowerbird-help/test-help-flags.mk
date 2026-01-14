test-help-flags-header:
	test "$(shell $(MAKE) help | grep 'Optional flags:')" = "Optional flags:"

test-help-flags-section-exists:
	$(MAKE) help | grep -q 'Optional flags:'
