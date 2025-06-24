####time series for provinces####
#################################

# cleaning the data s.t. only Netherlands aggregate enters

dutch_data <- merged_data[1:12, ]

#creating a pivot longer to be used in the merged line graph

pivotdata_set <- pivot_longer(dutch_data, cols = c(unemployment, crime_per_capita), names_to = "mvar", values_to = "value")

#creating the line graph

ggplot(pivotdata_set, aes(x = year, y = value, colour = mvar)) + 
  geom_line() +
  labs(title = "line graph of unemployment and crime through time", x = "time", y = "Value") +
  scale_x_continuous(breaks = seq(2013, 2024, by = 2), limits = c(2012, 2025))

##time series, using province data##

#first excluding aggregate data and making a long pivot#

merged_data2 <- merged_data[13:156, ]

pivotmerged <- pivot_longer(merged_data2, cols = c(unemployment, crime_per_capita), names_to = "mvar", values_to = "value")

#then making the graph 

ggplot(pivotmerged, aes(x = year, y = value, colour = mvar)) + 
  geom_smooth(method = "loess", span = 0.2, se = FALSE) +
  labs(x = "time(year)", y = "variable") +
  scale_x_continuous(breaks = seq(2013, 2024, by = 2), limits = c(2012, 2025))

##################################
###time series for aggragate######
##################################

#first make pivot data set which requires some additional cleaning

pivot_agg_data <- agg_merged %>%
  pivot_longer(cols = c(unemployment, crime_per_capita), names_to = "variable", values_to = "value")

# then make the plot

ggplot(pivot_agg_data, aes(x = year, y = value, colour = variable )) +
  geom_line() +
  labs(title = "aggragate crime and unemployment through time", x = "year", y = "variable") +
  scale_x_continuous(breaks = seq(1975, 2024, by = 5), limits = c(1972, 2026)) +
  geom_vline(xintercept = c(1979, 2008), 
             linetype = "solid", 
             color = "black", 
             size = 0.6) + 
  annotate("text", x = 1974, y = 9, label = "1979\noil-crisis") +
  annotate("text", x = 2017, y = 9, label = "2008\ngreat-recession")



