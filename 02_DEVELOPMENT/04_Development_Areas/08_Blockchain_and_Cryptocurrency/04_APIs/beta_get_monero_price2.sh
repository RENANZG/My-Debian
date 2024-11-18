#!/bin/bash

# CoinGecko API endpoint and time ranges
LIVE_PRICE_URL="https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=usd"
DAYS_7_AGO=7
DAYS_30_AGO=30
DAYS_365_AGO=365

# Fetch historical data for the past 7, 30, and 365 days
for days in $DAYS_7_AGO $DAYS_30_AGO $DAYS_365_AGO; do
  HISTORICAL_URL="https://api.coingecko.com/api/v3/coins/monero/market_chart?vs_currency=usd&days=$days"
  HISTORICAL_DATA_FILE="monero_${days}_days.summary.txt"

  # Download historical data
  curl -s "$HISTORICAL_URL" | grep -oP '\[\[.*?\]\]' | \
  sed 's/],\[/\n/g' | sed 's/^\[\[//;s/\]\]$//' | \
  sed 's/^\[\|\]$//g' | sed 's/\"//g' | \
  awk -F',' '{print strftime("%Y-%m-%d", $1/1000), $2}' > "$HISTORICAL_DATA_FILE"
done

# Define a function to handle weekends and format dates
gnuplot_script=$(cat <<'EOF'
reset

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
set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"
EOF
)

# Function to plot data
plot_data() {
  local file=$1
  local days=$2

  gnuplot -p -e "$gnuplot_script
    FILE = '$file'
    set xrange [*:*]
    set xtics 1*24*3600  # Set x-tics to one day intervals

    set multiplot layout 2,1

    # Plot with weekends included
    plot FILE using 1:2 with linespoints pointtype 7 linecolor rgb 'red' title 'With Weekends'

    # Plot without weekends
    set format x '%g'
    plot FILE using (dw5(timecolumn(1, \"%Y-%m-%d\"))):2 with linespoints pointtype 7 linecolor rgb 'web-green' title 'Without Weekends', \
         '' using (t0=dw5(timecolumn(1, \"%Y-%m-%d\"))):(NaN):xtic(dw7Tic(t0)) every 1

    unset multiplot
  "
}

# Loop through each data file and plot it
for file in monero_*.summary.txt; do
  echo "Plotting $file"
  days=$(echo $file | grep -oP '\d+')
  plot_data "$file" "$days"
done
