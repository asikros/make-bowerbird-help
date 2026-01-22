# Error checks
WORKDIR_BUILD ?= $(error ERROR: Undefined variable WORKDIR_BUILD)

# Configuration
bowerbird-help.width-target ?= 28
bowerbird-help.width-description ?= 60
bowerbird-help.files ?= $(MAKEFILE_LIST)

# Paths
__HELP_CACHE = $(WORKDIR_BUILD)/help/help.cache

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
awk -v target_width="$(bowerbird-help.width-target)" \
    -v desc_width="$(bowerbird-help.width-description)" \
    -v makefiles="$(bowerbird-help.files)" 'BEGIN { \
	FS = ":.*##"; \
	n = split(makefiles, files, " "); \
	cmd = "make"; \
	for (i = 1; i <= n; i++) { \
		cmd = cmd " -f " files[i]; \
	} \
	cmd = cmd " -pnRrq : 2>/dev/null"; \
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
function wrap_text(text, width, indent,    words, n, line, i, word, result, first) { \
	gsub(/^[[:space:]]+/, "", text); \
	gsub(/[[:space:]]+$$/, "", text); \
	n = split(text, words, /[[:space:]]+/); \
	line = ""; \
	result = ""; \
	first = 1; \
	for (i = 1; i <= n; i++) { \
		word = words[i]; \
		if (line == "") { \
			line = word; \
		} else if (length(line " " word) <= width) { \
			line = line " " word; \
		} else { \
			if (first) { \
				result = line; \
				first = 0; \
			} else { \
				result = result "\n" indent line; \
			} \
			line = word; \
		} \
	} \
	if (first) { \
		result = line; \
	} else { \
		result = result "\n" indent line; \
	} \
	return result; \
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
	indent = ""; \
	for (i = 0; i < target_width + 2; i++) \
		indent = indent " "; \
	wrapped = wrap_text(desc, desc_width, indent); \
	printf "  \033[38;5;179m%-" target_width "s\033[0m %s\n", target, wrapped; \
}' $(bowerbird-help.files) | LC_ALL=C sort -u
endef
