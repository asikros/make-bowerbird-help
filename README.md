# Bowerbird Help Tools

[![Makefile CI](https://github.com/ic-designer/make-bowerbird-help/actions/workflows/makefile.yml/badge.svg)](https://github.com/ic-designer/make-bowerbird-help/actions/workflows/makefile.yml)

Creates a `help` target that will list specified targets and optional flags alongside
user-defined descriptions. The help system automatically separates targets from flags
and displays them in organized sections with color formatting.

## Example Output

```console
$ make help

Available targets:
  check                        Runs the repository tests
  clean                        Deletes all files created by Make
  help                         Show this help message
  test                         Runs the repository tests

Optional flags:
  --verbose                    Enable verbose output
  --debug                      Enable debug mode
```

## Usage

### Annotating Targets

Targets are automatically included in the help output when annotated with the `##` syntax:

```makefile
target-name: ## Description of what this target does
target-name: prerequisites
	@echo "Running target..."
```

### Annotating Flags

Flags (targets starting with `--`) are automatically separated into the "Optional flags" section:

```makefile
.PHONY: --verbose
--verbose: ## Enable verbose output
```

### Requirements

- Help annotations must use the format: `target: ## Description`
- The `##` must appear on the same line as the target name and colon
- Flags are identified by starting with `--`
- The help system requires `WORKDIR_BUILD` to be defined for caching
