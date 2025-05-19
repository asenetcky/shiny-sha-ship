library(shiny)
library(bslib)
library(dplyr)

# data layer

data <-
    nanoparquet::read_parquet(
        fs::path_wd(
            "state-sha-ship",
            ext = "parquet"
        )
    )

state_list <- unique(data$state_territory)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
    # App title ----
    title = "Other State's SHAs and SHIPs",
    headerPanel("State/Territory Selector"),
    # Sidebar panel for inputs ----
    sidebar = sidebar(
        # select state or other
        selectInput("selected_state", "Select State or Territory", state_list)
    ),
    # Output: Histogram ----
    verbatimTextOutput("text")
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {
    selected_data <- reactive({
        data |> filter(state_territory == input$selected_state)
    })

    output$text <- renderPrint({
        print(selected_data())
    })
}


shinyApp(ui = ui, server = server)
