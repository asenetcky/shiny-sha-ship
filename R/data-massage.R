data <-
    read_folder("data") |>
    purrr::pluck(1)

data <-
    data |>
    select(-c("row-id", "note":"interesting")) |>
    rename_with(.fn = \(x) stringr::str_replace_all(x, "-", "_")) |>
    rename_with_stringr() |>
    mutate(
        content_title = stringr::str_to_lower(content_title),
        across(
            c(
                state_territory,
                content_type,
                content_platform,
                content_presentation_layer
            ),
            .fns = \(col) as.factor(col)
        ),
        link_landing_page = if_else(
            link_landing_page != "unknown",
            glue::glue(
                "<a href='{link_landing_page}'>{link_landing_page}</a>"
            ),
            link_landing_page
        ),
        link_item = if_else(
            link_item != "unknown",
            glue::glue(
                "<a href='{link_item}'>{link_item}</a>"
            ),
            link_item
        )
    )

nanoparquet::write_parquet(
    data,
    fs::path_wd("app", "state-sha-ship", ext = "parquet")
)
