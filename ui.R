
library(shiny)
library(DT)
library(ggrepel)



shinyUI(fluidPage(
  # Application title
  titlePanel("Hill Chart in R"),
  
  # Sidebar with tables for inputs
  sidebarLayout(
    sidebarPanel(dataTableOutput('x1'), width = 3),
    mainPanel(plotOutput("hill"),
              verbatimTextOutput('x2'),
              tableOutput('x3'))
  )
))







#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#Reference https://github.com/jienagu/DT_editable_as_shiny_input

# 
# 
# library(shiny)
# library(V8)
# library(shinyjs)
# library(shinysky)
# library(DT)
# library(data.table)
# library(lubridate)
# library(shinyalert)
# 
# useShinyalert()
# # Define UI for application that draws a histogram
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("DT Editor Minimal Example"),
#   shinyjs::useShinyjs(),
#   shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
#   actionButton("refresh", "Reset",style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
#   
#   helpText("Note: Remember to save any updates!"),
#   br(),
#   ### tags$head() is to customize the download button
#   tags$head(tags$style(".butt{background-color:#230682;} .butt{color: #e6ebef;}")),
#   downloadButton("Trich_csv", "Download in CSV", class="butt"),
#   useShinyalert(), # Set up shinyalert
#   uiOutput("MainBody_trich"),actionButton(inputId = "Updated_trich",label = "Save")
# ))

# 
# library(shiny)
# 
# # Define UI for application that draws a histogram
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("Hill Chart in R"),
#   
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     sidebarPanel(
#        sliderInput("bins",
#                    "Number of bins:",
#                    min = 1,
#                    max = 50,
#                    value = 30),
#        textInput("inputID", "label", value = "jjj", width = NULL,
#                  placeholder = NULL)
#     ),
#    
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#        plotOutput("distPlot")
#     )
#   )
# ))
