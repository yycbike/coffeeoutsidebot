package main

import (
	"testing"
	"time"
)

var basic_calendar_string = `BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:20200710T073000@coffeeoutside.bike
DTSTAMP;TZID=America/Edmonton:20200710T073000
DTSTART;TZID=America/Edmonton:20200710T073000
DTEND;TZID=America/Edmonton:20200710T083000
SUMMARY:CoffeeOutside - Tomkins Park
LOCATION:Tomkins Park
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
	if generated_ical_string != basic_calendar_string {
		t.Error(generated_ical_string)
	}
}

var geo_calendar_string = `BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:20200710T073000@coffeeoutside.bike
DTSTAMP;TZID=America/Edmonton:20200710T073000
DTSTART;TZID=America/Edmonton:20200710T073000
DTEND;TZID=America/Edmonton:20200710T083000
SUMMARY:CoffeeOutside - Tomkins Park
LOCATION:Tomkins Park
GEO:51.038027;-114.081159
END:VEVENT
END:VCALENDAR
`

func TestGeoIcalGeneration(t *testing.T) {
	mock_start_date := time.Date(2020, time.July, 10, 7, 30, 0, 0, time.UTC)
	mock_end_date := time.Date(2020, time.July, 10, 8, 30, 0, 0, time.UTC)
	geostr := "51.038027;-114.081159"
	mock_location := location{
		Name:   "Tomkins Park",
		Geostr: &geostr,
	}
	dispatch := Dispatch{start_time: mock_start_date, end_time: mock_end_date, location: mock_location}

	test_ical := IcalDispatch{dispatch: dispatch}

	generated_ical_string := test_ical.event_string(mock_start_date)
	if generated_ical_string != geo_calendar_string {
		t.Error(generated_ical_string)
	}
}
