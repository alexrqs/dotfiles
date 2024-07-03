#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Mongo Connect VPN
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Dev

echo "VPN!"
networksetup -connectpppoeservice "Mongo"
