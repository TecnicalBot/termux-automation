#!/data/data/com.termux/files/usr/bin/bash
BASE="${AUTOMATION_HOME:-$HOME/automation}"
mkdir -p "$BASE/logs" "$BASE/data"
LOG="$BASE/logs/automation.log"
log(){ printf '%s %s\n' "$(date '+%F %T')" "$*" >> "$LOG"; }
notify(){ timeout 8 termux-notification --id automation -t "$1" -c "$2" >/dev/null 2>&1 || true; }
say(){ timeout 12 termux-tts-speak "$*" >/dev/null 2>&1 || true; }
vibe(){ timeout 5 termux-vibrate -d "${1:-300}" >/dev/null 2>&1 || true; }
lock(){ exec 9>"$BASE/data/$1.lock"; flock -n 9 || exit 0; }
