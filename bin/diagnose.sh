#!/data/data/com.termux/files/usr/bin/bash
BASE="${AUTOMATION_HOME:-$HOME/automation}"
for c in bash jq termux-battery-status termux-sensor termux-torch termux-vibrate termux-tts-speak termux-sms-send tgui-bash; do printf '%-24s %s\n' "$c" "$(command -v "$c" || echo MISSING)"; done
bash -n "$BASE"/bin/*.sh; echo bash-syntax-OK
