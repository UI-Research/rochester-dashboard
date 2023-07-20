pacman::p_load(tidyverse)

sheet_1 <-
  readxl::read_xlsx("data/data-raw/City of Rochester ARPA capital projects for ACT Rochester.xlsx", skip = 1) %>%
  select(f_address = Street) %>%
  mutate(f_address = if_else(!str_detect(f_address, "Rochester, NY"), paste0(f_address, "Rochester, NY"), f_address)) %>%
  mutate(type = 'arpa_spending_status')


sheet_2 <-
  readxl::read_xlsx("data/data-raw/City of Rochester ARPA capital projects for ACT Rochester.xlsx", sheet = 2, col_names = FALSE)  %>%
  rename(f_address = `...1`) %>%
  mutate(f_address = paste0(f_address, ", Rochester, NY"),
         type = "buy_the_block_phase_1")


sheet_3 <-
  readxl::read_xlsx("data/data-raw/City of Rochester ARPA capital projects for ACT Rochester.xlsx", sheet = 3,
                  col_names = FALSE) %>%
  mutate(f_address = paste0(`...1`, ', ', `...2`, ', ', `...3`, ' ', `...4`),
         type = "housing_rehab_addresses") %>%
  select(f_address, type)

sheet_4 <-
  readxl::read_xlsx("data/data-raw/City of Rochester ARPA capital projects for ACT Rochester.xlsx", sheet = 4,
                  col_names = FALSE) %>%
  mutate(f_address = paste0(`...1`, ', ', `...2`, ', ', `...3`, ' ', `...4`)) %>%
  select(f_address) %>%
  mutate(type = 'roof_program_addresses')

addresses <- bind_rows(sheet_1, sheet_2, sheet_3, sheet_4)

write_csv(addresses, "data/data-raw/addresses.csv")
