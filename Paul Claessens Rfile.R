# Importing quarterly Dataset
DS1 <- `Werklozename.(%.van.beroepsbevolking)`
write.csv(DS1, "data/Werkloosheid.csv")
# Install Rnatural Earth Package
install.packages("rnaturalearth")



install.packages(c("sf", "dplyr", "readr", "tmap")) 
# 1. Load the libraries 
library(sf)       # spatial data
library(dplyr)    # data wrangling
library(readr)    # fast CSV reader
library(tmap)     # thematic mapping

# 2. Reading the crime table
crime <- read_csv("data/working_data/merged_panel_data_final.csv") %>%
    mutate(
      province = sub(" \\(PV\\)$", "", Regio.s),
      province = recode(province,                         # ← fixes the spelling
                        "Fryslân" = "Friesland") # drop " (PV)" suffix if present
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

