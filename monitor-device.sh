#!/data/data/com.termux/files/usr/bin/bash

TEMP_LIMIT=40
LOW_BATTERY_LIMIT=15

# Get battery info
data=$(termux-battery-status)
temp=$(echo "$data" | jq '.temperature')
percentage=$(echo "$data" | jq '.percentage')
status=$(echo "$data" | jq -r '.status')

# 🔥 Temperature alert
if (( $(echo "$temp > $TEMP_LIMIT" | bc -l) )); then
    termux-tts-speak "Warning! Phone temperature is ${temp} degree. Take action immediately."
fi

# 🔥 Low battery alert
if (( percentage < LOW_BATTERY_LIMIT )); then
    termux-tts-speak "Battery is critically low at $percentage percent. Please charge soon."
fi

# 🔥 Charging alert
if [ "$status" = "CHARGING" ]; then
    # Add any message if you want
    :
fi
