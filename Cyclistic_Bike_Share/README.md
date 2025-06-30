# Cyclistic Bike-Share Case Study

This project analyzes the 2024 Cyclistic bike-share data to uncover insights about user behavior, including ride durations, patterns by day of the week, time of day, and month, and comparisons between casual and member riders. The case study is built in R and includes data cleaning, exploration, and visualization to showcase key trends.

## Project Overview

The goal of this case study is to perform exploratory data analysis (EDA) on the Cyclistic bike-share data. The analysis includes cleaning, transforming, and visualizing the data to answer specific questions that help understand user behavior and improve business decisions.

## Data Source

The data is sourced from Cyclistic's bike-share platform, covering 12 months of ride data. The raw data files are stored in CSV format and have been cleaned and processed using R.

## Files in This Repository

### 1. `01_load_and_combine_data.R`

This script performs the following tasks:

- **Loads and Reads Data**: Loads raw CSV data files and combines them into one dataset.
- **Data Cleaning**: Cleans column names, checks for missing values, and handles duplicates.
- **Date-Time Transformation**: Converts date-time columns and creates new features like ride duration, day of the week, and month.
- **Data Quality Checks**: Filters out invalid data based on ride duration and missing station information.
- **Saves Cleaned Data**: Saves the cleaned data to a CSV and RDS file for future analysis.

### 2. `02_bike_share_analysis.R`

This script performs the following tasks:

- **Loads Cleaned Data**: Loads the cleaned dataset from the `01_load_and_combine_data.R` script.
- **Descriptive Analysis**: Computes key summary statistics including average ride duration, ride counts by user type, day of the week, time of day, and month.
- **Visualizations**: Creates bar charts to visualize the number of rides by day of the week, average ride duration by user type, ride counts by hour of day, and ride counts by month.

## Tools and Libraries

This project was developed using the following R packages:

- **tidyverse**: For data manipulation and visualization (dplyr, ggplot2, etc.)
- **lubridate**: For handling date and time-related operations.
- **janitor**: For cleaning column names to be consistent and easy to work with.
- **skimr**: For generating quick summary statistics.
- **scales**: For formatting numbers in visualizations (e.g., adding commas to large numbers).
- **here**: For defining file paths in a reproducible manner.

## Key Insights from the Analysis

1. **Ride Duration by User Type**  
   The analysis provides insights into the average ride duration for casual vs. member riders, with casual riders tending to have longer rides on average.

2. **Ride Frequency by Day of the Week**  
   The dataset reveals which days of the week see the most bike usage for both casual and member riders.

3. **Ride Frequency by Time of Day**  
   Identifies peak hours for bike rides, helping to optimize bike availability during busy times.

4. **Ride Frequency by Month**  
   The analysis shows how bike usage varies across the months, highlighting trends such as seasonal changes in ride frequency.

## How to Run the Scripts

### Prerequisites

You will need the following libraries installed in your R environment to run these scripts:

```r
install.packages(c("tidyverse", "lubridate", "janitor", "skimr", "scales", "here"))
```

## Running the Scripts
1. **Run the Data Cleaning Script**: Start by running 01_load_and_combine_data.R to load, clean, and prepare the data.

- This will create a cleaned dataset that can be used in subsequent analyses.

2. **Run the Analysis Script**: Next, run 02_bike_share_analysis.R to perform exploratory data analysis and generate visualizations from the cleaned dataset.

## File Paths
- **Raw Data Folder**: data/raw/csv/

- **Cleaned Data Folder**: data/cleaned/

The output_path variable in 01_load_and_combine_data.R ensures that the cleaned data is saved to the data/cleaned/ directory for use in later analysis.

## Conclusion
This case study demonstrates how R can be used to clean, analyze, and visualize large datasets in a reproducible and efficient manner. The insights gained can be useful for stakeholders in optimizing the bike-sharing system, understanding user behavior, and identifying areas for improvement.
