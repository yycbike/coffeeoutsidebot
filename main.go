package main

import (
	"fmt"
	"log"

	"gopkg.in/ini.v1"
)

func main() {
	cfg, err := ini.Load("cb_config.ini")
	if err != nil {
		log.Fatalf("Fail to read file: %v", err)
	}

	production := cfg.Section("").Key("production").MustBool(false)
	log.Printf("Is this production? %v", production)

	cityId, _ := cfg.Section("openweathermap").Key("cty_id").Int()
	apiKey := cfg.Section("openweathermap").Key("appid").String()
	forecast := get_forecast(apiKey, cityId)

	log.Println("Weather test")
	log.Printf("Weather temp %v", forecast.temp)
	log.Printf("Weather humidity %v", forecast.humidity)

	log.Println("Locations test")
	location := SelectLocation(forecast)

	log.Println(location)

	tweet_str := twitter_string(location)
	if production {
		notify_twitter(cfg.Section("twitter").Key("consumer_key").String(),
			cfg.Section("twitter").Key("consumer_secret").String(),
			cfg.Section("twitter").Key("token").String(),
			cfg.Section("twitter").Key("token_secret").String(),
			tweet_str)
	} else {
		fmt.Println(tweet_str)
	}
}
