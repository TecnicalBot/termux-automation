#!/data/data/com.termux/files/usr/bin/bash
case "${1:-info}" in
 play|pause|stop|info) timeout 8 termux-media-player "$1" 2>&1 || termux-toast "Media command failed";;
 next|previous) termux-toast "Universal next/previous is not available from Termux API"; exit 2;;
 *) echo "Usage: $0 play|pause|stop|info|next|previous"; exit 2;;
esac
