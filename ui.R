
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Fixed Mortgage Loan Calculator"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      numericInput("amount", "Mortgage Amount",
         value = 2000000, min = 1000, max = 2000000),      
      
      sliderInput("years",
                  "Term (Years)",
                  min = 1,
                  max = 50,
                  value = 30),
      numericInput("rate", "Interest rate",
                   value = 4, min = 1, max = 100)

    ),

    # Show a plot of the generated distribution
    mainPanel(
      h4(paste("Annuity"),textOutput("pred1"),sep=":"), 
      h4(paste("Total amount paid"),textOutput("pred2"),sep=":"), 
      plotOutput("distPlot")
    )
  )
))
