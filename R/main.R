library(dplyr) |> suppressPackageStartupMessages()
library(shiny)
library(shinyWidgets)
library(bslib) |> suppressPackageStartupMessages()
library(dplyr)
library(DT) |> suppressPackageStartupMessages()
library(fs)
library(succor)

is_data <- 
    !fs::dir_ls(
        fs::path_wd("data"),
        regexp = "[.]xlsx$"
    ) |>
    rlang::is_empty() 

if (is_data) source(fs::path_wd("R/data-massage", ext = "R"))

main <- function() shiny::runApp("app")

main()
