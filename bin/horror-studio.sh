#!/data/data/com.termux/files/usr/bin/bash
BASE="${AUTOMATION_HOME:-$HOME/automation}"; . "$BASE/bin/common.sh"; notify Horror "Starting horror studio"; for i in 1 2 3 4 5 6 7 8; do timeout 3 termux-torch on >/dev/null 2>&1 || true; vibe 120; sleep .35; timeout 3 termux-torch off >/dev/null 2>&1 || true; sleep .25; done; say "Welcome to the horror studio"; log horror-complete
