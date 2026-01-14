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
awk -v makefiles="$(MAKEFILE_LIST)" 'BEGIN { \
	FS = ":.*##"; \
	cmd = "make -f " makefiles " -pnRrq : 2>/dev/null"; \
	while ((cmd | getline line) > 0) { \
		if (line ~ /^[A-Za-z_][A-Za-z0-9_]*[[:space:]]*[:+?]?=[[:space:]]/) { \
			varname = line; \
			sub(/[[:space:]]*[:+?]?=.*$$/, "", varname); \
			gsub(/^[[:space:]]+/, "", varname); \
			value = line; \
			sub(/^[^=]*=[[:space:]]*/, "", value); \
			V[varname] = value; \
		} \
	} \
	close(cmd); \
	V["MAKEFILE_LIST"] = ""; \
} \
function expand(s,  var,pre,post,val,i,matched) { \
	for (i = 0; i < 10; i++) { \
		if (!match(s, /[$$][(][A-Za-z_][A-Za-z0-9_]*[)]/)) \
			break; \
		matched = substr(s, RSTART, RLENGTH); \
		var = matched; \
		gsub(/^[$$][(]/, "", var); \
		gsub(/[)]$$/, "", var); \
		val = (var in V) ? V[var] : ""; \
		pre = substr(s, 1, RSTART-1); \
		post = substr(s, RSTART+RLENGTH); \
		s = pre val post; \
	} \
	return s; \
} \
/^[a-zA-Z0-9_.%\/$$()\\-]+:.*##/ { \
	target = $$1; \
	desc = $$2; \
	gsub(/:$$/, "", target); \
	gsub(/^[[:space:]]+/, "", target); \
	gsub(/[[:space:]]+$$/, "", target); \
	target = expand(target); \
	if (target ~ /^--/ && "$(1)" != "flags") \
		next; \
	if (target !~ /^--/ && "$(1)" != "targets") \
		next; \
	printf "  \033[38;5;179m%-$(__HELP_WIDTH)s\033[0m %s\n", target, desc; \
}' $(MAKEFILE_LIST) | LC_ALL=C sort -u
endef
