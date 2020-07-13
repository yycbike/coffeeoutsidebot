package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"os"
)

// TODO make this an INI setting
const humidity_limit = 75 // I've found this to be a sweet spot, but this may be different in other cities

const override_file_name = "./override.json"
const prior_locations_file_name = "./prior_locations.json"

type location struct {
	Name       string
	Address    *string
	Url        *string
	High_limit *int
	Low_limit  *int
	Rainy_day  *bool
}

// Generics would be nice here...
func (l location) rainy_day() bool {
	var r bool = false
	if l.Rainy_day != nil {
		r = *l.Rainy_day
	}
	return r
}
func (l location) url() string {
	var u string = ""
	if l.Url != nil {
		u = *l.Url
	}
	return u
}
func (l location) address() string {
	var a string = ""
	if l.Address != nil {
		a = *l.Address
	}
	return a
}
func (l location) high_limit() int {
	var x int = 100
	if l.High_limit != nil {
		x = *l.High_limit
	}
	return x
}
func (l location) low_limit() int {
	var x int = -100
	if l.Low_limit != nil {
		x = *l.Low_limit
	}
	return x
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func retrieve_locations_list() (l []location) {
	dat, err := ioutil.ReadFile("./locations.json")
	check(err)

	var things []location
	err = json.Unmarshal([]byte(dat), &things)
	if err != nil {
		log.Println("Couldn't retrieve locations list:", err)
	}
	log.Printf("Locations list: %+v", things)

	return things
}

func retrieve_override_location() (l location) {
	dat, err := ioutil.ReadFile(override_file_name)
	check(err)

	var thing location
	err = json.Unmarshal([]byte(dat), &thing)
	if err != nil {
		log.Println("error:", err)
	}
	log.Printf("Override location: %+v", thing)

	err = os.Remove(override_file_name)
	if err != nil {
		fmt.Println(err)
		return
	}
	log.Printf("Override file %s successfully deleted", override_file_name)

	return thing
}

func SelectLocation(f forecast) (l location) {
	if _, err := os.Stat(override_file_name); err == nil {
		log.Println("Override found")
		return retrieve_override_location()
	}

	all_locations := retrieve_locations_list()
	var prior_locations []string = read_prior_locations_file()
	var usable_locations []location
	for _, loc := range all_locations {
		use, reason := use_location_forecast(loc, f)
		if use != true {
			fmt.Printf("Location: %v, fail reason %v\n", loc.Name, reason)
		} else if location_used_prior(loc.Name, prior_locations) {
			fmt.Printf("Location: %v, fail reason prior locations\n", loc.Name)
		} else {
			usable_locations = append(usable_locations, loc)
		}
	}

	fmt.Println(len(usable_locations))

	// Pick a random location

	var chosen_location = usable_locations[rand.Intn(len(usable_locations))]
	append_prior_locations_file(chosen_location)
	return chosen_location
}

func location_used_prior(l string, p []string) bool {
	for _, i := range p {
		if l == i {
			return true

		}
	}
	return false
}

func append_prior_locations_file(l location) {
	priors := read_prior_locations_file()
	log.Printf("Prior locations list: %+v", priors)
	new_priors := append(priors, l.Name)
	log.Printf("New prior locations list: %+v", new_priors)
	js, _ := json.Marshal(new_priors)

	err := ioutil.WriteFile(prior_locations_file_name, js, 0644)
	if err != nil {
		log.Fatal(err)
	}
}

func read_prior_locations_file() []string {
	dat, err := ioutil.ReadFile(prior_locations_file_name)
	check(err)

	var things []string
	err = json.Unmarshal([]byte(dat), &things)
	if err != nil {
		log.Println("Couldn't retrieve prior_locations list:", err)
	}
	log.Printf("Locations list: %+v", things)

	return things
}

func use_location_forecast(l location, f forecast) (use bool, reason string) {
	if f.temp < l.low_limit() {
		return false, "Low temp"
	} else if f.temp > l.high_limit() {
		return false, "High temp"
	} else if f.humidity > humidity_limit && !l.rainy_day() {
		return false, "Humidity"
	}
	return true, ""
}
