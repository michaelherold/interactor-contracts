# Change Log

All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning 2.0.0][semver]. Any violations of this scheme are considered to be bugs.

[semver]: http://semver.org/spec/v2.0.0.html

## [0.3.0] - 2019-10-09

### Added

* [#27](https://github.com/michaelherold/interactor-contracts/pull/27): Upgrade dry-validation to 1.0 - [@vaihtovirta](https://github.com/vaihtovirta).
* [#30](https://github.com/michaelherold/interactor-contracts/pull/30): Allow setting a custom I18n backend for contract messages - [@michaelherold](https://github.com/michaelherold).

### Changed

* [#29](https://github.com/michaelherold/interactor-contracts/pull/29): Renamed the `assures` method to `promises` and all of the internals to reflect the new naming. This is a backward-compatible change due to an alias of `assures` to `promises` - [@michaelherold](https://github.com/michaelherold), suggested by [@KelseyDH](https://github.com/KelseyDH).

### Fixed

* [#26](https://github.com/michaelherold/interactor-contracts/pull/26): Fix bug with inheritance - [@raykov](https://github.com/raykov).

### Miscellaneous

* [#24](https://github.com/michaelherold/interactor-contracts/pull/24): Fixed a typo in the gem specification - [@bittersweet](https://github.com/bittersweet).
* [#28](https://github.com/michaelherold/interactor-contracts/pull/28): Fixed
the Travis configuration to stop failing on JRuby builds - [@michaelherold](https://github.com/michaelherold).

## [0.2.0] - 2019-05-27

### Added

* [#18](https://github.com/michaelherold/interactor-contracts/pull/18): Add possibility to inherit class with saving interactor-contracts behaviour - [@raykov](https://github.com/raykov).

### Fixed

* [#16](https://github.com/michaelherold/interactor-contracts/pull/16): Fix BreachSet#to_hash issue with hashed messages in Breaches - [@raykov](https://github.com/raykov).

### Security

* [#15](https://github.com/michaelherold/interactor-contracts/pull/15): Update vulnerable dependencies in the development harness. No user-facing change - [@michaelherold](https://github.com/michaelherold).

## [0.1.0] - 2017-02-25

### Added

* [#2](https://github.com/michaelherold/interactor-contracts/pull/2): Support for dry-validations ~> 0.10 - [@andrewaguiar](https://github.com/andrewaguiar).
* [#7](https://github.com/michaelherold/interactor-contracts/pull/7): More ergonomic error handling via `BreachSet#to_hash` - [@michaelherold](https://github.com/michaelherold).

### Fixed

* [#5](https://github.com/michaelherold/interactor-contracts/pull/5): Refactored code base to prepare for the release of v0.1.0 - [@michaelherold](https://github.com/michaelherold).

### Miscellaneous

* [#3](https://github.com/michaelherold/interactor-contracts/pull/3): Updated all dependencies to fix build process - [@michaelherold](https://github.com/michaelherold).
* [#4](https://github.com/michaelherold/interactor-contracts/pull/4): Added Danger as a collaboration tool - [@michaelherold](https://github.com/michaelherold).
* [#6](https://github.com/michaelherold/interactor-contracts/pull/6): Updated the README - [@michaelherold](https://github.com/michaelherold).

[unreleased]: https://github.com/michaelherold/interactor-contracts/compare/v0.2.0...master
[0.3.0]: https://github.com/michaelherold/interactor-contracts/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/michaelherold/interactor-contracts/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/michaelherold/interactor-contracts/tree/v0.1.0
