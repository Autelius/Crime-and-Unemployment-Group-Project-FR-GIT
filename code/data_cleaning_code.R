
#merging unemployement_panel_data and total_crime_panel_data

merged_data <- cbind(unemployement_panel_data, crime_panel_data[, 4])

#merging population data and merged_data

merged_data <-cbind(merged_data, population_data[, 4])

#creating a new variable: crime per capita

merged_data <- mutate(merged_data, per_capita = (Total_Crimes/Population)*100)

write.csv(merged_data, "data/working_data/final_merged_panel_data.csv")

####cleaning area per province data####

area_data <- Volkstelling_oppervlakten_1930_14062025_133850

area_data_working <- area_data[, c(1, 5)]

colnames(area_data_working) = c("province", "Area(KM2)")

# removing NA rows

area_data_working <- area_data_working[6:17 ,]

#converting hectares to km2

area_data_working[[2]]  = as.numeric(area_data_working[[2]])

area_data_working[, 2] = area_data_working[, 2]/ 100

# add flevoland

flevoland <- data.frame(name = "Flevoland", value = 1417 )
colnames(flevoland) = c("province", "Area(KM2)")

area_data_working <- bind_rows(
  area_data_working[1:5, ], 
  flevoland, 
  area_data_working[6:nrow(area_data_working), ]
  
)

# now we transform this dataset such that every province repeats 12 times

area_data_working <- area_data_working %>%
  slice(rep(1:n(), each = 12))

# now we cbind this result in the merged_data_set

final_merged_panel_data <- cbind(final_merged_panel_data, area_data_working[, 2])

# cleaning data set more by adjusting colnames and deleteting unnessary columns

final_merged_panel_data <- final_merged_panel_data[, -1]

colnames(final_merged_panel_data) <- c("year", "province", "unemployment_rate", "total_crimes", "population", "crimes_per_capita", "area_km2")

#create a new variable: population density

final_merged_panel_data <- mutate(final_merged_panel_data, poplation_density = population/area_km2)

write.csv(final_merged_panel_data, "data/working_data/merged_panel_data_final.csv")



