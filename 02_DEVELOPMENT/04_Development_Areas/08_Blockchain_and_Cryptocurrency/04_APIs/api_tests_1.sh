#!/bin/bash

# Define the API key
API_KEY="your_api_key_here"

# Define the API endpoint and the date ranges
API_URL="https://api.coingecko.com/api/v3/coins/monero/market_chart"
DAYS_1="1"
DAYS_7="7"
DAYS_30="30"
DAYS_365="365"

# Define the files to store the data in the home directory
OUTPUT_1="$HOME/monero_1_day_coingecko.txt"
OUTPUT_7="$HOME/monero_7_days_coingecko.txt"
OUTPUT_30="$HOME/monero_30_days_coingecko.txt"
OUTPUT_365="$HOME/monero_365_days_coingecko.txt"

# Function to fetch and process data
fetch_data() {
    local days=$1
    local output=$2
    local temp_file="temp_${days}.txt"

    # Fetch data
    curl -s "${API_URL}?vs_currency=usd&days=${days}" \
        -H "Authorization: Bearer ${API_KEY}" | \
    jq -r '.prices[] | "\(.0) \(.1)"' | \
    while read -r timestamp price; do
        # Convert milliseconds to seconds for the date command
        timestamp_seconds=$((timestamp / 1000))
        date_str=$(date -d @"${timestamp_seconds}" -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null)
        if [[ $? -ne 0 ]]; then
            echo "Invalid timestamp: $timestamp" >&2
            continue
        fi
        echo "$date_str $price"
    done > "$temp_file"

    # Check for curl and jq errors
    if [[ $? -ne 0 ]]; then
        echo "Error fetching data for ${days} days" >&2
        return 1
    fi

    # Sort data by date (assuming date format is ISO 8601)
    sort "$temp_file" > "$output"

    # Clean up
    rm "$temp_file"
}

# Fetch and process data for different ranges
fetch_data "$DAYS_1" "$OUTPUT_1"
fetch_data "$DAYS_7" "$OUTPUT_7"
fetch_data "$DAYS_30" "$OUTPUT_30"
fetch_data "$DAYS_365" "$OUTPUT_365"

echo "Data fetching and sorting complete."
