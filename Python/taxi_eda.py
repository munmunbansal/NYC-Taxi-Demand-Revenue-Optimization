import pandas as pd
import matplotlib.pyplot as plt

# ---------------------------------------------------------
# NYC Taxi Data - Exploratory Data Analysis
# ---------------------------------------------------------

# Load data
df = pd.read_parquet("yellow_tripdata_2025-01.parquet")

print("Dataset shape:", df.shape)

# ---------------------------------------------------------
# 1. Basic Data Exploration
# ---------------------------------------------------------

print("\n--- Dataset Information ---")
print(df.info())

print("\n--- Descriptive Statistics ---")
print(df.describe())

print("\n--- Missing Values ---")
print(df.isnull().sum().sort_values(ascending=False))

# ---------------------------------------------------------
# 2. Trip Duration
# ---------------------------------------------------------

df["trip_duration_min"] = (
    df["tpep_dropoff_datetime"] -
    df["tpep_pickup_datetime"]
).dt.total_seconds() / 60

print("\n--- Trip Duration ---")
print(df["trip_duration_min"].describe())

# ---------------------------------------------------------
# 3. Data Quality Checks
# ---------------------------------------------------------

negative_fares = (df["fare_amount"] < 0).sum()
negative_totals = (df["total_amount"] < 0).sum()
zero_distance = (df["trip_distance"] <= 0).sum()

print("\n--- Data Quality Checks ---")
print("Negative fare records:", negative_fares)
print("Negative total amount records:", negative_totals)
print("Zero/negative distance records:", zero_distance)

# ---------------------------------------------------------
# 4. Outlier Detection
# ---------------------------------------------------------

print("\n--- Extreme Values ---")

print("Maximum trip distance:",
      df["trip_distance"].max())

print("Maximum fare:",
      df["fare_amount"].max())

print("Maximum total amount:",
      df["total_amount"].max())

print("Maximum trip duration:",
      df["trip_duration_min"].max())

# ---------------------------------------------------------
# 5. Hourly Demand Analysis
# ---------------------------------------------------------

df["pickup_hour"] = df["tpep_pickup_datetime"].dt.hour

hourly_trips = (
    df.groupby("pickup_hour")
      .size()
      .reset_index(name="trip_count")
)

print("\n--- Trips by Hour ---")
print(hourly_trips.sort_values("trip_count", ascending=False).head(10))

# ---------------------------------------------------------
# 6. Day-of-Week Analysis
# ---------------------------------------------------------

df["day_of_week"] = df["tpep_pickup_datetime"].dt.day_name()

day_order = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
]

daily_trips = (
    df.groupby("day_of_week")
      .size()
      .reindex(day_order)
      .reset_index(name="trip_count")
)

print("\n--- Trips by Day ---")
print(daily_trips)

# ---------------------------------------------------------
# 7. Payment Type Analysis
# ---------------------------------------------------------

payment_summary = (
    df.groupby("payment_type")
      .size()
      .reset_index(name="trip_count")
      .sort_values("trip_count", ascending=False)
)

print("\n--- Payment Type ---")
print(payment_summary)

# ---------------------------------------------------------
# 8. Correlation Analysis
# ---------------------------------------------------------

correlation = df[
    ["trip_distance", "fare_amount", "total_amount"]
].corr()

print("\n--- Correlation Matrix ---")
print(correlation)

# ---------------------------------------------------------
# 9. Save Aggregated Results
# ---------------------------------------------------------

hourly_trips.to_csv(
    "hourly_trip_summary.csv",
    index=False
)

daily_trips.to_csv(
    "daily_trip_summary.csv",
    index=False
)

print("\nEDA completed successfully.")