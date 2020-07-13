package main

// TODO - print forecast datetime, make sure it's accurate!!

import (
	"log"

	owm "github.com/briandowns/openweathermap"
)

type forecast struct {
	temp     int
	humidity int
}

func get_forecast(apiKey string, cityId int) (f forecast) {
	w, err := owm.NewForecast("5", "C", "en", apiKey)
	if err != nil {
		log.Fatalln(err)
	}

	w.DailyByID(cityId, 3)
	forecast_obj := w.ForecastWeatherJson.(*owm.Forecast5WeatherData)

	// split out details
	var fc forecast
	fc.temp = int(forecast_obj.List[2].Main.Temp)
	fc.humidity = forecast_obj.List[2].Main.Humidity
	return fc
}
