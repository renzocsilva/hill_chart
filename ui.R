shinyUI(fluidPage(
  # Application title
  titlePanel("Hill Chart in R"),
  
  # Sidebar with tables for inputs
  sidebarLayout(
    sidebarPanel(bookmarkButton(),
                 hr(),
                 dataTableOutput('x1'),
                 width = 4),
    mainPanel(
      plotOutput("hill"),
      hr(),
      column(4, includeMarkdown("README.md")),
      box(
        title = "Example",
        align = "center",
        img(
          src = 'example.png',
          align = "center",
          height = 300
        )
      )
    )
  )
))