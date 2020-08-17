package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"gopkg.in/ini.v1"
)

// TODO this assumes next event is always at Friday, 7:30
func next_event() time.Time {
	now := time.Now()

	var days_to_add = 0
	wd_num := int(now.Weekday())
	friday_num := int(time.Friday)
	log.Println(wd_num)

	// TODO could probably use a modulo operation here
	if wd_num < friday_num {
		days_to_add = friday_num - wd_num
	} else if wd_num == friday_num+1 {
		days_to_add = 6
	}
	log.Printf("days to add %v", days_to_add)
	nd := now.AddDate(0, 0, days_to_add)

	next_date := time.Date(nd.Year(), nd.Month(), nd.Day(), 7, 30, 0, 0, time.UTC)
	return next_date
}

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

	start := next_event()
	dur, _ := time.ParseDuration("1h")
	end := start.Add(dur)
	ical_str := generate_ical_event_string(time.Now(), start, end, location)
	if production {
		twit := TwitterDispatch{config_file: "cb_config.ini", location: location}
		twit.notify_twitter()
		ical_file, err := os.Create("yyc.ics")
		if err != nil {
			log.Println("Couldn't write icalendar file")
		}
		defer ical_file.Close()
		ical_file.WriteString(ical_str)
	} else {
		twit := TwitterDispatch{location: location}
		fmt.Println(twit.twitter_string())
		fmt.Println(ical_str)
	}
}
