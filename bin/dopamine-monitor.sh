#!/data/data/com.termux/files/usr/bin/bash
BASE="${AUTOMATION_HOME:-$HOME/automation}"; . "$BASE/bin/common.sh"; . "$BASE/config/dopamine.conf"; lock dopamine
[ "${DOPAMINE_ENABLED:-0}" = 1 ] || exit 0
while sleep "${DOPAMINE_INTERVAL:-900}"; do notify "Phone break" "Check your planned phone-use time."; say "Please take a mindful phone break."; done
