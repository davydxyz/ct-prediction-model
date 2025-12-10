# citbiclean

An R package for cleaning and preparing the Clinically-Important Traumatic Brain Injury (ciTBI) dataset for modeling.

## Installation

Install the package from the local source:

```r
# From the project root directory
install.packages("citbiclean", repos = NULL, type = "source")
```

Or using devtools:

```r
devtools::install("citbiclean")
```

## Usage

### Load the package

```r
library(citbiclean)
```

### Access the raw dataset

The raw dataset is automatically available through lazy-loading:

```r
# Access the raw data
head(citbi_raw)

# Check dimensions
dim(citbi_raw)  # 30,379 rows × 26 columns
```

### Clean the data

Use the `clean_citbi()` function to prepare the data for modeling:

```r
# Clean the built-in raw data
clean_data <- clean_citbi()

# Or clean custom data
clean_data <- clean_citbi(your_data)
```

The cleaning function:
- Converts missing value codes (91 = "Don't know", 92 = "Refused") to NA
- Creates the target variable `citbi` (1 if patient has ciTBI, 0 otherwise)
- Converts binary and categorical variables to factors
- Ensures numeric variables are properly typed

### Use in your analysis scripts

In your `constant_modeling.qmd`, `modeling.qmd`, and `competition.R` files:

```r
# Load the package
library(citbiclean)

# Access raw data (lazy-loaded, no need for read_csv)
# The citbi_raw dataset is automatically available

# Clean the data
clean_data <- clean_citbi()

# Now you can use clean_data for modeling
```

## Package Contents

- **Data**: `citbi_raw` - Raw dataset with 30,379 pediatric head trauma cases
- **Functions**: `clean_citbi()` - Data cleaning and preparation function
- **Documentation**: Full roxygen2 documentation for all functions and datasets

## Dataset Information

The dataset contains clinical data for pediatric patients with head trauma. Key variables include:

- Patient characteristics (age, gender)
- Symptoms (amnesia, headache, vomiting, dizziness)
- Clinical findings (GCS scores, hematoma, neurological deficits)
- Outcomes (CT done, death from TBI, positive intervention)

## Target Variable

A patient has clinically-important TBI (ciTBI) if:
- They have a positive intervention (`PosIntFinal = 1`), OR
- They died from TBI (`DeathTBI = 1`)

## References

Based on the PECARN study:
Kuppermann et al. (2009) "Identification of children at very low risk of clinically-important brain injuries after head trauma: a prospective cohort study." *The Lancet*, 374(9696), 1160-1170.
