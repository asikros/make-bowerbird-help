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
- Added `bowerbird-libs` as a dependency for kwargs support
### Changed
- Updated the `bowerbird-deps` and `bowerbird-test` calls to the new syntax.
- Converted all dependencies to use low-level API (`bowerbird::deps::git-dependency-low-level`)
### Deprecated
### Fixed
- Removed `.NOTPARALLEL` directive for Make 3.81 compatibility
### Security


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
