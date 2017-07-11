library(shiny)
library(leaflet)

# Define UI for showing twitter data analytics on zika virus
shinyUI(fluidPage( 
  
  # Application title
  headerPanel("Twitter Data Analytics on Zika Virus"),
  
  # Sidebar with controls to select the options to plot & leaflet against
  # number of tweets, country, laitude, longitude, tweet text
  sidebarLayout(
    sidebarPanel(
      helpText("This following options are for showing comparison of number of tweets 
               by countries & showing most used keywords in tweets: "),
      selectInput("option", "Options:", 
                  c("Comparison in Bar Graph"= "tweetsCount",
                    "Comparison in bubble chart" = "bubbleChart",
                    "Used keywords in wordcloud" = "wordcloud")
                  ),
      br(),
      helpText("This following option is for showing twitter user places in Map: "),
      
      selectInput("selection", "Map Selection:",
                  c("Twitter Users' Countries in Map" = "map"))
      
      
    ),

    # Show the caption, plot & leaflet of the requested variable against tweet data
    mainPanel(
      plotOutput("twtPlot"),
      leafletOutput("worldMap")
    )
  )
))