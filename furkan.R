

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




dat <- read.csv("data/unemployment_data_clean.csv",        
                stringsAsFactors = FALSE)


dat_t <- as.data.frame(t(dat))

head(dat_t)

write.csv(dat_t, "data/dat_t.csv")







# ---- 1.  Very small set of packages --------------------------------
# run this INSTALL line just once
install.packages(c("sf", "ggplot2", "readr", "gganimate", "dplyr", "viridis"))

library(sf)          # maps
library(ggplot2)     # plotting
library(readr)       # read_csv()
library(dplyr)       # joins / pipes
library(gganimate)   # slider
library(viridis)     # colour-blind-safe scale

# ---- 2.  Read your panel -------------------------------------------
crime <- read_csv("panel_data_crime.csv")      # columns: Year, Region, Total_Crimes

# ---- 3.  Get the official province shapes (CBS via PDOK) -----------
prov <- st_read(
  "https://service.pdok.nl/cbs/gebiedsindelingen/2024_1/"
  |> paste0("geojson/cbs_gebiedsindelingen_2024_1_provincie.geojson"),
  quiet = TRUE
) |>
  select(statnaam, geometry)                   # keep only name + geometry

# ---- 4.  Join shapes with crime data -------------------------------
mapdf <- prov |>
  left_join(crime, by = c(statnaam = "Region")) |>
  filter(!is.na(Total_Crimes))                 # drop rows with no data

# ---- 5.  Build the map and add the slider --------------------------
p <- ggplot(mapdf) +
  geom_sf(aes(fill = Total_Crimes)) +
  scale_fill_viridis_c() +
  theme_void() +
  labs(title = "Registered crimes by province",
       subtitle = "Year: {frame_time}",
       fill = "Crimes") +
  transition_time(Year)                        # << slider comes from here

# ---- 6.  Render to a small HTML file you can open in any browser ----
anim <- animate(p, renderer = html_renderer(), width = 650, height = 700, fps = 4)
anim_save("crime_nl_provinces.html", animation = anim)





# install once
install.packages(c("sf", "ggplot2"))

library(sf)
library(ggplot2)



install.packages("cbsodataR")
library(cbsodataR)
cbs_maps <- cbs_get_maps()
# the layout of the data.frame is:
str(cbs_maps)


# 1. read the GeoJSON straight from PDOK 
nl_prov <- st_read(
  "https://cartomap.github.io/nl/wgs84/provincie_2014.geojson",
  quiet = TRUE
)

# 2. quick visual check 
ggplot(nl_prov) + geom_sf(fill = "lightgrey") + theme_void()




# merging crime per capita and provincial map
install.packages(c("sf", "dplyr", "readr", "tmap"))   # tmap is optional but handy


# ------------------------------------------------------------
#  Crime-per-capita choropleth – Dutch provinces
# ------------------------------------------------------------
#  ONE-TIME setup (uncomment if you haven't done this before):
#  install.packages(c("sf", "dplyr", "readr", "tmap"))
#  -----------------------------------------------------------

# 1. Load the libraries --------------------------------------
library(sf)       # spatial data
library(dplyr)    # data wrangling
library(readr)    # fast CSV reader
library(tmap)     # thematic mapping

# 2. Read your crime table -----------------------------------
crime <- read_csv("data/working_data/final_merged_panel_data.csv") %>%
  mutate(
    province = sub(" \\(PV\\)$", "", Regio.s)   # drop " (PV)" suffix if present
  ) %>%
  filter(!province %in% "Nederland")            # keep only the provinces

# 3. Read the GeoJSON of provinces ---------------------------
# CBS map files use columns 'statcode' (id) and 'statnaam' (name)  :contentReference[oaicite:0]{index=0}
prov_shapes <- read_sf("https://cartomap.github.io/nl/wgs84/provincie_2014.geojson")

# 4. Join your data with the shapes --------------------------
nl_crime <- prov_shapes %>%
  left_join(crime, by = c("statnaam" = "province"))

# 5. Draw an interactive map with tmap -----------------------
tmap_mode("view")  # 'plot' for static maps; 'view' gives leaflet interactivity

tm_shape(nl_crime) +
  tm_polygons(
    col        = "per_capita",       # <-- replace with the exact column name in your CSV
    palette    = "Reds",
    style      = "quantile",
    border.col = "white",
    id         = "statnaam",
    popup.vars = c("Crime per capita" = "per_capita")
  ) +
  tm_layout(
    title = "Crime per capita by Dutch province"
  )
