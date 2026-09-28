# Termux Automation Suite

A collection of Android automations built with Termux, Termux:API, Termux:GUI, and Termux:Boot.

## Included automations

- Emergency action: notification, vibration, optional SMS, torch blink, TTS, and cooldown.
- Floating SOS overlay using Termux:GUI.
- Food monitor for battery and charging state.
- Ambient-light monitor with configurable torch thresholds.
- Horror-studio alert effects.
- Optional dopamine reminder.
- Screenshot/download helpers.

## Requirements

Install these Android apps from compatible sources:

- Termux
- Termux:API
- Termux:GUI
- Termux:Boot

Inside Termux, install the required command-line packages used by the scripts:

```bash
pkg update
pkg install bash coreutils jq termux-api
```

Install or verify the matching Termux:GUI Bash binding according to the Termux:GUI release instructions. The command used by this project is `tgui-bash`.

## Configuration

The emergency configuration is intentionally empty by default:

```bash
nano ~/automation/config/emergency.conf
```

Example local configuration (do not commit real contact details):

```bash
EMERGENCY_NUMBERS="+1234567890"
EMERGENCY_MESSAGE="EMERGENCY: I need help. Please call me immediately."
```

Keep this file private. It is ignored by Git and should have mode `600`:

```bash
chmod 600 ~/automation/config/emergency.conf
```

The emergency action will not send SMS while `EMERGENCY_NUMBERS` is empty. Never test with a real contact unless you understand that the message will be sent.

## Starting services

Start the boot launcher manually:

```bash
bash ~/automation/boot/start-automation
```

For automatic startup, create the Termux:Boot link:

```bash
mkdir -p ~/.termux/boot
ln -sf ~/automation/boot/start-automation ~/.termux/boot/start-automation
```

Open Termux:GUI once and grant **Display over other apps** permission. Disable battery optimization for Termux and its add-ons if the device stops background services.

## Emergency overlay behavior

The floating SOS button triggers the emergency action on a **long-click only**. A normal tap is logged but does not send SMS. This is a safety feature.

The overlay depends on the Termux:GUI version and Android device. Verify it manually by checking:

```bash
tail -f ~/automation/logs/emergency-overlay.log
```

A successful start logs `overlay-ready`. A long-click should log `event=longClick` and `emergency-triggered`. With an empty contact list, the action performs local alerts and logs `SMS-skipped-no-contacts`.

## Diagnostics

```bash
bash ~/automation/bin/diagnose.sh
bash -n ~/automation/bin/*.sh ~/automation/boot/start-automation
```

Runtime logs and state are intentionally ignored by Git. Do not commit phone numbers, SMS logs, PID files, or Android-specific secrets.

## Limitations

This project is experimental and device-dependent. Android permissions, battery management, Termux:GUI versions, and add-on installation sources can affect behavior. It is not a guaranteed emergency-response system; maintain another reliable way to contact emergency services.
