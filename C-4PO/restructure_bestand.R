#### RESTRUCTURE SCRIPT ####

# function to transform the joined prnl data into long format
join_longformat_prnl <- function(join_dat) {
  join_dat %>%
    mutate(
      start_date = ymd(birthdate)) %>% 
    select(-year) %>%
    pivot_longer(
      cols = -c("rins", "rin", "rins_mo", "rin_mo", "rins_fa", "rin_fa", "rins_mo2", "rin_mo2",
                "start_date"),
      names_to = "variables",
      values_to = "recorded_value",
      #names_transform = list(variables = as.character),
      values_transform = list(recorded_value = as.character),
      values_drop_na = TRUE) 
}  

prnl_long <- join_longformat_prnl(join_prnl)

# function to transform the joined gba data into long format
join_longformat_gba <- function(join_dat) {
  join_dat %>%
    pivot_longer(
      cols = -c("rins", "rin", "rins_mo", "rin_mo", "rins_fa", "rin_fa", "rins_mo2", "rin_mo2"),
      names_to = "variables",
      values_to = "recorded_value",
      #names_transform = list(variables = as.character),
      values_transform = list(recorded_value = as.character),
      values_drop_na = TRUE) 
}  

gba_long_mo <- join_longformat_gba(join_gba_mo) 
gba_long_fa <- join_longformat_gba(join_gba_fa) 


# function to transform the joined data into long format
join_longformat <- function(join_dat) {
  join_dat %>%
  pivot_longer(
    cols = -c("rins", "rin", "rins_mo", "rin_mo", "rins_fa", "rin_fa", "rins_mo2", "rin_mo2",
              "start_date", "end_date"),
    names_to = "variables",
    values_to = "recorded_value",
    #names_transform = list(variables = as.character),
    values_transform = list(recorded_value = as.character),
    values_drop_na = TRUE) 
}  


residence_long_mo <- join_longformat(join_residence_mo)
residence_long_fa <- join_longformat(join_residence_fa)

educ_long_mo <- join_longformat(join_educ_mo)
educ_long_fa <- join_longformat(join_educ_fa)

income_long_mo <- join_longformat(join_income_mo)
income_long_fa <- join_longformat(join_income_fa)

spolis_long_mo <- join_longformat(join_spolis_mo)
spolis_long_fa <- join_longformat(join_spolis_fa)

secm_long_mo <- join_longformat(join_secm_mo)
secm_long_fa <- join_longformat(join_secm_fa)

health_long_mo <- join_longformat(join_health_mo)
health_long_fa <- join_longformat(join_health_fa)


# remove joined data to clear memory
rm(join_prnl_mo, join_gba_mo, join_residence_mo, join_educ_mo, join_income_mo, 
   join_spolis_mo, join_secm_mo, join_health_mo)
rm(join_prnl_fa, join_gba_fa, join_residence_fa, join_educ_fa, join_income_fa, 
   join_spolis_fa, join_secm_fa, join_health_fa)

#### CREATE SPELLS ####
# function to collapse the data and create spells, so that if a recorded value remains 
# the same over time this period will be recorded in one row with start_date and end_date

# function for the mother
spell_longformat_mo <- function(long_dat) {
  long_dat %>%
    #mutate_at(c("start_date", "end_date"), lubridate::ymd) %>% 
    arrange(rin_mo, variables, start_date) %>% 
    # for the mother of a child, for each variable, group recorded_values that are the same
    group_by(rins, rin, rins_mo, rin_mo, variables, recorded_value) %>% 
    # determine start and stop dates for each collapsed period
    summarise(start_date = first(start_date), end_date = last(end_date)) 
}

#function for the father
spell_longformat_fa <- function(long_dat) {
  long_dat %>%
    #mutate_at(c("start_date", "end_date"), lubridate::ymd) %>% 
    arrange(rin_fa, variables, start_date) %>% 
    # for the father of a child, for each variable, group recorded_values that are the same
    group_by(rins, rin, rins_fa, rin_fa, variables, recorded_value) %>% 
    # determine start and stop dates for each collapsed period
    summarise(start_date = first(start_date), end_date = last(end_date)) 
}

spell_educ_mo <- spell_longformat_mo(educ_long_mo)
spell_educ_fa <- spell_longformat_mo(educ_long_fa)

spell_income_mo <- spell_longformat_mo(income_long_mo)
spell_income_fa <- spell_longformat_mo(income_long_fa)

spell_health_mo <- spell_longformat_mo(health_long_mo)
spell_health_fa <- spell_longformat_mo(health_long_fa)

# remove data to clear memory
rm(educ_long_mo, income_long_mo, health_long_mo)
rm(educ_long_fa, income_long_fa, health_long_fa)
