# citbiclean Package Setup Guide

## Part 1 Complete ✓

The `citbiclean` R package has been successfully created with all required components.

## Package Structure

```
citbiclean/
├── DESCRIPTION           # Package metadata
├── NAMESPACE            # Exported functions (auto-generated)
├── README.md            # Package documentation
├── R/
│   ├── clean_citbi.R    # Data cleaning function
│   └── data.R           # Dataset documentation
├── data/
│   └── citbi_raw.rda    # Raw dataset for lazy-loading
├── data-raw/
│   └── prepare_data.R   # Script to prepare data
└── man/
    ├── clean_citbi.Rd   # Function documentation
    └── citbi_raw.Rd     # Dataset documentation
```

## Installation

From the project root directory:

```r
install.packages("citbiclean", repos = NULL, type = "source")
```

## Usage in Your Files

### In `constant_modeling.qmd`:

```r
# Load the package
library(citbiclean)

# Access raw data (lazy-loaded - no read_csv needed!)
# citbi_raw is automatically available

# Clean the data
data <- clean_citbi()

# Now proceed with Part 2 & 3...
```

### In `modeling.qmd`:

```r
# Load the package
library(citbiclean)
library(tidymodels)

# Clean the data
data <- clean_citbi()

# Now proceed with Part 4, 5, & 6...
```

### In `competition.R`:

```r
# Load the package
library(citbiclean)

# Clean training data
train_data <- clean_citbi()

# Load and clean test data
# test_data <- read_csv("test.csv")
# ... (you'll need to apply similar cleaning to test data)

# Now proceed with Part 7...
```

## What the Package Does

### 1. Provides `citbi_raw` dataset
- Lazy-loaded (no file paths needed)
- Automatically available after `library(citbiclean)`
- 30,379 rows × 26 columns

### 2. Provides `clean_citbi()` function
- Converts missing codes (91, 92) to NA
- Creates target variable `citbi`:
  - `Yes` if patient has ciTBI (PosIntFinal=1 OR DeathTBI=1)
  - `No` otherwise
- Converts variables to appropriate types:
  - Binary variables → factors ("No", "Yes")
  - Gender → factor ("Male", "Female")
  - Continuous variables → numeric
- Returns: 30,379 rows × 27 columns (adds `citbi` column)

### 3. Full Documentation
- `?citbi_raw` - Dataset documentation
- `?clean_citbi` - Function documentation

## Key Features

✓ **Roxygen2 documentation** for all functions and datasets
✓ **Lazy-loading** of raw dataset (access via `citbi_raw`)
✓ **Proper package structure** following R standards
✓ **Tested and verified** - all components working

## Target Variable Distribution

- No ciTBI: 29,832 patients (98.2%)
- Yes ciTBI: 547 patients (1.8%)

## Next Steps

Now you can proceed with:
- **Part 2**: Create constant prediction models
- **Part 3**: Calculate accuracy, precision, and recall
- **Part 4-6**: Build and evaluate ML models
- **Part 7**: Kaggle competition

Simply load the package in each file and use `clean_citbi()` to get cleaned data!
