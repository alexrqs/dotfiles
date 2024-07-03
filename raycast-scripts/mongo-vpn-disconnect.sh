#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Mongo Disconnect VPN
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Dev

echo "Disconnected VPN"
networksetup -disconnectpppoeservice "Mongo"
