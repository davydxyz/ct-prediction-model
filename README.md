# CT Predict: Predicting Clinically-Important Traumatic Brain Injury

A machine learning project to identify children at very low risk of clinically-important traumatic brain injuries (ciTBI) for whom CT imaging might be unnecessary, helping to reduce unnecessary radiation exposure in pediatric patients.

## Project Overview

CT imaging of head-injured children carries risks of radiation-induced malignancy. This project builds classification models to predict ciTBI in pediatric patients using clinical features, potentially reducing unnecessary CT scans while maintaining patient safety.

### Main Research Question

**Can we identify children at very low risk of clinically-important traumatic brain injuries using clinical predictors alone?**

## Dataset

The project uses data from the PECARN (Pediatric Emergency Care Applied Research Network) study:

- **30,379 pediatric patients** with head trauma
- **Clinical features**: age, gender, symptoms (vomiting, altered mental status), Glasgow Coma Scale scores, and physical exam findings
- **Target variable (ciTBI)**: Patient has clinically-important TBI if they had a positive intervention OR died from TBI

### Reference

Kuppermann et al. (2009) "Identification of children at very low risk of clinically-important brain injuries after head trauma: a prospective cohort study." *The Lancet*, 374(9696), 1160-1170.
[PubMed Link](https://pubmed.ncbi.nlm.nih.gov/19758692/)

## Project Structure

```
.
├── README.md                    # This file
├── citbiclean/                  # R package for data cleaning
│   ├── R/
│   │   ├── clean_citbi.R       # Data cleaning functions
│   │   └── data.R              # Dataset documentation
│   ├── data/
│   │   └── citbi_raw.rda       # Raw dataset (lazy-loaded)
│   ├── man/                    # Package documentation
│   └── DESCRIPTION             # Package metadata
├── data/
│   ├── citbi.csv               # Original dataset
│   ├── tbi_data_dictionary.xlsx
│   └── Kuppermann_2009_The-Lancet_000.pdf
├── constant_modeling.qmd        # Baseline models (Parts 2-3)
├── modeling.qmd                 # ML models (Parts 4-6)
├── competition.R                # Kaggle competition submission script
├── test.csv                     # Test set for Kaggle
└── submission.csv               # Model predictions for Kaggle
```

## Key Components

### 1. Data Cleaning Package (`citbiclean`)

A custom R package that:
- Provides lazy-loading access to the raw dataset (`citbi_raw`)
- Implements data cleaning functions with roxygen2 documentation
- Handles missing value codes (91 = "Don't know", 92 = "Refused")
- Creates the binary target variable `citbi`
- Converts variables to appropriate types (factors, numerics)

**Installation:**
```r
devtools::install("citbiclean")
```

**Usage:**
```r
library(citbiclean)

# Access raw data (lazy-loaded)
head(citbi_raw)

# Clean the data
clean_data <- clean_citbi()
```

### 2. Modeling Approach

The project evaluates multiple classification algorithms:

**Baseline Models:**
- Constant predictions (all positive / all negative)

**Machine Learning Models:**
- Logistic Regression
- K-Nearest Neighbors (KNN)
- Decision Tree (optional)
- Random Forest (optional)
- LightGBM (optional)

### 3. Model Evaluation

Models are evaluated using classification metrics appropriate for imbalanced medical data:

- **Accuracy**: Overall correctness
- **Precision**: Of predicted ciTBI cases, how many actually have ciTBI?
- **Recall**: Of actual ciTBI cases, how many did we identify?
- **F-beta Score**: Weighted harmonic mean of precision and recall

For this medical application, **recall is most important** to avoid missing true ciTBI cases, as false negatives could have serious consequences.

### 4. Hyperparameter Tuning

The project implements hyperparameter tuning using tidymodels framework to optimize model performance, particularly focusing on maximizing the F1-score.

### 5. Kaggle Competition

The final model is evaluated on a held-out test set (13,013 observations) in a Kaggle competition, with the goal of maximizing F1-score.

## Getting Started

### Prerequisites

```r
# Required packages
install.packages(c(
  "tidymodels",
  "tidyverse",
  "dplyr",
  "rpart",      # Decision trees
  "ranger",     # Random forest
  "kknn",       # K-nearest neighbors
  "lightgbm"    # LightGBM (optional)
))
```

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ct-predict-davydxyz
```

2. Install the `citbiclean` package:
```r
devtools::install("citbiclean")
```

### Running the Analysis

1. **Baseline models** (Parts 2-3):
```bash
quarto render constant_modeling.qmd
```

2. **Machine learning models** (Parts 4-6):
```bash
quarto render modeling.qmd
```

3. **Generate Kaggle submission**:
```r
source("competition.R")
```

This creates `submission.csv` with predictions for the test set.

## Results

The current best model uses:
- **Algorithm**: K-Nearest Neighbors (K=5)
- **Features**: `AgeInMonth`, `Gender`, `GCSTotal`, `Vomit`, `AMS`
- **Preprocessing**: Median imputation for numeric features, mode imputation for categorical features, normalization

The submission file includes predictions for 13,013 test observations.

## Key Findings

- **Feature importance**: Glasgow Coma Scale (GCS) scores and altered mental status are strong predictors of ciTBI
- **Class imbalance**: ciTBI is rare (~1-2% of cases), requiring careful evaluation metric selection
- **Model trade-offs**: Higher recall (catching more ciTBI cases) often comes at the cost of more false positives (unnecessary CT scans)

## Files Generated

- `constant_modeling.pdf`: Analysis of baseline models
- `modeling.pdf`: Machine learning model results
- `submission.csv`: Kaggle competition predictions (id, target_feature)

## Submission Requirements

1. **GitHub**: Push all `.qmd` files, rendered `.pdf` files, `competition.R`, and the `citbiclean` package
2. **Kaggle**: Submit `submission.csv` to the competition leaderboard

## Author

Yizhou Xu (davyd@berkeley.edu)

## Course

STAT 133 - Project 6
University of California, Berkeley

## License

MIT
