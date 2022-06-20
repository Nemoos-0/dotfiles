#!/bin/bash

# Terminate already running bar instances
killall -q i3bar
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar top &

