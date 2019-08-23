library(dplyr)
library(shiny)
library(DT)
library(ggrepel)
library(RColorBrewer)
library(shinydashboard)


### References:
#The editable table's coding was mostly obtained from Yihui Xie's answer in the post below
#https://groups.google.com/forum/#!topic/shiny-discuss/FeqU0AoTpz0


enableBookmarking(store = "url")


### Initial fixed parameters #TODO: consider taking shiny input here.
u <- 50
sd <- 20
base <-
  data.frame(x = seq(0, 100, length = 100),
             y = dnorm(seq(0, 100, length = 100), mean = u, sd = sd))



### Useful

# # Print the values of inputs
# output$x2 = renderPrint({
#   data.frame(Task = shinyValue('v1_', 20), Progress = shinyValue('v2_', 20), Show = shinyValue('v3_',20))
# })
#verbatimTextOutput('x2')

# # show table used in plot
# output$x3 <- renderTable({
#   tasks()
# })

# ,
# tableOutput('x3'))
