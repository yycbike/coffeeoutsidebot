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
	Paused     *bool
	Geostr     *string // "lat_float;long_float"
}

// Generics would be nice here...
func (l location) rainy_day() bool {
	var r bool = false
	if l.Rainy_day != nil {
		r = *l.Rainy_day
	}
	return r
}
func (l location) paused() bool {
	var r bool = false
	if l.Paused != nil {
		r = *l.Paused
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
func (l location) use_location_forecast(f forecast) bool {
	if f.temp < l.low_limit() {
		log.Printf("Location: %v, fail reason %v\n", l.Name, "Low temp")
		return false
	} else if f.temp > l.high_limit() {
		log.Printf("Location: %v, fail reason %v\n", l.Name, "High temp")
		return false
	} else if f.humidity > humidity_limit && !l.rainy_day() {
		log.Printf("Location: %v, fail reason %v\n", l.Name, "Humidity")
		return false
	}
	return true
}

func retrieve_locations_list() []location {
	dat, err := ioutil.ReadFile("./locations.json")
	check(err)

	var things []location
	err = json.Unmarshal([]byte(dat), &things)
	if err != nil {
		log.Println("Couldn't retrieve locations list:", err)
	}

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
	// Check for an override
	if _, err := os.Stat(override_file_name); err == nil {
		log.Println("Override found")
		return retrieve_override_location()
	}

	// Get entire pool of locations
	all_locations := retrieve_locations_list()

	var usable_locations []location
	for _, loc := range all_locations {
		if loc.paused() {
			log.Printf("Skipping %v, paused", loc.Name)
			continue
		}
		// Filter out only the locations that meet the weather parameters
		if loc.use_location_forecast(f) {
			usable_locations = append(usable_locations, loc)
		}
	}

	// Find whichever viable location was chosen furthest ago
	chosen_location := get_last_used_usable(usable_locations)
	return chosen_location
}

func remove_loc_from_list(s []location, p string) []location {
	log.Printf("removing %v", p)
	var i int
	for j, loc := range s {
		if loc.Name == p {
			i = j
			break
		}
	}
	s[i] = s[0]
	return s[1:]
}

// TODO This is inefficient, but N is small for now
func get_last_used_usable(l []location) location {
	var prior_locations []string = read_prior_locations_file()
	var p string

	var usable_locations []location
	usable_locations = l

	// Work through prior locations, until there's only one location left to choose
	for len(usable_locations) > 1 {
		// log.Printf("loop %v", usable_locations)
		// Get most recent location from list
		if len(prior_locations) > 0 {
			p = prior_locations[len(prior_locations)-1]
			prior_locations = prior_locations[:len(prior_locations)-1]
		} else {
			// There's no more prior locations, so break out of the loop
			break
		}

		// If location is in usable locations, remove it from the choices
		usable_locations = remove_loc_from_list(usable_locations, p)
	}

	// If there's multiple locations remaining, choose a random location
	// If there's only 1, this should just pick the 1
	chosen_location := usable_locations[rand.Intn(len(usable_locations))]

	// Append this location to the chosen list
	append_prior_locations_file(chosen_location)
	return chosen_location

}

func append_prior_locations_file(l location) {
	priors := read_prior_locations_file()
	log.Printf("Prior locations list: %+v", priors)
	new_priors := append(priors, l.Name)
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

	return things
}
