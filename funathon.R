#1-import data 
#Données aéroport ----

#Permet d'avoir la liste des variables 
read_csv2(unlist(urls$airports))
import_airport_data <- function(list_files){
  pax_apt_all <- readr::read_csv2(
    list_files, 
    col_types = cols(
      ANMOIS = col_character(),
      APT = col_character(),
      APT_NOM = col_character(),
      APT_ZON = col_character(),
      .default = col_double()
    )
  ) %>% 
    clean_dataframe()
  
  return(pax_apt_all)
  
}

#Création d'une fonction créant deux colonne et met en minuscule le nom des colonne et lignes
clean_dataframe <- function(df){
  df <- df %>% 
    mutate(
      an = str_sub(ANMOIS,1,4),
      mois = str_sub(ANMOIS,5,6)
    ) %>%
    mutate(
      mois = str_remove(mois, "^0+")
    )
  colnames(df) <- tolower(colnames(df))
  
return(df)

#Données compagnies ----
  
import_compagnies_data <- function(list_files){
  pax_cie_all <- readr::read_csv2(
    file=list_files,
    col_types = cols(
      ANMOIS=col_character(),
      CIE=col_character(),
      CIE_NOM=col_character(),
      CIE_NAT=col_character(),
      CIE_PAYS=col-character(),
      .default=col_double()
    )
  ) %>% clean_dataframe()
  return(pax_cie_all)
}


#Données liaisons -----
  import_liaisons_data <- function(list_files){
    
    pax_lsn_all <- readr::read_csv2(
      file = list_files,
      col_types = cols(
        ANMOIS = col_character(),
        LSN = col_character(),
        LSN_DEP_NOM = col_character(),
        LSN_ARR_NOM = col_character(),
        LSN_SCT = col_character(),
        LSN_FSC = col_character(),
        .default = col_double()
      ) 
    ) %>% 
      clean_dataframe()
    
    return(pax_lsn_all)
    
  }

# Localisation aéroports ----
library(sf)
airports_location <- st_read(urls$geojson$airport)
