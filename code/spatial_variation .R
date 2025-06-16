install.packages(c("sf", "ggplot2"))
library(sf)
library(ggplot2)

install.packages("cbsodataR")
library(cbsodataR)
cbs_maps <- cbs_get_maps()
# the layout of the data.frame is:
str(cbs_maps)


#read the GeoJSON straight from PDOK 
nl_prov <- st_read(
  "https://cartomap.github.io/nl/wgs84/provincie_2014.geojson",
  quiet = TRUE
)



#Crime per capita by Dutch province – 2023 map

library(sf)
library(dplyr)
library(readr)
library(tmap)

# Reading the CSV  →  2023 only
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


# Drawing
tm_shape(nl_crime) +
  tm_polygons(
    col        = "crimes_per_capita",
    style      = "quantile",                   # Method for breaking data into intervals
    palette    = "Reds",                       # Correct argument to set the color palette
    border.col = "white",
    id         = "statnaam",                       # Using "name" from the NLD_prov dataset
    statnaam = c("Province" = "name", "Crime per capita (dummy)" = "crimes_per_capita")
  ) +
  tm_layout(
    title = "Crime per capita by Dutch province – 2023"
  )




# Population density by Dutch province - 2023

library(sf)       # spatial data
library(dplyr)    # data wrangling
library(readr)    # fast CSV reader
library(tmap)     # thematic mapping

pop <- read_csv("data/working_data/merged_panel_data_final.csv",
                show_col_types = FALSE) |>
  filter(year== 2023) |>
  mutate(
    region = sub(" \\(PV\\)$", "", province),      # <- use the province column
    region = recode(region, "Fryslân" = "Friesland")
  ) |>
  filter(!region %in% "Nederland")               # keep only provinces


# map form cbs

shapes <- read_sf("https://cartomap.github.io/nl/wgs84/provincie_2014.geojson")

#    shapes carries columns:  statcode (id)  statnaam (human name)  geometry


# Fixing the names

pop <- pop |> mutate(
  region = recode(region,
                  "Fryslân" = "Friesland")
)


# Joining the map with data 

nl_pop <- shapes |>
  left_join(pop, by = c("statnaam" = "region"))


# Drawing tmap v4 syntax

tmap_mode("view")   # 'plot' for static maps; 'view' gives leaflet interactivity

tm_shape(nl_pop) +
  tm_polygons(
    col        = "poplation_density",           
    fill.scale = tm_scale_intervals(style = "quantile",
                                    values = "viridis"),
    border.col = "white",
    id         = "statnaam",
    popup.vars = c("Population density" = "poplation_density")
  ) +
  tm_title("Population density by Dutch province - 2023")
