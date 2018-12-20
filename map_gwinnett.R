# gwinnett_map.R
# created: December 9, 2018
# read in geocoded data 

# load libraries
library(tidyverse)
library(readxl)
library(leaflet)
library(sf)
library(tmap)
library(tidycensus)
library(tigris)
options(tigris_use_cache = TRUE)

gw_ih <- st_read("../invh/gwinnett/data/gwinnet_geocode_cadastral.geojson")

# test map
tm_shape(gw_ih) +
  tm_dots()

# map properties in leaflet
t <- leaflet(gw_ih, width = "100%") %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") %>%
  setView(-83.97,33.95, zoom = 10) %>%
  addCircles(col = "#4d89e2")

t


# read in 2008-2012 ACS data
tracts10 <- get_acs(geography = "tract",
                    variables = c("B19013_001E",
                                  'B25001_001E',
                                  'B25002_002E',
                                  'B25002_003E',
                                  'B25003_001E',
                                  'B25003_002E',
                                  'B25003_003E',
                                  'B02001_001E',
                                  'B02001_002E',
                                  'B02001_003E',
                                  'B25077_001E'),
                    county = "Gwinnett",
                    state = "GA",
                    survey = "acs5",
                    year = 2012,
                    output = 'wide') %>%
  rename(hhincome10 = "B19013_001E",
         tothu10 = 'B25001_001E',
         totocc10 = 'B25002_002E',
         totvac10 = 'B25002_003E',
         tottenure10 = 'B25003_001E',
         ownocc10 = 'B25003_002E',
         rentocc10 = 'B25003_003E',
         tpop10 = 'B02001_001E',
         white10 = 'B02001_002E',
         black10 = 'B02001_003E',
         medvalue10 = 'B25077_001E')  %>%
  mutate(hopct10 = round(100 * (ownocc10/tottenure10),1),
         rntpct10 = round(100 * (rentocc10/tottenure10),1),
         occpct10 = round(100 * (totocc10/tottenure10), 1),
         vacpct10 = round(100 * (totvac10/tottenure10), 1),
         whtpct10 = round(100 * (white10/tpop10), 1),
         blkpct10 = round(100 * (black10/tpop10), 1))

# medrent10 = 'B25031_001E'

# read in 2008-2012 ACS data
tracts17 <- get_acs(geography = "tract", 
                    variables = c("B19013_001E",'B25001_001E','B25002_002E',
                                  'B25002_003E','B25003_001E','B25003_002E',
                                  'B25003_003E', 'B02001_001E',
                                  'B02001_002E',
                                  'B02001_003E',
                                  'B17001_001E',
                                  'B17001_002E', 
                                  'B25077_001E', 
                                  'B25031_001E'),
                    county = "Gwinnett",
                    state = "GA",
                    year = 2017,
                    survey = "acs5",
                    geometry = TRUE,
                    output = 'wide') %>%
  rename(hhincome17 = "B19013_001E",
         tothu17 = 'B25001_001E',
         totocc17 = 'B25002_002E',
         totvac17 = 'B25002_003E',
         tottenure17 = 'B25003_001E',
         ownocc17 = 'B25003_002E',
         rentocc17 = 'B25003_003E',
         tpop17 = 'B02001_001E',
         white17 = 'B02001_002E',
         black17 = 'B02001_003E',
         tpov17 = 'B17001_001E',
         ipov17 = 'B17001_002E',
         medvalue17 = 'B25077_001E',
         medrent17 = 'B25031_001E') %>%
  mutate(hopct17 = round(100 * (ownocc17/tottenure17),1),
         rntpct17 = round(100 * rentocc17/tottenure17),1,
         occpct17 = round(100 * totocc17/tottenure17), 1,
         vacpct17 = round(100 * totvac17/tottenure17), 1,
         whtpct17 = round(100 * (white17/tpop17), 1),
         blkpct17 = round(100 * (black17/tpop17), 1),
         povrt17 = round(100 * (ipov17/tpov17),1))

# Join 2010 "tbl_df" to 2017 "sf"
acs_gwinnett <- merge(tracts17,tracts10, by = 'GEOID')