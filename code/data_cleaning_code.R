
#merging unemployement_panel_data and total_crime_panel_data

merged_data <- cbind(unemployement_panel_data, crime_panel_data[, 4])

#merging population data and merged_data

merged_data <-cbind(merged_data, population_data[, 4])

#creating a new variable: crime per capita

merged_data <- mutate(merged_data, per_capita = (Total_Crimes/Population)*100)

write.csv(merged_data, "data/working_data/final_merged_panel_data.csv")