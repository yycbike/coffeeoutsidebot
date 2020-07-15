package main

import (
	//"fmt"
	"testing"
	"time"
)

var calendar_string = `BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:20200710T073000@coffeeoutside.bike
DTSTAMP;TZID=America/Edmonton:20200710T073000
DTSTART;TZID=America/Edmonton:20200710T073000
DTEND;TZID=America/Edmonton:20200710T083000
SUMMARY:CoffeeOutside - Tomkins Park
END:VEVENT
END:VCALENDAR`

func TestIcalGeneration(t *testing.T) {
	mock_start_date := time.Date(2020, time.July, 10, 7, 30, 0, 0, time.UTC)
	dur, _ := time.ParseDuration("1h")
	mock_end_date := mock_start_date.Add(dur)

	var mock_location = location{Name: "Tomkins Park"}
	generated_ical_string := generate_ical_event_string(mock_start_date, mock_start_date, mock_end_date, mock_location)
	//	fmt.Printf(generated_ical_string)
	if generated_ical_string != calendar_string {
		t.Error(generated_ical_string)
	}
}
