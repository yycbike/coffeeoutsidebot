package main

import (
	"fmt"
	"time"
)

func generate_ical_event_string(creation_time time.Time, start_time time.Time, end_time time.Time, loc location) string {
	calendar_string := `BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
`

	stringformat := "20060102T150405"
	formatted_creation := creation_time.Format(stringformat)
	formatted_start := start_time.Format(stringformat)
	formatted_end := end_time.Format(stringformat)

	calendar_string += fmt.Sprintf("UID:%v@coffeeoutside.bike\n", formatted_creation)
	calendar_string += fmt.Sprintf("DTSTAMP;TZID=America/Edmonton:%v\n", formatted_creation)
	calendar_string += fmt.Sprintf("DTSTART;TZID=America/Edmonton:%v\n", formatted_start)
	calendar_string += fmt.Sprintf("DTEND;TZID=America/Edmonton:%v\n", formatted_end)

	calendar_string += fmt.Sprintf("SUMMARY:CoffeeOutside - %v\n", loc.Name)

	calendar_string += `END:VEVENT
END:VCALENDAR`

	return calendar_string
}
