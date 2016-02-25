#!/usr/bin/env python
# CoffeeOutsideBot
# Copyright 2016, David Crosby
# BSD 2-clause license
#
# TODO - add rest of the locations, etc
# TODO - automate weather forecast lookup
# TODO - automate Cyclepalooza event creation
# TODO - clean this ugly thing up

import json
import random
from twitter import *
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('./cb_config.ini')

tcreds = {}

# yuck
for section in ['twitter']:
    if parser.has_section(section):
        if section == 'twitter':
            for option in parser.options('twitter'):
                tcreds[option] = parser.get('twitter', option)

print(tcreds)

locations = []
try:
    with open('./winter_locations', 'r') as file_handle:
        for l in file_handle:
            if len(l.strip()) > 0:
                locations.append(l.strip())
except IOError, err:
    print(err)

location = random.choice(locations)
new_status = "This week's #CoffeeOutside is at " + location + ", see you there! #yycbike"
print(new_status)

# The Twitter Bits
t = Twitter(
    auth=OAuth(tcreds['token'], tcreds['token_secret'], tcreds['consumer_key'], tcreds['consumer_secret']))
t.statuses.update(status=new_status)
