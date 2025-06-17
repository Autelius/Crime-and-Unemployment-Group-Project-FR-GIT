criminaliteit_per_leeftijd <- read.csv("data/raw_data/criminaliteit_per_leeftijd.csv")

crime2021 <- criminaliteit_per_leeftijd %>% filter(Perioden == "2021")

crime2021 <- crime2021 %>% filter(Geboorteland == "Totaal")

columns <- c("Leeftijdscategorie", "PercCriminilateit")

eindproduct <- columns

crime2021 <- crime2021[, -c(1:2)]
crime2021 <- crime2021[, -c(2:6)]

#making categories

crime2021$Leeftijd <- ifelse(crime2021$Leeftijd %in% c("12 tot 18 jaar", "18 tot 23 jaar"),
                                     "Youth (12–23)", "Adult+ (23+)")

colnames(crime2021) = c("leeftijdcat", "crime")

# making boxplot
# Create the boxplot
ggplot(crime2021, aes(x = leeftijdcat, y = crime)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  labs(
    title = "Boxplot of Crime Suspect Rate by Age Group",
    x = "Grouped Age Range",
    y = "Suspects per 10,000 Inhabitants"
  ) 

