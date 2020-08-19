package main

import (
	"testing"
)

func TestRainyDayLocationHumidity(t *testing.T) {
	r := true
	l := location{Rainy_day: &r}
	if !l.use_location_forecast(forecast{humidity: humidity_limit + 1}) {
		t.Fail()
	}
}
func TestSunnyDayLocationHumidity(t *testing.T) {
	r := false
	l := location{Rainy_day: &r}
	if l.use_location_forecast(forecast{humidity: humidity_limit + 1}) {
		t.Fail()
	}
}

func TestLocationHighTemp(t *testing.T) {
	h := 1
	loc := location{High_limit: &h}
	if loc.use_location_forecast(forecast{temp: 2}) {
		t.Fail()
	}
}
func TestLocationLowTemp(t *testing.T) {
	l := 1
	loc := location{Low_limit: &l}
	if loc.use_location_forecast(forecast{temp: 0}) {
		t.Fail()
	}
}
func TestLocationMiddleTemp(t *testing.T) {
	l := 1
	h := 10
	loc := location{Low_limit: &l, High_limit: &h}
	if !loc.use_location_forecast(forecast{temp: 5}) {
		t.Fail()
	}
}

func TestLocListRemoval(t *testing.T) {
	loc := []location{{Name: "foo"}, {Name: "bar"}, {Name: "baz"}}
	remove_loc_from_list(loc, "bar")
	if loc[0].Name != "foo" {
		t.Fail()
	}
	if loc[2].Name != "baz" {
		t.Fail()
	}
}
