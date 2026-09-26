AUTOMATION SETUP
================

Created under: ~/automation
Boot launcher: ~/.termux/boot/start-automation

Implemented:
- Emergency action: vibration, SMS when contacts are configured, torch blink, TTS, notification, cooldown.
- Food monitor: low-battery and charging state notifications/TTS.
- Ambient-light monitor: turns torch on below LIGHT_ON_LUX after a delay and off above LIGHT_OFF_LUX.
- Horror studio: torch blink, vibration, TTS, notification.
- Soft dopamine reminder: disabled by default.
- Screenshot helper: uses termux-screenshot only if installed; otherwise reports unavailable.

Not implemented as a claim:
- Small Termux:GUI overlay/2-second hold: requires a successful overlay API test against this installed GUI build.
- Full-screen red GUI screen: requires Termux:GUI Activity implementation.
- Camera hand-wave music control: not provided by Bash/Termux API.
- Hard phone-use blocking: requires Android Digital Wellbeing, Accessibility, device-owner, or a native app.

Configure emergency contacts in:
~/automation/config/emergency.conf
Keep the list empty until ready. Use international format.

Useful commands:
~/automation/bin/diagnose.sh
~/automation/bin/emergency-action.sh
~/automation/bin/horror-studio.sh
~/automation/bin/screenshot-organizer.sh
cat ~/automation/logs/automation.log
pkill -f '$HOME/automation/bin/food-monitor.sh'
pkill -f '$HOME/automation/bin/light-monitor.sh'
~/.termux/boot/start-automation
