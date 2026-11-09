# ============================================================
# 1. IMPORT LIBRARIES
# ============================================================

import pandas as pd
from pathlib import Path

# ============================================================
# 2. LOAD THE ORIGINAL DATASET
# ============================================================

PROJECT_DIR = Path(__file__).resolve().parent.parent

RAW_FILE = PROJECT_DIR / "data" / "raw" / "Sample - Superstore.csv"

df_raw = pd.read_csv(
    RAW_FILE,
    encoding="cp1252",
    dtype={"Postal Code": "string"}
)

# Create a working copy
df = df_raw.copy()

df["Order Date"] = pd.to_datetime(
    df["Order Date"],
    format="%m/%d/%Y",
    errors="coerce"
)

df["Ship Date"] = pd.to_datetime(
    df["Ship Date"],
    format="%m/%d/%Y",
    errors="coerce"
)
print(df[["Order Date", "Ship Date"]].dtypes)

print("Dataset loaded successfully!")


# ============================================================
# 3. INITIAL DATA INSPECTION
# ============================================================

# Display first five records
print("First five records:")
print(df.head())

# Dataset dimensions
print("\nDataset shape:", df.shape)

# Column names
print("\nColumn names:")
print(df.columns.tolist())

# Data types
print("\nData types:")
print(df.dtypes)

# Dataset information
print("\nDataset information:")
df.info()

# ============================================================
# 4. MISSING-VALUE ASSESSMENT
# ============================================================

missing_values = df.isnull().sum()

print("Missing values by column:")
print(missing_values)

print("\nTotal missing values:", missing_values.sum())

print(
    "\nColumns containing missing values:",
    (missing_values > 0).sum()
)

# Check for dates that could not be converted
print(
    "Invalid Order Dates:",
    df["Order Date"].isnull().sum()
)

print(
    "Invalid Ship Dates:",
    df["Ship Date"].isnull().sum()
)





# ============================================================
# 5. DUPLICATE AND IDENTIFIER VALIDATION
# ============================================================

# Check completely duplicated rows
duplicate_rows = df.duplicated().sum()

print("Duplicate rows:", duplicate_rows)

# Check unique Row IDs
print(
    "\nUnique Row IDs:",
    df["Row ID"].nunique()
)

print("Total rows:", len(df))

# Check unique Order IDs
print(
    "\nUnique Order IDs:",
    df["Order ID"].nunique()
)

print("Total transaction rows:", len(df))




# ============================================================
# 6. DATE CONSISTENCY VALIDATION
# ============================================================

invalid_dates = df[
    (df["Ship Date"] < df["Order Date"]) |
    df["Order Date"].isna() |
    df["Ship Date"].isna()
]

print("Invalid date records:", len(invalid_dates))

print(
    invalid_dates[
        ["Order Date", "Ship Date"]
    ].head()
)





# ============================================================
# 7. NUMERICAL DATA ASSESSMENT
# ============================================================

numeric_columns = [
    "Sales",
    "Quantity",
    "Discount",
    "Profit"
]

# Statistical summary
print("Numerical summary:")
print(df[numeric_columns].describe())

# Check Sales values
print(
    "Sales zero or below:",
    (df["Sales"] <= 0).sum()
)

# Check Profit values
print(
    "\nProfit zero:",
    (df["Profit"] == 0).sum()
)

print(
    "Profit negative:",
    (df["Profit"] < 0).sum()
)

print(
    "Profit positive:",
    (df["Profit"] > 0).sum()
)

# Distribution of discount values
print(
    df["Discount"]
    .value_counts()
    .sort_index()
)

# Distribution of product quantities
print(
    df["Quantity"]
    .value_counts()
    .sort_index()
)

# ============================================================
# 8. FINANCIAL TOTALS VERIFICATION
# ============================================================

total_rows = len(df)

total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()

average_discount = df["Discount"].mean()

print("Total Rows:", total_rows)

print(
    "Total Sales:",
    round(total_sales, 2)
)

print(
    "Total Profit:",
    round(total_profit, 2)
)

print(
    "Average Discount:",
    round(average_discount, 4)
)

# ============================================================
# 9. CATEGORICAL DATA VALIDATION
# ============================================================

categorical_columns = [
    "Ship Mode",
    "Segment",
    "Region",
    "Category",
    "Sub-Category"
]

for column in categorical_columns:

    print(f"\n{column}:")

    print(
        df[column].value_counts()
    )

# ============================================================
# 10. CATEGORY AND SUB-CATEGORY RELATIONSHIP
# ============================================================

subcategory_relationship = (
    df.groupby("Sub-Category")["Category"]
    .nunique()
    .sort_values(ascending=False)
)

print(subcategory_relationship)



# ============================================================
# 11. PRODUCT NAME INSPECTION
# ============================================================

print("Sample product names:")

for name in df["Product Name"].head(15):
    print(name)



# ============================================================
# 12. CREATE CLEANED DATAFRAME
# ============================================================

clean_df = df.copy()

print("Original dataset shape:", df.shape)

print("Working dataset shape:", clean_df.shape)

print("\nWorking dataset data types:")
print(clean_df.dtypes)



# ============================================================
# 13. POSTAL CODE VALIDATION AND CLEANING
# ============================================================

# Check postal code data type
print(
    "Postal Code data type:",
    clean_df["Postal Code"].dtype
)

# Check postal code lengths before standardization
print(
    "\nShortest postal code length:",
    clean_df["Postal Code"].str.len().min()
)

print(
    "Longest postal code length:",
    clean_df["Postal Code"].str.len().max()
)

# Identify invalid postal code formats
if clean_df["Postal Code"].isna().any():
    raise ValueError("Missing postal codes found. Review them before cleaning.")
postal_codes = clean_df["Postal Code"].dropna()

invalid_postal_codes = postal_codes[
    ~postal_codes.str.fullmatch(r"\d{1,5}")
]

print(
    "\nInvalid postal code formats:",
    len(invalid_postal_codes)
)

print(invalid_postal_codes.head())

# Standardize postal codes to five characters

if len(invalid_postal_codes) > 0:
    raise ValueError(
        "Invalid postal codes found. Review them before cleaning."
    )

clean_df["Postal Code"] = (
    clean_df["Postal Code"].str.zfill(5)
)

print("Postal codes standardized successfully.")

print(
    "Shortest length:",
    clean_df["Postal Code"].str.len().min()
)

print(
    "Longest length:",
    clean_df["Postal Code"].str.len().max()
)

print(
    "\nPostal code samples:"
)

print(
    clean_df["Postal Code"].head(10)
)



# ============================================================
# 14. FINAL DATA QUALITY VALIDATION
# ============================================================

print("FINAL DATASET VALIDATION")

print("-" * 40)

print("Rows:", len(clean_df))

print("Columns:", len(clean_df.columns))

print(
    "Total Sales:",
    round(clean_df["Sales"].sum(), 2)
)

print(
    "Total Profit:",
    round(clean_df["Profit"].sum(), 2)
)

print(
    "Missing values:",
    clean_df.isnull().sum().sum()
)

print(
    "Duplicate rows:",
    clean_df.duplicated().sum()
)

print(
    "Unique Row IDs:",
    clean_df["Row ID"].nunique()
)

date_check = (
    clean_df["Ship Date"].notna() &
    clean_df["Order Date"].notna() &
    (clean_df["Ship Date"] >= clean_df["Order Date"])
)
assert date_check.all()

print("Invalid date records:", (~date_check).sum())




# ============================================================
# 15. FINAL VALIDATION ASSERTIONS
# ============================================================

# 1. Verify dataset dimensions
assert clean_df.shape == (9994, 21)

# 2. Verify no missing values
assert clean_df.isnull().sum().sum() == 0

# 3. Verify no duplicate rows
assert clean_df.duplicated().sum() == 0

# 4. Verify Row ID uniqueness
assert clean_df["Row ID"].nunique() == 9994

# 5. Verify Sales total
assert round(clean_df["Sales"].sum(), 2) == 2297200.86

# 6. Verify Profit total
assert round(clean_df["Profit"].sum(), 2) == 286397.02

# 7. Verify all postal codes contain exactly five digits
assert clean_df["Postal Code"].str.fullmatch(r"\d{5}").all()

# 8. Verify date data types
assert pd.api.types.is_datetime64_any_dtype(clean_df["Order Date"])
assert pd.api.types.is_datetime64_any_dtype(clean_df["Ship Date"])

# 9. Verify no missing or invalid dates
assert clean_df["Order Date"].notna().all()
assert clean_df["Ship Date"].notna().all()

# 10. Validate chronological order of dates
date_check = clean_df["Ship Date"] >= clean_df["Order Date"]

print("All dates valid:", date_check.all())
print("Invalid date count:", (~date_check).sum())

assert date_check.all()

# 11. Final confirmation
print("All final validation assertions passed!")




# ============================================================
# 16. EXPORT CLEANED DATASET
# ============================================================

PROCESSED_FILE = PROJECT_DIR / "data" / "processed" / "Superstore_Cleaned.csv"

clean_df.to_csv(
    PROCESSED_FILE,
    index=False,
    encoding="utf-8"
)

print("Cleaned dataset exported successfully!")
print("Export location:", PROCESSED_FILE.resolve())
print("Exported file exists:", PROCESSED_FILE.exists())
