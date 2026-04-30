#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Define variables relative to the script location
SAVE_DIR="$SCRIPT_DIR/../screenshot"
CONFIG_FILE="$SCRIPT_DIR/.devicerc"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FORCE_DISCOVER=false

# Parse flags
while [[ "$1" == --* ]]; do
    case "$1" in
        --discover|--refresh)
            FORCE_DISCOVER=true
            shift
            ;;
        *)
            # If it's not a flag, treat it as device ID
            break
            ;;
    esac
done

# Function to get Flutter selected device (primary method)
get_flutter_device() {
    flutter devices --machine 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for device in data.get('devices', []):
        if device.get('supported', True):
            print(device.get('id', ''))
            break
except:
    pass
" 2>/dev/null
}

# Function to get first online device from mobilecli (fallback)
get_mobilecli_device() {
    mobilecli devices 2>/dev/null | jq -r '.data.devices[0].id // empty' 2>/dev/null
}

# Function to save device ID to config file
save_device_config() {
    echo "DEVICE_ID=\"$1\"" > "$CONFIG_FILE"
    echo "✓ Saved device ID to $CONFIG_FILE"
}

# Function to load device ID from config file
load_device_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        if [ -n "$DEVICE_ID" ]; then
            echo "$DEVICE_ID"
        fi
    fi
}

# Show usage information
show_usage() {
    echo "Usage: $0 [options] [device_id]"
    echo ""
    echo "Options:"
    echo "  --discover, --refresh    Force device discovery (skip cached device)"
    echo ""
    echo "Examples:"
    echo "  $0                       # Use cached device or auto-discover"
    echo "  $0 iPhone_15             # Use specific device and cache it"
    echo "  $0 --discover            # Force rediscover device"
    echo ""
    echo "Available devices:"
    mobilecli devices
}

# Determine device ID (in order of priority)
if [ "$FORCE_DISCOVER" = true ]; then
    # Force device discovery, skip cached config
    echo "🔍 Force discovering device..."
    FLUTTER_DEVICE=$(get_flutter_device)
    if [ -n "$FLUTTER_DEVICE" ]; then
        DEVICE_ID="$FLUTTER_DEVICE"
        echo "✓ Using VS Code Flutter selected device: $DEVICE_ID"
        save_device_config "$DEVICE_ID"
    else
        MOBILECLI_DEVICE=$(get_mobilecli_device)
        if [ -n "$MOBILECLI_DEVICE" ]; then
            DEVICE_ID="$MOBILECLI_DEVICE"
            echo "✓ Using first online device from mobilecli: $DEVICE_ID"
            save_device_config "$DEVICE_ID"
        else
            echo "Error: No online device found."
            show_usage
            exit 1
        fi
    fi
elif [ -n "$1" ]; then
    # Use device ID from command line argument
    DEVICE_ID="$1"
    echo "✓ Using provided device: $DEVICE_ID"
    save_device_config "$DEVICE_ID"
else
    # Try to load from config file
    CACHED_DEVICE=$(load_device_config)
    if [ -n "$CACHED_DEVICE" ]; then
        DEVICE_ID="$CACHED_DEVICE"
        echo "✓ Using cached device: $DEVICE_ID (use --discover to refresh)"
    else
        # Try Flutter device first
        FLUTTER_DEVICE=$(get_flutter_device)
        if [ -n "$FLUTTER_DEVICE" ]; then
            DEVICE_ID="$FLUTTER_DEVICE"
            echo "✓ Using VS Code Flutter selected device: $DEVICE_ID"
            save_device_config "$DEVICE_ID"
        else
            # Fall back to first device from mobilecli
            MOBILECLI_DEVICE=$(get_mobilecli_device)
            if [ -n "$MOBILECLI_DEVICE" ]; then
                DEVICE_ID="$MOBILECLI_DEVICE"
                echo "✓ Using first online device from mobilecli: $DEVICE_ID"
                save_device_config "$DEVICE_ID"
            else
                echo "Error: No online device found."
                show_usage
                exit 1
            fi
        fi
    fi
fi

FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

# Ensure the screenshot directory exists
mkdir -p "$SAVE_DIR"

# Capture screenshot
echo "Capturing device $DEVICE_ID..."
mobilecli screenshot --device "$DEVICE_ID" --output "$FILE_PATH"

# Output result
if [ $? -eq 0 ]; then
    echo "✓ Done! Screenshot saved to: $FILE_PATH"
else
    echo "Error: Capture failed. Check device connection."
    exit 1
fi