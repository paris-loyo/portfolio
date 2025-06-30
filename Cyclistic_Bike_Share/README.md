# 🚲 Cyclistic Bike-Share Case Study
![Built with R](https://img.shields.io/badge/Built%20With-R-blue?logo=r)
![Project Status](https://img.shields.io/badge/Status-Completed-brightgreen)

This project analyzes the 2024 Cyclistic bike-share data to uncover insights about user behavior, such as ride durations, patterns by day of the week, time of day, and month, with comparisons between casual and member riders.

The case study was built in **R** and includes data cleaning, transformation, exploration, and visualization.

---

## 📌 Project Overview

The goal of this case study is to perform exploratory data analysis (EDA) on the Cyclistic bike-share data. This includes:

- Cleaning and transforming the raw data
- Visualizing usage patterns
- Comparing behaviors between rider types
- Generating actionable insights for business decisions

---

## 📂 Data Source

The data is sourced from Cyclistic’s public bike-share system and covers 12 months of ride data. All data was downloaded in `.csv` format, then cleaned and processed using R.

---

## 📁 Files in This Repository

### `01_load_and_combine_data.R`
Performs:

- Data loading and combining from multiple CSV files
- Standardizes column names and formats
- Handles missing values and duplicates
- Feature engineering (e.g., ride duration, weekday)
- Basic data quality filtering
- Saves cleaned data to `data/cleaned/` as `.csv` and `.RDS`

### `02_bike_share_analysis.R`
Performs:

- Loads the cleaned dataset
- Descriptive statistics on ride behavior
- Generates visualizations (e.g., average ride duration by user type, rides per day of the week, etc.)
- Saves visualizations as .png in the charts/ directory

---

## 📊 Tools & Libraries

- `tidyverse` – data wrangling and visualization
- `lubridate` – working with dates and times
- `janitor` – clean column names
- `skimr` – quick data summaries
- `scales` – format plots nicely
- `here` – manage relative file paths cleanly

---

## 📈 Key Insights

1. **Casual vs. Member Ride Duration**  
   Casual riders tend to have significantly longer average ride durations. This could inform pricing strategies or marketing campaigns focused on casual riders.

2. **Usage by Day of the Week**  
   Casual riders prefer weekends, while members show more predictable weekday commuting patterns.

3. **Peak Ride Times**  
   The majority of rides occur during late afternoons and early evenings, which could suggest peak hours for maintenance or marketing.

4. **Monthly Trends**  
   Summer months see the highest usage, especially among casual riders. This could indicate opportunities for seasonal promotions or resource allocation.

---

## ▶️ How to Run the Analysis

### 📦 Prerequisites

Install required R packages:

```r
install.packages(c("tidyverse", "lubridate", "janitor", "skimr", "scales", "here"))
```

### 🚀 Steps

1. **Run `01_load_and_combine_data.R`** to:
   - Load, clean, and preprocess the data
   - Engineer useful features like `ride_length`, `day_of_week`, and `month`
   - Save the cleaned dataset in `data/cleaned/` as both `.csv` and `.RDS`

2. **Run `02_bike_share_analysis.R`** to:
   - Load the cleaned dataset
   - Perform descriptive statistical analysis
   - Generate visualizations and save them as .png files in the charts/ directory

---

## Files and Folders

- `data/raw/` — raw CSV files  
- `data/cleaned/` — cleaned datasets  
- `scripts/` — R scripts for cleaning and analysis  
- `charts/` — output images  
- `README.md` — project overview

---

## 🧠 Conclusion

This case study demonstrates how R can be used to:

- Clean and prepare large datasets
- Perform effective exploratory data analysis (EDA)
- Create impactful visualizations
- Communicate insights in a reproducible, transparent way

The findings can help Cyclistic (or similar bike-share companies) improve marketing strategies, resource allocation, and user engagement by better understanding rider behavior patterns.

---

## 👤 Author

Feel free to connect with me on [LinkedIn](https://linkedin.com/in/parisloyo) or reach out if you have any questions or feedback about this project!

---
