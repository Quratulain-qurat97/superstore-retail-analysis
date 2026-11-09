# Superstore Retail Analysis

An end-to-end retail data analytics project using **Python, MySQL, and SQL** to clean, validate, and analyze the Sample Superstore dataset.

## Project Overview

This project explores retail sales, profitability, customer segments, regional performance, and shipping operations using the Sample Superstore dataset.

The workflow focuses on building a reproducible data preparation process, validating data quality, and using SQL to answer business-related questions.

## Tools & Technologies

- **Python** – Data cleaning, transformation, and validation
- **Pandas** – Data manipulation and analysis
- **MySQL** – Database storage and querying
- **SQL** – Business analysis and data validation
- **Git & GitHub** – Version control and project documentation

## Project Structure

```text
superstore-retail-analysis/
│
├── data/
│   ├── raw/
│   │   └── README.md
│   └── processed/
│       └── README.md
│
├── python/
│   └── data_cleaning.py
│
├── sql/
│   └── superstore_analysis_cleaned.sql
│
├── README.md
└── .gitignore
```

## Data Preparation & Cleaning

The Python cleaning script performs the following tasks:

- Loads the original dataset.
- Converts order and shipping dates into proper datetime formats.
- Inspects missing values and duplicate records.
- Validates unique identifiers.
- Checks numeric and categorical fields.
- Standardizes postal codes.
- Performs final data quality checks.
- Exports the cleaned dataset as a CSV file.

### Data Validation Results

| Validation | Result |
|---|---:|
| Total records | 9,994 |
| Total columns | 21 |
| Unique Row IDs | 9,994 |
| Missing values | 0 |
| Duplicate rows | 0 |
| Total Sales | $2,297,200.86 |
| Total Profit | $286,397.02 |

## SQL Analysis

The cleaned dataset is loaded into MySQL for further analysis.

The SQL queries investigate:

1. Regional sales performance
2. Category and sub-category profitability
3. Customer segment performance
4. Discount impact on sales and profit
5. Top 10 customers by revenue
6. Monthly sales trends and month-over-month changes
7. Shipping mode performance
8. Loss-making states

Additional validation queries check record counts, financial totals, discount distributions, invalid values, and database column types.

## Dataset

The Sample Superstore dataset is not included in this repository.

The Kaggle uploader from whom a copy was obtained identifies Tableau's Sample Superstore data as the original source.

- [Tableau Sample Superstore source](https://community.tableau.com/s/question/0D54T00000CWeX8SAL/sample-superstore-sales-excelxls)

Please obtain the dataset from an authorized source and review its applicable terms before use.

## How to Run

### 1. Clone the repository

```bash
git clone https://github.com/Quratulain-qurat97/superstore-retail-analysis.git
```

### 2. Install the required Python library

```bash
pip install pandas
```

### 3. Obtain the dataset

Place the original CSV file in:

```text
data/raw/Sample - Superstore.csv
```

### 4. Run the Python cleaning script

```bash
python python/data_cleaning.py
```

The cleaned dataset will be generated in:

```text
data/processed/Superstore_Cleaned.csv
```

### 5. Run the SQL analysis

Import the cleaned CSV into MySQL, configure the database and table names to match the SQL script, and execute the queries in:

```text
sql/superstore_analysis_cleaned.sql
```

## Project Status

<badge color="success">Python cleaning completed</badge> <badge color="success">SQL analysis prepared</badge>

The interactive dashboard is being developed separately as a React-based project.

## Acknowledgements

The original dataset is credited to its respective owners and creators. The Kaggle uploader identifies Tableau's Sample Superstore data as the source.

The Python cleaning workflow, SQL queries, data validation, and analysis were developed as part of this educational and portfolio project.
