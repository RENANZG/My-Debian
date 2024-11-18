#!/bin/bash

########################################################################
# File Name    : monero_prices.sh
# Description  : This script retrieves the prices of Monero (XMR) 
#                cryptocurrency for today, 7 days ago, 30 days ago, 
#                and 365 days ago from the CoinCap API. It then 
#                generates a comparison graph using gnuplot.
# Dependencies : curl, jq, gnuplot
# Usage        : • Make the script executable with:
#                chmod +x monero_prices.sh
#                • Run the script with [no arguments]:
#                bash monero_prices.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

API_HISTORY_URL="https://api.coincap.io/v2/assets/monero/history"
INTERVAL="d1"  # Daily intervals

# Calculate Unix timestamp in milliseconds
calculate_timestamp() {
    date -d "$1" +%s000
}

# Get price on a specific date
get_price_on_date() {
    local date=$1
    local start_timestamp=$(calculate_timestamp "$date")
    local end_timestamp=$((start_timestamp + 86400000))  # +1 day in milliseconds

    local response=$(curl -s "${API_HISTORY_URL}?interval=${INTERVAL}&start=${start_timestamp}&end=${end_timestamp}&limit=100")
    
    # Check if response is valid JSON
    if ! echo "$response" | jq empty >/dev/null 2>&1; then
        echo "Error: Invalid JSON response for date $date"
        echo "N/A"
        return
    fi

    local price=$(echo "$response" | jq -r '.data[0].priceUsd')

    if [ "$price" == "null" ] || [ -z "$price" ]; then
        echo "N/A"
    else
        echo "$price"
    fi
}

# Get the average price over a period
get_average_price() {
    local start_date=$1
    local end_date=$2
    local start_timestamp=$(calculate_timestamp "$start_date")
    local end_timestamp=$(calculate_timestamp "$end_date")

    local response=$(curl -s "${API_HISTORY_URL}?interval=${INTERVAL}&start=${start_timestamp}&end=${end_timestamp}&limit=10000")
    
    # Check if response is valid JSON
    if ! echo "$response" | jq empty >/dev/null 2>&1; then
        echo "Error: Invalid JSON response for period from $start_date to $end_date"
        echo "N/A"
        return
    fi

    local prices=$(echo "$response" | jq -r '.data[].priceUsd | select(. != null)')
    
    if [ -z "$prices" ]; then
        echo "N/A"
        return
    fi

    local total_price=$(echo "$prices" | awk '{s+=$1} END {print s}')
    local count=$(echo "$prices" | wc -l)

    if [ "$count" -eq 0 ]; then
        echo "N/A"
    else
        local average=$(echo "scale=2; $total_price / $count" | bc -l)
        echo "$average"
    fi
}

# Dates
today=$(date +%Y-%m-%d)
seven_days_ago=$(date -d "7 days ago" +%Y-%m-%d)
thirty_days_ago=$(date -d "30 days ago" +%Y-%m-%d)
one_year_ago=$(date -d "1 year ago" +%Y-%m-%d)

# Retrieve prices
today_price=$(get_price_on_date "$today")
seven_days_price=$(get_average_price "$seven_days_ago" "$today")
thirty_days_price=$(get_average_price "$thirty_days_ago" "$today")
one_year_price=$(get_average_price "$one_year_ago" "$today")

# Display prices
echo "Today's Price: $today_price USD"
echo "7 Days Ago Price: $seven_days_price USD"
echo "30 Days Ago Price: $thirty_days_price USD"
echo "1 Year Ago Price: $one_year_price USD"

# Prepare data for gnuplot
data_file="monero_prices.dat"
echo -e "Date\tPrice" > "$data_file"

# Append data to the file
echo -e "$today\t$today_price" >> "$data_file"
echo -e "$(date -d "7 days ago" +%Y-%m-%d)\t$seven_days_price" >> "$data_file"
echo -e "$(date -d "30 days ago" +%Y-%m-%d)\t$thirty_days_price" >> "$data_file"
echo -e "$(date -d "1 year ago" +%Y-%m-%d)\t$one_year_price" >> "$data_file"

# Check if data file is empty
if [ ! -s "$data_file" ]; then
    echo "No valid data to plot."
    exit 1
fi

# Plot with gnuplot
gnuplot -persist <<-EOFMarker
    set title "Monero (XMR) Prices Comparison"
    set xlabel "Date"
    set ylabel "Price (USD)"
    set xdata time
    set timefmt "%Y-%m-%d"
    set format x "%Y-%m-%d"
    set xtics rotate
    plot "$data_file" using 1:2 with linespoints title "Monero Prices"
EOFMarker
