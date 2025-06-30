# ====================================
# Bike Share Case Study - Analysis Script
# Author: Paris Loyo
# Date: June 2025
# Description: EDA and insights for Cyclistic 2024 data
# ====================================

# ---- 1. Load Libraries ----
# Load libraries for data manipulation, analysis, and visualization
library(tidyverse)  # Includes dplyr, ggplot2, and other packages for data analysis
library(lubridate)  # For handling date and time objects (e.g., extracting hours)
library(skimr)      # For quick summary statistics of the dataset
library(scales)     # For formatting numbers (e.g., adding commas to large numbers)

# ---- 2. Load Cleaned Combined Data ----
# Load cleaned bike share data (12 months combined)
bike_data <- read_csv(output_path)

# ---- Optional: Quick Data Check ----
# Glimpse to quickly inspect the structure and data types of the dataset
glimpse(bike_data)  # Displays column names, data types, and a preview of data
skim(bike_data)     # Provides summary statistics (mean, min, max, NA counts, etc.)
anyNA(bike_data)    # Check if there are any missing values in the dataset

# ---- 3. Descriptive Analysis ----
# 3.1. Basic summary stats (duration and count)
summary_stats <- bike_data %>%
  group_by(member_casual) %>%  # Group by 'member_casual' to compare members vs casual riders
  summarise(
    avg_duration = mean(ride_length),    # Calculate average ride duration
    median_duration = median(ride_length), # Calculate median ride duration
    max_duration = max(ride_length),      # Calculate the maximum ride duration
    min_duration = min(ride_length),      # Calculate the minimum ride duration
    sd_duration = sd(ride_length),        # Calculate the standard deviation of ride durations
    ride_count = n()                      # Count the number of rides in each group
  )

# Display summary statistics for members vs. casual riders
print(summary_stats)

# 3.2. Ensure 'day_of_week' is a factor with levels ordered from Sunday to Saturday
# Convert 'day_of_week' to a factor and set levels from Sun to Sat
bike_data$day_of_week <- factor(bike_data$day_of_week, levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))

# 3.3. Rides by day of week
# Group by user type and day of the week to calculate ride counts and avg duration
rides_by_day <- bike_data %>%
  group_by(member_casual, day_of_week) %>%  # Group by user type and day of the week
  summarise(rides = n(),                   # Count the number of rides for each combination
            avg_duration = mean(ride_length)) %>%  # Calculate the average ride duration
  arrange(member_casual)     # Arrange the data by user type

# Print the ride counts and average durations by day of week
print(rides_by_day)

# 3.4. Ride counts by time of day
# Extract 'hour_of_day' from 'started_at' timestamp
bike_data <- bike_data %>%
  mutate(hour_of_day = hour(started_at))  # Extract hour from the 'started_at' column (in 24-hour format)

# Group the data by 'member_casual' and 'hour_of_day', then calculate the ride counts by hour
rides_by_time <- bike_data %>%
  group_by(member_casual, hour_of_day) %>%  # Group by user type and hour of the day
  summarise(rides = n())                    # Count the number of rides for each hour

# Print the ride counts by time of day
print(rides_by_time)

# 3.5. Ride counts by month
# Convert 'month' to a factor and order from Jan to Dec
rides_by_month <- bike_data %>%
  group_by(member_casual, month) %>%       # Group by user type and month
  summarise(rides = n())                   # Count the number of rides in each month

# Set the 'month' column as a factor and order it from January to December (using month.abb, which is abbreviated month names)
rides_by_month <- rides_by_month %>%
  mutate(month = factor(month, levels = month.abb))  # Ensure months are ordered from Jan to Dec

# Print the ride counts by month
print(rides_by_month)

# ---- 4. Visualizations ----
# 4.1. Rides by Day of Week (chart)
# Bar chart: Rides by day of week by user type
ggplot(rides_by_day, aes(x = day_of_week, y = rides, fill = member_casual)) +
  geom_col(width = 0.7, position = "dodge") +  # Create separate bars for each day of the week and user type (dodged side by side)
  scale_y_continuous(labels = label_comma()) +  # Format y-axis with commas for easier readability
  labs(title = "Number of Rides by Day of Week",  # Title and axis labels
       x = "Day of Week", y = "Ride Count") +
  theme_minimal() +  # Use minimal theme (clean, simple design)
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

# 4.2. Average Ride Duration by User Type (chart)
# Bar chart: Average ride duration by user type
ggplot(summary_stats, aes(x = member_casual, y = avg_duration, fill = member_casual)) +
  geom_col() +  # Create bars for each user type
  labs(title = "Average Ride Duration by User Type",  # Title and axis labels
       x = "User Type", y = "Avg Duration (minutes)") +
  theme_minimal()  # Use minimal theme

# 4.3. Rides by Hour of Day (chart)
# Bar chart: Rides by hour of day by user type
ggplot(rides_by_time, aes(x = hour_of_day, y = rides, fill = member_casual)) +
  geom_col(position = "dodge") +  # Create separate bars for each hour and user type
  scale_y_continuous(labels = label_comma()) +  # Format y-axis with commas for readability
  labs(title = "Ride Counts by Time of Day",  # Title and axis labels
       x = "Hour of Day", y = "Ride Count") +
  theme_minimal()  # Use minimal theme

# 4.4. Ride counts by month (chart)
# Bar chart: Ride counts by month (Jan - Dec) for each user type
ggplot(rides_by_month, aes(x = month, y = rides, fill = member_casual)) +
  geom_col(width = 0.7, position = "dodge") +  # Create separate bars for each month and user type
  scale_y_continuous(labels = label_comma()) +  # Format y-axis with commas for readability
  labs(title = "Ride Counts by Month",  # Title and axis labels
       x = "Month", y = "Ride Count") +
  theme_minimal() +  # Use minimal theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability
