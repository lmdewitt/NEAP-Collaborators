library(googlesheets4)
library(yaml)

# Replace with your actual Google Sheet URL
sheet_url <- "https://docs.google.com/spreadsheets/d/17LrcAj5mCkFsZmxLHbMOAuDRJjjDmvpP-mOJxg-79KU"

# Read data into an R data frame
df <- read_sheet(sheet_url)

# Define columns that should be merged into the Quarto 'categories' array
category_columns <- c("Expertise", "Products", "Skills")

# Helper function to strip quotes and split values by comma
parse_array_string <- function(val) {
  if (is.null(val) || is.na(val)) return(character(0))
  
  clean_str <- as.character(val)
  # Strip outer/inner double & single quotes
  clean_str <- gsub('^["\']|["\']$', '', trimws(clean_str))
  clean_str <- gsub('"', '', clean_str)
  clean_str <- gsub("'", '', clean_str)
  
  items <- trimws(unlist(strsplit(clean_str, ",")))
  items[nchar(items) > 0]
}

yaml_list <- lapply(seq_len(nrow(df)), function(i) {
  row_list <- as.list(df[i, ])
  row_list <- row_list[!is.na(row_list)]
  
  # 1. Clean up stray quotes from ALL text fields so they look neat in listings tables
  row_list <- lapply(row_list, function(val) {
    if (is.character(val)) {
      v <- gsub('^["\']|["\']$', '', trimws(val))
      v <- gsub('^"|"$', '', v)
      return(v)
    }
    return(val)
  })
  
  # 2. Extract and combine values from category source columns
  combined_categories <- c()
  
  for (col in category_columns) {
    if (!is.null(row_list[[col]])) {
      parsed <- parse_array_string(row_list[[col]])
      combined_categories <- c(combined_categories, parsed)
    }
  }
  
  # 3. Remove duplicates and attach as 'categories' (using as.list to force YAML array format)
  unique_categories <- unique(combined_categories)
  if (length(unique_categories) > 0) {
    row_list[["categories"]] <- as.list(unique_categories)
  }
  
  # Note: Original columns like row_list$Products, row_list$Skills remain untouched
  return(row_list)
})

# Write to YAML
write_yaml(yaml_list, "collaborators_all_cat.yml")
