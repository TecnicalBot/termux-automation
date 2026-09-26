#!/data/data/com.termux/files/usr/bin/bash
set -u
BASE=/data/data/com.termux/files/home/automation
case "${1:-status}" in
  screenshot) exec "$BASE/bin/screenshot-organizer.sh" ;;
  horror) exec "$BASE/bin/horror-studio.sh" ;;
  emergency) exec "$BASE/bin/emergency-action.sh" ;;
  food) termux-battery-status | jq . ;;
  music) exec "$BASE/bin/music-control.sh" "${2:-info}" ;;
  status) termux-notification --id automation-menu --title Automation --content "Use assistive-menu.sh screenshot, horror, emergency, food, or music" ;;
  *) echo "Usage: assistive-menu.sh screenshot|horror|emergency|food|music"; exit 2 ;;
esac
