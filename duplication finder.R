# Install required packages if not installed
if (!require("RefManageR")) install.packages("RefManageR", dependencies = TRUE)
if (!require("VennDiagram")) install.packages("VennDiagram", dependencies = TRUE)

library(RefManageR)
library(VennDiagram)

process_bib_files <- function(bib1, bib2, bib3, output_file = "cerrado.bib") {
  # Read the .bib files
  bib_data1 <- ReadBib(bib1, check = FALSE)
  bib_data2 <- ReadBib(bib2, check = FALSE)
  bib_data3 <- ReadBib(bib3, check = FALSE)
  
  # Extract DOIs and Titles
  get_identifiers <- function(bib_data) {
    dois <- tolower(unlist(lapply(bib_data, function(x) x$doi)))
    titles <- tolower(unlist(lapply(bib_data, function(x) x$title)))
    
    # Use DOIs if available, otherwise fallback to titles
    identifiers <- ifelse(!is.na(dois) & dois != "", dois, titles)
    return(identifiers)
  }
  
  ids1 <- get_identifiers(bib_data1)
  ids2 <- get_identifiers(bib_data2)
  ids3 <- get_identifiers(bib_data3)
  
  # Create Venn Diagram Data
  venn_data <- list(
    SciELO = ids1,
    Scopus = ids2,
    Web = ids3
  )
  
  venn_plot <- draw.triple.venn(
    area1 = length(ids1), area2 = length(ids2), area3 = length(ids3),
    n12 = length(intersect(ids1, ids2)), 
    n23 = length(intersect(ids2, ids3)), 
    n13 = length(intersect(ids1, ids3)), 
    n123 = length(intersect(intersect(ids1, ids2), ids3)),
    category = c("SciELO", "Scopus", "Web"),
    fill = c("red", "blue", "green"),
    alpha = 0.5
  )
  
  grid.draw(venn_plot)
  
  # Combine all entries
  all_entries <- c(bib_data1, bib_data2, bib_data3)
  
  # Remove duplicates
  unique_ids <- unique(c(ids1, ids2, ids3))
  unique_entries <- all_entries[match(unique_ids, get_identifiers(all_entries))]
  
  # Save new .bib file
  WriteBib(unique_entries, file = output_file)
  
  message("Processed and saved unique references to: ", output_file)
}

# Example usage
process_bib_files("String4eng_SciELO.bib", "String4eng_Scopus.bib", "String4eng_Web.bib")
