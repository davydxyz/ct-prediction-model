#' Clean ciTBI Dataset
#'
#' This function cleans and prepares the raw ciTBI dataset for modeling by
#' handling missing values, converting variable types, and creating the target
#' variable for clinically-important traumatic brain injury (ciTBI).
#'
#' @param data A data frame containing the raw ciTBI data. Defaults to the
#'   built-in `citbi_raw` dataset.
#'
#' @return A cleaned data frame ready for modeling with:
#'   \itemize{
#'     \item Missing value codes (91, 92) converted to NA
#'     \item Target variable `citbi` created (1 if patient has ciTBI, 0 otherwise)
#'     \item Categorical variables converted to factors
#'     \item Numeric variables properly typed
#'   }
#'
#' @details
#' The function performs the following cleaning steps:
#' \itemize{
#'   \item Converts special missing value codes (91 = "Don't know", 92 = "Refused") to NA
#'   \item Creates the target variable `citbi` based on `PosIntFinal` or `DeathTBI`
#'   \item Converts binary and categorical variables to factors
#'   \item Ensures numeric variables are properly typed
#'   \item Removes unnecessary identifier columns if desired
#' }
#'
#' @examples
#' \dontrun{
#' # Load the package
#' library(citbiclean)
#'
#' # Clean the built-in raw data
#' clean_data <- clean_citbi()
#'
#' # Or clean custom data
#' clean_data <- clean_citbi(my_data)
#' }
#'
#' @export
#' @importFrom dplyr mutate across everything
clean_citbi <- function(data = citbi_raw) {
  data <- data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(),
        ~ dplyr::case_when(
          . == 91 ~ NA_real_,
          . == 92 ~ NA_real_,
          TRUE ~ as.numeric(.)
        )
      )
    )

  data <- data |>
    dplyr::mutate(
      citbi = dplyr::case_when(
        PosIntFinal == 1 | DeathTBI == 1 ~ 1,
        TRUE ~ 0
      )
    )

  binary_vars <- c("Amnesia_verb", "Seiz", "ActNorm", "HA_verb", "Vomit",
                   "Dizzy", "AMS", "SFxPalp", "FontBulg", "Hema", "Clav",
                   "NeuroD", "OSI", "CTForm1", "CTDone", "DeathTBI",
                   "PosIntFinal", "citbi")

  data <- data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::any_of(binary_vars),
        ~ factor(., levels = c(0, 1), labels = c("No", "Yes"))
      )
    )

  if ("Gender" %in% names(data)) {
    data <- data |>
      dplyr::mutate(
        Gender = factor(Gender, levels = c(1, 2), labels = c("Male", "Female"))
      )
  }

  numeric_vars <- c("AgeInMonth", "LocLen", "SeizLen", "GCSEye",
                    "GCSVerbal", "GCSMotor", "GCSTotal")

  data <- data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::any_of(numeric_vars),
        ~ as.numeric(.)
      )
    )

  return(data)
}
