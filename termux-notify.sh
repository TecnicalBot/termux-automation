#!/data/data/com.termux/files/usr/bin/bash

# Define important keywords
IMPORTANT_KEYWORDS=("update" "security" "battery" "warning" "error" "alert" "urgent")

# Get notifications JSON
json=$(termux-notification-list)

# Loop through each notification
echo "$json" | jq -c '.[]' | while read -r notif; do
    title=$(echo "$notif" | jq -r '.title')
    content=$(echo "$notif" | jq -r '.content')

    # Lowercase combined text
    text=$(echo "$title $content" | tr 'A-Z' 'a-z')

    is_important=false

    # Keyword check
    for keyword in "${IMPORTANT_KEYWORDS[@]}"; do
        if echo "$text" | grep -q "$keyword"; then
            is_important=true
            break
        fi
    done

    if [ "$is_important" = true ]; then
        speak_msg="Important notification. Title: $title. Message: $content."
        termux-tts-speak "$speak_msg"
    fi
done
