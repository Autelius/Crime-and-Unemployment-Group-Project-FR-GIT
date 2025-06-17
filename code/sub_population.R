criminaliteit_per_leeftijd <- read_csv("data/raw_data/criminaliteit_per_leeftijd.csv")

criminaliteit2021 <- criminaliteit_per_leeftijd %>% filter(Perioden == "2021")

criminaliteit2021 <- criminaliteit2021 %>% filter(Geboorteland == "Totaal")

columns <- c("Leeftijdscategorie", "PercCriminilateit")

eindproduct <- columns
