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
- Comprehensive test suite with 11 tests covering formatting, edge cases, and feature behavior

### Changed
- Renamed `test` target to `check` for consistency with Bowerbird standards
- Default help layout optimized for 80-column terminals (target=25, desc=55)
- Test suite rewritten to use help cache file comparison (more reliable than stdout)
- Tests are now self-contained with inline expected values
- Updated to kwargs-based dependency API
- Added `bowerbird-libs` as a dependency for kwargs support

### Fixed
- Help descriptions now wrap cleanly instead of running off screen
- Removed `.NOTPARALLEL` directive for Make 3.81 compatibility
- Better handling of edge cases (empty descriptions, long words, long target names)


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
