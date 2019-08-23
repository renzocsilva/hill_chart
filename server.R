library(dplyr)


### Initial fixed parameters #TODO: consider taking shiny input here.
u <- 50
sd <- 20
base <- data.frame(x = seq(0, 100, length=100), y = dnorm(seq(0, 100, length=100), mean=u, sd=sd))

# The editable table's coding was mostly obtained from Yihui Xie's answer in the post below
#https://groups.google.com/forum/#!topic/shiny-discuss/FeqU0AoTpz0



shinyServer(function(input, output) { 
 
   # create a character vector of shiny inputs 
  shinyInput <- function(FUN, len, id, ...) { 
    inputs = character(len) 
    for (i in seq_len(len)) { 
      inputs[i] <- as.character(FUN(paste0(id, i), label = NULL, ...)) 
    } 
    inputs 
  } 
  
  # obtain the values of inputs 
  shinyValue <- function(id, len) { 
    unlist(lapply(seq_len(len), function(i) { 
      value = input[[paste0(id, i)]] 
      if (is.null(value)) NA else value 
    })) 
  } 
  
  # a sample data frame 
  res <- data.frame( 
    Task = shinyInput(textInput, 20, 'v1_', value = "Add task here"),
    Progress = shinyInput(numericInput, 20, 'v2_', value = 0, min = 0, max = 100, step = 1),
    Show = shinyInput(checkboxInput, 20, 'v3_', value = FALSE, width = 1),
    stringsAsFactors = FALSE 
  ) 
  
  # render the table containing shiny inputs 
  output$x1 = DT::renderDataTable( 
    res, server = FALSE, escape = FALSE, options = list( 
      preDrawCallback = JS('function() { 
Shiny.unbindAll(this.api().table().node()); }'), 
      drawCallback = JS('function() { 
Shiny.bindAll(this.api().table().node()); } ') 
    ) 
  ) 
  
  
  
  # print the values of inputs 
  output$x2 = renderPrint({ 
    data.frame(Task = shinyValue('v1_', 20), Progress = shinyValue('v2_', 20), Show = shinyValue('v3_',20)) 
  }) 
  
  
  tasks <- reactive({
    
    data.frame(Task = shinyValue('v1_', 20), Progress = shinyValue('v2_', 20), Show = shinyValue('v3_',20)) %>%
      filter(Show == TRUE) %>%
      mutate(Position = dnorm(Progress, mean = u, sd = sd))
      
  })
  
  output$x3 <- renderTable({
    tasks()
  })
  
  
  output$hill <- renderPlot({
    
    ggplot(data = NULL, aes()) +
      
      #Cosmetics
      scale_fill_gradient(low = "salmon", high = "lightblue",
                          space = "Lab", na.value = "grey50", guide = "colourbar",
                          aesthetics = "fill") +
      scale_x_continuous(limits = c(-10, 110)) +
      scale_y_continuous(limits = c(0, max(base$y * 1.2))) +
      theme_minimal() +
      theme(axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()) +
      annotate(geom = "text", y = 0, x = 50, label = "Hill Chart", size = 5) +
      annotate(geom = "segment", y = 0.1*max(base$y), yend = max(base$y), x = 50, xend = 50, linetype = 2, lwd = 0.5) +
      
      
      
      #Add hill line
      geom_line(data = base, aes(x,y)) +
      
      #Add points
      geom_point(data = tasks(), aes(x = tasks()$Progress, y = tasks()$Position, color = tasks()$Levels, fill = tasks()$Levels),
                 size = 10,
                 show.legend = FALSE,
                 alpha = 0.7,
                 shape = 21,
                 color = "black",
                 stroke = 1
      ) +
      #Add labels
      geom_label_repel(data = tasks(), aes(x = tasks()$Progress, y = tasks()$Position, label = tasks()$Task, color = tasks()$Levels, fill = tasks()$Levels),
                       show.legend = FALSE,
                       force = 10,
                       direction = "y",
                       vjust = 0,
                       hjust = 0.5,
                       size = 3,
                       box.padding = 2,
                       segment.color = "grey50",
                       segment.size = 0.2,
                       color = "black",
                       nudge_y = tasks()$Position * 1,
                       ylim = c(tasks()$Position, tasks()$Position * 1.3)
      )
    
    
  })
  
  
  
  
} 
) 






#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


# library(shiny)
# 
# # Define server logic required to draw a histogram
# shinyServer(function(input, output) {
#    
#     
#   output$distPlot <- renderPlot({
#     
#     
#     tasks <- data.frame(Task = c("Getting started", "Pondering Options", "Figuring it out", "Ready to roll", "Getting it done", "Final details", "Completed"), 
#                         Levels = c(0,10,25,50,75,90,100))
#     
#     tasks$Position <- dnorm(tasks$Levels, mean = u, sd = sd)
#     
#     base <- data.frame(x = seq(0, 100, length=100), y = dnorm(seq(0, 100, length=100), mean=u, sd=sd))
#     

#     
#   })
#   
# })


# 
# library(shiny)
# library(shinyjs)
# ## shinysky is to customize buttons
# library(shinysky)
# library(DT)
# library(data.table)
# library(lubridate)
# library(shinyalert)
# 
# rm(list = ls())
# useShinyalert()
# shinyServer(function(input, output, session){
#   
#   ### interactive dataset 
#   vals_trich<-reactiveValues()
#   vals_trich$Data<-readRDS("./apps/hill_chart/note.rds")
#   
#   
#   #### MainBody_trich is the id of DT table
#   output$MainBody_trich<-renderUI({
#     fluidPage(
#       hr(),
#       column(6,offset = 6,
#              HTML('<div class="btn-group" role="group" aria-label="Basic example" style = "padding:10px">'),
#              ### tags$head() This is to change the color of "Add a new row" button
#              tags$head(tags$style(".butt2{background-color:#231651;} .butt2{color: #e6ebef;}")),
#              div(style="display:inline-block;width:30%;text-align: center;",actionButton(inputId = "Add_row_head",label = "Add", class="butt2") ),
#              tags$head(tags$style(".butt4{background-color:#4d1566;} .butt4{color: #e6ebef;}")),
#              div(style="display:inline-block;width:30%;text-align: center;",actionButton(inputId = "mod_row_head",label = "Edit", class="butt4") ),
#              tags$head(tags$style(".butt3{background-color:#590b25;} .butt3{color: #e6ebef;}")),
#              div(style="display:inline-block;width:30%;text-align: center;",actionButton(inputId = "Del_row_head",label = "Delete", class="butt3") ),
#              ### Optional: a html button 
#              # HTML('<input type="submit" name="Add_row_head" value="Add">'),
#              HTML('</div>') ),
#       
#       column(12,dataTableOutput("Main_table_trich")),
#       tags$script("$(document).on('click', '#Main_table_trich button', function () {
#                   Shiny.onInputChange('lastClickId',this.id);
#                   Shiny.onInputChange('lastClick', Math.random()) });")
#       
#     ) 
# })
#   
#   #### render DataTable part ####
#   output$Main_table_trich<-renderDataTable({
#     DT=vals_trich$Data
#     datatable(DT,selection = 'single',
#               escape=F) })
#   
#   
#   observeEvent(input$Add_row_head, {
#     ### This is the pop up board for input a new row
#     showModal(modalDialog(title = "Add a new row",
#                           dateInput(paste0("Date_add", input$Add_row_head), "Date:", value = Sys.Date()),
#                           textInput(paste0("Description_add", input$Add_row_head), "Description"),
#                           textInput(paste0("Names_add", input$Add_row_head), "Name"),
#                           numericInput(paste0("Request_add", input$Add_row_head), "Request Number:",0),  
#                           selectInput(paste0("Completed_add", input$Add_row_head), "Status:",choices=c("Yes", "On progress")),
#                           textInput(paste0("Comments_add", input$Add_row_head), "Comments"), 
#                           actionButton("go", "Add item"),
#                           easyClose = TRUE, footer = NULL ))
#     
#   })
#   ### Add a new row to DT  
#   observeEvent(input$go, {
#     new_row=data.frame(
#       Date=as.character( input[[paste0("Date_add", input$Add_row_head)]] ),
#       Description=input[[paste0("Description_add", input$Add_row_head)]],
#       Names=input[[paste0("Names_add", input$Add_row_head)]],
#       Request=input[[paste0("Request_add", input$Add_row_head)]],
#       Completed=input[[paste0("Completed_add", input$Add_row_head)]],
#       Comments=input[[paste0("Comments_add", input$Add_row_head)]]
#     )
#     vals_trich$Data<-rbind(vals_trich$Data,new_row )
#     removeModal()
#   })
#   
#   
#   
#   
#   ### save to RDS part 
#   observeEvent(input$Updated_trich,{
#     saveRDS(vals_trich$Data, "./apps/hill_chart/note.rds")
#     shinyalert(title = "Saved!", type = "success")
#   })
#   
#   
#   
#   ### delete selected rows part
#   ### this is warning messge for deleting
#   observeEvent(input$Del_row_head,{
#     showModal(
#       if(length(input$Main_table_trich_rows_selected)>=1 ){
#         modalDialog(
#           title = "Warning",
#           paste("Are you sure delete",length(input$Main_table_trich_rows_selected),"rows?" ),
#           footer = tagList(
#             modalButton("Cancel"),
#             actionButton("ok", "Yes")
#           ), easyClose = TRUE)
#       }else{
#         modalDialog(
#           title = "Warning",
#           paste("Please select row(s) that you want to delect!" ),easyClose = TRUE
#         )
#       }
#       
#     )
#   })
#   
#   ### If user say OK, then delete the selected rows
#   observeEvent(input$ok, {
#     vals_trich$Data=vals_trich$Data[-input$Main_table_trich_rows_selected]
#     removeModal()
#   })
#   
#   ### edit button
#   observeEvent(input$mod_row_head,{
#     showModal(
#       if(length(input$Main_table_trich_rows_selected)>=1 ){
#         modalDialog(
#           fluidPage(
#             h3(strong("Modification"),align="center"),
#             hr(),
#             dataTableOutput('row_modif'),
#             actionButton("save_changes","Save changes"),
#             tags$script(HTML("$(document).on('click', '#save_changes', function () {
#                              var list_value=[]
#                              for (i = 0; i < $( '.new_input' ).length; i++)
#                              {
#                              list_value.push($( '.new_input' )[i].value)
#                              }
#                              Shiny.onInputChange('newValue', list_value) });")) ), size="l" )
#   }else{
#     modalDialog(
#       title = "Warning",
#       paste("Please select the row that you want to edit!" ),easyClose = TRUE
#     )
#   }
#   
#           )
#     })
#   
#   
#   
#   
#   #### modify part
#   output$row_modif<-renderDataTable({
#     selected_row=input$Main_table_trich_rows_selected
#     old_row=vals_trich$Data[selected_row]
#     row_change=list()
#     for (i in colnames(old_row))
#     {
#       if (is.numeric(vals_trich$Data[[i]]))
#       {
#         row_change[[i]]<-paste0('<input class="new_input" value= ','"',old_row[[i]],'"','  type="number" id=new_',i,' ><br>')
#       } 
#       else if( is.Date(vals_trich$Data[[i]])){
#         row_change[[i]]<-paste0('<input class="new_input" value= ','"',old_row[[i]],'"',' type="date" id=new_  ',i,'  ><br>') 
#       }
#       else 
#         row_change[[i]]<-paste0('<input class="new_input" value= ','"',old_row[[i]],'"',' type="textarea"  id=new_',i,'><br>')
#     }
#     row_change=as.data.table(row_change)
#     setnames(row_change,colnames(old_row))
#     DT=row_change
#     DT 
#   },escape=F,options=list(dom='t',ordering=F,scrollX = TRUE),selection="none" )
#   
#   
#   
#   ### This is to replace the modified row to existing row
#   observeEvent(input$newValue,
#                {
#                  newValue=lapply(input$newValue, function(col) {
#                    if (suppressWarnings(all(!is.na(as.numeric(as.character(col)))))) {
#                      as.numeric(as.character(col))
#                    } else {
#                      col
#                    }
#                  })
#                  DF=data.frame(lapply(newValue, function(x) t(data.frame(x))))
#                  colnames(DF)=colnames(vals_trich$Data)
#                  vals_trich$Data[input$Main_table_trich_rows_selected]<-DF
#                  
#                }
#   )
#   ### This is nothing related to DT Editor but I think it is nice to have a download function in the Shiny so user 
#   ### can download the table in csv
#   output$Trich_csv<- downloadHandler(
#     filename = function() {
#       paste("Trich Project-Progress", Sys.Date(), ".csv", sep="")
#     },
#     content = function(file) {
#       write.csv(data.frame(vals_trich$Data), file, row.names = F)
#     }
#   )
#   
#   })
