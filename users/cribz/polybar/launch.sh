#!/usr/bin/env bash

#polybar main 2>&1 | tee /tmp/polybar.log & disown &
polybar 2>&1 | tee /tmp/polybar.log & disown &

echo "Polybar launched..."
