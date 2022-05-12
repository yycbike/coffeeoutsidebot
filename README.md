# CoffeeOutsideBot

The CoffeeOutsideBot is designed to pick a location in the city
for the #yycbike crowd to meet and enjoy some hot coffee (or tea!).

## Installation

```
git clone https://github.com/yycbike/coffeeoutsidebot.git
cd coffeeoutsidebot
bundle install
bundle exec bin/coffeeoutsidebot
```

## Twitter integration
You can get the necessary API keys at https://dev.twitter.com/

## OpenWeatherMap integration
You can get an API key at https://openweathermap.org/price

## iCalendar integration
An .ics file is auto generated. The current bot's version can be found at
https://coffeeoutside.bike/yyc.ics

## RSS integration
You can add the bot to your favourite RSS reader with
https://coffeeoutside.bike/yyc.rss

## Cron job
To have the coffeeoutsidebot fire regularly, set up a cron job

```
0 17 * * 3  pushd /path/to/coffeeoutsidebot && bundle exec ruby bin/coffeeoutsidebot
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/dafyddcrosby/coffeeoutside. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [code of
conduct](https://github.com/yycbike/coffeeoutside/blob/main/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CoffeeOutside project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/yycbike/coffeeoutside/blob/main/CODE_OF_CONDUCT.md).
