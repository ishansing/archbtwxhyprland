#!/bin/bash

# Check if MPD is playing or paused
status=$(mpc status | grep -oE '\[playing\]|\[paused\]')
if [ -z "$status" ]; then
  exit 0
fi

artist=$(mpc -f "%artist%" current)
title=$(mpc -f "%title%" current)

# Fallback to filename if tags missing
if [ "$artist" = "N/A" ] && [ "$title" = "N/A" ]; then
  file=$(mpc -f "%file%" current)
  filename=$(basename "$file")
  filename="${filename%.*}"
  track="$filename"
elif [ "$artist" = "N/A" ]; then
  track="$title"
elif [ "$title" = "N/A" ]; then
  track="$artist"
else
  track="$artist - $title"
fi

# Output final formatted string
echo "  $track"
