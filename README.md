# RailsFeatureFlip

This gem provides a generator to create feature flip config classes that can be used to define what features can be used in what stage and/or how they should behave in what stage.


## Example

    bin/rails generate rails_feature_flag:feature Thing enabled:boolean foo bar

    This will create:
        config/features/thing_feature.rb

    Then in application.rb:
        config.x.features.help_center = Features::Thing.new(enabled: false, foo: 'bar', bar: 'baz')
    With that you can use:
        App.features.thing.enabled?
        # => false
        App.features.thing.foo
        # => bar

The main benefit over the default `config.x` namespace is the readability in code whereas 

    if App.features.thing.enabled?
      # do something with feature "thing"
    end

is more readable than

    if Rails.env.development?
      # do something with feature "thing" in development stage
    elsif Rails.env.test?
      # do something with feature "thing" in test stage
    else
      # do something with feature "thing" in production stage
    end

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rails-feature-flip

After that setup the gem to work in your app by executing:

    $ bin/rails generate rails_feature_flip:install

## Usage

To get usage instructions run:

    $ bin/rails generate rails_feature_flip:feature -h



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/itsbede/rails-feature-flip. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rails-feature-flip/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailsFeatureFlip project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rails-feature-flip/blob/main/CODE_OF_CONDUCT.md).
