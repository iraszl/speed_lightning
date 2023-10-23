![Speed Lightning Ruby Logo](https://repository-images.githubusercontent.com/708296260/fb927743-6c96-42aa-9601-4e7a67d3ab7a)

# SpeedLightning

Ruby interface for Speed Lightning API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'speed_lightning'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install speed_lightning

## Usage

Find full documentation of this gem and more examples: [Detailed Documentation](DOCUMENTATION.md)

Optionally, if you are testing this gem without installing in IRB
```
irb
require './lib/speed_lightning'
```

Otherwise once bundled test in your own project:

`require 'speed_lightning'`

Initialize the library with Speed test environment secret key

`client = SpeedLightning::Client.new(secret_key: "your_speed_secret_key_here")`

create a new checkout link with required parameters in test mode: invoice amount, success return url

`response = client.create_checkout_link(777, "https://your_website.com/thank_you")`

get speed checkout url with QR code and LN invoice:

`puts response.url`

get speed checkout ID:

`puts checkout_id = response.id`

get invoice status

`response = client.retrieve_checkout_link(checkout_id)`

get payment status

`puts response.status`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iraszl/speed_lightning. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/iraszl/speed_lightning/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SpeedLightning project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/iraszl/speed_lightning/blob/master/CODE_OF_CONDUCT.md).