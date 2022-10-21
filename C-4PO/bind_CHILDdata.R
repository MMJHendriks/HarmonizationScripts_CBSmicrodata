# bind all the data

# for the mother
CHILD_data_mo <- bind_rows(prnl_long, gba_long_mo, residence_long_mo, spell_educ_mo, spell_income_mo, 
                           spolis_long_mo, secm_long_mo, spell_health_mo) %>% 
  select(-c("rins_fa", "rin_fa", "rins_mo2", "rin_mo2"))

# save this dataset
saveRDS(CHILD_data_mo, "CHILD_data_mo.rds")


# for the father
CHILD_data_fa <- bind_rows(prnl_long, gba_long_fa, residence_long_fa, spell_educ_fa, spell_income_fa, 
                           spolis_long_fa, secm_long_fa, spell_health_fa) %>% 
  select(-c("rins_mo", "rin_mo", "rins_mo2", "rin_mo2"))

# save this dataset
saveRDS(CHILD_data_fa, "CHILD_data_fa.rds")


CHILD_data <- bind_rows(CHILD_data_fa, CHILD_data_mo)
saveRDS(CHILD_data, "CHILD_data.rds")

