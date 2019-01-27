# SimpleJsonLogFormatter

Json formatter for Ruby logger.

This project is based on [LtsvLogFormatter](https://github.com/sonots/ltsv_log_formatter) and modified for json.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_json_log_formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_json_log_formatter

## Usage

```ruby
require 'logger'
require 'simple_json_log_formatter'
logger = Logger.new
logger.formatter = SimpleJsonLogFormatter.new
```

### Rails

Configure at `config/application.rb` or `config/environments/*.rb`

```ruby
# config/application.rb
# OR
# config/environments/*.rb
config.log_formatter = SimpleJsonLogFormatter.new
```

### Options

- time_key
    - Change the key name of the time field. Set nil to remove. Default: time
- severity_key
    - Change the key name of the severity field. Set nil to remove. Default: severity
- progname_key
    - Change the key name of the progname field. Set nil to remove. Default: progname
- message_key
    - Change the key name for the message field. Default: message
- datetime_format
    - Change date and time format of the time field. Default: `%FT%T%:z`

```ruby
logger.formatter = SimpleJsonLogFormatter.new(time_key: "log_time", progname_key: nil)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taogawa/simple_json_log_formatter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleJsonLogFormatter project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/simple_json_log_formatter/blob/master/CODE_OF_CONDUCT.md).
