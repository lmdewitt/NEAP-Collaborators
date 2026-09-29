library(googlesheets4)
library(yaml)

# Replace with your actual Google Sheet URL
sheet_url <- "https://docs.google.com/spreadsheets/d/17LrcAj5mCkFsZmxLHbMOAuDRJjjDmvpP-mOJxg-79KU"

# Read data into an R data frame
df <- read_sheet(sheet_url)

# Columns to transform into YAML arrays
# Add Products, Skills, etc. here if you want them cleaned and array-formatted too
array_columns <- c(
  "Expertise" = "categories"
  )

# Helper function to strip quotes, split on commas, and return a clean vector
parse_array_string <- function(val) {
  if (is.null(val) || is.na(val)) return(NULL)
  
  clean_str <- as.character(val)
  # Strip outer/inner double & single quotes
  clean_str <- gsub('^["\']|["\']$', '', trimws(clean_str))
  clean_str <- gsub('"', '', clean_str)
  clean_str <- gsub("'", '', clean_str)
  
  items <- trimws(unlist(strsplit(clean_str, ",")))
  items <- items[nchar(items) > 0]
  
  if (length(items) == 0) return(NULL) else return(items)
}

yaml_list <- lapply(seq_len(nrow(df)), function(i) {
  row_list <- as.list(df[i, ])
  row_list <- row_list[!is.na(row_list)]
  
  # Also clean stray quotes from regular string columns
  row_list <- lapply(row_list, function(val) {
    if (is.character(val)) {
      v <- gsub('^["\']|["\']$', '', trimws(val))
      v <- gsub('^"|"$', '', v)
      return(v)
    }
    return(val)
  })
  
  # Convert specified columns to YAML arrays
  for (col in names(array_columns)) {
    yaml_key <- array_columns[[col]]
    
    if (!is.null(row_list[[col]])) {
      parsed_val <- parse_array_string(row_list[[col]])
      
      if (!is.null(parsed_val)) {
        # Converting to as.list() forces yaml::write_yaml to render every element with a hyphen `-`
        row_list[[yaml_key]] <- as.list(parsed_val)
      }
      
      if (col != yaml_key) {
        row_list[[col]] <- NULL
      }
    }
  }
  
  return(row_list)
})

# Write to YAML
write_yaml(yaml_list, "collaborators.yml")
