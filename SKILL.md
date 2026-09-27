---
name: termux-automation-builder
description: Build, audit, repair, and document Termux automations using Termux, Termux:API, Termux:GUI, and Termux:Boot, especially Bash-first background services, floating overlays, emergency actions, sensors, notifications, battery workflows, and boot startup.
keywords:
  - Termux
  - Termux:API
  - Termux:GUI
  - Termux:Boot
  - floating overlay
  - Bash automation
  - emergency button
  - Android automation
  - tgui-bash
  - sensor monitor
  - boot script
allowed-tools:
  - Read
  - Write
  - Edit
  - Create
  - List
  - Grep
---

# Termux Automation Builder

Use this skill whenever the user asks to create, repair, audit, or extend an automation using Termux, Termux:API, Termux:GUI, or Termux:Boot.

## Core operating rules

1. Do not guess Termux:GUI APIs, function signatures, command names, package paths, event names, or return formats.
2. Before changing files, inspect the live device:
   - Bash availability and `$PREFIX`.
   - `command -v` for required commands.
   - installed package versions with `pkg`/`dpkg`.
   - Termux:GUI local help/tutorial/source files.
   - available sensors using `termux-sensor -l`.
   - Android and device constraints when available.
3. Prefer Bash, but invoke GUI scripts through the actual installed GUI binding. Do not run a GUI binding script with ordinary `bash` unless the binding explicitly supports that.
4. Use absolute Termux paths where wrappers may clear or alter environment variables. Do not assume `/data/data/com.termux/files/usr/bin/sh` exists; verify it. Use Bash explicitly when needed.
5. Do not claim success merely because files were written. A feature is complete only after a live, feature-specific test and evidence in logs/process state.
6. If a feature is unsupported by these tools, say so clearly and implement a safe fallback only if appropriate. Never replace a requested small overlay with a full-screen Activity without explaining the difference.

## Research and version handling

- Prefer current official Termux, Termux:API, Termux:GUI, and Termux:Boot documentation/repositories.
- Verify that the Android add-on and Termux-side package are compatible and preferably from the same distribution source.
- Inspect the installed local GUI tutorial/API before writing code.
- Test a minimal GUI request before building the full application:
  1. basic Activity/control request;
  2. overlay creation;
  3. button creation and sizing;
  4. event registration;
  5. event delivery.
- Treat a scalar overlay activity ID differently from a normal Activity/task tuple. Do not blindly index GUI responses as arrays. Capture raw responses and stderr.
- If GUI IPC hangs, returns an error number, or returns no response, identify it as an Android add-on/binding/service issue rather than inventing a Bash fix.

## Overlay requirements

For a floating button:

- Use a true Termux:GUI overlay, not a lock-screen Activity.
- Explicitly set compact width and height in dp.
- Explicitly set position.
- Record activity and view IDs in logs.
- Prevent duplicate overlay processes and stale instances.
- Enable only the event types supported by the installed API.
- Verify that actual events arrive in the log.
- For a required hold duration, prefer measuring touch-down to touch-up duration when supported. Do not assume platform `longClick` is emitted or configurable.
- Ordinary click must not trigger emergency SMS if the user requested a long press.
- Secure lock-screen behavior is device/firmware dependent. Distinguish overlay behavior from lock-screen Activity behavior and report what was actually tested.

## Emergency automation safety

- Never invent or hard-code emergency contacts.
- Keep recipients and message in a protected config file, normally mode `600`.
- Leave recipients empty during installation unless the user explicitly provides them.
- Never send a real SMS during installation or diagnostics without explicit confirmation.
- Normalize/validate phone numbers and show the exact target before a manual test.
- Include cooldown/debounce and duplicate-send prevention.
- Provide logs for trigger, SMS attempt, success/failure, vibration, torch, TTS/audio, and notification.
- Make the emergency sequence modular: vibration, SMS, torch blinking, TTS, notification, alarm/audio, and optional red emergency screen.
- Use timeouts around Termux:API calls that can hang.
- Restore volume/torch state where practical.

## File and service design

Use an idempotent layout such as:

```text
~/automation/
├── bin/
├── boot/
├── config/
├── data/
├── logs/
└── README.txt
```

Recommended implementation practices:

- Shared Bash helper for logging, config loading, PID files, locks, notifications, TTS, and cleanup.
- Separate service scripts for unrelated monitors.
- PID files and lock files in runtime/state directories.
- `mkdir -p` before writes.
- `chmod 700` for private directories and `chmod 600` for secrets/config containing contacts.
- Use `flock` or equivalent where available.
- Start only one instance per service.
- Make boot launchers executable and use Bash explicitly.
- Termux:Boot scripts belong in `~/.termux/boot/`; the user must open Termux:Boot once after installation.
- Avoid recursive symlinks or boot launchers that execute themselves.
- Validate every generated script with `bash -n`.
- Use quoted heredocs or another safe method so `$HOME`, arrays, command substitutions, and paths are not expanded during file generation.
- After writing, inspect the first lines, file size, permissions, and relevant content.

## Diagnostics and health checks

Every substantial setup should provide:

- `diagnose.sh` or equivalent.
- Individual logs per service.
- Status commands showing process, PID, config, permissions, recent errors, and API availability.
- A safe self-test mode that does not send SMS or trigger destructive actions.
- Clear commands to start, stop, restart, view logs, configure, and uninstall.
- A final report separating:
  - actually installed;
  - actually tested;
  - currently running;
  - not tested;
  - unsupported or Android-limited.

When fixing a failure:

1. Reproduce it.
2. Capture the exact command, stderr, raw API response, and log.
3. Identify whether it is a script, binding, IPC, permission, package-version, or Android-policy problem.
4. Apply the smallest evidence-based change.
5. Re-run the specific failing test.
6. Check for duplicate/stale processes after retries.
7. Do not report completion until the test passes.

## Known capability boundaries

Do not promise these using only Bash plus Termux/Termux:API/GUI/Boot without additional components:

- Reliable camera-based hand-wave recognition.
- Universal Spotify/other-app next/previous control.
- Hard blocking of all phone use or apps.
- Guaranteed interaction with a secure lock screen.
- General system screenshots when no supported screenshot command or Android route exists.
- Guaranteed screen wake/unlock behavior.
- Guaranteed behavior after Samsung battery killing or Android policy changes.

Possible alternatives must be labeled as alternatives: Digital Wellbeing, Focus Mode, Accessibility/device-owner/native app, Tasker/plugins, ADB/wireless debugging, or a dedicated screenshot/gesture app.

## Sensors and monitors

- Discover the actual ambient-light sensor name locally; do not hard-code it without checking.
- Use decimal-safe comparisons for lux values.
- Use hysteresis, debounce, minimum dark/light duration, and battery cutoffs to prevent flickering and battery drain.
- For battery/charging monitors, persist state so TTS/notifications are not repeated every loop.
- Define exact thresholds and transitions before implementation.

## User interaction

Ask only for essential missing decisions, such as emergency recipients, hold duration, schedule, battery thresholds, or what “done charging” means. Otherwise use safe defaults, document them, and keep dangerous actions disabled until explicitly configured.

Always be concise but truthful. If a prior setup claimed success without verification, correct the record and re-audit instead of preserving the claim.
