library(dplyr)
#importing data sets

agg_unemployment <- read.csv("data/raw_data/aggragate_total_unemployment.csv")
agg_crime <- read.csv("data/raw_data/aggragate_total_crime.csv")

#cleaning data: removing unnecessary rows, for agg_crime till 1975

agg_unemployment <- agg_unemployment[-c(51,52) ,]
agg_unemployment <- agg_unemployment[, -1]

agg_crime <- agg_crime[-82 , ]
agg_crime <- agg_crime[-c(1:31) ,]
agg_crime <- agg_crime[, -1]

# giving colnames

colnames(agg_unemployment) = c("year", "unemployment")
colnames(agg_crime) = c("year", "total_crimes")

#merging the two data set

agg_merged <- cbind(agg_unemployment, agg_crime[, 2])

#additional cleaning to make analysis easier

colnames(agg_merged) = c("year", "unemployment", "total_crime")

agg_merged <- agg_merged %>%
  mutate(total_crime = as.numeric(total_crime)) %>%
  mutate(year = as.numeric(year))

#use the following comand to check if all numerics are actually numerics
# and not characters, which is vital for the plots

str(agg_merged)

#importing raw population data

agg_population <- read.csv("data/raw_data/population_data_raw.csv")

#cleaning population data

agg_population <-agg_population[, -4]
agg_population <- agg_population[, -1]
agg_population <- agg_population[-c(1:75) ,]

#merging agg_pop to agg_merged

agg_merged <- cbind(agg_merged, agg_population[, 2])

#readjusting names

colnames(agg_merged) = c("year", "unemployment", "total_crime", "population")

# just like once before, use this command to see if everything is classed as numeric
str(agg_merged)

##adding per capita variable

agg_merged <- agg_merged %>%
  mutate(crime_per_capita = (total_crime/population)*100)





