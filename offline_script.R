library(ggplot2)
library(ggrepel)
library(RColorBrewer)


### Get User input
u <- 50
sd <- 20
base <- data.frame(x = seq(0, 100, length=100), y = dnorm(seq(0, 100, length=100), mean=u, sd=sd))


### Note: $Task and $Levels are users input from the shiny app

tasks <- data.frame(Task = c("Getting started", "Pondering Options", "Figuring it out", "Ready to roll", "Getting it done", "Final details", "Completed"), 
                    Levels = c(0,10,25,50,75,90,100))

tasks$Position <- dnorm(tasks$Levels, mean = u, sd = sd)

base <- data.frame(x = seq(0, 100, length=100), y = dnorm(seq(0, 100, length=100), mean=u, sd=sd))

### Set up the plot

ggplot(data = NULL, aes()) + 
  
  #Cosmetics
  scale_fill_gradient(low = "salmon", high = "lightblue",
                      space = "Lab", na.value = "grey50", guide = "colourbar",
                      aesthetics = "fill") +
  scale_x_continuous(limits = c(-10, 110)) +
  scale_y_continuous(limits = c(0, max(tasks$Position * 1.2))) +
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
  geom_point(data = tasks, aes(x = tasks$Levels, y = tasks$Position, color = tasks$Levels, fill = tasks$Levels),
    size = 10,
    show.legend = FALSE,
    alpha = 0.7,
    shape = 21,
    color = "black",
    stroke = 1
  ) + 
  #Add labels
  geom_label_repel(data = tasks, aes(x = tasks$Levels, y = tasks$Position, label = tasks$Task, color = tasks$Levels, fill = tasks$Levels),
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
    nudge_y = tasks$Position * 1,
    ylim = c(tasks$Position, tasks$Position * 1.3)
  )
  












