# Groute

Google Directions および Google Distance Matrix APIを利用して二つの地点の間のルートや距離の計算をするためのライブラリ

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'groute'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install groute

## Usage

### 設定

Google Map Directions APIを利用する場合には、Google Map APIのキーの設定が必要

```ruby
Groute.configure do |conf|
  conf.google_map_api_key = "<YOUR GOOGLE MAP API KEY HERE>"
end
```

### 直線距離

ヒュベニの公式をつかって直線距離をメートルで計算します

```ruby
shibuya = Groute::LatLng.new(35.658034, 139.701636)
roppoingi = Groute::LatLng.new(35.662725, 139.731216)
Groute::StraitDistanceCalculator.new.distance(shibuya, roppoingi)
# => Groute::Distance(2728)
```

### Google Directions API

Google Directions APIを利用して、移動距離をメートルで計算します

```ruby
shibuya = Groute::LatLng.new(35.658034, 139.701636)
roppoingi = Groute::LatLng.new(35.662725, 139.731216)
Groute::GoogleDirectionsDistanceCalculator.call(shibuya_latlng, roppongi_latlng)
# => Groute::Distance(7197)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocket7878/groute. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pocket7878/groute/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Groute project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pocket7878/groute/blob/master/CODE_OF_CONDUCT.md).
