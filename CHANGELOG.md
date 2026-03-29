## [Unreleased]

## [1.0.0] - 2026-03-29

### Breaking Changes

- Requires Ruby >= 3.0 (was >= 2.6)
- Requires Rails >= 7.0 (was >= 5.0)
- Generated feature classes now use ActiveModel::Attributes instead of hand-rolled attr_reader/initialize

### Bug Fixes

- Fix generator namespace typo (`rails_feature_flag` → `rails_feature_flip`) in README, USAGE, and install message
- Fix `all.rb` loader using fragile relative path — now uses `File.expand_path(__dir__)`
- Fix singular/plural mismatch in install generator (`config/feature` → `config/features`)
- Fix install generator using `File.read` with CWD-relative path instead of destination root
- Use idiomatic `empty_directory` in install generator instead of `Dir.mkdir`

### New Features

- **ActiveModel::Attributes**: Generated features include type casting, built-in defaults, and attribute introspection
- **Default values**: `--defaults enabled:false amount:100` flag on the feature generator
- **Auto-enabled attribute**: `enabled:boolean` is added by default (skip with `--no-enabled`)
- **Feature namespacing**: `Billing::InvoicePdf` generates nested modules in subdirectories
- **Controller/view helpers**: `feature_enabled?(:name)` and `require_feature :name` via Railtie
- **Test helper**: `with_feature(:name, enabled: true) { ... }` for overriding features in tests
- **Feature registry**: `RailsFeatureFlip::Registry.all`, `.names`, `.find(:name)`
- **Runtime toggles**: `RailsFeatureFlip.enable(:name)`, `.disable(:name)`, `.toggle(:name)`
- **Rake task**: `rake features` lists all registered features with status and attributes

### Quality

- Added Rubocop with rubocop-minitest and rubocop-rake
- Added 40 tests with 152 assertions covering generators, helpers, registry, and toggles
- CI matrix expanded to Ruby 3.0, 3.1, 3.2, 3.3, 3.4, 4.0

## [0.1.1] - 2024-02-23

- Initial release on rubygems.org

## [0.1.0] - 2024-02-23

- Start of the gem
