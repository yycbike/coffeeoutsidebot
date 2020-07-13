package main

import (
	"fmt"
	"testing"
)

func TestUseLocationHumidity(t *testing.T) {
	var r = true
	if use, reason := use_location_forecast(location{Rainy_day: &r}, forecast{humidity: humidity_limit + 1}); use == false {
		fmt.Println(reason)
		t.Fail()
	}
	r = false
	if use, reason := use_location_forecast(location{Rainy_day: &r}, forecast{humidity: humidity_limit + 1}); use == true {
		fmt.Println(reason)
		t.Fail()
	}
}

func TestUseLocationTemp(t *testing.T) {
	var l = 1
	var h = 1
	if use, _ := use_location_forecast(location{High_limit: &h}, forecast{temp: 2}); use == true {
		t.Fail()
	}
	if use, _ := use_location_forecast(location{Low_limit: &l}, forecast{temp: 0}); use == true {
		t.Fail()
	}
	l = 1
	h = 10
	if use, _ := use_location_forecast(location{Low_limit: &l, High_limit: &h}, forecast{temp: 5}); use == false {
		t.Fail()
	}
}
