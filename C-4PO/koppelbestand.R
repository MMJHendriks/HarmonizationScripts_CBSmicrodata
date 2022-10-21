#### select birthcohort from prnl ####
 
# create a dataframe for the prnl data
koppel_dat <- tibble(rins = factor(), rin = character(),
                     rins_mo = factor(), rin_mo = character())

# loop to bind the prnl data from the available years
for (year in seq(format(dmy(cfg$prnl_year_min), "%Y"),
                 format(dmy(cfg$prnl_year_max), "%Y"))) { 
  
  if (year >= 2008) { 
    koppel_dat <- read_sav(get_prnl_filename(year),
                         col_select = c("rinpersoon_kind", "rinpersoons_kind_uitgebreid", 
                                        "rinpersoon_moeder", "rinpersoons_moeder", "datumkind")) %>% 
      # rename variables for clarity and continuity 
      rename(rins = rinpersoons_kind_uitgebreid,
             rin = rinpersoon_kind,
             rins_mo = rinpersoons_moeder,             
             rin_mo = rinpersoon_moeder,
             birthdate = datumkind) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             rins_mo = as_factor(rins_mo, levels = "values"),
             birthdate = ymd(birthdate)) %>% 
      # add to data
      bind_rows(koppel_dat, .)
    
  } else if (year <= 2007) {
    koppel_dat <- read_sav(get_prnl_filename(year),
                         col_select = c("rinkindnum", "srtnumkind", "rinma",
                                        "srtnummoeder", "datumkind")) %>%
      # rename variables for clarity and continuity
      rename(rins = srtnumkind,
             rin = rinkindnum,
             rins_mo = srtnummoeder,
             rin_mo = rinma,
             birthdate = datumkind) %>%
      mutate(rins = as_factor(rins, levels = "values"),
             rins_mo = as_factor(rins_mo, levels = "values"),
             # keep leading zeros
             rin = sprintf("%09d", rin),
             rin_mo = sprintf("%09d", rin_mo),
             rin = as.character(rin),
             rin_mo = as.character(rin_mo),
             birthdate = ymd(birthdate)) %>% 
      # add to data
      bind_rows(koppel_dat, .) 
  }
}

#remove duplicate rows
koppel_dat <- unique(koppel_dat)

# check if all of the prnl kids have a registered mother 
colSums(is.na(koppel_dat))
# there are no NAs for rin_mo


#### add parents to birthcohort from GBA ####
kindouder_path <- file.path(loc$data_folder, loc$kindouder_data)

koppel_dat <- left_join(
  x = koppel_dat,
  y = read_sav(kindouder_path) %>% 
    select(-(c("XKOPPELNUMMER"))) %>% 
    as_factor(only_labelled = TRUE, levels = "values"),
  by = c("rins" = "RINPERSOONS", "rin" = "RINPERSOON")) %>% 
  rename(rins_fa = RINPERSOONSpa,
         rin_fa = RINPERSOONpa,
         rins_mo2 = RINPERSOONSMa,
         rin_mo2 = RINPERSOONMa) 
# after the join the koppel_dat still has the same number of observations, as it should

# check if all of the prnl kids have a registered mother and father
 
# first, check NAs resulting from the join
sum(is.na(koppel_dat$rin_mo2))
# there are 14113 NAs for rin_mo
sum(is.na(koppel_dat$rin_fa))
# there are 14113 NAs for rin_fa
# so, 14364 kids with mothers are recorded in prnl who do not exist in kindouder_path (GBA?)

# clean the koppel_dat to recognise NAs in kindouder_path
koppel_dat <- koppel_dat %>% 
  mutate(rin = ifelse(rin == "       NA", "", rin),
         rin_fa = ifelse(rin_fa == "---------", NA, rin_fa),
         rin_mo2 = ifelse(rin_mo2 == "---------", NA, rin_mo2))

# second, check NAs total resulting from the join and NAs recorded for parents in kindouder_path
sum(is.na(koppel_dat$rin_fa))
# there are 97522 NAs for rin_fa
sum(is.na(koppel_dat$rin_mo2))
# there are 14136 NAs for rin_mo2

# check if the mother recorded in prnl is the same as the mother in kindouder_path
sum(!is.na(koppel_dat$rin_mo == koppel_dat$rin_mo2))
# is 2213957, if you add the number of NAs (14136) this adds up to the total number of observations

# prnl and kindouder_path were joined succesfully 
# we now have a dataset containing the kids in the birthcohort and their parents

# select a subset of the data
# set seed to ensure reproducability 
# set.seed(1234)
# koppel_dat <- koppel_dat %>% sample_n(1000, replace = FALSE)


saveRDS(koppel_dat, "koppel_data.rds")

