library(readr)
library(dplyr)
library(stringr)
library(sf)
library(plotly)
library(ggplot2)
library(gt)

source("correction/R/import_data.R")
source("correction/R/create_data_list.R")
source("correction/R/clean_dataframe.R")
source("correction/R/figures.R")


# Load data ----------------------------------
urls <- create_data_list("./sources.yml")


pax_apt_all <- import_airport_data(unlist(urls$airports))
pax_cie_all <- import_compagnies_data(unlist(urls$compagnies))
pax_lsn_all <- import_liaisons_data(unlist(urls$liaisons))

airports_location <- st_read(urls$geojson$airport)

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]

#1) Graph du trafic par aéroport
figure_plotly <- plot_airport_line(trafic_aeroports, default_airport)

#2) Tableau HTML
YEARS_LIST  <- as.character(2018:2022)
MONTHS_LIST <- 1:12

trafic_aeroports <- pax_apt_all %>%
  mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>%
  filter(apt %in% default_airport) %>%
  mutate(
    date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
  )

stats_aeroports <- summary_stat_airport(
  create_data_from_input(pax_apt_all, 2021, 6)
)

stats_liaisons  <- summary_stat_liaisons(
  create_data_from_input(pax_lsn_all, 2021, 6)
)
table_airports <- create_table_airports(stats_aeroports)


#3) Cartes des aéroports 
carte_interactive <- map_leaflet_airport(
  pax_apt_all, airports_location,
  month, year
)
