# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

```markdown
## [Unreleased] - YYYY-MM-DD

### Added
### Changed
### Deprecated
### Fixed
### Security
```

## [Unreleased] - YYYY-MM-DD

### Added
- **Configurable annotation marker** with new `bowerbird-help.annotation` variable (default: `\#\#`)
  - Allows customization of the annotation pattern used to identify help text
  - Enables separation of test annotations from production help output
- **Alphabetical sorting** for targets and flags in help output
  - Targets and flags are now displayed in alphabetical order
  - Multi-line wrapped descriptions stay together during sorting
  - Case-insensitive sorting for better consistency
- **Configurable column widths** for help output with three new variables:
  - `bowerbird-help.width-target` (default: 28) - Controls target column width
  - `bowerbird-help.width-description` (default: 60) - Controls description column width
  - `bowerbird-help.files` (default: `$(MAKEFILE_LIST)`) - Controls which files to parse
- **Word wrapping** for help descriptions that exceed configured width
  - Intelligent wrapping at word boundaries
  - Proper indentation for wrapped lines
  - Support for multiple line wraps
- **Variable expansion** in help comments - `$(VAR)` now expands in target names and descriptions
- Development proposal structure with draft/accepted/rejected categories
- Comprehensive test suite with 13 tests covering formatting, edge cases, sorting, and feature behavior
  - Added `test-formatting-sorting-targets.mk` for target sorting validation
  - Added `test-formatting-sorting-flags.mk` for flag sorting validation

### Changed
- Renamed `test` target to `check` for consistency with Bowerbird standards
- Default help layout optimized for 80-column terminals (target=25, desc=55)
- Test suite rewritten to use help cache file comparison (more reliable than stdout)
- Tests now use `####` annotation marker within `ifdef` blocks to prevent test targets from appearing in production help
- Tests are now self-contained with inline expected values
- Updated to kwargs-based dependency API
- Added `bowerbird-libs` as a dependency for kwargs support
- Enhanced AWK script to use `index()` for precise annotation matching

### Fixed
- **Word wrap alignment** for multi-line descriptions now properly aligns continuation lines
- **Test annotation isolation** - test mock targets and flags no longer appear in main help output
- Help descriptions now wrap cleanly instead of running off screen
- Removed `.NOTPARALLEL` directive for Make 3.81 compatibility
- Better handling of edge cases (empty descriptions, long words, long target names)
- Annotation matching now correctly distinguishes between `##` and `####` patterns


## [0.1.0] - 2024-06-07

### Added
- Migrated the help target to a separate repo.
- Added a description of the help tags to the README.
### Changed
- Added bowerbird dependencies for githooks and test.
- Migrate test-runner over to bowerbird-test
- Updated the makefile settings to disable both builtin rules and variables, enable
  parallel execution of jobs, and to disable paralle operation of `private_clean`.
### Fixed
- Fixed possible bug in regex where '_' character was escaped '\_' which causes a
  warning on Ubuntu test host.
