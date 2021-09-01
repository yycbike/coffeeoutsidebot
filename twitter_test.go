package main

import (
	"testing"
)

func TestTwitterString(t *testing.T) {
	lstr := "17th Ave"
	ustr := "https://example.org"
	mock_location := location{Name: "Tomkins Park", Address: &lstr, Url: &ustr}
	dispatch := Dispatch{location: mock_location}
	test_twit := TwitterDispatch{dispatch: dispatch}

	generated_string := "This week's #CoffeeOutside - Tomkins Park https://example.org (17th Ave), see you there! #yycbike"
	if test_twit.twitter_string() != generated_string {
		t.Error(generated_string)
	}
}

func TestTwitterStringNoURL(t *testing.T) {
	lstr := "17th Ave"
	mock_location := location{Name: "Tomkins Park", Address: &lstr}
	dispatch := Dispatch{location: mock_location}
	test_twit := TwitterDispatch{dispatch: dispatch}

	generated_string := "This week's #CoffeeOutside - Tomkins Park (17th Ave), see you there! #yycbike"
	if test_twit.twitter_string() != generated_string {
		t.Error(generated_string)
	}
}

func TestTwitterStringNoAddress(t *testing.T) {
	ustr := "https://example.org"
	mock_location := location{Name: "Tomkins Park", Url: &ustr}
	dispatch := Dispatch{location: mock_location}
	test_twit := TwitterDispatch{dispatch: dispatch}

	generated_string := "This week's #CoffeeOutside - Tomkins Park https://example.org, see you there! #yycbike"
	if test_twit.twitter_string() != generated_string {
		t.Error(generated_string)
	}
}
