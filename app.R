library(shiny)
library(shinydashboard)
library(tidyverse)

ui <- dashboardPage(
  dashboardHeader(title = "Star Wars"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Homeworld", tabName = "homes", icon = icon("jedi")),
      menuItem("Species", tabName = "species", icon = icon("pastafarianism"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "homes",
        fluidRow(
          box(title = "Homeworld Graph", 
              selectInput("sw_species", "Choose species", choices = c(unique(starwars$species)))),
          box(plotOutput(outputId = "sw_plot"))
        )
      ),
      tabItem(
        tabName = "species",
        fluidRow(
          box(title = "Species Body Graph",
              selectInput("sw_species_2", "Choose species", choices = c(unique(starwars$species)))),
          box(plotOutput(outputId = "body_plot"))
        )
      )
    )
  )
)

server <- function(input, output) {
  species_df <- reactive({
    starwars %>% 
      filter(species == input$sw_species)
  })
  output$sw_plot <- renderPlot({
    ggplot(data = species_df(), aes(x = homeworld)) +
      geom_bar() +
      coord_flip()
  })
  species_df_2 <- reactive({
    starwars %>% 
      filter(species == input$sw_species_2)
  })
  output$body_plot <- renderPlot({
    ggplot(data = species_df_2(), aes(x = height, y = mass)) +
      geom_point() +
      geom_smooth()
  })
}

shinyApp(ui = ui, server = server)