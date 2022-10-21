#### CBS DATA KOPPEL PIPELINE ####

# script to (1) generate a koppelbestand, (2) bind CBS data multiple years per subject, 
# (3) join the koppelbestand with the subject data, and (4) restruture the data into a long format 

# load the necessary libraries 
library(tidyverse)
library(readxl)
library(haven)
library(lubridate)

# input the desired config file here:
cfg_file <- "preprocessing_set.yml"

# load the configuration 
cfg <- config::get("data_preparation", file = cfg_file)
loc <- config::get("file_locations", file = cfg_file)

# run 
# load the necessary functions to get the filenames
source("functions_filenames.R")

# generate a koppelbestand
source("koppelbestand.R")

# bind the CBS data per subject over the years
source("cbsdata_big.R")

# join the koppelbestand with the subjectdata
source("join_bestand.R")

# restructure the data into long format
source("restructure_bestand.R")

# bind all the datasets into one big dataset named CHILD
source("bind_CHILDdata.R")

