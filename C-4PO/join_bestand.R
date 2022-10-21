#### JOIN SCRIPT ####
# This script joins the koppel_data file with CBS datafiles on various topics, including  
# prnl, gba, residence, education, income, spolis, social economic categories and health care costs.
# The function of this script is to link each child with the parent data and birth records

# join the PRNL data with the koppel_data; add birth records of the child
join_prnl <- koppel_dat %>% 
  left_join(y = prnl_dat,
            by = c("rin" = "rin", "rins" = "rins", "rin_mo" = "rin_mo", "rins_mo" = "rins_mo")) 

# join the gba data with the koppel_data; add parents birthdates, country of origin and generation 
# for the mother
join_gba_mo <- koppel_dat %>% 
  left_join(gba_dat,
            by = c("rin_mo" = "rin", "rins_mo" = "rins")) %>% 
  rename_at(vars(-c("rins", "rin", "rins_mo", "rin_mo", "rins_fa", "rin_fa", "rins_mo2", "rin_mo2")), 
            function(x) paste0(x, "_mo"))

# for the father
join_gba_fa <- koppel_dat %>% 
  left_join(gba_dat,
            by = c("rin_fa" = "rin", "rins_fa" = "rins")) %>% 
  rename_at(vars(-c("rins", "rin", "rins_mo", "rin_mo", "rins_fa", "rin_fa", "rins_mo2", "rin_mo2")),
            function(x) paste0(x, "_fa"))


# function to join a CBS dataset with koppel_dat, to link data from the parents to child 
# for the morther 
join_mo <- function(dat) {
  koppel_dat %>% 
    left_join(dat,
              by = c("rin_mo" = "rin", "rins_mo" = "rins")) %>% 
    rename_at(vars(-c("rins", "rin", "rins_mo", "rin_mo", "rins_fa", "rin_fa", "rins_mo2", "rin_mo2",
                      "start_date", "end_date")), function(x) paste0(x, "_mo"))
}

# for the father
join_fa <- function(dat) {
  koppel_dat %>% 
    left_join(dat,
              by = c("rin_fa" = "rin", "rins_fa" = "rins")) %>% 
    rename_at(vars(-c("rins", "rin", "rins_mo", "rin_mo", "rins_fa", "rin_fa", "rins_mo2", "rin_mo2",
                      "start_date", "end_date")), function(x) paste0(x, "_fa"))
}


# select the CBS topic datafile to join 
join_residence_mo <- join_mo(residence_dat)
join_residence_fa <- join_fa(residence_dat)

join_educ_mo <- join_mo(educ_dat)
join_educ_fa <- join_fa(educ_dat)

join_income_mo <- join_mo(income_dat)
join_income_fa <- join_fa(income_dat)

join_spolis_mo <- join_mo(spolis_dat)
join_spolis_fa <- join_fa(spolis_dat)

join_polis_mo <- join_mo(polis_dat)
join_polis_fa <- join_fa(polis_dat)

join_secm_mo <- join_mo(secm_dat)
join_secm_fa <- join_fa(secm_dat)

join_health_mo <- join_mo(health_dat)
join_health_fa <- join_fa(health_dat)


# remove data to clear memory
rm(prnl_dat)
#rm(prnl_dat, gba_dat, residence_dat, educ_dat, income_dat, spolis_dat, secm_dat, health_dat)


