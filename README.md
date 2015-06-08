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

```ruby
require 'gnip-powertrack'

headers = {
    authorization: [GNIP_USERNAME, GNIP_PASSWORD],
    'Accept-Encoding' => 'gzip,deflate,sdch'
}

stream = Gnip::Powertrack::Stream::Connector.new GNIP_API_STREAM_URL, headers
stream.start
```

Each message is a JSON string. When received, the `Gnip::Powertrack::Stream.process_chunk` method calls `Gnip::Powertrack.process(message)`. You will need to define `Gnip::Powertrack.process(message)`.

Example:

```ruby
module Gnip
  module Powertrack
    def self.process(message)
      # enqueue message to some worker or other asynchronous process
    end
  end
end
```

We want to keep the Powertrack connector as fast and as light-weight as possible. Is should not be processing anything. No JSON decoding. It should pass the message off ASAP.

## Development

Yes.

## Todo

1. Tests
2. Remove extra classes and methods

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gnip-powertrack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
