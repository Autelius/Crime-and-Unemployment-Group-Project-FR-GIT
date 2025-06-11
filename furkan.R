

# Read the data, skipping the first 5 metadata rows
# and setting the correct separator and decimal character.
DS2 <- read.table(
  "Crime-and-Unemployment-Group-Project-FR-GIT/data/unemployment_data",
  header = FALSE,      # We will add headers manually
  sep = ",",           # Values are separated by commas
  dec = ",",           # Decimals are represented by commas
  skip = 5,            # Skip the first 5 lines of metadata
  quote = "\""         # Values are enclosed in quotes
)

# The last row in the file is a source credit, which should be removed.
DS2 <- DS2[1:(nrow(DS2) - 1), ]

# Assigning proper column names. The first two columns are an index and the region, followed by years 2013-2024.
column_names <- c("Index", "Region", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024")
colnames(DS2) <- column_names

# Removing the first 'Index' column.
DS2 <- DS2[, -1]

# First few rows of our clean data frame
head(DS2)

# Saving as a new CSV file
write.csv(DS2, "unemployment_data_clean.csv", row.names = FALSE)