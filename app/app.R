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

my_selection <- unique(data$state_territory)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
    # App title ----
    title = "Other State's SHAs and SHIPs",
    headerPanel("State/Territory Selector"),
    # Sidebar panel for inputs ----
    sidebar = sidebar(
        # select state or other
        selectInput("selected_state", "Select State or Territory", my_selection)
    ),
    # Output: Histogram ----
    textOutput("text")
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {
    selected_data <- reactive({
        data |> filter(state_territory == input$selected_state)
    })

    output$text <- renderText({
        print(selected_data())
    })

    # 1. It is "reactive" and therefore should be automatically
    #    re-executed when inputs (input$bins) change
    # 2. Its output type is a plot
    # output$distPlot <- renderPlot({
    #     x <- faithful$waiting
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)

    #     hist(
    #         x,
    #         breaks = bins,
    #         col = "#007bc2",
    #         border = "white",
    #         xlab = "Waiting time to next eruption (in mins)",
    #         main = "Histogram of waiting times"
    #     )
    # })
}


shinyApp(ui = ui, server = server)
