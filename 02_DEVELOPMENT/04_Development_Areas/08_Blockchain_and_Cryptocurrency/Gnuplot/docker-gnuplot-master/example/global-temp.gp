set xlabel 'Year'
set ylabel 'Mean'
set grid
set datafile separator ','
set term png size 800,450
set output 'global-temp.png'

# data format
# Source,Year,Mean
# GCAG,2016,0.9363
# GISTEMP,2016,0.99
# GCAG,2015,0.8998
# GISTEMP,2015,0.87

plot 'global-temp-data.csv' every 2::0 skip 1 using 2:3 title 'Global Temperature' with lines linewidth 2
