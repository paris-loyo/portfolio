# ============================================
# Cyclistic Bike-Share Data Cleaning Pipeline
# ============================================
# Cyclistic bike-share data cleaning pipeline (12 months of data)
# Written in R using tidyverse, janitor, lubridate, and here.

# ---- 1. Load Libraries ----
# Load necessary libraries for data manipulation and cleaning
library(tidyverse)   # For data manipulation and visualization
library(janitor)     # For cleaning column names
library(lubridate)   # For working with dates and times
library(here)        # For robust, project-relative file paths

# ---- 2. Set File Paths ----
# Load all CSV files from the raw data folder using 'here' for reproducibility
file_list <- list.files(path = here("data/raw/csv"), pattern = "*.csv", full.names = TRUE)

output_path <- here("data/cleaned/2024_bike_data_combined.csv")

# ---- 3. Read Data and Verify Columns ----
# Check if required columns are present in each file before combining
required_cols <- c("started_at", "ended_at")

# Load and check columns simultaneously during the read step
data_list <- file_list %>%
  set_names(basename(.)) %>%
  map(~ {
    message("Reading file: ", .x)  # Debugging message
    data <- tryCatch(
      read_csv(.x) %>% clean_names(),
      error = function(e) {
        message("Error reading file '", .x, "': ", e$message)
        return(NULL)
      }
    )
    
    if (is.null(data)) {
      message("Failed to load: ", .x)  # Debugging message
      return(NULL)
    }
    
    if (!all(required_cols %in% names(data))) {
      message("File '", .x, "' is missing required columns: ", 
              paste(setdiff(required_cols, names(data)), collapse = ", "), ". Skipping.")
      return(NULL)
    }
    
    return(data)  # Return the loaded data if no issues
  })

data_list <- compact(data_list)  # Remove any NULLs from failed file reads

# ---- 4. Load and Combine Data ----
# Combine all data into one dataframe
bike_data_2024 <- bind_rows(data_list)

if (nrow(bike_data_2024) == 0) {
  stop("No data was loaded. Please check your source files or file path. Ensure that the files in the 'data/raw/csv' directory are valid CSVs.")
}

if (!all(required_cols %in% names(bike_data_2024))) {
  stop("Combined data is missing required columns: ", 
       paste(setdiff(required_cols, names(bike_data_2024)), collapse = ", "))
}

if (!"ride_id" %in% names(bike_data_2024)) {
  stop("Column 'ride_id' is missing from the combined data.")
}

# ---- Optional: Quick Inspection ----
# Glimpse of the first few rows of the combined data
# This helps to ensure the data is loaded correctly and check column names and types
glimpse(bike_data_2024)

# ---- 5. Clean Date/Time and Add Calculated Columns ----
# Convert datetime columns and calculate ride length in minutes
# Extract day of week and month from 'started_at'

bike_data_2024 <- bike_data_2024 %>%
  mutate(
    started_at = ymd_hms(as.character(started_at)),   # Convert to datetime format
    ended_at = ymd_hms(as.character(ended_at)),       # Convert to datetime format
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")),  # Calculate ride duration
    day_of_week = wday(started_at, label = TRUE),  # Extract day of the week (Sun, Mon, etc.)
    month = month(started_at, label = TRUE)  # Extract month (Jan, Feb, etc.)
  ) %>%
  filter(!is.na(started_at) & !is.na(ended_at))  # Remove rows with missing dates

# Check for any NAs that may have resulted from date parsing
if (any(is.na(bike_data_2024$started_at)) | any(is.na(bike_data_2024$ended_at))) {
  stop("Some 'started_at' or 'ended_at' values could not be parsed. Please check the data format.")
}

# ---- Optional: Quick Inspection ----
# Check the structure again after mutation to confirm that new columns were added
glimpse(bike_data_2024)

# ---- 6. Data Quality Checks: Remove Missing & Duplicate Values ----
# Filter out rows with missing IDs, stations, or invalid ride lengths
# Remove duplicate ride IDs

rows_before <- nrow(bike_data_2024)
missing_ride_id <- bike_data_2024 %>% filter(is.na(ride_id))
missing_before <- nrow(missing_ride_id)
if (missing_before > 0) {
  message("⚠️ Warning: Some ride_ids are missing. Removing ", missing_before, " rows.\n")
}

bike_data_2024 <- bike_data_2024 %>%
  filter(!is.na(ride_id))

missing_station_data <- bike_data_2024 %>%
  filter(is.na(start_station_name) | is.na(end_station_name))

if (nrow(missing_station_data) > 0) {
  message("⚠️ Warning: Some station data is missing. Removing ", nrow(missing_station_data), " rows.\n")
}

if (any(duplicated(bike_data_2024$ride_id))) {
  dup_count <- sum(duplicated(bike_data_2024$ride_id))
  message("⚠️ Duplicate ride_id values detected: ", dup_count, " duplicates found. Resolving...\n")
} else {
  message("✅ No duplicates found.\n")
}

before_distinct <- nrow(bike_data_2024)
bike_data_2024 <- bike_data_2024 %>% distinct(ride_id, .keep_all = TRUE)
after_distinct <- nrow(bike_data_2024)

if (nrow(bike_data_2024) == 0) {
  stop("After removing duplicates, the dataset is empty. Please check the data integrity.")
}

if (before_distinct != after_distinct) {
  message("⚠️ Removed ", before_distinct - after_distinct, " duplicate rows during distinct operation.")
} else {
  message("✅ No duplicates were found during distinct operation.")
}

# ---- 7. Track How Many Rows Were Removed During Filtering ----
# Before filtering: save the initial number of rows
initial_rows <- nrow(bike_data_2024)

# Check for extreme ride_length values before filtering
if (any(bike_data_2024$ride_length <= 0, na.rm = TRUE)) {
  message("⚠️ Warning: Some ride_lengths are zero or negative. These will be removed during cleaning.\n")
}

# Remove implausible or incomplete records (e.g., negative ride lengths, missing stations)
removed_invalid_length <- sum(bike_data_2024$ride_length <= 0, na.rm = TRUE)
removed_missing_station <- sum(is.na(bike_data_2024$start_station_name) | is.na(bike_data_2024$end_station_name))

message("Rows removed due to invalid 'ride_length' (<= 0): ", removed_invalid_length)
message("Rows removed due to missing station data: ", removed_missing_station)

# Filter out rows with invalid ride_length (<= 0) or longer than 24 hours (1440 minutes) or missing station data
bike_data_2024 <- bike_data_2024 %>%
  filter(
    ride_length > 1 &   # Remove rides shorter than 1 minute (possible entry errors)
      ride_length < 1440 &
      !is.na(start_station_name) & 
      !is.na(end_station_name)
  )

if (any(bike_data_2024$ride_length <= 0 | bike_data_2024$ride_length >= 1440)) {
  message("⚠️ Warning: Some ride_lengths still fall outside valid range (1 to 1440). Please check.")
}

# Ensure no NAs remain in ride_length
if (anyNA(bike_data_2024$ride_length)) {
  message("⚠️ Warning: There are still missing values in 'ride_length' after filtering.")
}

# After filtering: check the number of rows again
final_rows <- nrow(bike_data_2024)

# Print how many rows were removed during the filtering process
message("Initial rows: ", initial_rows)
message("Final rows: ", final_rows)
message("Rows removed during cleaning: ", initial_rows - final_rows)

message("Rows removed due to invalid ride_length (<= 0):", removed_invalid_length, "\n")
message("Rows removed due to missing station data:", removed_missing_station, "\n")

# ---- 8. Convert to Factors & Summarize ----
# Convert 'member_casual' and 'month' to factors for accurate grouping and plotting.
# Print summary statistics and a preview grouped by member type and month.

# Optional: Check for correct column data types
if (!all(c("member_casual", "month") %in% colnames(bike_data_2024))) {
  stop("Required columns 'member_casual' or 'month' are missing.")
}

# Ensure 'member_casual' and 'month' are factors for correct grouping and plotting
bike_data_2024 <- bike_data_2024 %>%
  mutate(
    member_casual = as.factor(member_casual),
    month = factor(month, levels = month.abb) # Jan, Feb, ..., Dec
  )

if (!is.factor(bike_data_2024$member_casual) | !is.factor(bike_data_2024$month)) {
  message("⚠️ Columns 'member_casual' or 'month' are not factors. Converting them now.")
}

message("Final dataset dimensions: ", paste(dim(bike_data_2024), collapse = " x "))
summary(bike_data_2024)

# Generate a preview of the cleaned data by counting rides by member type and month
bike_data_2024 %>%
  count(member_casual, month) %>%
  arrange(desc(n)) %>%
  print(n = 100)  # Display the first 100 rows of the summary, sorted by count

# ---- 9. Save Combined Cleaned File ----
# Save cleaned data to CSV for future analysis
write_csv(bike_data_2024, output_path)
message("Cleaned data saved successfully to: ", output_path, "\n")

# ---- Optional: Save Cleaned Data as RDS (R's Native Format) ----
# Save the cleaned data in RDS format to load more quickly in future sessions
# RDS format preserves column types and can be read faster than CSV
output_rds_path <- here("data/cleaned/2024_bike_data_combined.rds")
saveRDS(bike_data_2024, output_rds_path)

# To load the RDS file later:
# bike_data_2024 <- readRDS("data/cleaned/2024_bike_data_combined.rds")
