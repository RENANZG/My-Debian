#!/bin/bash

# CoinGecko API endpoints
LIVE_PRICE_URL="https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=usd"

# Historical data endpoint configuration
DAYS_7_AGO=7
CURRENT_TIMESTAMP=$(date +%s)
FROM_TIMESTAMP_7_DAYS_AGO=$(date -d "$DAYS_7_AGO days ago" +%s)

# Fetch historical data for the past 7 days
HISTORICAL_URL="https://api.coingecko.com/api/v3/coins/monero/market_chart?vs_currency=usd&days=$DAYS_7_AGO"
HISTORICAL_DATA_FILE=$(mktemp)

# Download historical data
curl -s "$HISTORICAL_URL" | grep -oP '\[\[.*?\]\]' | sed 's/],\[/\n/g' | sed 's/^\[\[//;s/\]\]$//' | sed 's/^\[\|\]$//g' | sed 's/\"//g' | awk -F',' '{print strftime("%Y-%m-%d", $1/1000), $2}' > "$HISTORICAL_DATA_FILE"

# Define functions to handle weekends and format dates
gnuplot_script=$(cat <<EOF
reset

FILE = "$HISTORICAL_DATA_FILE"

# Define constants
SecPerDay    = 3600*24
SecPerWeek   = 7*SecPerDay

# Functions to handle weekends and format dates
isWeekend(t) = int(tm_wday(t)+1)%7 < 2
myTimeFmt    = "%Y-%m-%d"
tOff         = tm_year(0)==1970 ? 3 : 5     # offset for gnuplot5.x: 3, gnuplot4.x: 5
dw5(t)       = isWeekend(t) ? NaN : int(t/SecPerDay) - 2*int((t+tOff*SecPerDay)/SecPerWeek)
dw5tow7(n)   = n==n ? n*SecPerDay + (int(n+tOff)/5)*2*SecPerDay : NaN
dw7Tic(n)    = n==n ? strftime(myTimeFmt,dw5tow7(n)) : ''

# Set plot settings
set key top center out noautotitle
set grid x,y
set ytics 1
set xtics rotate by -45
set xlabel "Date"
set ylabel "Price (USD)"

# Set x-axis range and format
set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"
set xrange [*:*]
set xtics 1*24*3600  # Set x-tics to one day intervals

set multiplot layout 2,1

    # Plot with weekends included
    plot FILE using 1:2 with linespoints pointtype 7 linecolor rgb "red" title "With Weekends"

    # Plot without weekends
    set format x "%g"
    plot FILE using (dw5(timecolumn(1,"%Y-%m-%d"))):2 with linespoints pointtype 7 linecolor rgb "web-green" title "Without Weekends", \
         '' using (t0=dw5(timecolumn(1,"%Y-%m-%d"))):(NaN):xtic(dw7Tic(t0)) every 1

unset multiplot
EOF
)

# Execute the gnuplot script
echo "$gnuplot_script" | gnuplot -p

# Clean up
rm "$HISTORICAL_DATA_FILE"
