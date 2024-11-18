set xlabel 'Year'
set ylabel 'Mean'
set grid
set title 'Global Temperature'
set datafile separator ','
set term png size 800,450
set output 'global-temp-multi.png'

# data format
# Source,Year,Mean
# GCAG,2016,0.9363
# GISTEMP,2016,0.99
# GCAG,2015,0.8998
# GISTEMP,2015,0.87

plot 'global-temp-data.csv' every 2::0 skip 1 using 2:3 title 'GCAG' with lines linewidth 2, \
 'global-temp-data.csv' every 2::1 skip 1 using 2:3 title 'GISTEMP' with lines linewidth 2
