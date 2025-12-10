## Code for Kaggle competition (part 7)

library(citbiclean)
library(tidymodels)
library(dplyr)

train_data_full <- clean_citbi()

train_data_full <- train_data_full |>
  filter(
    !is.na(AgeInMonth),
    !is.na(Gender),
    !is.na(GCSTotal),
    !is.na(Vomit),
    !is.na(AMS),
    !is.na(citbi)
  )

competition_test_raw <- read.csv("test.csv")

test_ids <- competition_test_raw$id

competition_test <- competition_test_raw |>
  select(-id) |>
  dplyr::mutate(
    dplyr::across(
      dplyr::everything(),
      ~ dplyr::case_when(
        . == 91 ~ NA_real_,
        . == 92 ~ NA_real_,
        TRUE ~ as.numeric(.)
      )
    )
  ) |>
  mutate(id = test_ids)

binary_vars <- c("Amnesia_verb", "Seiz", "ActNorm", "HA_verb", "Vomit",
                 "Dizzy", "AMS", "SFxPalp", "FontBulg", "Hema", "Clav",
                 "NeuroD", "OSI", "CTForm1", "CTDone", "DeathTBI")

competition_test <- competition_test |>
  dplyr::mutate(
    dplyr::across(
      dplyr::any_of(binary_vars),
      ~ factor(., levels = c(0, 1), labels = c("No", "Yes"))
    )
  )

if ("Gender" %in% names(competition_test)) {
  competition_test <- competition_test |>
    dplyr::mutate(
      Gender = factor(Gender, levels = c(1, 2), labels = c("Male", "Female"))
    )
}

numeric_vars <- c("AgeInMonth", "LocLen", "SeizLen", "GCSEye",
                  "GCSVerbal", "GCSMotor", "GCSTotal")

competition_test <- competition_test |>
  dplyr::mutate(
    dplyr::across(
      dplyr::any_of(numeric_vars),
      ~ as.numeric(.)
    )
  )

citbi_recipie <-
    recipe(citbi ~ AgeInMonth + Gender + GCSTotal + Vomit + AMS, data = train_data_full) |>
    step_impute_median(all_numeric_predictors()) |>
    step_impute_mode(all_nominal_predictors()) |>
    step_zv(all_predictors()) |>
    step_normalize(all_numeric_predictors())

knn_spec <- nearest_neighbor(neighbors = 5) |>
    set_engine("kknn") |>
    set_mode("classification")

knn_workflow <- workflow() |>
    add_recipe(citbi_recipie) |>
    add_model(knn_spec)

final_knn_fit <- knn_workflow |>
    fit(data = train_data_full)

competition_predictions <- competition_test |>
    bind_cols(predict(final_knn_fit, new_data = competition_test, type = "class"))

submission <- competition_predictions |>
    mutate(.pred_class = if_else(is.na(.pred_class), factor("No", levels = c("No", "Yes")), .pred_class)) |>
    mutate(target_feature = if_else(.pred_class == "Yes", 1, 0)) |>
    select(id, target_feature)

write.csv(submission, file = "submission.csv", row.names = FALSE)

cat("Submission file created: submission.csv\n")
cat("Number of predictions:", nrow(submission), "\n")
cat("Prediction distribution:\n")
print(table(submission$target_feature))
cat("\nChecking for NA values:\n")
cat("NA in id:", sum(is.na(submission$id)), "\n")
cat("NA in target_feature:", sum(is.na(submission$target_feature)), "\n")
