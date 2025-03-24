#!/bin/bash

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title=" To-Do List" \
    --no-buttons \
    --list \
    --column=Task: \
    --column=Priority: \
    --column=Due Date: \
    --timeout-indicator=bottom \
"Buy groceries" "High" "Tomorrow" \
"Complete project report" "Medium" "In 3 days" \
"Call the plumber" "Low" "This week" \
"Email boss about vacation" "High" "Today" \
"Finish reading book" "Medium" "This weekend" \
"Clean the house" "High" "Tomorrow" \
"Renew car insurance" "Low" "Next month" \
"Schedule dentist appointment" "Medium" "This month" \
"Prepare for presentation" "High" "In 2 days" \
"Backup important files" "Low" "Next week" \
"Buy new shoes" "Medium" "This weekend" \
"Organize closet" "Low" "Next month" \
"Fix broken door handle" "High" "Today" \
"Set up new laptop" "Medium" "This week" \
"Update resume" "Low" "In 2 weeks" \
"More tasks" "https://example.com" ""