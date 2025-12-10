# Example Usage of the citbiclean Package
# ==========================================

# 1. Install the package (run once)
# install.packages("citbiclean", repos = NULL, type = "source")

# 2. Load the package
library(citbiclean)
library(dplyr)

# 3. Access the raw data (lazy-loaded, automatically available)
# No need for read_csv() or any file path!
head(citbi_raw)
dim(citbi_raw)  # 30,379 × 26

# 4. Clean the data using the package function
clean_data <- clean_citbi()

# 5. Inspect the cleaned data
dim(clean_data)  # 30,379 × 27 (added citbi column)

# Check the target variable
table(clean_data$citbi)
#    No   Yes
# 29832   547

# Check for missing values
colSums(is.na(clean_data))

# 6. Use in modeling (example)
# Split into train/test or use directly for modeling

# Example: Check class balance
prop.table(table(clean_data$citbi))

# Example: Summary of key variables
summary(clean_data)


# ==========================================
# HOW TO USE IN YOUR QMD AND R FILES
# ==========================================

# In constant_modeling.qmd:
# ```{r}
# library(citbiclean)
# data <- clean_citbi()
# # Your modeling code here...
# ```

# In modeling.qmd:
# ```{r}
# library(citbiclean)
# data <- clean_citbi()
# # Your tidymodels code here...
# ```

# In competition.R:
# library(citbiclean)
# train_data <- clean_citbi()
# # Load test data and make predictions...
