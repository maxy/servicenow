# servicenow [![Build Status](https://travis-ci.org/rubyisbeautiful/servicenow.png)](https://travis-ci.org/rubyisbeautiful/servicenow)[![Code Climate](ht    tps://codeclimate.com/github/rubyisbeautiful/servicenow.png)](https://codeclimate.com/github/rubyisbeautiful/servicenow)
This is a very simple, WIP REST API Client for ServiceNow.


## Installation

Set these environment variables:

`SNOW_API_USERNAME`

`SNOW_API_PASSWORD`

`SNOW_API_BASE_URL`


Add this line to your application's Gemfile:

```ruby
gem 'servicenow'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install servicenow

## Usage

e.g.

```ruby
client = Servicenow::Client.new
change = client.get_change('CHG123456')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/servicenow.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
