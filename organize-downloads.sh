#!/data/data/com.termux/files/usr/bin/bash

DOWNLOADS="$HOME/storage/downloads"
UNPROCESSED="$DOWNLOADS/unprocessed"

mkdir -p "$UNPROCESSED"

# Function to get folder name based on extension
get_folder() {
    case "$1" in
        jpg|jpeg|png|gif|webp|bmp|tiff) echo "images" ;;
        mp4|mkv|mov|avi|webm) echo "videos" ;;
        mp3|wav|m4a|flac|aac|ogg) echo "audio" ;;
        pdf) echo "pdf" ;;
        txt|md|rtf) echo "documents" ;;
        doc|docx|ppt|pptx|xls|xlsx|csv) echo "office" ;;
        zip|rar|7z|tar|gz) echo "archives" ;;
        apk|xapk|apks) echo "apk" ;;
        json|xml|yaml|yml) echo "data" ;;
        *) echo "others" ;;
    esac
}

# Loop through FILES + SYMLINKS in downloads
for f in "$DOWNLOADS"/*; do
    [ -e "$f" ] || continue     # skip if nonexistent (globs)
    [ "$f" = "$UNPROCESSED" ] && continue

    filename=$(basename "$f")
    ext="${filename##*.}"
    ext="${ext,,}"  # lowercase

    folder=$(get_folder "$ext")
    target="$UNPROCESSED/$folder"

    mkdir -p "$target"
    mv -n -- "$f" "$target/"
done

echo "✔ All files moved into: $UNPROCESSED"
