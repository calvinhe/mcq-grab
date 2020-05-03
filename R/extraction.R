



extract_pdf <- function(id, folder_name = "pdfs"){
  
  pdfs <- list.files(here::here(folder_name))
  
  output <- pdfs[str_detect(pdfs, id) & str_detect(pdfs, ".pdf")]
  
  if(is_empty(output)) output <- NA_character_
  
  return(output)
  
}



extract_answers <- function(pdf_link){
  
  if ( is.na(pdf_link) | pdf_link == "NA"){
    
    output <- tibble(question = as.character(1:20),
                     answer = rep("no pdf found", 20) )
    
    return(output)
  } else{
    
    txt <- pdf_text(here::here("pdfs",  pdf_link))
    multiple_choice_location <- map_lgl(txt, ~ str_detect(., "below table"))
    
    
    if (sum(multiple_choice_location) != 1 ) {
      output <- tibble(question = as.character(1:20),
                       answer = rep("no mcq page", 20) )
    } else{
      
      # data <- tibble(text =
      #                  txt[multiple_choice_location] %>% 
      #                  str_squish()  %>% 
      #                  str_extract("Answer.*") %>% 
      #                  str_remove("Answer ") %>% 
      #                  str_to_lower() %>% 
      #                  str_extract_all("\\d+\\D+") %>% 
      #                  as_vector())
      
      data <- tibble(text =
                       txt[multiple_choice_location] %>%
                       str_squish()  %>%
                       str_extract("Answer.*") %>%
                       str_remove("Answer ") %>%
                       str_to_lower() %>%
                       str_extract_all("\\d\\D+ |\\d\\d\\D+ ") %>%
                       as_vector())
      
      output <- data %>% 
        mutate(question = str_extract(text, "\\d+"),
               answer = str_extract(text, "\\D+" ) %>% str_squish()) %>% 
        select(-text) %>% 
        output_checks()
    
    }
    
  }
  
 
  
  return(output)
  
}


output_checks <- function(output){
  
  # check length
  output_mod <- output %>%   
    mutate(answer = case_when( str_length(answer) > 1 ~ paste0(answer, "- Check this - multiple answers"),
                              is.na(answer) ~ "Check this - NA", 
                              TRUE ~ answer))
          
  
  # check if number >20
  if( any(as.numeric(output$question) > 20) ){
    output_mod <- tibble(question = as.character(1:20),
                     answer = rep("scraper failed", 20) )
    
  }
  
  # Check if empty
  if (nrow(output) == 0) {
    output_mod <- tibble(question = as.character(1:20),
                         answer = rep("scraper failed", 20) )
  }
  
  return(output_mod)
  
}


