library(dplyr)
library(succor)

data <-
    read_folder("data") |>
    purrr::pluck(1)

data <-
    data |>
    select(-c("row-id", "note":"interesting")) |>
    rename_with(.fn = \(x) stringr::str_replace_all(x, "-", "_")) |>
    rename_with_stringr()

nanoparquet::write_parquet(data, "data/state-sha-ship.parquet")
