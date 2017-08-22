#!/usr/bin/env python
# CoffeeOutsideBot
# Copyright 2016-2017, David Crosby
# BSD 2-clause license
#
# TODO - automate Cyclepalooza event creation

import os
import json
import random
from twitter import *
from ConfigParser import SafeConfigParser
import openweathermapy.core as owm

# TODO clean up config file parsing
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

def retrieve_owm_config(config_file='./cb_config.ini'):
    parser = SafeConfigParser()
    parser.read(config_file)

    owm_creds = {}
    # yuck
    for section in ['openweathermap']:
        if parser.has_section(section):
            if section == 'openweathermap':
                for option in parser.options('openweathermap'):
                    owm_creds[option] = parser.get('openweathermap', option)
    return owm_creds

def retrieve_all_locations_list():
    locations = []
    try:
        with open('./locations.json', 'r') as fp:
            locations = json.load(fp)
    except IOError, err:
        print(err)
    return locations["locations"]

def retrieve_prior_locations_list():
    prior_locations = []
    try:
        with open('./prior_locations', 'r') as file_handle:
            for l in file_handle:
                if len(l.strip()) > 0:
                    prior_locations.append(l.strip())
    except IOError, err:
        print(err)
    return prior_locations[-8:]

def add_location_to_prior_locations(location):
    if dryrun():
        print("Not adding to prior locations")
    else:
        try:
            with open('./prior_locations', 'a+') as file_handle:
                file_handle.write(location["name"] + "\n")
        except IOError, err:
            print(err)

def notify_twitter(location):
    # TODO assert length of string is not greater than 140 chars
    new_status = "This week's #CoffeeOutside - "
    new_status += location["name"]
    if 'url' in location:
        new_status += " " + location["url"]
    if 'address' in location:
        new_status += " (" + location["address"] + ")"
    new_status += ", see you there! #yycbike"
    print("Twitter:" + new_status)

    tcreds = retrieve_twitter_config()

    if not dryrun():
        t = Twitter(
        auth=OAuth(tcreds['token'], tcreds['token_secret'], tcreds['consumer_key'], tcreds['consumer_secret']))
        t.statuses.update(status=new_status)

def get_forecast_temperature():
    # Use Celsius
    owm_creds = retrieve_owm_config()
    # TODO remove hardcode for Calgary city id
    data = owm.get_forecast_daily(5913490, 3, **owm_creds)
    print(data[2])
    return data[2]['temp']['morn']

def select_location(locations):
    prior_locations = retrieve_prior_locations_list()
    print(prior_locations)
    temperature = get_forecast_temperature()

    print("Temperature:" + str(temperature))

    # TODO: 'rainy-day' locations limiting
    valid_locations = []
    for l in locations:
        if l["name"] in prior_locations:
            if dryrun:
                print("Skipping" + l["name"])
            continue
        if 'low_limit' in l:
            if temperature < l['low_limit']:
                continue
        if 'high_limit' in l:
            if temperature > l['high_limit']:
                continue
        valid_locations.append(l)

    if dryrun():
        for l in valid_locations:
            print(l["name"])
        print("\n")

    return random.choice(valid_locations)

def dryrun():
    print("DRY RUN MODE")
    return os.getenv('DRY_RUN') != None

def main():
    locations = retrieve_all_locations_list()

    # TODO - clean this up a bit, a bit racy
    # TODO - override functionality is broken!
    if os.path.isfile('./override'):
        try:
            with open('./override', 'r') as file_handle:
                location = file_handle.readline(),strip()
        except IOError, err:
            print(err)
        os.unlink('./override')
    else:
        location = select_location(locations)

    notify_twitter(location)
    add_location_to_prior_locations(location)

if __name__ == '__main__':
    main()
