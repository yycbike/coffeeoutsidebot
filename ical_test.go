package main

import (
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
END:VCALENDAR
`

func TestIcalGeneration(t *testing.T) {
	mock_start_date := time.Date(2020, time.July, 10, 7, 30, 0, 0, time.UTC)
	mock_end_date := time.Date(2020, time.July, 10, 8, 30, 0, 0, time.UTC)
	mock_location := location{Name: "Tomkins Park"}
	dispatch := Dispatch{start_time: mock_start_date, end_time: mock_end_date, location: mock_location}

	test_ical := IcalDispatch{dispatch: dispatch}

	generated_ical_string := test_ical.event_string(mock_start_date)
	if generated_ical_string != calendar_string {
		t.Error(generated_ical_string)
	}
}
