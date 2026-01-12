test-help-targets-header:
	$(MAKE) help | grep -q 'Available targets:'

test-help-targets-check:
	$(MAKE) help | grep -q 'check.*Runs the repository tests'

test-help-targets-clean:
	$(MAKE) help | grep -q 'clean.*Deletes all files created by Make'

test-help-targets-help:
	$(MAKE) help | grep -q 'help.*Show this help message'

test-help-targets-test:
	$(MAKE) help | grep -q 'test.*Runs the repository tests'

test-help-targets-not-in-flags:
	! $(MAKE) help | awk '/Optional flags:/,EOF' | grep -q 'check'
