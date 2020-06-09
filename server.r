library(shiny)
shinyServer(function(input, output) {
  
# Reactive function is to fetch the dataset observations based on the user's choice
  datasetInput <- reactive({

    switch(input$dataset,
           "iris" = iris,
           "mtcars" = mtcars,
           "trees" = trees)
  })
  
#reactive function is for the file extension 
 fileext <- reactive({
   switch(input$type,
          "Excel (CSV)" = "csv", "Text (TSV)" = "txt","Text (Space Separated)" = "txt", "Doc" = "doc")
   
 })
  
 #Output of renderTable will be used in the mainPanel of ui.r
  output$table <- renderTable({
    datasetInput()
    
  })
  

  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client browser what name to use when saving the file.
    filename = function() {
      paste(input$dataset, fileext(), sep = ".") # example : iris.csv, iris.doc, iris.txt 
      
    },
    
    # This function should write data to a file given to it by the argument 'file'.
    content = function(file) {
      sep <- switch(input$type, "Excel (CSV)" = ",", "Text (TSV)" = "\t","Text (Space Separated)" = " ", "Doc" = " ")
      
        write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
    }
  )
})