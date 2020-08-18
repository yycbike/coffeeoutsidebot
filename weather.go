package main

// TODO - print forecast datetime, make sure it's accurate!!

import (
	"log"

	owm "github.com/briandowns/openweathermap"
	"gopkg.in/ini.v1"
)

type WeatherService struct {
	config_file string
	city_id     int
	api_key     string
}

type forecast struct {
	temp     int
	humidity int
}

func (ws *WeatherService) load_config() {
	cfg, err := ini.Load("cb_config.ini")
	if err != nil {
		log.Fatalf("Fail to read file: %v", err)
	}

	ws.city_id, _ = cfg.Section("openweathermap").Key("cty_id").Int()
	ws.api_key = cfg.Section("openweathermap").Key("appid").String()

}

func (ws WeatherService) get_forecast() (f forecast) {
	ws.load_config()
	w, err := owm.NewForecast("5", "C", "en", ws.api_key)
	if err != nil {
		log.Fatalln(err)
	}

	w.DailyByID(ws.city_id, 3)
	forecast_obj := w.ForecastWeatherJson.(*owm.Forecast5WeatherData)

	// split out details
	var fc forecast
	fc.temp = int(forecast_obj.List[2].Main.Temp)
	fc.humidity = forecast_obj.List[2].Main.Humidity

	log.Printf("Weather temp %v", fc.temp)
	log.Printf("Weather humidity %v", fc.humidity)

	return fc
}
