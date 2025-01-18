#!/bin/bash

# Define the Betterbird process name
PROCESS_NAME="betterbird"

# Check if Betterbird is running
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "Betterbird is running. Killing the process..."
    # Kill the running Betterbird process
    pkill -x "$PROCESS_NAME"
    sleep 2  # Wait for the process to terminate
fi

# Start a new Betterbird process
echo "Starting Betterbird..."
betterbird &

