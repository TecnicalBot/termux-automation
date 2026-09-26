#!/data/data/com.termux/files/usr/bin/bash
set -u
BASE="${AUTOMATION_HOME:-$HOME/automation}"; . "$BASE/bin/common.sh"; . "$BASE/config/emergency.conf"; lock emergency
last=$(cat "$BASE/data/emergency.last" 2>/dev/null || echo 0); now=$(date +%s)
if [ $((now-last)) -lt "${EMERGENCY_COOLDOWN_SECONDS:-60}" ]; then notify "Emergency cooldown" "Please wait before retrying."; exit 0; fi
printf '%s' "$now" > "$BASE/data/emergency.last"
notify "EMERGENCY ACTIVATED" "Help mode started"; vibe 1200
if [ -n "${EMERGENCY_NUMBERS:-}" ]; then
  if timeout 20 termux-sms-send -n "$EMERGENCY_NUMBERS" "$EMERGENCY_MESSAGE" >> "$BASE/logs/sms.log" 2>&1; then log SMS-sent; notify "Emergency SMS sent" "$EMERGENCY_NUMBERS"; else log SMS-failed; notify "SMS failed" "Check logs"; fi
else log SMS-skipped-no-contacts; notify "No emergency contacts" "Edit $BASE/config/emergency.conf"; fi
for i in 1 2 3 4 5 6; do timeout 3 termux-torch on >/dev/null 2>&1 || true; sleep .25; timeout 3 termux-torch off >/dev/null 2>&1 || true; sleep .25; done
say "Emergency activated. Please help."
log emergency-complete
