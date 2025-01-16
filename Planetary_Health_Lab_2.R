#Planetary health labs -- Peru dengue data:

rm(list=ls())
library(tidyverse)
library(lubridate)
library(doBy)
library(mosaic)
library(car)
library(sf)
library(sjPlot)
library(here)
library(tmap)

###################################
#Lab 2: Quantifying the environment
###################################

# GEE temperature data extraction to match with Peru dengue data

# 1) Run the GEE code to process, visualize and export temperature data in Peruvian districts



# 2a) Map temperature data by district as you did in lab 1 for dengue cases:
# read in Peru district file as a spatial dataset:
Peru_dist <- read_sf(here("data/per_admbnda_adm3_2018.shp")) # change file path for your context
head(Peru_dist)

# read in temperature data for all of Peru:
Peru_dist_temp <- read.csv(here("data/Peru_Temperature.csv")) # change file path if needed (, header=T)
head(Peru_dist_temp)
Peru_dist_temp$IDDIST <- str_pad(Peru_dist_temp$IDDIST, 6, pad = "0") # pad with leading 0 to match IDDIST in shapefile
Peru_dist_temp$system.index <- NULL

# merge temperature and spatial data:
Peru_dist_temp_merge <- merge(Peru_dist, Peru_dist_temp, by=c("IDDIST"), all.x=T, all.y=T)
head(Peru_dist_temp_merge)

# make a simple map in R:
plot(Peru_dist_temp_merge["mean"], nbreaks=20, breaks="kmeans", lwd=0.1)

# 2b) now make the map pretty! This can be done by building out the code above (or using another package like ggplot in R), or in ArcGIS (e.g.: https://www.youtube.com/watch?v=JEk5oaSx0eg)
# add a legend and title, and play around with the color palette and breaks

tm_graticules(lines = FALSE) + 
tm_shape(Peru_dist_temp_merge) + 
  tm_fill(col = "mean", style = "cont",
          palette = "viridis", 
          title = "Temperature (°C)", 
          showNA = FALSE) + 
  tm_compass(position = c("0.01", "0.87"), 
             size = 1.1) + 
  tm_scale_bar(position = c("left", "bottom")) +
  tm_layout(legend.outside = TRUE, 
            main.title = "Mean temperature (°C) by district in Peru")

# Repeat for another type of data, could be:
# a) another band from the ERA5 data (choose the precipitation band)
# b) population density (worldpop)
# c) land cover (NLCD)
# d) aerosol pollution (MODIS AOD)
# e) anything else you can imagine

# and could be using the same Peru shapefile to add data to the model for lab 3
# or could be for the other health data you explored in lab 1
