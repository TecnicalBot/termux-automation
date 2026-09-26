#!/data/data/com.termux/files/usr/bin/bash
if command -v termux-media-player >/dev/null 2>&1; then termux-media-player info; else termux-toast "Universal music gesture control is unavailable"; fi
