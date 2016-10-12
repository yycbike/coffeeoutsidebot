#!/usr/bin/env python
# CoffeeOutsideBot
# Copyright 2016, David Crosby
# BSD 2-clause license
#
# TODO - add rest of the locations, etc
# TODO - automate weather forecast lookup
# TODO - automate Cyclepalooza event creation

import json
import random
from twitter import *
from ConfigParser import SafeConfigParser

def retrieve_twitter_config(config_file='./cb_config.ini'):
    parser = SafeConfigParser()
    parser.read(config_file)

    tcreds = {}
    # yuck
    for section in ['twitter']:
        if parser.has_section(section):
            if section == 'twitter':
                for option in parser.options('twitter'):
                    tcreds[option] = parser.get('twitter', option)
    return tcreds

def retrieve_all_locations_list():
    locations = []
    try:
        with open('./winter_locations', 'r') as file_handle:
            for l in file_handle:
                if len(l.strip()) > 0:
                    locations.append(l.strip())
    except IOError, err:
        print(err)
    return locations

def retrieve_prior_locations_list():
    prior_locations = []
    try:
        with open('./prior_locations', 'r') as file_handle:
            for l in file_handle:
                if len(l.strip()) > 0:
                    prior_locations.append(l.strip())
    except IOError, err:
        print(err)
    return prior_locations

def add_location_to_prior_locations(location):
    try:
        with open('./prior_locations', 'a+') as file_handle:
            file_handle.write(location + "\n")
    except IOError, err:
        print(err)

def notify_twitter(location):
    # TODO assert length of string is not greater than 140 chars
    new_status = "This week's #CoffeeOutside - " + location + ", see you there! #yycbike"
    print("Twitter:" + new_status)

    tcreds = retrieve_twitter_config()

    t = Twitter(
        auth=OAuth(tcreds['token'], tcreds['token_secret'], tcreds['consumer_key'], tcreds['consumer_secret']))
    t.statuses.update(status=new_status)

def main():
    locations = retrieve_all_locations_list()
    prior_locations = retrieve_prior_locations_list()

    while True:
        location = random.choice(locations)
        if location not in prior_locations[-5:]:
            break

    notify_twitter(location)
    add_location_to_prior_locations(location)

if __name__ == '__main__':
    main()
