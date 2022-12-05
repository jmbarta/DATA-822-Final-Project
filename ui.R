ui <- basicPage(
  h1("R Shiny Bar Plot using ggplot"), 
  selectInput(inputId = "sel_AgeGroup", 
              label = "Choose Age Group", 
              list("25 to 39", "40 to 64", "65 and older")),
  plotOutput("plot")
)