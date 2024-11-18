#!/usr/bin/env bash

# fetch yearly sample data from https://datahub.io/core/global-temp
curl -L https://datahub.io/core/global-temp/r/annual.csv > global-temp-data.csv

# generate the plot
docker run --rm -v $(pwd):/work remuslazar/gnuplot global-temp.gp

# generate a plot with multiple data sets
docker run --rm -v $(pwd):/work remuslazar/gnuplot global-temp-multi.gp
