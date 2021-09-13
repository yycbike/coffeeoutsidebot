package main

import (
	"bytes"
	"embed"
	"log"
	"os"
	"text/template"
	"time"
)

type IcalDispatch struct {
	dispatch    Dispatch
	output_file string
}

func (i IcalDispatch) notify() {
	ical_file, err := os.Create("yyc.ics")
	if err != nil {
		log.Println("Couldn't write icalendar file")
	}
	defer ical_file.Close()
	ical_file.WriteString(i.event_string(time.Now()))
}

// TODO put weather forecast in event
// TODO put location URL in event

//go:embed *tmpl
var f embed.FS

type IcalVars struct {
	CreationTime string
	StartTime    string
	EndTime      string
	LocationName string
	Geostr       string
}

func (i IcalDispatch) event_string(creation_time time.Time) string {
	var data IcalVars

	stringformat := "20060102T150405"
	data.CreationTime = creation_time.Format(stringformat)
	data.StartTime = i.dispatch.start_time.Format(stringformat)
	data.EndTime = i.dispatch.end_time.Format(stringformat)
	data.LocationName = i.dispatch.location.Name

	data.Geostr = ""
	if i.dispatch.location.Geostr != nil {
		data.Geostr = *i.dispatch.location.Geostr
	}

	tmpl := template.Must(template.ParseFS(f, "ical.tmpl"))
	var buf bytes.Buffer
	tmpl.Execute(&buf, data)

	return buf.String()
}
