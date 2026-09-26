#!/data/data/com.termux/files/usr/bin/bash
BASE="${AUTOMATION_HOME:-$HOME/automation}"; . "$BASE/bin/common.sh"; . "$BASE/config/food.conf"; lock food
state=$(cat "$BASE/data/food.state" 2>/dev/null || echo normal)
while sleep 60; do
 j=$(termux-battery-status 2>/dev/null) || continue
 p=$(printf '%s' "$j" | jq -r .percentage); s=$(printf '%s' "$j" | jq -r .status)
 if [ "$p" -lt "$FOOD_VERY_HUNGRY_PERCENT" ] && [ "$state" != very ]; then say "I am very hungry. I need food immediately."; notify "Very hungry" "Battery $p percent"; state=very
 elif [ "$p" -lt "$FOOD_HUNGRY_PERCENT" ] && [ "$state" = normal ]; then say "I am hungry. I need food."; notify Hungry "Battery $p percent"; state=hungry
 elif [ "$s" = CHARGING ] || [ "$s" = FULL ]; then [ "$state" = eating ] || { say "I am eating."; notify Charging "I am charging."; }; [ "$p" -ge "$FOOD_DONE_PERCENT" ] && state=done || state=eating
 elif [ "$s" = DISCHARGING ] && [ "$state" = done ]; then say "I am done with my food."; notify Done "Charging session complete."; state=normal; fi
 printf '%s' "$state" > "$BASE/data/food.state"
done
