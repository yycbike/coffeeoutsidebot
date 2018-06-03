#!/usr/bin/env python
# CoffeeOutsideBot
# Copyright 2016-2018, David Crosby
# BSD 2-clause license

import os
import json
import random
import logging
from twitter import *
from ConfigParser import SafeConfigParser
from weather import Forecast

# TODO If no override, use LocationChooser

class LocationChooser():
    def __init__(self):

        self.retrieve_locations_list()
        self.retrieve_prior_locations_list()

    def retrieve_locations_list(self, locations_file='./locations.json'):
        self.locations = []
        try:
            with open(locations_file, 'r') as fp:
                locations = json.load(fp)
        except IOError, err:
            print(err)
        self.locations = locations["locations"]

    def select_location(self):
        forecast = Forecast()
        temperature = forecast.temperature()
        humidity = forecast.humidity()

        self.valid_locations = []
        for l in self.locations:
            if l["name"] in self.prior_locations:
                logging.debug("Skipping prior location " + l["name"])
                continue
            if 'low_limit' in l:
                if temperature < l['low_limit']:
                    continue
            if 'high_limit' in l:
                if temperature > l['high_limit']:
                    continue
            if humidity > 75:
                if 'rainy_day' in l:
                    if not l['rainy_day'] == True:
                        continue
                else:
                    continue
            self.valid_locations.append(l)

        return random.choice(self.valid_locations)

    def retrieve_prior_locations_list(self,
        prior_locations_file='./prior_locations'):
        self.prior_locations = []
        prior = []
        try:
            with open(prior_locations_file, 'r') as file_handle:
                for l in file_handle:
                    if len(l.strip()) > 0:
                        prior.append(l.strip())
        except IOError, err:
            print(err)
        self.prior_locations = prior[-8:]

    def add_location_to_prior_locations(self, location):
        try:
            with open('./prior_locations', 'a+') as file_handle:
                file_handle.write(location["name"] + "\n")
        except IOError, err:
            print(err)

if __name__ == '__main__':
    import pprint
    logging.basicConfig(level=logging.DEBUG)
    ee = LocationChooser()
    print("Chosen location", ee.select_location())
    pp = pprint.PrettyPrinter(indent=2)
    pp.pprint(ee.valid_locations)
