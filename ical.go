package main

import (
	"fmt"
	"log"
	"os"
	"time"
)

type IcalDispatch struct {
	dispatch      Dispatch
	creation_time time.Time
	output_file   string
}

func (i IcalDispatch) notify() {
	ical_file, err := os.Create("yyc.ics")
	if err != nil {
		log.Println("Couldn't write icalendar file")
	}
	defer ical_file.Close()
	ical_file.WriteString(i.event_string(time.Now()))
}

func (i IcalDispatch) event_string(creation_time time.Time) string {
	calendar_string := `BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
`

	stringformat := "20060102T150405"
	formatted_creation := creation_time.Format(stringformat)
	formatted_start := i.dispatch.start_time.Format(stringformat)
	formatted_end := i.dispatch.end_time.Format(stringformat)

	calendar_string += fmt.Sprintf("UID:%v@coffeeoutside.bike\n", formatted_creation)
	calendar_string += fmt.Sprintf("DTSTAMP;TZID=America/Edmonton:%v\n", formatted_creation)
	calendar_string += fmt.Sprintf("DTSTART;TZID=America/Edmonton:%v\n", formatted_start)
	calendar_string += fmt.Sprintf("DTEND;TZID=America/Edmonton:%v\n", formatted_end)

	calendar_string += fmt.Sprintf("SUMMARY:CoffeeOutside - %v\n", i.dispatch.location.Name)

	calendar_string += `END:VEVENT
END:VCALENDAR`

	return calendar_string
}
