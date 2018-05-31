#!/usr/bin/env python
# CoffeeOutsideBot
# Copyright 2016-2017, David Crosby
# BSD 2-clause license
#
# TODO - automate Cyclepalooza event creation

import os
import json
import logging
from ConfigParser import SafeConfigParser
import openweathermapy.core as owm

class Forecast:
    def __init__(self, config_file='./cb_config.ini'):
        parser = SafeConfigParser()
        parser.read(config_file)

        self.owm_config = {}
        # yuck
        for section in ['openweathermap']:
            if parser.has_section(section):
                if section == 'openweathermap':
                    for option in parser.options('openweathermap'):
                        self.owm_config[option] = parser.get('openweathermap', option)

        self.forecast = self.get_forecast()

    def get_forecast(self):
        # Use Celsius
        # TODO remove hardcode for Calgary city id
        data = owm.get_forecast_daily(5913490, 3, **self.owm_config)
        logging.debug(data[2])
        return data[2]

    def temperature(self):
        return self.forecast['temp']['morn']

    def humidity(self):
        return self.forecast['humidity']

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    ee = Forecast()
    print("forecast temperature:", ee.temperature())
    print("forecast humidity:", ee.humidity())
