# Load necessary library
install.packages("bibliometrix")  # Uncomment if not installed yet
library(bibliometrix)

# Step 1: Import Web of Science Data
file_path <- "cerrado.bib"  # Replace with the actual file path
M <- convert2df(file_path, dbsource = "wos", format = "bibtex")

# Step 2: Extract Key Information (Title, Authors, Journal, Year, DOI, Citations, Keywords)
papers_info <- M[, c("TI", "AU", "SO", "PY", "DI", "TC", "DE")]

# Rename columns for better understanding
colnames(papers_info) <- c("Title", "Authors", "Journal", "Year", "DOI", "Citations", "Keywords")

# Step 3: Classify Journals as International or Brazilian (heuristic based on Journal name)
# You can expand this list as needed (example for journals with 'Brazil' or 'Brazilian' in the name)
papers_info$JournalType <- ifelse(grepl("Brazil|brasileiro", papers_info$Journal, ignore.case = TRUE), "Brazilian", "International")

# Step 4: Save the Extracted Data as a CSV File
write.csv(papers_info, "WoS_papers_info.csv", row.names = FALSE)

# Step 5: Verify that the CSV was saved correctly
cat("The data has been saved as 'WoS_papers_info_with_keywords.csv'\n")
list.files()  # Check if the CSV file is in the working directory
