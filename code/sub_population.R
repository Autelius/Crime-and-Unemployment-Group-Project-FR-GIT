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

##sub population analysis for unemployment

unemployment_age <- read.csv("data/raw_data/unemployment_per_age.csv")

unemployment_age <- unemployment_age[-c(1:6, 19) ,]

unemployment_age <- unemployment_age[, -1]

colnames(unemployment_age) = c("leeftijd", "unemployment")

unemployment_age$leeftijd <- ifelse(unemployment_age$leeftijd %in% c("15 tot 20 jaar", "20 tot 25 jaar"),
                             "Youth", "Adult")

unemployment_age$unemployment <- gsub(",", ".", unemployment_age$unemployment)

# Convert character to numeric
unemployment_age$unemployment <- as.numeric(unemployment_age$unemployment)

ggplot(unemployment_age, aes(x = leeftijd, y = unemployment)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  labs(
    title = "Boxplot of Crime Suspect Rate by Age Group",
    x = "Grouped Age Range",
    y = "unemployment"
  ) 




