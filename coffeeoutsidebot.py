#!/usr/bin/env python
# CoffeeOutsideBot
# Copyright 2016-2018, David Crosby
# BSD 2-clause license
#
# TODO - automate Cyclepalooza event creation

import os
import json
import logging
from twitter import *
from ConfigParser import SafeConfigParser
from weather import Forecast
from locationchooser import LocationChooser

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

def dryrun():
    print("DRY RUN MODE")
    return os.getenv('DRY_RUN') != None

def main():
    # TODO - clean this up a bit, a bit racy
    # TODO - override functionality is broken!

    magic8ball = LocationChooser()
    if os.path.isfile('./override.json'):
        try:
            with open('./override.json', 'r') as file_handle:
                location = json.load(file_handle)
        except IOError, err:
            print(err)
        os.unlink('./override.json')
    else:
        # Let the bot choose a location
        location = magic8ball.select_location()

    notify_twitter(location)
    if not dryrun():
        magic8ball.add_location_to_prior_locations(location)

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    main()
