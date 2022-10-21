#### KOPPEL DATA ####
koppel_dat <- readRDS("koppel_data.rds")

parents <- c(koppel_dat$rin_mo, koppel_dat$rin_fa)

#### BIRTH RECORDS PRNL DATA ####

# create a dataframe for the prnl data
prnl_dat <- tibble(rins = factor(), rin = character(), rins_mo = factor(),
                   rin_mo = character(), sex_at_birth = factor(), PRNL_mortality = factor(),
                   PRNL_birthweight = double(), PRNL_gestational_age = double(), 
                   PRNL_gestational_age_week = double(),
                   PRNL_parity = factor(), PRNL_origing_mo = factor(), 
                   PRNL_originv_mo = factor(), PRNL_multiples = factor(), year = numeric())

# loop to bind the prnl data from the available years
for (year in seq(format(dmy(cfg$prnl_year_min), "%Y"),
                 format(dmy(cfg$prnl_year_max), "%Y"))) { 
  
  if (year >= 2008) { 
    prnl_dat <- read_sav(get_prnl_filename(year),
                         col_select = c("rinpersoon_kind", "rinpersoons_kind_uitgebreid", 
                                        "rinpersoon_moeder", "rinpersoons_moeder",
                                        "datumkind", "geslachtkind", "sterfte", "gewichtkind_ruw", "amddd",
                                         "amww", "pariteit_cat2", "herkomst_g", "herkomst_v", "meerling")) %>% 
      
      # rename variables for clarity and continuity 
      rename(rins = rinpersoons_kind_uitgebreid,
             rin = rinpersoon_kind,
             rins_mo = rinpersoons_moeder,
             rin_mo = rinpersoon_moeder,
             birthdate = datumkind,
             sex_at_birth = geslachtkind,
             PRNL_mortality = sterfte,
             PRNL_birthweight = gewichtkind_ruw,
             PRNL_gestational_age = amddd,
             PRNL_gestational_age_week = amww,
             PRNL_parity = pariteit_cat2,
             PRNL_origing_mo = herkomst_g,
             PRNL_originv_mo = herkomst_v,
             PRNL_multiples = meerling) %>% 
      mutate(rins = as_factor(rins, levels = "value"),
             rins_mo = as_factor(rins_mo, levels = "value"),
             birthdate = ymd(birthdate),
             # set levels to check the labels 
             sex_at_birth = as_factor(sex_at_birth, levels = "labels"),
             PRNL_mortality = as_factor(PRNL_mortality, levels = "labels"),
             PRNL_parity = as_factor(PRNL_parity, levels = "labels"),
             PRNL_origing_mo = as_factor(PRNL_origing_mo, levels = "labels"),
             PRNL_originv_mo = as_factor(PRNL_originv_mo, levels = "labels"),
             PRNL_multiples = as_factor(PRNL_multiples, levels = "labels"),
             year = year) %>% 
      # add to data
      bind_rows(prnl_dat, .)

  } else if (year <= 2007) {
    prnl_dat <- read_sav(get_prnl_filename(year),
                         col_select = c("rinkindnum", "srtnumkind", "rinma", "srtnummoeder",
                                        "datumkind", "geslachtkind", "sterfte", "gewichtkind_ruw",
                                        "amddd", "amww", "pariteit_cat2", "herkomst_g", "herkomst_v", 
                                        "meerling")) %>%
      # rename variables for clarity and continuity
      rename(rins = srtnumkind,
             rin = rinkindnum,
             rins_mo = srtnummoeder,
             rin_mo = rinma,
             birthdate = datumkind,
             sex_at_birth = geslachtkind,
             PRNL_mortality = sterfte,
             PRNL_birthweight = gewichtkind_ruw,
             PRNL_gestational_age = amddd,
             PRNL_gestational_age_week = amww,
             PRNL_parity = pariteit_cat2,
             PRNL_origing_mo = herkomst_g,
             PRNL_originv_mo = herkomst_v,
             PRNL_multiples = meerling) %>%
      mutate(rins = as_factor(rins, levels = "value"),
             rins_mo = as_factor(rins_mo, levels = "value"),
             birthdate = ymd(birthdate),
             # keep leading zeros
             rin = sprintf("%09d", rin),
             rin_mo = sprintf("%09d", rin_mo),
             # convert numeric rin to character
             rin = as.character(rin),
             rin_mo = as.character(rin_mo),
             # clean rin and set NA to empty string
             rin = ifelse(rin == "       NA", "", rin),
             # clean other variables and show labels 
             sex_at_birth = as_factor(sex_at_birth, levels = "labels"),
             PRNL_mortality = as_factor(PRNL_mortality, levels = "labels"),
             PRNL_parity = as_factor(PRNL_parity, levels = "labels"),
             PRNL_origing_mo = as_factor(PRNL_origing_mo, levels = "labels"),
             PRNL_originv_mo = as_factor(PRNL_originv_mo, levels = "labels"),
             PRNL_multiples = as_factor(PRNL_multiples, levels = "labels"),
             year = year) %>%
      # add to data
      bind_rows(prnl_dat, .)
  }

}

prnl_dat <- unique(prnl_dat)

# if level names start with a capital change it to lower
levels(prnl_dat$sex_at_birth) <- tolower(levels(prnl_dat$sex_at_birth))
levels(prnl_dat$PRNL_mortality) <- tolower(levels(prnl_dat$PRNL_mortality))
levels(prnl_dat$PRNL_parity) <- tolower(levels(prnl_dat$PRNL_parity))
levels(prnl_dat$PRNL_origing_mo) <- tolower(levels(prnl_dat$PRNL_origing_mo))
levels(prnl_dat$PRNL_originv_mo) <- tolower(levels(prnl_dat$PRNL_originv_mo))
levels(prnl_dat$PRNL_multiples) <- tolower(levels(prnl_dat$PRNL_multiples))

#### PARENTS LINK GBA DATA ####
# load additional parent data from GBAPERSOONTAB
gba_path <- file.path(loc$data_folder, loc$gba_data)

# to do: try adding a filter for c("rin", "rins") in prnl 

gba_dat<-read_sav(gba_path, col_select = c("RINPERSOONS","RINPERSOON",
                                           "GBAGEBOORTEJAAR", "GBAGEBOORTEMAAND", "GBAGEBOORTEDAG", 
                                           "GBAGENERATIE", "GBAHERKOMSTGROEPERING")) %>% 
  
  filter(RINPERSOON %in% parents) %>% 
  mutate(birthday = dmy(paste(GBAGEBOORTEDAG, GBAGEBOORTEMAAND, GBAGEBOORTEJAAR, sep = "-"))) %>% 
  select(-GBAGEBOORTEJAAR, -GBAGEBOORTEMAAND, -GBAGEBOORTEDAG) %>% 
  mutate(RINPERSOONS = as_factor(RINPERSOONS, level = "values"),
         GBAHERKOMSTGROEPERING = as_factor(GBAHERKOMSTGROEPERING),
         GBAGENERATIE = as_factor(GBAGENERATIE)) %>% 
  rename(rins = RINPERSOONS,
         rin = RINPERSOON,
         GBA_origin = GBAHERKOMSTGROEPERING,
         GBA_generation = GBAGENERATIE)

saveRDS(gba_dat, "gba_dat.rds")

#### RESIDENCE DATA ####
residence_dat <- 
  read_sav(get_residence_filename(cfg$residence_year)) %>% 
  filter(RINPERSOON %in% parents) %>% 
  rename(rins = RINPERSOONS,
         rin = RINPERSOON,
         start_date = GBADATUMAANVANGADRESHOUDING,
         end_date = GBADATUMEINDEADRESHOUDING,
         residence = RINOBJECTNUMMER,
         residence_type = SOORTOBJECTNUMMER) %>% 
  mutate(rins = as_factor(rins, levels = "values"),
         residence_type = as_factor(residence_type, levels = "values"),
         start_date = ymd(start_date),
         end_date = ymd(end_date))


#### EDUCATION LEVEL #### 

# create a dataframe for the education level data
educ_dat <- tibble(rins = factor(), rin = character(), educationlevel = factor(), educationnr = factor(), year = numeric())

# loop to bind the hoogsteopltab data from the available years

for (year in seq(format(dmy(cfg$educ_year_min), "%Y"),
                 format(dmy(cfg$educ_year_max), "%Y"))) {
  if (year >= 1999 & year <= 2012){
    educ_dat <- read_sav(get_educ_filename(year),
                         col_select = c("RINPERSOONS","RINPERSOON", "OPLNRHB")) %>%  
      # filter only parents of kids in the birthcohort 
      filter(RINPERSOON %in% parents) %>% 
      # rename variables for clarity and consistency
      rename(rins = RINPERSOONS,
             rin = RINPERSOON,
             educationnr = OPLNRHB) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             educationnr = ifelse(educationnr == "----", NA, educationnr),
             educationnr = as.factor(educationnr),
             year = year) %>% 
      bind_rows(educ_dat, .)
    
  } else if (year >= 2013 & year <= 2018) { 
    educ_dat <- read_sav(get_educ_filename(year),
                         col_select = c("RINPERSOONS","RINPERSOON", "OPLNIVSOI2016AGG4HBMETNIRWO","OPLNRHB")) %>% 
      # filter only parents of kids in the birthcohort 
      filter(RINPERSOON %in% parents) %>%
      # rename variables for clarity and consistency
      rename(rins = RINPERSOONS,
             rin = RINPERSOON,
             educationlevel = OPLNIVSOI2016AGG4HBMETNIRWO,
             educationnr = OPLNRHB) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             educationlevel = ifelse(educationlevel == "----", NA, educationlevel),
             educationnr = ifelse(educationnr == "----", NA, educationnr),
             educationlevel = as.factor(educationlevel),
             educationnr = as.factor(educationnr),
             year = year) %>% 
      bind_rows(educ_dat, .)

  } else if (year >= 2019) {
    educ_dat <- read_sav(get_educ_filename(year),
                         col_select = c("RINPERSOONS","RINPERSOON", "OPLNIVSOI2021AGG4HBmetNIRWO", "OPLNRHB")) %>% 
      # filter only parents of kids in the birthcohort 
      filter(RINPERSOON %in% parents) %>%
      # rename variables for clarity and consistency
      rename(rins = RINPERSOONS,
             rin = RINPERSOON,
             educationlevel = OPLNIVSOI2021AGG4HBmetNIRWO,
             educationnr = OPLNRHB) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             educationlevel = ifelse(educationlevel == "----", NA, educationlevel),
             educationnr = ifelse(educationnr == "----", NA, educationnr),
             educationlevel = as.factor(educationlevel),
             educationnr = as.factor(educationnr),
             year = year) %>% 
      bind_rows(educ_dat, .)
  }
} 

# restructure year into start_data and end_date
educ_dat <- educ_dat %>% 
  mutate(
    start_date = as.Date(paste(year, 1, 1, sep = "-")),
    end_date = as.Date(paste(year, 12, 31, sep = "-"))) %>% 
  select(-year)

#### INCOME ####

income_dat <- tibble(rins = factor(), rin = character(), income = double())

# loop to bind the income data from the available years
for (year in seq(format(dmy(cfg$parent_income_year_min), "%Y"),
                 format(dmy(cfg$parent_income_year_max), "%Y"))) {
  if (year >= 2011 & year <= 2020) {
    income_dat <- read_sav(get_inpa_filename(year),
                         col_select = c("RINPERSOONS","RINPERSOON", "INPPERSBRUT")) %>% 
      filter(RINPERSOON %in% parents) %>%       
      rename(rins = RINPERSOONS,
             rin = RINPERSOON,
             income = INPPERSBRUT) %>%
      mutate(rins = as_factor(rins, levels = "values"),
             income = as.numeric(income),
             income = ifelse(income == "9999999999", NA, income),
             year = year) %>%

      bind_rows(income_dat, .)
    
  } else if (year >= 2003 & year <= 2010) {
    income_dat <- read_sav(get_ipi_filename(year),
                           col_select = c("RINPERSOONS","RINPERSOON", "PERSBRUT")) %>% 
                           # use skip and n_max in test run as to not make the dataframe too big 
      filter(RINPERSOON %in% parents) %>%       
      rename(rins = RINPERSOONS,
             rin = RINPERSOON,
             income = PERSBRUT) %>%
      mutate(rins = as_factor(rins, levels = "values"),
             income = as.numeric(income),
             income = ifelse(income == "999999999", NA, income),
             year = year) %>% 
      bind_rows(income_dat, .)
    
  }
}

# restructure year into start_data and end_date
income_dat <- income_dat %>% 
  mutate(
    start_date = as.Date(paste(year, 1, 1, sep = "-")),
    end_date = as.Date(paste(year, 12, 31, sep = "-"))) %>% 
  select(-year)


#### HOURLY INCOME ####
spolis_dat <- tibble(rins = factor(), rin = character(),
                     SPOLIS_wages = double(), SPOLIS_paidhours = double(), SPOLIS_contract = factor())

for (year in seq.int(cfg$parent_spolis_year_min, cfg$parent_spolis_year_max)) {
  if (year >= 2010 & year <= 2021) {
    spolis_dat <- read_sav(get_spolis_filename(year),
                           col_select = c("RINPERSOONS", "RINPERSOON", 
                                          "SDATUMAANVANGIKO", "SDATUMEINDEIKO",
                                          "SBASISLOON", "SBASISUREN", "SCONTRACTSOORT")) %>%
      filter(RINPERSOON %in% parents) %>% 
      rename(rins = RINPERSOONS, 
             rin = RINPERSOON, 
             start_date = SDATUMAANVANGIKO, 
             end_date = SDATUMEINDEIKO,
             SPOLIS_wages = SBASISLOON, 
             SPOLIS_paidhours = SBASISUREN, 
             SPOLIS_contract = SCONTRACTSOORT) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             SPOLIS_contract = as_factor(SPOLIS_contract, levels = "values"),
             start_date = ymd(start_date),
             end_date = ymd(end_date)) %>% 
      bind_rows(spolis_dat, .)
  }
}


polis_dat <- tibble(rins = factor(), rin = character(),
                     SPOLIS_wages = double(), SPOLIS_paidhours = double(), SPOLIS_contract = factor())

for (year in seq.int(cfg$parent_polis_year_min, cfg$parent_polis_year_max)) {
  if (year >= 2006 & year <= 2009) {
    polis_dat <- read_sav(get_polis_filename(year),
                           col_select = c("RINPERSOONS", "RINPERSOON", 
                                          "AANVBUS", "EINDBUS",
                                          "BASISLOON", "BASISUREN", "CONTRACTSOORT")) %>%
      filter(RINPERSOON %in% parents) %>% 
      rename(rins = RINPERSOONS, 
             rin = RINPERSOON, 
             start_date = AANVBUS, 
             end_date = EINDBUS,
             SPOLIS_wages = BASISLOON, 
             SPOLIS_paidhours = BASISUREN, 
             SPOLIS_contract = CONTRACTSOORT) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             SPOLIS_contract = as_factor(SPOLIS_contract, levels = "values"),
             start_date = ymd(start_date),
             end_date = ymd(end_date)) %>% 
      bind_rows(polis_dat, .)
  }
}


#### SOCIOECONOMIC ####

# select the most recent secm file 
secm_dat <- 
  read_sav(file.path(loc$data_folder, loc$secm_data)) %>% 
  select(-ONDERWIJSNR_crypt) %>% 
  as_factor(only_labelled = TRUE, levels = "values") %>% 
  # select only secm of parents in prnl data 
  filter(RINPERSOON %in% parents) %>% 
  # rename variables for clarity and consistency
  rename(
    rins = RINPERSOONS,
    rin = RINPERSOON,
    start_date = AANVSECM,
    end_date = EINDSECM,
    SECM = SECM,
    SECM_employee = XKOPPELWERKNSECM,
    SECM_director = XKOPPELDGASECM,
    SECM_selfemployed = XKOPPELZELFSTSECM,
    SECM_otherwork = XKOPPELOVACTIEFSECM,
    SECM_unemployed = XKOPPELWERKLUITKSECM,
    SECM_socialassistance = XKOPPELBIJSTANDSECM,
    SECM_otherassistance = XKOPPELSOCVOORZOVSECM,
    SECM_disability = XKOPPELZIEKTEAOSECM,
    SECM_retirement = XKOPPELPENSIOENSECM,
    SECM_student = XKOPPELSCHOLSTUDSECM,
    SECM_familywork = XKOPPELMEEWERKENDSECM) %>% 
  mutate(
    SECM_employee = ifelse(SECM_employee == "", NA, 1),
    SECM_director = ifelse(SECM_director == "", NA, 1),
    SECM_selfemployed = ifelse(SECM_selfemployed == "", NA, 1),
    SECM_otherwork = ifelse(SECM_otherwork == "", NA, 1),
    SECM_unemployed = ifelse(SECM_unemployed == "", NA, 1),
    SECM_socialassistance = ifelse(SECM_socialassistance == "", NA, 1),
    SECM_otherassistance = ifelse(SECM_otherassistance == "", NA, 1),
    SECM_disability = ifelse(SECM_disability == "", NA, 1),
    SECM_retirement = ifelse(SECM_retirement == "", NA, 1),
    SECM_student = ifelse(SECM_student == "", NA, 1),
    SECM_familywork = ifelse(SECM_familywork == "", NA, 1),
    start_date = ymd(start_date),
    end_date = ymd(end_date))


#### HEALTH COSTS ####  

health_dat <- tibble(rins = factor(), rin = character(),ZVWK_GP_basic = double(), ZVWK_GP_regist = double(),
                     ZVWK_GP_consult = double(), ZVWK_GP_other = double(), ZVWK_pharmacy = double(), ZVWK_dentalcare = double(),
                     ZVWK_hospital = double(), ZVWK_physical_therapy = double(), ZVWK_physical_other = double(), 
                     ZVWK_appliances = double(), ZVWK_patient_transport_sit = double(), ZVWK_patient_transport_lie = double(),
                     ZVWK_birth_obstetrician = double(), ZVWK_birth_maternitycare = double(), ZVWK_abroad = double(),
                     ZVWK_abroad_sub1 = double(), ZVWK_abroad_sub2 = double(), ZVWK_mentalhealth_bas = double(), 
                     ZVWK_mentalhealth_spec = double(), ZVWK_mentalhealth_spec_stay = double(), 
                     ZVWK_mentalh_spec_nostay_inst = double(), ZVWK_mentalh_spec_nostay_ind = double(),
                     ZVWK_mentalh_spec_other = double(), ZVWK_mentalh_spec_long = double(), 
                     ZVWK_geriatric = double(), ZVWK_localnurse = double(), ZVWK_multidisc = double(),
                     ZVWK_sensory = double(), ZVWK_total = double(), ZVWK_deductible = double(), 
                     ZVWK_primarycare_residence = double(), ZVWK_other = double(), year = integer())


for (year in seq(format(dmy(cfg$health_year_min), "%Y"),
                 format(dmy(cfg$health_year_max), "%Y"))) {
  
  if (year >= 2018 & year <= 2019) {
      health_dat <- read_sav(get_zvwzorgkosten_filename(year), 
                             col_select = c(-"ZVWKOPHOOGFACTOR", -"ZVWKHUISARTS", -"ZVWKPARAMEDISCH",
                                            -"ZVWKZIEKENVERVOER", -"ZVWKGEBOORTEZORG", -"ZVWKEERSTELIJNSPSYCHO",
                                            -"ZVWKGGZ", -"NOPZVWKGGZOVERIG")) %>%
        filter(RINPERSOON %in% parents) %>% 
        rename(
          rins = RINPERSOONS,
          rin = RINPERSOON,
          ZVWK_pharmacy = ZVWKFARMACIE, 
          ZVWK_dentalcare = ZVWKMONDZORG,
          ZVWK_hospital = ZVWKZIEKENHUIS, 
          ZVWK_appliances = ZVWKHULPMIDDEL,           
          ZVWK_abroad = ZVWKBUITENLAND,
          ZVWK_other = ZVWKOVERIG,
          ZVWK_mentalhealth_bas = ZVWKGENBASGGZ, 
          ZVWK_mentalhealth_spec = ZVWKSPECGGZ,
          ZVWK_mentalhealth_spec_stay = NOPZVWKGGZMV,
          ZVWK_mentalh_spec_nostay_inst = NOPZVWKGGZZVINST,
          ZVWK_mentalh_spec_nostay_ind = NOPZVWKGGZZVZELF,
          ZVWK_mentalh_spec_long = NOPZVWKLANGDGGZ,          
          ZVWK_geriatric = ZVWKGERIATRISCH,
          ZVWK_localnurse = ZVWKWYKVERPLEGING,          
          ZVWK_GP_basic = NOPZVWKEERSTELIJNSOND, 
          ZVWK_GP_regist = NOPZVWKHUISARTSINSCHRIJF,
          ZVWK_GP_consult = NOPZVWKHUISARTSCONSULT, 
          ZVWK_GP_other = NOPZVWKHUISARTSOVERIG, 
          ZVWK_physical_therapy = NOPZVWKFYSIOTHERAPIE, 
          ZVWK_physical_other = NOPZVWKPARAMEDISCHOV, 
          ZVWK_birth_obstetrician = NOPZVWKVERLOSKUNDE, 
          ZVWK_birth_maternitycare = NOPZVWKKRAAMZORG,
          ZVWK_patient_transport_sit = NOPZVWKZIEKENVERVOERZIT, 
          ZVWK_patient_transport_lie = NOPZVWKZIEKENVERVOERLIG,
          ZVWK_abroad_sub1 = NOPZVWKBUITENLGRENS, 
          ZVWK_abroad_sub2 = NOPZVWKBUITENLZINL, 
          ZVWK_multidisc = ZVWKMULTIDISC,
          ZVWK_sensory = ZVWKZINTUIGLIJK,
          ZVWK_total = ZVWKTOTAAL,
          ZVWK_deductible = NOPZVWKVRIJWILLIGEIGENRISICO,
          ZVWK_primarycare_residence = ZVWKEERSTELIJNSVERBLIJF) %>% 
        mutate(rins = as_factor(rins, levels = "values"),
               year = year) %>%
        bind_rows(health_dat, .)
      
  } else if (year == 2017) {
    health_dat <- read_sav(get_zvwzorgkosten_filename(year), 
                           col_select = c(-"ZVWKOPHOOGFACTOR", -"ZVWKHUISARTS", -"ZVWKPARAMEDISCH",
                                          -"ZVWKZIEKENVERVOER", -"ZVWKGEBOORTEZORG", -"ZVWKEERSTELIJNSPSYCHO",
                                          -"ZVWKGGZ", -"NOPZVWKGGZOVERIG")) %>%
      filter(RINPERSOON %in% parents) %>% 
      rename(
        rins = RINPERSOONS,
        rin = RINPERSOON,
        ZVWK_pharmacy = ZVWKFARMACIE, 
        ZVWK_dentalcare = ZVWKMONDZORG,
        ZVWK_hospital = ZVWKZIEKENHUIS, 
        ZVWK_appliances = ZVWKHULPMIDDEL,           
        ZVWK_abroad = ZVWKBUITENLAND,
        ZVWK_other = ZVWKOVERIG,
        ZVWK_mentalhealth_bas = ZVWKGENBASGGZ, 
        ZVWK_mentalhealth_spec = ZVWKSPECGGZ,
        ZVWK_mentalhealth_spec_stay = NOPZVWKGGZMV,
        ZVWK_mentalh_spec_nostay_inst = NOPZVWKGGZZVINST,
        ZVWK_mentalh_spec_nostay_ind = NOPZVWKGGZZVZELF,
        ZVWK_mentalh_spec_long = NOPZVWKLANGDGGZ,          
        ZVWK_geriatric = ZVWKGERIATRISCH,
        ZVWK_localnurse = ZVWKWYKVERPLEGING,          
        ZVWK_GP_basic = NOPZVWKEERSTELIJNSOND, 
        ZVWK_GP_regist = NOPZVWKHUISARTSINSCHRIJF,
        ZVWK_GP_consult = NOPZVWKHUISARTSCONSULT, 
        ZVWK_GP_other = NOPZVWKHUISARTSOVERIG, 
        ZVWK_physical_therapy = NOPZVWKFYSIOTHERAPIE, 
        ZVWK_physical_other = NOPZVWKPARAMEDISCHOV, 
        ZVWK_birth_obstetrician = NOPZVWKVERLOSKUNDE, 
        ZVWK_birth_maternitycare = NOPZVWKKRAAMZORG,
        ZVWK_patient_transport_sit = NOPZVWKZIEKENVERVOERZIT, 
        ZVWK_patient_transport_lie = NOPZVWKZIEKENVERVOERLIG,
        ZVWK_abroad_sub1 = NOPZVWKBUITENLGRENS, 
        ZVWK_abroad_sub2 = NOPZVWKBUITENLZINL, 
        ZVWK_multidisc = ZVWKMULTIDISC,
        ZVWK_sensory = ZVWKZINTUIGLIJK,
        ZVWK_total = ZVWKTOTAAL,
        ZVWK_deductible = NOPZVWKVRIJWILLIGEIGENRISICO) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             year = year) %>%
      bind_rows(health_dat, .)
    
  } else if (year >= 2015 & year <= 2016) {
    health_dat <- read_sav(get_zvwzorgkosten_filename(year), 
                           col_select = c(-"ZVWKOPHOOGFACTOR", -"ZVWKHUISARTS", -"ZVWKPARAMEDISCH",
                                          -"ZVWKZIEKENVERVOER", -"ZVWKGEBOORTEZORG", -"ZVWKEERSTELIJNSPSYCHO",
                                          -"ZVWKGGZ", -"NOPZVWKGGZOVERIG")) %>%
      filter(RINPERSOON %in% parents) %>% 
      rename(
        rins = RINPERSOONS,
        rin = RINPERSOON,
        ZVWK_pharmacy = ZVWKFARMACIE, 
        ZVWK_dentalcare = ZVWKMONDZORG,
        ZVWK_hospital = ZVWKZIEKENHUIS, 
        ZVWK_appliances = ZVWKHULPMIDDEL,           
        ZVWK_abroad = ZVWKBUITENLAND,
        ZVWK_other = ZVWKOVERIG,
        ZVWK_mentalhealth_bas = ZVWKGENBASGGZ, 
        ZVWK_mentalhealth_spec = ZVWKSPECGGZ,
        ZVWK_mentalhealth_spec_stay = NOPZVWKGGZMV,
        ZVWK_mentalh_spec_nostay_inst = NOPZVWKGGZZVINST,
        ZVWK_mentalh_spec_nostay_ind = NOPZVWKGGZZVZELF,
        ZVWK_mentalh_spec_long = NOPZVWKLANGDGGZ,          
        ZVWK_geriatric = ZVWKGERIATRISCH,
        ZVWK_localnurse = ZVWKWYKVERPLEGING,          
        ZVWK_GP_basic = NOPZVWKEERSTELIJNSOND, 
        ZVWK_GP_regist = NOPZVWKHUISARTSINSCHRIJF,
        ZVWK_GP_consult = NOPZVWKHUISARTSCONSULT, 
        ZVWK_GP_other = NOPZVWKHUISARTSOVERIG, 
        ZVWK_physical_therapy = NOPZVWKFYSIOTHERAPIE, 
        ZVWK_physical_other = NOPZVWKPARAMEDISCHOV, 
        ZVWK_birth_obstetrician = NOPZVWKVERLOSKUNDE, 
        ZVWK_birth_maternitycare = NOPZVWKKRAAMZORG,
        ZVWK_patient_transport_sit = NOPZVWKZIEKENVERVOERZIT, 
        ZVWK_patient_transport_lie = NOPZVWKZIEKENVERVOERLIG,
        ZVWK_abroad_sub1 = NOPZVWKBUITENLGRENS, 
        ZVWK_abroad_sub2 = NOPZVWKBUITENLZINL, 
        ZVWK_multidisc = ZVWKMULTIDISC,
        ZVWK_sensory = ZVWKZINTUIGLIJK) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             year = year) %>%
      bind_rows(health_dat, .)
    
  } else if (year == 2014) {
    health_dat <- read_sav(get_zvwzorgkosten_filename(year), 
                           col_select = c(-"ZVWKOPHOOGFACTOR", -"ZVWKHUISARTS", -"ZVWKPARAMEDISCH",
                                          -"ZVWKZIEKENVERVOER", -"ZVWKGEBOORTEZORG", -"ZVWKEERSTELIJNSPSYCHO",
                                          -"ZVWKGGZ", -"NOPZVWKGGZOVERIG", -"ZVWKWYKVERPLEGING")) %>%
      filter(RINPERSOON %in% parents) %>% 
      rename(
        rins = RINPERSOONS,
        rin = RINPERSOON,
        ZVWK_pharmacy = ZVWKFARMACIE, 
        ZVWK_dentalcare = ZVWKMONDZORG,
        ZVWK_hospital = ZVWKZIEKENHUIS, 
        ZVWK_appliances = ZVWKHULPMIDDEL,           
        ZVWK_abroad = ZVWKBUITENLAND,
        ZVWK_other = ZVWKOVERIG,
        ZVWK_mentalhealth_bas = ZVWKGENBASGGZ, 
        ZVWK_mentalhealth_spec = ZVWKSPECGGZ,
        ZVWK_mentalhealth_spec_stay = NOPZVWKGGZMV,
        ZVWK_mentalh_spec_nostay_inst = NOPZVWKGGZZVINST,
        ZVWK_mentalh_spec_nostay_ind = NOPZVWKGGZZVZELF,
        ZVWK_geriatric = ZVWKGERIATRISCH,
        ZVWK_GP_basic = NOPZVWKEERSTELIJNSOND, 
        ZVWK_GP_regist = NOPZVWKHUISARTSINSCHRIJF,
        ZVWK_GP_consult = NOPZVWKHUISARTSCONSULT, 
        ZVWK_GP_other = NOPZVWKHUISARTSOVERIG, 
        ZVWK_physical_therapy = NOPZVWKFYSIOTHERAPIE, 
        ZVWK_physical_other = NOPZVWKPARAMEDISCHOV, 
        ZVWK_birth_obstetrician = NOPZVWKVERLOSKUNDE, 
        ZVWK_birth_maternitycare = NOPZVWKKRAAMZORG,
        ZVWK_patient_transport_sit = NOPZVWKZIEKENVERVOERZIT, 
        ZVWK_patient_transport_lie = NOPZVWKZIEKENVERVOERLIG) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             year = year) %>%
      bind_rows(health_dat, .)
    
  } else if (year == 2013){
    health_dat <- read_sav(get_zvwzorgkosten_filename(year), 
                           col_select = c(-"ZVWKOPHOOGFACTOR", -"ZVWKHUISARTS", -"ZVWKPARAMEDISCH",
                                          -"ZVWKZIEKENVERVOER", -"ZVWKGEBOORTEZORG", -"ZVWKGENBASGGZ",
                                          -"ZVWKSPECGGZ", -"ZVWKWYKVERPLEGING")) %>%
      filter(RINPERSOON %in% parents) %>% 
      rename(
        rins = RINPERSOONS,
        rin = RINPERSOON,
        ZVWK_pharmacy = ZVWKFARMACIE, 
        ZVWK_dentalcare = ZVWKMONDZORG,
        ZVWK_hospital = ZVWKZIEKENHUIS, 
        ZVWK_appliances = ZVWKHULPMIDDEL,           
        ZVWK_abroad = ZVWKBUITENLAND,
        ZVWK_other = ZVWKOVERIG,
        ZVWK_mentalhealth_bas = ZVWKEERSTELIJNSPSYCHO, 
        ZVWK_mentalhealth_spec = ZVWKGGZ,
        ZVWK_mentalhealth_spec_stay = NOPZVWKGGZMV,
        ZVWK_mentalh_spec_nostay_inst = NOPZVWKGGZZVINST,
        ZVWK_mentalh_spec_nostay_ind = NOPZVWKGGZZVZELF,
        ZVWK_geriatric = ZVWKGERIATRISCH,
        ZVWK_GP_basic = NOPZVWKEERSTELIJNSOND, 
        ZVWK_GP_regist = NOPZVWKHUISARTSINSCHRIJF,
        ZVWK_GP_consult = NOPZVWKHUISARTSCONSULT, 
        ZVWK_GP_other = NOPZVWKHUISARTSOVERIG, 
        ZVWK_physical_therapy = NOPZVWKFYSIOTHERAPIE, 
        ZVWK_physical_other = NOPZVWKPARAMEDISCHOV, 
        ZVWK_birth_obstetrician = NOPZVWKVERLOSKUNDE, 
        ZVWK_birth_maternitycare = NOPZVWKKRAAMZORG,
        ZVWK_patient_transport_sit = NOPZVWKZIEKENVERVOERZIT, 
        ZVWK_patient_transport_lie = NOPZVWKZIEKENVERVOERLIG,
        ZVWK_mentalh_spec_other = NOPZVWKGGZOVERIG) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             year = year) %>%
      bind_rows(health_dat, .)
    
  } else if (year >= 2009 & year <= 2012) {
    health_dat <- read_sav(get_zvwzorgkosten_filename(year), 
                           col_select = c(-"ZVWKOPHOOGFACTOR", -"ZVWKHUISARTS", -"ZVWKPARAMEDISCH",
                                          -"ZVWKZIEKENVERVOER", -"ZVWKGEBOORTEZORG", -"ZVWKGENBASGGZ",
                                          -"ZVWKSPECGGZ", -"ZVWKGERIATRISCH", -"ZVWKWYKVERPLEGING")) %>%
      filter(RINPERSOON %in% parents) %>% 
      rename(
        rins = RINPERSOONS,
        rin = RINPERSOON,
        ZVWK_pharmacy = ZVWKFARMACIE, 
        ZVWK_dentalcare = ZVWKMONDZORG,
        ZVWK_hospital = ZVWKZIEKENHUIS, 
        ZVWK_appliances = ZVWKHULPMIDDEL,           
        ZVWK_abroad = ZVWKBUITENLAND,
        ZVWK_other = ZVWKOVERIG,
        ZVWK_mentalhealth_bas = ZVWKEERSTELIJNSPSYCHO, 
        ZVWK_mentalhealth_spec = ZVWKGGZ,
        ZVWK_mentalhealth_spec_stay = NOPZVWKGGZMV,
        ZVWK_mentalh_spec_nostay_inst = NOPZVWKGGZZVINST,
        ZVWK_mentalh_spec_nostay_ind = NOPZVWKGGZZVZELF,
        ZVWK_GP_basic = NOPZVWKEERSTELIJNSOND, 
        ZVWK_GP_regist = NOPZVWKHUISARTSINSCHRIJF,
        ZVWK_GP_consult = NOPZVWKHUISARTSCONSULT, 
        ZVWK_GP_other = NOPZVWKHUISARTSOVERIG, 
        ZVWK_physical_therapy = NOPZVWKFYSIOTHERAPIE, 
        ZVWK_physical_other = NOPZVWKPARAMEDISCHOV, 
        ZVWK_birth_obstetrician = NOPZVWKVERLOSKUNDE, 
        ZVWK_birth_maternitycare = NOPZVWKKRAAMZORG,
        ZVWK_patient_transport_sit = NOPZVWKZIEKENVERVOERZIT, 
        ZVWK_patient_transport_lie = NOPZVWKZIEKENVERVOERLIG,
        ZVWK_mentalh_spec_other = NOPZVWKGGZOVERIG) %>% 
      mutate(rins = as_factor(rins, levels = "values"),
             year = year) %>%
      bind_rows(health_dat, .)
    
  }
  
} 

health_dat <- health_dat %>% 
  mutate(
    start_date = as.Date(paste(year, 1, 1, sep = "-")),
    end_date = as.Date(paste(year, 12, 31, sep = "-"))) %>% 
  select(-year)


