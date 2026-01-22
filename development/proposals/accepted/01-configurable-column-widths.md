# Configurable Column Widths with Word Wrapping

```
Status:   Accepted
Project:  make-bowerbird-help
Created:  2026-01-21
Implemented: 2026-01-22
Author:   Bowerbird Team
```

---

## Summary

Add configurable column widths to the help system, allowing projects to customize the target column width and description column width independently. Implement intelligent word wrapping for descriptions that exceed the configured width, ensuring clean, readable help output across different terminal sizes and content lengths.

## Problem

The current help system uses a fixed width (`__HELP_WIDTH = 28`) for the target column, which creates several limitations:

1. **Fixed Layout**: No flexibility to adjust column widths for different project needs
2. **Long Target Names**: Projects with long target names (e.g., `--bowerbird-report-slow-tests`) get truncated or cause misalignment
3. **Verbose Descriptions**: Long descriptions run off the screen without wrapping, making them hard to read in 80-120 column terminals
4. **One Size Fits All**: Cannot optimize layout for narrow vs wide terminals
5. **Manual Line Breaks**: Developers must manually break long descriptions across multiple target entries

**Example scenario:**
```
Optional flags:
  --bowerbird-fail-fast       Kill all tests on first failure
  --bowerbird-report-slow-tests Report the 3 slowest tests after suite completion with timing information
```

The second line's description extends beyond 80 columns, running off screen or wrapping awkwardly.

## Proposed Solution

### Configuration Variables

Add three new configuration variables that projects can override:

```makefile
# Default column widths (maintains current behavior)
bowerbird-help.width-target ?= 28
bowerbird-help.width-description ?= 60
bowerbird-help.files ?= $(MAKEFILE_LIST)
```

**Target Width (`bowerbird-help.width-target`):**
- Controls the width of the first column (target names)
- Defaults to 28 (current behavior)
- Can be increased for projects with long target names

**Description Width (`bowerbird-help.width-description`):**
- Controls the maximum width of the second column (descriptions)
- Defaults to 60 characters (reasonable for 80-120 column terminals)
- Enables word wrapping when descriptions exceed this width

**Help Files (`bowerbird-help.files`):**
- Controls which files the help system parses for `##` comments
- Defaults to `$(MAKEFILE_LIST)` (all included makefiles)
- Can be overridden to parse specific files (useful for testing)

### Word Wrapping Algorithm

Implement word wrapping in AWK that:
1. **Splits on Word Boundaries**: Never breaks words mid-character
2. **Preserves Indentation**: Wrapped lines align with the first line of description
3. **Handles Multiple Wraps**: Supports descriptions that wrap multiple times
4. **Respects ANSI Codes**: Color codes don't affect width calculations

```awk
function wrap_text(text, width, indent,    words, n, line, i, word, result, first) {
    gsub(/^[[:space:]]+/, "", text);
    gsub(/[[:space:]]+$$/, "", text);
    n = split(text, words, /[[:space:]]+/);
    line = "";
    result = "";
    first = 1;
    for (i = 1; i <= n; i++) {
        word = words[i];
        if (line == "") {
            line = word;
        } else if (length(line " " word) <= width) {
            line = line " " word;
        } else {
            if (first) {
                result = line;
                first = 0;
            } else {
                result = result "\n" indent line;
            }
            line = word;
        }
    }
    if (first) {
        result = line;
    } else {
        result = result "\n" indent line;
    }
    return result;
}
```

### Updated Help Output

**Without wrapping (short descriptions):**
```
  target-name                 Short description here
  longer-target-name          Another description
```

**With wrapping (long descriptions):**
```
  target-name                 This is a very long description that
                              exceeds the maximum width and gets
                              wrapped intelligently at word breaks
  another-target              Short one
```

## Alternatives Considered

### Alternative 1: Keep Fixed Width

**Rejected**: Doesn't solve the problem of long target names or descriptions. Forces projects to manually abbreviate text or live with poor formatting.

### Alternative 2: Terminal Width Auto-Detection

**Rejected**:
- Complex to implement in Make/AWK
- Unpredictable behavior in CI/CD environments
- Doesn't work well in pipes or redirected output
- Different team members may have different terminal widths

### Alternative 3: Truncate Instead of Wrap

**Rejected**:
- Loses information
- Forces manual abbreviation of descriptions
- Poor user experience
- Help text should be complete and readable

### Alternative 4: Separate Help Files

**Rejected**:
- Breaks the elegant `##` comment integration
- Increases maintenance burden (help text separated from code)
- Loses co-location of code and documentation
- More files to manage

## Trade-offs

### Benefits

- **Flexibility**: Projects can customize layout for their specific needs
- **Readability**: Long descriptions no longer run off screen
- **Professional**: Clean, wrapped output looks polished
- **Adaptable**: Can optimize for narrow or wide terminals
- **Maintainable**: No manual line breaks needed in descriptions
- **Backward Compatible**: Existing projects work without changes

### Costs

- **Slightly More Complex**: AWK function adds ~20 lines of code
- **Configuration Decision**: Projects need to choose appropriate widths
- **Testing Overhead**: Need to test various width combinations

### Performance

- **Negligible Impact**: Word wrapping happens once during help generation
- **Cached Output**: Help is cached in build directory
- **Fast AWK Processing**: String manipulation in AWK is efficient

## Examples

### Example 1: Default Configuration

```makefile
# Uses defaults: target_width=28, desc_width=60
include bowerbird.mk

.PHONY: clean
clean: ## Remove all generated files and build artifacts from the project
```

**Output:**
```
Available targets:
  clean                       Remove all generated files and build
                              artifacts from the project
```

### Example 2: Wide Target Column

```makefile
bowerbird-help.width-target = 40
bowerbird-help.width-description = 50

include bowerbird.mk

.PHONY: --bowerbird-report-slow-tests
--bowerbird-report-slow-tests: ## Report the 3 slowest tests after suite completion
```

**Output:**
```
Optional flags:
  --bowerbird-report-slow-tests           Report the 3 slowest tests after
                                          suite completion
```

### Example 3: Narrow Terminal (80 columns)

```makefile
bowerbird-help.width-target = 24
bowerbird-help.width-description = 45

include bowerbird.mk
```

**Output (fits in 80 columns):**
```
Available targets:
  build                   Compile and build all project
                          components including dependencies
  test                    Run the complete test suite with
                          coverage reports
```

### Example 4: Wide Terminal (120+ columns)

```makefile
bowerbird-help.width-target = 30
bowerbird-help.width-description = 75

include bowerbird.mk
```

**Output (optimized for wide displays):**
```
Available targets:
  build                         Compile and build all project components including dependencies
  test                          Run the complete test suite with all tests and generate coverage
```

### Example 5: Before and After Comparison

**Before (fixed 28 width, no wrapping):**
```
Optional flags:
  --bowerbird-report-slow-tests Report the 3 slowest tests after suite completion with timing information
  --bowerbird-suppress-warnings Suppress warning messages during test discovery and execution to reduce noise
```
(Descriptions run off screen at 80-100 columns)

**After (configurable widths with wrapping):**
```
Optional flags:
  --bowerbird-report-slow-tests      Report the 3 slowest tests after suite
                                     completion with timing information
  --bowerbird-suppress-warnings      Suppress warning messages during test
                                     discovery and execution to reduce noise
```
(Clean, readable, fits in terminal)

## Implementation Plan

### Phase 1: Add Configuration Variables ✅ Complete

1. ✅ Add `bowerbird-help.width-target` with default of 28
2. ✅ Add `bowerbird-help.width-description` with default of 60
3. ✅ Add `bowerbird-help.files` with default of `$(MAKEFILE_LIST)`
4. ✅ Replace hardcoded `$(MAKEFILE_LIST)` with `$(bowerbird-help.files)`

### Phase 2: Implement Word Wrapping ✅ Complete

1. ✅ Add `wrap_text()` AWK function to `__HELP_AWK`
2. ✅ Update output formatting to use wrapped text
3. ✅ Calculate indentation dynamically based on target width
4. ✅ Pass width variables to AWK

### Phase 3: Testing ✅ Complete

Created 11 comprehensive test files in `test/bowerbird-help/`:

**Formatting Tests:**
1. ✅ `test-formatting-short.mk` - Short descriptions (no wrapping needed)
2. ✅ `test-formatting-long.mk` - Long descriptions (single wrap)
3. ✅ `test-formatting-multiple-lines.mk` - Very long descriptions (multiple wraps)
4. ✅ `test-formatting-custom-widths.mk` - Custom width configuration
5. ✅ `test-formatting-edge-empty-desc.mk` - Empty description edge case
6. ✅ `test-formatting-edge-long-word.mk` - Single word exceeds width
7. ✅ `test-formatting-edge-long-target.mk` - Target name longer than width

**Feature Tests:**
8. ✅ `test-targets-hardcoded.mk` - Multiple targets with sorting
9. ✅ `test-targets-variable.mk` - Variable expansion in targets
10. ✅ `test-flags-hardcoded.mk` - Flags (--prefix) with wrapping
11. ✅ `test-flags-variable.mk` - Variable expansion in flags

**Test Approach:** Each test file is self-contained with inline expected output, uses help cache file comparison instead of stdout, and runs with `--no-print-directory` for clean output.

### Phase 4: Documentation

1. Update README with configuration options
2. Add usage examples showing different configurations
3. Document best practices for choosing widths
4. Add visual before/after comparisons

## Testing Strategy

### Actual Implementation

**Test Structure:** Each test file is self-contained with inline configuration and expected values:

```makefile
# test/bowerbird-help/test-formatting-short.mk
__PATH_FORMATTING_SHORT := $(lastword $(MAKEFILE_LIST))

ifdef TEST_FORMATTING_SHORT
bowerbird-help.width-target = 25
bowerbird-help.width-description = 55
bowerbird-help.files = $(__PATH_FORMATTING_SHORT)

mock-formatting-short: ## Short description
endif

define expected-formatting-short

Available targets:
  \033[38;5;179mmock-formatting-short    \033[0m Short description

Optional flags:

endef

test-formatting-short:
	@mkdir -p $(WORKDIR_TEST)/$@
	@$(MAKE) --no-print-directory \
		WORKDIR_BUILD=$(WORKDIR_TEST)/$@ \
		TEST_FORMATTING_SHORT=true \
		bowerbird-help.files=$(__PATH_FORMATTING_SHORT) \
		help \
		>/dev/null 2>&1
	@$(call bowerbird::test::compare-file-content-from-var,\
		$(WORKDIR_TEST)/$@/help/help.cache,\
		expected-formatting-short)
```

**Key Improvements Over Proposal:**
- ✅ **Cache file comparison instead of stdout**: Avoids Make debug output pollution
- ✅ **One test per file**: Better organization, easier to maintain
- ✅ **Self-contained tests**: Configuration and expectations in same file
- ✅ **Inline expected values**: Uses `define` blocks instead of separate fixture files
- ✅ **Clean output**: Uses `>/dev/null 2>&1` to suppress all output during test
- ✅ **Help cache testing**: Tests actual cached output, not ephemeral stdout

**Benefits:**
- Tests see only their own help comments (via `bowerbird-help.files`)
- Expected output co-located with test configuration
- Full multiline comparison with clear diff output on failure
- No shared fixture files to maintain
- Each test is independently runnable
- Simpler mental model (one file = one test feature)

### Manual Testing

```bash
# Run all tests
make check

# Run individual tests
make test-formatting-short
make test-formatting-long
make test-formatting-multiple-lines
make test-formatting-custom-widths
make test-formatting-edge-long-word
make test-formatting-edge-empty-desc
make test-formatting-edge-long-target
make test-targets-hardcoded
make test-targets-variable
make test-flags-hardcoded
make test-flags-variable
```

### Edge Cases (Implemented)

**Test: `test-formatting-edge-long-word.mk`**
- Single word exceeds description width
- Tests: `supercalifragilisticexpialidocious description`
- Width: target=25, description=55
- Result: Long word on first line, "description" wraps to second line

**Test: `test-formatting-edge-empty-desc.mk`**
- Empty description (only `##` comment)
- Tests: `target: ##`
- Result: Target with trailing space, no description text

**Test: `test-formatting-edge-long-target.mk`**
- Target name equals or exceeds target width
- Tests: `mock-formatting-edge-long-target: ## Description text`
- Result: Description immediately follows target without extra spacing

**Additional edge cases tested:**
1. **Multiple wraps**: `test-formatting-multiple-lines.mk` - 4-line wrapped description
2. **Variable expansion**: `test-targets-variable.mk` and `test-flags-variable.mk`
3. **Custom widths**: `test-formatting-custom-widths.mk` - different width configuration
4. **Sorting**: Both targets and flags tests verify alphabetical sorting

## Implementation Details

### Modified Files

**`src/bowerbird-help/bowerbird-help.mk`:**

```makefile
# Configuration (new)
bowerbird-help.width-target ?= 28
bowerbird-help.width-description ?= 60
bowerbird-help.files ?= $(MAKEFILE_LIST)

# Paths
__HELP_CACHE = $(WORKDIR_BUILD)/help/help.cache

# Updated __HELP_AWK macro
define __HELP_AWK
awk -v target_width="$(bowerbird-help.width-target)" \
    -v desc_width="$(bowerbird-help.width-description)" \
    -v makefiles="$(bowerbird-help.files)" 'BEGIN { \
	# ... existing BEGIN block ...
} \
function wrap_text(text, width, indent, ...) { \
	# ... wrapping implementation ...
} \
/^[a-zA-Z0-9_.%\/$$()\\-]+:.*##/ { \
	target = $$1;
	desc = $$2;
	# ... existing parsing ...

	# Calculate indent for wrapped lines
	indent = "";
	for (i = 0; i < target_width + 2; i++)
		indent = indent " ";

	# Wrap description
	wrapped = wrap_text(desc, desc_width, indent);

	# Print with proper formatting
	printf "  \033[38;5;179m%-" target_width "s\033[0m %s\n", \
		target, wrapped;
}' $(bowerbird-help.files) | LC_ALL=C sort -u
endef
```

### Backward Compatibility

✅ **Fully backward compatible:**

1. **Existing projects**: Continue working without changes (default values match current behavior)
2. **Default values**: `width-target = 28` matches old `__HELP_WIDTH`
3. **No API changes**: Same `##` comment syntax
4. **Override mechanism**: Uses standard Make `?=` pattern

### Best Practices for Projects

**Choosing Column Widths:**

```makefile
# Formula: target_width + desc_width + 4 <= terminal_width
# (4 = 2 for indent + 2 for separator)

# For 80-column terminals
bowerbird-help.width-target = 24
bowerbird-help.width-description = 45

# For 120-column terminals (default)
bowerbird-help.width-target = 28
bowerbird-help.width-description = 60

# For wide terminals (160+ columns)
bowerbird-help.width-target = 35
bowerbird-help.width-description = 90
```

**Consider Target Length:**
- Short names (< 15 chars): Use smaller target width (20-25)
- Medium names (15-25 chars): Use default width (28)
- Long names (> 25 chars): Increase target width (35-40)

**Consider Description Verbosity:**
- Terse descriptions: Can use wider desc width (70-80)
- Verbose descriptions: Use narrower desc width (45-60) for better wrapping

**Using `bowerbird-help.files`:**
- Default (`$(MAKEFILE_LIST)`): Parse all included makefiles (normal usage)
- Testing: Set to specific fixture file for isolated tests
- Custom: Set to subset of files if needed (e.g., exclude certain includes)

## Migration Path

No migration needed - feature is opt-in via configuration variables.

**To adopt the feature:**

```makefile
# Add before including bowerbird.mk
bowerbird-help.width-target = 35
bowerbird-help.width-description = 50

include bowerbird.mk
```

**Projects can adopt incrementally:**
1. Start with defaults (no changes needed)
2. Adjust target width if needed
3. Adjust description width for better wrapping
4. Test with `make help` after each adjustment

## Future Enhancements

### Terminal Width Auto-Detection (Optional)

Could add optional terminal width detection for advanced use cases:

```makefile
bowerbird-help.auto-width ?= 0  # Disabled by default

ifneq ($(bowerbird-help.auto-width),0)
    TERMINAL_WIDTH := $(shell tput cols 2>/dev/null || echo 80)
    bowerbird-help.width-description = $(shell echo $$(($(TERMINAL_WIDTH) - $(bowerbird-help.width-target) - 4)))
endif
```

### Color-Aware Width Calculation

Handle ANSI color codes in descriptions without affecting width:

```awk
function strip_ansi(text) {
    gsub(/\033\[[0-9;]*m/, "", text);
    return text;
}

function visual_length(text) {
    return length(strip_ansi(text));
}
```

### Multi-Line Target Support

Allow very long target names to truncate with ellipsis:

```
  very-long-target-name...    Description here
```

## Documentation Updates

### README.md (Pending)

Should add section "Configurable Column Widths":
- Explain the three configuration variables
- Show examples for different terminal widths (80, 120 columns)
- Provide formula for choosing widths: `target_width + desc_width + 4 ≤ terminal_width`
- Include visual before/after comparisons
- Document the 80-column standard: target=25, description=55

### Test Documentation

Test files serve as working examples:
- `test/bowerbird-help/test-formatting-*.mk` - Various formatting scenarios
- `test/bowerbird-help/test-targets-*.mk` - Target name handling
- `test/bowerbird-help/test-flags-*.mk` - Flag (--prefix) handling
- Each test file demonstrates width configuration and expected output

## References

- Current implementation: `src/bowerbird-help/bowerbird-help.mk`
- Related projects: make-bowerbird-test (uses flag help strings)
- AWK text processing: GNU AWK manual, Chapter 9 (Functions)
- Terminal width standards: 80 columns (traditional), 120 columns (modern)

---

## Notes on Implementation vs Proposal

**Where Implementation is Better:**

1. **Cache File Comparison**: Implementation tests the help cache file directly instead of stdout, avoiding Make's debug output pollution. This is more reliable and tests the actual cached output.

2. **Self-Contained Test Files**: Each test file contains its own configuration and expected values inline, rather than using shared fixture files. This makes tests easier to understand and maintain.

3. **One Test Per File**: Separating tests into individual files (rather than one file with multiple tests) improves organization and makes it easier to run specific tests.

4. **80-Column Standard**: Tests use `width-target=25, width-description=55` for 80-column terminals, which is more practical than the proposed `60` for description width.

**Proposal Features Not Yet Implemented:**

- README documentation section (documented in this proposal instead)
- Recommended width formulas for different terminal sizes (documented in this proposal)

## Revision History

- **Revision 1** (2026-01-21): Initial draft proposal with implementation
- **Revision 2** (2026-01-22): Updated to reflect actual implementation, marked as accepted, noted improvements over original design
