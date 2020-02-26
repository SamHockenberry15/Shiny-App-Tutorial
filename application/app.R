#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Need to install shiny, DT

library(shiny)
library(leaflet)
library(DT) 
library(dplyr)


# Define UI for application that draws a histogram
NewBikeData <- read.csv("./NewBikeData.csv")
ui <- fluidPage(
   
   # Application title
   titlePanel("Bikes"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("slide",
                     "Dist:",
                     min = .1,
                     max = 27,
                     value = 10)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         leafletOutput("myMap"),
         dataTableOutput("myTable")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$myMap <- renderLeaflet({
     NewBikeData %>%
       filter(distance <= input$slide) %>%
       leaflet() %>%
       addTiles() %>%
       addCircles(lng = ~long,lat = ~lat)
   })
   
   output$myTable <- renderDataTable({
     NewBikeData %>%
       filter(distance <= input$slide)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

