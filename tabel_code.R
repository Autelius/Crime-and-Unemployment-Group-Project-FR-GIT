#data van 2010-2012 verwijderen
crime_data_filtered <- crime_data_clean[crime_data_clean$Year > 2012, ]
#trasnpose van crime_data_clean
crime_data_filtered_transpose<- t(crime_data_filtered)