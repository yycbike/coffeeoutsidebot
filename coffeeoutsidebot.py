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
    with open('./summer_locations', 'r') as file_handle:
        for l in file_handle:
            if len(l.strip()) > 0:
                locations.append(l.strip())
except IOError, err:
    print(err)

prior_locations = []
try:
    with open('./prior_locations', 'r') as file_handle:
        for l in file_handle:
            if len(l.strip()) > 0:
                prior_locations.append(l.strip())
except IOError, err:
    print(err)

while True:
    location = random.choice(locations)
    if location not in prior_locations[-5:]:
        break

print(prior_locations[-5:])

new_status = "This week's #CoffeeOutside is at " + location + ", see you there! #yycbike"
print(new_status)

try:
    with open('./prior_locations', 'a+') as file_handle:
        file_handle.write(location + "\n")
except IOError, err:
    print(err)

# The Twitter Bits
t = Twitter(
    auth=OAuth(tcreds['token'], tcreds['token_secret'], tcreds['consumer_key'], tcreds['consumer_secret']))
t.statuses.update(status=new_status)
