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
      if (is.null(value))
        NA
      else
        value
    }))
  }
  
  # a sample data frame
  res <- data.frame(
    Task = shinyInput(textInput, 40, 'v1_', value = ""),
    Progress = shinyInput(
      numericInput,
      40,
      'v2_',
      value = 50,
      min = 0,
      max = 100,
      step = 1
    ),
    Show = shinyInput(checkboxInput, 40, 'v3_', value = FALSE, width = 1),
    stringsAsFactors = FALSE
  )
  
  # render the table containing shiny inputs
  output$x1 = DT::renderDataTable(
    res,
    server = FALSE,
    escape = FALSE,
    options = list(
      preDrawCallback = JS(
        'function() {
        Shiny.unbindAll(this.api().table().node()); }'
      ),
      drawCallback = JS('function() {
                        Shiny.bindAll(this.api().table().node()); } ')
      )
      )
  
  # take inputs and turn into usable data.frame
  tasks <- reactive({
    data.frame(
      Task = shinyValue('v1_', 40),
      Progress = shinyValue('v2_', 40),
      Show = shinyValue('v3_', 40)
    ) %>%
      filter(Show == TRUE) %>%
      mutate(Position = dnorm(Progress, mean = u, sd = sd))
  })
  
  # get the hill
  output$hill <- renderPlot({
    ggplot(data = NULL, aes()) +
      
      #Cosmetics
      scale_fill_gradientn(
        colors = c("salmon", "lightblue"),
        aesthetics = "fill",
        limits = c(0, 100)
      ) +
      scale_x_continuous(limits = c(-20, 120)) +
      scale_y_continuous(limits = c(-max(base$y) * 0.1, max(base$y * 1.2))) +
      theme_minimal() +
      theme(
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
      ) +
      annotate(
        geom = "text",
        y = 0,
        x = 50,
        label = "Hill Chart",
        size = 5
      ) +
      annotate(
        geom = "segment",
        y = 0.1 * max(base$y),
        yend = max(base$y),
        x = 50,
        xend = 50,
        linetype = 2,
        lwd = 0.5
      ) +
      
      
      
      #Add hill line
      geom_line(data = base, aes(x, y)) +
      
      #Add points
      geom_point(
        data = tasks(),
        aes(
          x = tasks()$Progress,
          y = tasks()$Position,
          color = tasks()$Progress,
          fill = tasks()$Progress
        ),
        size = 12,
        show.legend = FALSE,
        alpha = 0.7,
        shape = 21,
        color = "black",
        stroke = 1
      ) +
      #Add labels
      geom_label_repel(
        data = tasks(),
        aes(
          x = tasks()$Progress,
          y = tasks()$Position,
          label = tasks()$Task,
          color = tasks()$Progress,
          fill = tasks()$Progress
        ),
        show.legend = FALSE,
        force = 5,
        direction = "both",
        vjust = 0.5,
        hjust = 0.5,
        size = 4,
        box.padding = 1,
        segment.color = "grey50",
        segment.size = 0.5,
        color = "black"
      )
  })
      })
