

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






# We use read.csv because the separator is a comma.
# Learned that stringsAsFactors = FALSE would be helpful
crime_data_raw <- read.csv(
  "Crime-and-Unemployment-Group-Project-FR-GIT/data/crime_data",
  header = TRUE,
  stringsAsFactors = FALSE
)


# The last column contains the crime counts with dots as thousands separators.
# Getting the name of that column.
crime_count_col <- names(crime_data_raw)[ncol(crime_data_raw)]

# Removing the dots from the crime count column using gsub()
# The \\. is used to specify a literal dot.
crime_data_raw[[crime_count_col]] <- gsub("\\.", "", crime_data_raw[[crime_count_col]])

# Converting the cleaned column to a numeric type
crime_data_raw[[crime_count_col]] <- as.numeric(crime_data_raw[[crime_count_col]])


# Rename the columns for easier access
colnames(crime_data_raw) <- c("Index", "Crime_Type", "Year", "Region", "Total_Crimes")


# Removing the original 'Index' column
crime_data_clean <- crime_data_raw[, -1]


# Saved the cleaned data frame to a new CSV file
write.csv(
  crime_data_clean, 
  "crime_data_clean.csv", 
  row.names = FALSE # Prevents write.csv from adding another row number column
)

# clean data
cat("Data cleaning complete. Here are the first few rows of the clean data:\n")
print(head(crime_data_clean))

cat("\nAnd here is the structure of the data, showing 'Total_Crimes' is now numeric:\n")
str(crime_data_clean)




dat <- read.csv("unemployment_data_clean.csv",        
                stringsAsFactors = FALSE)


dat_t <- as.data.frame(t(dat))

head(dat_t)
