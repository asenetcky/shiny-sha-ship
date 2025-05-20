# data layer
data <-
    nanoparquet::read_parquet(
        fs::path_wd(
            #"app",
            "state-sha-ship",
            ext = "parquet"
        )
    )

# user selection
state_list <- levels(data$state_territory)

content_type_list <- levels(data$content_type)

content_platform_list <- levels(data$content_platform)

# ui that filters a DT table
ui <- page_sidebar(
    # App title ----
    title = "Other State's SHAs and SHIPs",
    # Sidebar panel for inputs ----
    sidebar = sidebar(
        width = 500,
        # select state or other
        pickerInput(
            inputId = "selected_state",
            label = "Select State or Territory",
            choices = state_list,
            options = pickerOptions(
                actionsBox = TRUE,
                size = 5,
                selectedTextFormat = "count > 3"
            ),
            multiple = TRUE,
            selected = "massachusetts"
        ),
        pickerInput(
            inputId = "selected_content_type",
            label = "select content type",
            choices = content_type_list,
            options = pickerOptions(
                actionsBox = TRUE,
                size = 5
            ),
            multiple = TRUE,
            selected = content_type_list
        ),
        pickerInput(
            inputId = "selected_content_platform",
            label = "select platform type",
            choices = content_platform_list,
            options = pickerOptions(
                actionsBox = TRUE,
                size = 5
            ),
            multiple = TRUE,
            selected = content_platform_list
        )
    ),
    # Output: DT Table ----
    DT::dataTableOutput("table")
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {
    selected_data <- reactive({
        data |>
            filter(
                state_territory %in%
                    input$selected_state &
                    (content_type %in%
                        input$selected_content_type |
                        content_platform %in% input$selected_content_platform)
                #&
                #content_type %in% input$selected_content_type &
                # content_platform %in% input$selected_content_platform
            )
    })

    output$table <- DT::renderDataTable({
        DT::datatable(selected_data(), escape = FALSE)
    })
}


shinyApp(ui = ui, server = server)
