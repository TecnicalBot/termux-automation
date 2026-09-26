#!/data/data/com.termux/files/usr/bin/bash
BASE="${AUTOMATION_HOME:-$HOME/automation}"; . "$BASE/bin/common.sh"; . "$BASE/config/light.conf"; lock light
state=off; since=0
while sleep 5; do
 x=$(timeout 4 termux-sensor -s "$LIGHT_SENSOR" -n 1 2>/dev/null | jq -r '.[].values[0]' 2>/dev/null | head -1); [ -n "$x" ] || continue
 if awk -v x="$x" -v t="$LIGHT_ON_LUX" 'BEGIN{exit !(x<=t)}'; then
  [ "$since" -gt 0 ] || since=$(date +%s)
  if [ "$state" = off ] && [ $(( $(date +%s)-since )) -ge "$LIGHT_DARK_SECONDS" ]; then timeout 3 termux-torch on >/dev/null 2>&1 || true; state=on; notify "Dark environment" "Torch enabled"; log "light-on lux=$x"; fi
 elif awk -v x="$x" -v t="$LIGHT_OFF_LUX" 'BEGIN{exit !(x>=t)}'; then
  since=0
  if [ "$state" = on ]; then timeout 3 termux-torch off >/dev/null 2>&1 || true; state=off; notify Light "Torch disabled"; log "light-off lux=$x"; fi
 fi
done
