# cleaning the data s.t. only Netherlands aggregate enters

dutch_data <- merged_data[1:12, ]

#creating a pivot longer to be used in the merged line graph

pivotdata_set <- pivot_longer(dutch_data, cols = c(unemployment, crime_per_capita), names_to = "mvar", values_to = "value")

#creating the line graph

ggplot(pivotdata_set, aes(x = year, y = value, colour = mvar)) + 
  geom_line() +
  labs(title = "line graph of unemployment and crime through time", x = "time", y = "Value") +
  scale_x_continuous(breaks = seq(2013, 2024, by = 2), limits = c(2012, 2025))






