######################
####Initialization####
######################
library(tidyverse)
library(dplyr)
library(ggplot2)

######################
####Load Data#########   
######################

merged_panel_data_final <- read.csv("data/working_data/merged_panel_data_final.csv")


###########################################
####Filter Data to Use only Netherlands####
###########################################

NL_Data_Merged <- merged_panel_data_final %>%
  filter(province == "Nederland")





##############################
####Scatterplot+Regression####
##############################

ggplot(NL_Data_Merged, aes(x = unemployment_rate, y = crimes_per_capita)) +
  geom_point(aes(color = province), alpha = 0.5) +
  labs(title = "Scatterplot of Unemployment vs Crime per Capita.NL",
       x = "Unemployment Rate (%)",
       y = "Crime per Capita") +
  theme_minimal() +
  scale_color_manual(values = "Blue") +
  theme(legend.position = "right")+
  # Adding a linear regression line
  geom_smooth(method = "lm", se = TRUE, color = "Blue", fill = "lightblue")