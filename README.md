# CoffeeOutsideBot

The CoffeeOutsideBot is super high-tech artificial intelligence, designed to pick a location in the city for the #yycbike crowd to meet and enjoy some hot coffee (or tea!).

## Requirements

* Python 3.2+

## Installation

```
git clone https://github.com/yycbike/coffeeoutsidebot.git
cd coffeeoutsidebot
pip install -r ./requirements.txt
```

## Twitter integration
You can get the necessary API keys at https://dev.twitter.com/

## OpenWeatherMap integration
You can get an API key at https://openweathermap.org/price

## Cron job
To have the coffeeoutsidebot fire regularly, set up a cron job

```
0 17 * * 3  /bin/bash -c "source /path/to/coffeeoutsidebot/bin/activate && pushd /path/to/coffeeoutsidebot/ && /path/to/coffeeoutsidebot/bin/python /path/to/coffeeoutsidebot/coffeeoutsidebot.py"
```
