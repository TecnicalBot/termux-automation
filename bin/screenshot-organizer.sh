#!/data/data/com.termux/files/usr/bin/bash
BASE="${AUTOMATION_HOME:-$HOME/automation}"; out="$BASE/data/screenshots"; mkdir -p "$out"; f="$out/screenshot-$(date +%Y%m%d-%H%M%S).png"
if command -v termux-screenshot >/dev/null 2>&1 && termux-screenshot -f "$f" >/dev/null 2>&1; then termux-toast "Screenshot saved"; exit 0; fi
if [ -x /system/bin/screencap ] && /system/bin/screencap -p "$f" >/dev/null 2>&1; then termux-toast "Screenshot saved"; exit 0; fi
termux-toast "Screenshot unavailable on this device"; exit 1
