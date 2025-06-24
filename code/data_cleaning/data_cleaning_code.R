####################################################################
####I NNITIALIZING #################################################
####################################################################

library(dplyr)
library(readr)
library(tidyverse)
library(ggplot2)

DS_Panel_Unemployment <- read.csv("data/working_data/panel_data_unemployement.csv")
DS_Panel_Crime <- read.csv("data/working_data/panel_data_crime.csv")
DS_Population <- read.csv("data/population_data.csv")

####################################################################
##### merging unemployement_panel_data and total_crime_panel_data ##
####################################################################

merged_data <- cbind(DS_Panel_Unemployment, DS_Panel_Crime [, 5])

####################################################################
#### merging population data and merged_data #######################
####################################################################

merged_data <-cbind(merged_data, DS_Population [, 4])

####################################################################
#### renaming columns for clarity, and removing column 1,2 #########
####################################################################

merged_data <- merged_data [, -c(1:2)] 
colnames(merged_data) <- c("Year", "province", "Unemployment_Rate", "total_Crimes", "Population")
  
####################################################################
#### creating a new variable: crime per capita #####################
####################################################################

merged_data <- mutate(merged_data, crimes_per_capita = (total_Crimes/Population)*100)

write.csv(merged_data, "data/working_data/merged_panel_data_final.csv")

####################################################################
#### cleaning area per province data ###############################
####################################################################

area_data_working <- read.csv("data/raw_data/area_data.csv")

colnames(area_data_working) = c("X", "province", "Area(KM2)")

####################################################################
#### removing NA rows and converting hectares to km2 ###############
####################################################################

area_data_working <- area_data_working[6:17 ,]

area_data_working[[3]]  = as.numeric(area_data_working[[3]])

area_data_working[, 3] = area_data_working[, 3]/ 100

####################################################################
#### add flevoland to area_data_working ############################
####################################################################

flevoland <- data.frame(name = "Flevoland", value = 1417 )
colnames(flevoland) = c("province", "Area(KM2)")

area_data_working <- bind_rows(
  area_data_working[1:5, ], flevoland,  
  area_data_working[6:nrow(area_data_working), ]
)

####################################################################
##### now we transform area_data_working such that every province ##
##### repeats 12 times #############################################
####################################################################

area_data_working <- area_data_working %>%
  slice(rep(1:n(), each = 12))

####################################################################
#### now we cbind this result in the merged_data_set and adjusting #
#### colnames for clarity ##########################################
####################################################################

merged_panel_data_final <- cbind(merged_data, area_data_working[, 3])

colnames(merged_panel_data_final) <- c("year", "province", "unemployment_rate", "total_crimes", "population", "crimes_per_capita", "area_km2")

####################################################################
#### create a new variable: population density #####################
####################################################################

merged_panel_data_final <- mutate(merged_panel_data_final, poplation_density = population/area_km2)

write.csv(merged_panel_data_final, "data/working_data/merged_panel_data_final.csv")


####################################################################
#### Done :)! ######################################################
####################################################################

