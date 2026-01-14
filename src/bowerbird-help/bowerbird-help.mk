# Error checks
WORKDIR_BUILD ?= $(error ERROR: Undefined variable WORKDIR_BUILD)

# Paths
__HELP_CACHE = $(WORKDIR_BUILD)/help/help.cache
__HELP_WIDTH = 28

# Targets
.PRECIOUS: %/.
%/.:
	@mkdir -p "$@"

.PHONY: help
help: ## Show this help message
help: $(__HELP_CACHE)
	@{ set +x; } 2>/dev/null; cat $^

$(__HELP_CACHE): $(MAKEFILE_LIST) | $(dir $(__HELP_CACHE))/.
	@{ set +x; } 2>/dev/null; { \
		printf "\nAvailable targets:\n"; \
		$(call __HELP_AWK,targets); \
		printf "\nOptional flags:\n"; \
		$(call __HELP_AWK,flags); \
		printf "\n"; \
	} > $@

define __HELP_AWK
awk 'BEGIN { \
	FS = ":.*##"; \
} \
/^[a-zA-Z0-9_.%\/$$()\\-]+:.*##/ { \
	target = $$1; \
	desc = $$2; \
	gsub(/:$$/, "", target); \
	gsub(/^[[:space:]]+/, "", target); \
	gsub(/[[:space:]]+$$/, "", target); \
	if (target ~ /^--/ && "$(1)" != "flags") \
		next; \
	if (target !~ /^--/ && "$(1)" != "targets") \
		next; \
	printf "  \033[38;5;179m%-$(__HELP_WIDTH)s\033[0m %s\n", target, desc; \
}' $(MAKEFILE_LIST) | LC_ALL=C sort -u
endef
