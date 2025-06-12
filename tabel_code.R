#data van 2010-2012 verwijderen
crime_data_filtered <- crime_data_clean[crime_data_clean$Year > 2012, ]
#trasnpose van crime_data_clean
crime_data_filtered_transpose<- t(crime_data_filtered)
#adding filterd data to data folder
write.csv(crime_data_filtered_transpose, "data/working_data_crime.csv")
# install tidyverse
install.packages("tidyverse")
library(tidyverse)
# adding data to data folder
write.csv(Arbeidsdeelname__provincie_10062025_140614, "data/unemployment_data_clean.csv")
# deleting the first row of crime data
crime_data_cut <- crime_data_filtered[, -1]
#adding population data to the data folder
write.csv(Population_data, "data/population_data.csv")
