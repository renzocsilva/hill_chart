shinyUI(fluidPage(
  # Application title
  titlePanel("Hill Chart in R"),
  
  # Sidebar with tables for inputs
  sidebarLayout(
    sidebarPanel(dataTableOutput('x1'), width = 3),
    mainPanel(plotOutput("hill"),
              tableOutput('x3'))
  )
))