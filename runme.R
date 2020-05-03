library(pdftools)
library(tidyverse)
library(janitor)

purrr::walk(list.files("R", full.names = T), source)

# Set up ------------------------------------------------------------------
# Extract sheet name for muliple choice template
sheet <- readxl::excel_sheets(list.files("template", full.name = T))[str_detect(readxl::excel_sheets(list.files("template", full.name = T)), "Multiple Choice") ]


# Marking Template --------------------------------------------------------
marking_template <- readxl::read_excel(list.files("template", full.name = T), skip = 4, sheet = sheet) %>% 
  janitor::remove_empty(which = "rows") %>% 
  select(-STRING, -Marker, -starts_with("Identifier")) %>%
  pivot_longer(`1`:`20`, names_to = "question") %>% 
  select(-value)


distinct_students <- marking_template %>% 
  distinct(`Student ID`, .keep_all = T) %>% 
  select(-question) 

student_id_order <- readxl::read_excel(list.files("template", full.name = T), skip = 4, sheet = sheet) %>% 
  janitor::remove_empty(which = "rows") %>% 
  {.$`Student ID`}


# Extract marks -----------------------------------------------------------
final <- distinct_students %>% 
  mutate(pdf_link = map_chr(`Student ID`, ~ extract_pdf(.)),
         answer = map( pdf_link,  ~ extract_answers(.))) %>% 
  unnest(answer) 

final_wide <- final %>%
            pivot_wider(  names_from = question, values_from = answer)  %>% 
            select(-pdf_link,  pdf_link)
            

write_csv(final_wide, path = here::here("output", "mcq_answers.csv"))

