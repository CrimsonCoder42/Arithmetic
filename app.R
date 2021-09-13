#Arithmetic
#August 30, 2020

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
source("jaxmat.R")


#The user interface
header <- dashboardHeader(title = "A trivial reactive app")
sidebar <- dashboardSidebar(disable = TRUE)
body <- dashboardBody(
    fluidRow(
        column(width = 6,
               radioButtons("type", "Select operand type", c("addition","multiplication"), selected = "addition",
                            inline = T ),
               sliderInput("left", "Left operand",  -7, 7, 1 ),
               sliderInput("right", "Right operand", -7, 7, 1 ),
               h2(uiOutput("results")),
               h2(uiOutput("results_mathjax"))
               
        )
    )
)
ui <- dashboardPage(header, sidebar, body)



#Functions that read the input and modify the output and input
server <- function(session, input, output) {
    #This works without any explicit reactive function
    
    #save the user's choice as a variable
    math_type_r = reactive( input$type )
    
    
    output$results <- renderUI({
        if( math_type_r() == "addition"){
            txt = paste0("Sum is ",input$left + input$right)   
        } else {
            txt = paste0("Product is ",input$left * input$right)  
        }
        
        #an example of changing text color
        div(txt, style = "color:blue;")
    })
    
    output$results_mathjax <- renderUI({
        
        if( math_type_r() == "addition"){
            jaxI( paste0("x=",input$left,",", "y=", input$right, ",", "x+y=", input$left+input$right  ) )
        } else {
            jaxI( paste0("x=",input$left,",", "y=", input$right, ",", "xy=", input$left*input$right  ) )
        }
        
    })
    
    
    #The next two lines fail
    # sum <- input$left+input$right     #not allowed
    # output$results <- renderUI(paste0("Sum is ",sum))    
    #  Use a reactive expression instead and it works   
    #  sum <- reactive({input$left+input$right})  
    #  output$results <- renderUI(paste0("Sum is ",sum()))
    # Defining an ordinary function also works
    # sum <- function() input$left+input$right #Shiny must know this is reactive and reevaluate it
    # output$results <- renderUI(paste0("Sum is ",sum()))
    #Here is a way to create a list of values that respond to changing inputs
    #  myReactives <- reactiveValues()
    #You need observe() to create a reactive context
    #  observe({myReactives$sum <- input$left+input$right
    #  myReactives$left <- input$left
    #  myReactives$right <- input$right
    #  })
    #  output$results <- renderUI(paste0("Sum of ",myReactives$left,
    #                                    " and ", myReactives$right, " is ",myReactives$sum))
    
    
}

#Run the app
shinyApp(ui = ui, server = server)