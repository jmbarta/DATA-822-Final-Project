library(dplyr)
library(tidyr)
library(ggplot2)
library(pheatmap)
library(reshape2)


server <- function(input, output, session) {
  bach <- read.csv("Bachelor_Degree_Majors.csv")
  ages <- bach %>% select(-"Bachelor.Degree.Holders") %>%
    filter(Age.Group != "25 and older" & Sex == "Male" | Age.Group != "25 and older" & Sex == "Female")
  degrees.long <- melt(ages,                                 
                       id.vars = c("State", "Sex", "Age.Group"))
  
  # Summarize Data and then Plot
  data <- reactive({
    req(input$sel_AgeGroup)
    degrees.long <- degrees.long %>% filter(Age.Group %in% input$sel_AgeGroup) %>%
      group_by(Sex, variable) %>% summarise(value = sum(value)) 
  
    })
  
  # Plot
  output$plot <- renderPlot({
    g <- ggplot(data(), aes(y = value, x = Sex, fill = variable))
    g + geom_bar(stat = "sum", position = "dodge") +
      scale_y_continuous(breaks = c(0, 1500000, 3000000, 4500000, 6000000, 7700000), 
                         labels=c('0', '1,500,000', '3,000,000', '4,500,000', '6,000,000', '7,500,000')) +
      scale_fill_viridis_d(option = "plasma") +
      xlab("Sex") +
      ylab("Number of Bachelor Degrees") +
      ggtitle("Total Bachelor's Degrees in the U.S. in 2019") +
      labs(fill='Degree') +
      theme(axis.text = element_text(size = 10),
            axis.title = element_text(size = 15),
            plot.title = element_text(size = 20, face = "bold"))
      
  })
}

