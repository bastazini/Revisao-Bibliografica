library(bibliometrix)
library(openxlsx)

Sco_art = convert2df("String6eng_Scopus_articles.bib", dbsource = "scopus", format = "bibtex")
Sco_book = convert2df("String6eng_Scopus_book.bib", dbsource = "scopus", format = "bibtex")
Sco_rev = convert2df("String6port_Scopus_review.bib", dbsource = "scopus", format = "bibtex")
Sco_art_por = convert2df("String6port_Scopus_articles.bib", dbsource = "scopus", format = "bibtex")
Sco_rev_por = convert2df("String6port_Scopus_review.bib", dbsource = "scopus", format = "bibtex")

Wos_art = convert2df("String6eng_Web_articles.bib", dbsource = "isi", format = "bibtex")
Wos_rev = convert2df("String6eng_Web_review.bib", dbsource = "isi", format = "bibtex")
Wos_art_por = convert2df("String6port_Web_articles.bib", dbsource = "isi", format = "bibtex")
Wos_rev_por = convert2df("String6port_Web_review.bib", dbsource = "isi", format = "bibtex")


Database = mergeDbSources(Sco_art, Sco_book, Sco_rev,Wos_art,Wos_rev,Sco_art_por,Sco_rev_por, Wos_art_por, Wos_rev_por, remove.duplicated = TRUE)
dim(Database)

write.xlsx(Database, file = "cerrado.xlsx")

biblioshiny()



# Function to find and display duplicates based on DOI and Title
find_duplicates <- function(df, id_column = "DI", title_column = "TI") {
  
  # Check if DI and TI columns exist
  if(!id_column %in% colnames(df) || !title_column %in% colnames(df)){
    stop(paste("Error: The ID column '", id_column, "' or the Title column '", title_column, "' are missing in the dataframe.", sep = ""))
  }
  
  # Handle missing DOI values (replace with "")
  df[[id_column]][is.na(df[[id_column]])] <- ""
  
  # Create a combined ID based on DOI and Title
  df$combined_id <- paste(df[[id_column]], df[[title_column]], sep = "_")
  
  # Find duplicated combined IDs
  duplicates <- df$combined_id[duplicated(df$combined_id, fromLast = FALSE) | duplicated(df$combined_id, fromLast = TRUE)]
  
  if (length(duplicates) == 0) {
    cat("No duplicates found.\n")
    return(NULL)
  } else {
    cat("Duplicates found:\n")
    duplicate_rows <- df[df$combined_id %in% duplicates, ]
    
    # Print the duplicated rows.  You might want to adjust the columns
    # selected for display.
    print(duplicate_rows[, c("DI", "TI", "PY", "SO", "DB")])  #Example columns
    # (DOI, Title, Publication Year, Source, Database source)
    
    #Optional: Return the duplicate rows
    return(duplicate_rows)
  }
}



# Call the function to find and print duplicates.
duplicates <- find_duplicates(Database)


# Example using EID column instead of DI if needed (and a different title)
# Database$EID[is.na(Database$EID)] <- "" #Handle NAs in EID
# duplicates_eid <- find_duplicates(Database, id_column = "EID", title_column = "AB") # Searches duplicates using EID instead of DI and Abstract instead of Title
