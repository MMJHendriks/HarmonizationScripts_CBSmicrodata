# function to get latest PRNL version of specified year
get_prnl_filename <- function(year) {
  fl <- list.files(
    path = file.path(loc$data_folder, loc$prnl_data, year),
    pattern = paste0(year,"V[0-9]+(?i)(.sav)"),
    full.names = TRUE
  )
  # return only the latest version
  sort(fl, decreasing = TRUE)[1]
}


# function to get latest KINDOUDERTAB version of specified year
get_kindouder_filename <- function(year) {
  fl <- list.files(
    path = file.path(loc$data_folder, loc$kindouder_data, year),
    pattern = paste0("KINDOUDER", year,"V[0-9]+(?i)(.sav)"),
    full.names = TRUE
  )
  # return only the latest version
  sort(fl, decreasing = TRUE)[1]
}


# function to get latest residence version of specified year
get_residence_filename <- function(year) {
  fl <- list.files(
    path = file.path(loc$data_folder, loc$residence_data),
    pattern = paste0("GBAADRESOBJECT", year),
    full.names = TRUE
  )
  # return only the latest version
  sort(fl, decreasing = TRUE)[1]
}


# function to get latest hoogsteopltab version of specified year
get_educ_filename <- function(year) {
  fl <- list.files(
    path = file.path(loc$data_folder, loc$educ_data, year),
    pattern = "(?i)(.sav)",
    full.names = TRUE
  )
  # return only the latest version
  sort(fl, decreasing = TRUE)[1]
}


  # function to get latest inpa version of specified year
get_inpa_filename <- function(year) {
  fl <- list.files(
    path = file.path(loc$data_folder, loc$income_data),
    pattern = paste0("INPA", year, "TABV[0-9]+(?i)(.sav)"),
    full.names = TRUE
  )
  #return only the latest version
  sort(fl, decreasing = TRUE)[1]
}


  # function to get latest ipi version of speified year
get_ipi_filename <- function(year) {
  # get all ipi files with the specified year 
  fl <- list.files(
    path = file.path(loc$data_folder, loc$income_ipi_data, year),
    pattern = paste0("PERSOONINK", year, "TABV[0-9]+(?i)(.sav)"),
    full.names = TRUE
  )
  #return only the latest version
  sort(fl, decreasing = TRUE)[1]
}


# function to get latest spolis version of specified year
get_spolis_filename <- function(year) {
  # get all spolis files with the specified year 
  fl <- list.files(
    path = file.path(loc$data_folder, loc$spolis_data, year),
    pattern = paste0(year, "V[0-9]+(?i)(.sav)"),
    full.names = TRUE
  )
  # return only the latest version
  sort(fl, decreasing = TRUE)[1]
}

# function to get latest spolis version of specified year
get_polis_filename <- function(year) {
  # get all spolis files with the specified year 
  fl <- list.files(
    path = file.path(loc$data_folder, loc$polis_data, year),
    pattern = paste0("POLISBUS", year, "V[0-9]+(?i)(.sav)"),
    full.names = TRUE
  )
  # return only the latest version
  sort(fl, decreasing = TRUE)[1]
}

# function to get latest ZVWKZORGKOSTEN version of specified year
get_zvwzorgkosten_filename <- function(year) {
  fl <- list.files(
    path = file.path(loc$data_folder, loc$zvwzorgkosten_data, year),
    pattern = paste0("ZVWZORGKOSTEN", year,"TABV[0-9]+(?i)(.sav)"),
    full.names = TRUE
  )
  # return only the latest version
  sort(fl, decreasing = TRUE)[1]
}
