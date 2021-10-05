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
roppongi = Groute::LatLng.new(35.662725, 139.731216)
Groute::StraitDistanceCalculator.new.distance(
  from: shibuya,
  to: roppongi
)
# => Groute::Distance(2728)
```

### Google Directions APIのルート検索

Google Directions APIを利用して、ルートを計算します

```ruby
shibuya = Groute::LatLng.new(35.658034, 139.701636)
roppongi = Groute::LatLng.new(35.662725, 139.731216)
Groute::GoogleDirectionsDistanceCalculator.new.route(shibuya, roppongi)
# => Groute::Route(17, Groute::Distance(7197))
```

### Google Distance Matrix API

Google Distance Matrix API利用して、ルートを計算します

#### hexagonalオプション

インスタンス生成時に `hexagonal:` オプションを指定する事で、
以下に説明する周辺6点に展開する手法を利用するかどうかの切りかえが可能です。

`hexagonal: `オプションのデフォルト値は `false` です.

##### hexagonal: falseの場合

6点に展開する事なく、指定された目的地と出発地の距離をDistance Matrix APIで計算します

```ruby
shibuya = Groute::LatLng.new(35.658034, 139.701636)
roppongi = Groute::LatLng.new(35.662725, 139.731216)
Groute::GoogleDistanceMatrixDistanceCalculator.new.route(shibuya, roppongi)
# => Groute::Route(5, Groute::Distance(2653))
```

##### hexagonal: trueの場合

指定された出発地と目的地を周辺100mの6箇所の点と共にDistance Matrix APIにかけ、
最短のルートの距離をかえします.

```ruby
shibuya = Groute::LatLng.new(35.658034, 139.701636)
roppongi = Groute::LatLng.new(35.662725, 139.731216)
Groute::GoogleDistanceMatrixDistanceCalculator.new(hexagonal: true).route(shibuya, roppongi)
# => Groute::Route(5, Groute::Distance(2653))
```

###### この手法のメリット

この手法は、誤って出発地及び目的地が高速道路上であると判定され、
長大なルートが利用されてしまう危険性にたいする部分的な対処方法です。

###### この手法のデメリット

その一方で、Distance Matrix APIは、リクエストに指定した地点の組みあわせに比例してコストがかかるため
コストは他の手法に対して高くなるため、利用は慎重にこれ以外の手法で要求が満せない時にのみ利用してください。

また、周辺に地点を展開した事によってルートの始点または終点が道路の反対側になってしまう場合があり、
その場合には道路を反対まで移動する分の距離が結果に反映されない等の不具合が発生する可能性があります

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO

- [ ] Google Directions APIのレスポンスから、有料道路の交通費を抽出
- [ ] Google Directions APIのレスポンスから、ルートのPoylineを抽出
- [ ] Google Distance Matrix APIのレスポンスから、有料道路の交通費を抽出
- [ ] Google Distance Matrix APIの内部で利用された出発地と目的地を抽出

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/azitinc/groute. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/azitinc/groute/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Groute project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/azitinc/groute/blob/master/CODE_OF_CONDUCT.md).
