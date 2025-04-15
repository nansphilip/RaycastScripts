#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Resize (stage manager)
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ↔️

# Documentation:
# @raycast.author nansp
# @raycast.authorURL https://raycast.com/nansp

# Check if the application detected 
window_check=$(yabai -m query --windows --window 2>/dev/null)

if [ -z "$window_check" ] || [[ "$window_check" == "null" ]]; then
    terminal-notifier \
        -title "Resize (stage manager)" \
        -message "Native apps are not supported." \
        -appIcon "./scaling.png"
    exit 0
fi

# Top, right and bottom gap
gap=15

# Stage manager gap
stage_manager_gap=160

# Get screen information
screen_json=$(yabai -m query --displays --window)

screen_origin_x=$(echo "$screen_json" | jq -r '.frame.x | floor')
screen_origin_y=$(echo "$screen_json" | jq -r '.frame.y | floor')

## Maximize window
yabai -m window --move abs:"$screen_origin_x:$screen_origin_y"
yabai -m window --resize abs:"5000:3000"

# Get window information
window_json=$(yabai -m query --windows --window)

# Screen dimensions and position
screen_w=$(echo "$screen_json" | jq -r '.frame.w | floor')
screen_h=$(echo "$screen_json" | jq -r '.frame.h | floor')
screen_x=$(echo "$screen_json" | jq -r '.frame.x | floor')
screen_y=$(echo "$screen_json" | jq -r '.frame.y | floor')

# Window dimensions and position
window_w=$(echo "$window_json" | jq -r '.frame.w | floor')
window_h=$(echo "$window_json" | jq -r '.frame.h | floor')
window_x=$(echo "$window_json" | jq -r '.frame.x | floor')
window_y=$(echo "$window_json" | jq -r '.frame.y | floor')

# Calculate menu bar height
top_diff=$((${window_y#-} - ${screen_y#-}))
top_diff_abs=$((${top_diff#-}))

# Window active position
x=$((screen_x + stage_manager_gap + gap))
y=$((screen_y + top_diff_abs + gap))

# Window active dimensions
w=$((window_w - stage_manager_gap - gap * 2))
h=$((window_h - gap * 2))

# Apply position to active window
yabai -m window --move abs:"$x:$y"

# Apply a "reset" height
yabai -m window --resize abs:"$w:100"
# Then apply "correct" height
yabai -m window --resize abs:"$w:$h"
