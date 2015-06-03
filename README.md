# Gnip::Powertrack

This gem is based entirely on the code sample provided by Gnip called the [Thin Connector](https://github.com/gnip/sample-ruby-connector). As a matter of fact, the connection code was copied directly from the repo.

All of the command line interactivity is removed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gnip-powertrack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gnip-powertrack

## Usage

```
require 'gnip-powertrack'

headers = {
    authorization: [GNIP_USERNAME, GNIP_PASSWORD],
    'Accept-Encoding' => 'gzip,deflate,sdch'
}

stream = Gnip::Powertrack::Stream::Connector.new GNIP_API_STREAM_URL, headers
stream.start
```

## Development


## Contributing

1. Fork it ( https://github.com/[my-github-username]/gnip-powertrack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
