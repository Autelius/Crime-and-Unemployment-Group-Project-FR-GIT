
library(sf)
library(ggplot2)
library(dplyr)
library(readr)
library(cbsodataR)
cbs_maps <- cbs_get_maps()
# the layout of the data.frame is:
str(cbs_maps)


#read the GeoJSON straight from PDOK 
nl_prov <- st_read(
  "https://cartomap.github.io/nl/wgs84/provincie_2014.geojson",
  quiet = TRUE
)


# Reading the CSV  (2023) 
crime <- read_csv("data/working_data/merged_panel_data_final.csv",
                  show_col_types = FALSE) |>
  filter(year == 2023) |>
  mutate(
    province = sub(" \\(PV\\)$", "", province),        # use the *province* column 
    province = recode(province, "Fryslân" = "Friesland")
  ) |>
  filter(!province %in% "Nederland")


# Province shapes (CBS 2014)
prov_shapes <- read_sf("https://cartomap.github.io/nl/wgs84/provincie_2014.geojson")


# Join data → map
nl_crime <- prov_shapes |>
  left_join(crime, by = c("statnaam" = "province"))




#Crime per capita by Dutch province – 2023

ggplot(nl_crime) +
  geom_sf(aes(fill = crimes_per_capita), color = "white", size = 0.2) +
  scale_fill_gradient(
    low  = "#fee5d9",  # pale red
    high = "#a50f15",  # dark red
    na.value = "grey90",
    name = "Crime\nper capita"
  ) +
  labs(
    title = "Crime per capita by Dutch province – 2023"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text  = element_blank(),
    axis.ticks = element_blank()
  )



#Population density by Dutch province – 2023

ggplot(nl_crime) +
  geom_sf(aes(fill = poplation_density), color = "white", size = 0.2) +
  scale_fill_gradient(
    low  = "#deebf7",  # pale blue
    high = "#08306b",  # dark blue
    na.value = "grey90",
    name = "Population\ndensity"
  ) +
  labs(
    title = "Population density by Dutch province – 2023"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text  = element_blank(),
    axis.ticks = element_blank()
  )



#Unemployment rate by Dutch province – 2023

ggplot(nl_crime) +
  geom_sf(aes(fill = unemployment_rate), color = "white", size = 0.2) +
  scale_fill_gradient(
    low  = "#e5f5e0",  # pale green
    high = "#00441b",  # dark green
    na.value = "grey90",
    name = "Unemployment\nrate"
  ) +
  labs(
    title = "Unemployment rate by Dutch province – 2023"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text  = element_blank(),
    axis.ticks = element_blank()
  )