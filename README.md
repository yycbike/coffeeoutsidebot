# CoffeeOutsideBot

The CoffeeOutsideBot is designed to pick a location in the city for the
#yycbike crowd to meet and enjoy some hot coffee (or tea!).

## Installation

```
git clone https://github.com/yycbike/coffeeoutsidebot.git
go build
```

## Twitter integration
You can get the necessary API keys at https://dev.twitter.com/

## OpenWeatherMap integration
You can get an API key at https://openweathermap.org/price

## Cron job
To have the coffeeoutsidebot fire regularly, set up a cron job

```
0 17 * * 3  pushd /path/to/coffeeoutsidebot && /path/to/coffeeoutsidebot/coffeeoutsidebot
```
