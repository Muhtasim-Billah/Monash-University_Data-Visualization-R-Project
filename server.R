#Author: Muhtasim Billah
#There are some changes made here for this version. 
#Related CSV Data File Not Attached

require(maptools)
require(ggplot2)
# we need the following libraries
library(Lahman)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library("tm") # for text mining
#Library to be called
library(plotly)
library(leaflet)
library(rgdal)


# Define server logic required to plot & leaflet various variables against twitter data
shinyServer(function(input, output,session) {
  
  
  # Generate a plot of the requested variable against twitter data 
  output$twtPlot <- reactivePlot(function() {
    
    twtCountMap <- read.csv("CSV FILE")  #reading the excel file
    
    if (input$option == "tweetsCount")   #if user selects comparison in bar graph option
    {
    
      p <- ggplot(twtCountMap, aes(x = country, y = tweetsCount, fill = factor(country))) + theme_bw()
      p <- p + geom_bar(stat = "identity", position = "dodge") + 
            scale_fill_brewer("country", palette = "Spectral") + 
            geom_text(aes(label = tweetsCount), position = position_dodge(width = 0.9), 
                vjust = 1.5)
      print(p)
    }
    
    else if (input$option == "bubbleChart") #if user selects comparison in bubble chart option
    {
      p <- ggplot(twtCountMap, aes(country,tweetsCount,size=tweetsCount, label=tweetsCount))
      p <- p+geom_point(colour="blue") +scale_size_area(limits=c(60,90))+geom_text(size=3)
      p <- p + xlab("Countries tweeting on Zika") + ylab("Tweets on Zika")
      
      print(p)
      
    }
    else if (input$option == "wordcloud")   #if user selects used keywords in wordcloud option
    {
      # Read the excel file containing all twitter texts
      text <- readLines("CSV FILE")
      
      # Load the data as a corpus and save a copy as 'input'
      input <- Corpus(VectorSource(text))
      docs = input
      
      
      docs <- tm_map(docs, content_transformer(tolower))
      docs <- tm_map(docs, removeWords, stopwords("english"))
      docs <- tm_map(docs, removePunctuation)
      docs <- tm_map(docs, PlainTextDocument)
      docs <- tm_map(docs, stemDocument)
      docs <- tm_map(docs, #CODE TO WRITE, c("zika","virus","zikavirus")) 
      
      
      # and process again
      dtm <- TermDocumentMatrix(docs)
      m <- as.matrix(dtm)
      v <- sort(rowSums(m),decreasing=TRUE)
      d <- data.frame(words = names(v), freq=v)
      nrow(d)
      head(d, 10)
      
      # and display again, 'the' should be gone
      set.seed(1234)
      wordcloud(words = d$words, freq = d$freq, min.freq = 1,
                #CODE TO WRITE
                colors=brewer.pal(8, "Dark2"))
    }
    
  })
  
  # Generate a leaflet of the requested variable against twitter latitude,longiude, number of tweets, country 
  output$worldMap <- renderLeaflet({
    
    if(input$selection == "map")  #if user selects twitter users' countries in map option
    {
      #CODE TO WRITE                      #read the excel file containing latitude, logitude, country name
    
      leaflet(places) %>% addTiles() %>%
        addCircles(lng = ~Long, lat = ~Lat, weight = 1,
                 #CODE TO WRITE                                       #multiply the tweetscount with 20000 to show 
                                                                        #the indicator bubble clearly visuable in map
                  )
  
    }
    
  })

  
})
