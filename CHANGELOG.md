## [Unreleased]

## [0.2.1] - 2026-05-31

### Changed
- Updated the HTTParty dependency requirement to allow patched versions.

## [0.2.0] - 2023-10-24

### Added
- Added support for named parameters in client initialization and method calls for better readability and flexibility.
- Introduced `Retryable` module for retrying failed requests.
- Introduced error handling with `SpeedLightning::Error`.
- Added convenience paid? method to check if payment has been completed.

### Changed
- Improved the file structure.
- Renamed methods for creating and retrieving checkout links.
- Modified client initialization to use named parameter `secret_key`.
- Refactored `CheckoutLink` class to handle raw API attributes and conversion to Ruby time objects.

## [0.1.1] - 2023-10-23

- Minor updates for publishing to RubyGems

## [0.1.0] - 2023-10-22

- Initial release
