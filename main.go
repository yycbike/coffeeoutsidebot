package main

import (
	"fmt"
	"log"
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

type Dispatch struct {
	location   location
	start_time time.Time
	end_time   time.Time
}

func main() {
	cfg, err := ini.Load("cb_config.ini")
	if err != nil {
		log.Fatalf("Fail to read file: %v", err)
	}

	production := cfg.Section("").Key("production").MustBool(false)
	log.Printf("Is this production? %v", production)

	ws := WeatherService{config_file: "cb_config.ini"}
	forecast := ws.get_forecast()
	location := SelectLocation(forecast)

	start := next_event()
	dur, _ := time.ParseDuration("1h")
	end := start.Add(dur)
	dispatch := Dispatch{start_time: start, end_time: end, location: location}

	log.Println(dispatch)
	twitter := TwitterDispatch{config_file: "cb_config.ini", dispatch: dispatch}
	ical := IcalDispatch{output_file: "yyc.ics", dispatch: dispatch}
	if production {
		twitter.notify()
		ical.notify()
	} else {
		// TODO maybe a standard debug interface?
		fmt.Println(twitter.twitter_string())
		fmt.Println(ical.event_string(time.Now()))
	}
}
