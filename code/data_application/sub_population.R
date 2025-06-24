criminaliteit_per_leeftijd <- read.csv("data/raw_data/criminaliteit_per_leeftijd.csv")

crime2021 <- criminaliteit_per_leeftijd %>% filter(Perioden == "2021")

crime2021 <- crime2021 %>% filter(Geboorteland == "Totaal")

crime2021 <- crime2021[, -c(1:2, 4:8)]

colnames(crime2021) <- c("Age", "Crime")

crime2021$Crime = (crime2021$Crime/10000)*100

#making categories

crime2021$Age <- ifelse(crime2021$Age %in% c("12 tot 18 jaar", "18 tot 23 jaar"),
                                     "Youth (12–23)", "Adult+ (23+)")

# making boxplot
# Create the boxplot
ggplot(crime2021, aes(x = Age, y = Crime)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  labs(
    title = "Boxplot of Crime Suspect Rate by Age Group",
    x = "Age category",
    y = "Crime Rate"
  ) 

##sub population analysis for unemployment

unemployment_age <- read.csv("data/raw_data/unemployment_per_age.csv")

unemployment_age <- unemployment_age[-c(1:6, 19) ,]

unemployment_age <- unemployment_age[, -1]

colnames(unemployment_age) = c("Age", "Unemployment")

unemployment_age$Unemployment <- gsub(",", ".", unemployment_age$Unemployment)

unemployment_age$Unemployment <- as.numeric(unemployment_age$Unemployment)


unemployment_age$Age <- ifelse(unemployment_age$Age %in% c("15 tot 20 jaar", "20 tot 25 jaar"),
                             "Youth (15-25)", "Adult (25+)")

# Convert character to numeric
unemployment_age$Unemployment <- as.numeric(unemployment_age$Unemployment)

ggplot(unemployment_age, aes(x = Age, y = Unemployment)) +
  geom_boxplot(fill = "skyblue", color = "darkblue") +
  labs(
    title = "Boxplot of Crime Suspect Rate by Age Group",
    x = "Age category",
    y = "unemployment"
  ) 





