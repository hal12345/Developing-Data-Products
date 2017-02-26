
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

annuity<-function (amount, rate, years){return(amount * (rate/100) / ( 1 - ( 1 + (rate/100))^(-years)))}

redemption <-  function (amount, rate, years){
  annuity<-amount * (rate/100) / ( 1 - ( 1 + (rate/100))^(-years))
  df<-data.frame(year = seq(1,years,1))
  df$loan<-0
  df$annuity<-annuity
  df$interest<-0
  df$amortization<-0
  df$total<-0
  df$totint<-0
  
  df$loan[1]<-amount
  df$interest[1]<-amount*rate/100
  df$amortization[1]<-df$annuity[1]-df$interest[1]
  df$total[1]<-df$annuity[1]
  df$totint[1]<-df$interest[1]
  for (i in 2:years) {
    df$loan[i]<-df$loan[i-1]-df$amortization[i-1]
    df$interest[i]<-df$loan[i]*rate/100
    df$amortization[i]<-df$annuity[i]-df$interest[i]
    df$total[i]<-df$total[i-1]+df$annuity[i]
    df$totint[i]<-df$interest[i]+df$totint[i-1]
  }
  
  return(df)
}


shinyServer(function(input, output) {

 
  output$pred1 <- renderText({  
    
    a<-annuity (input$amount, input$rate, input$years)
      format(a, decimal.mark=",",  big.mark=" ",small.mark=".", small.interval=3)
  
  })
  
  
  output$pred2 <- renderText({  
    
    a<-annuity (input$amount, input$rate, input$years)
    format(a* input$years, decimal.mark=",",  big.mark=" ",small.mark=".", small.interval=3)
    
  })
  
  output$distPlot <- renderPlot({

    df<-redemption(input$amount, input$rate, input$years)
    g_range <- range(0, df$loan, df$loan, df$total)
    
    plot(df$loan, xlab="Year", ylab="Amount", col="blue",ylim=g_range)
    lines(df$total, type="o", pch=22, lty=2, col="red")
    lines(df$totint, type="o", pch=22, lty=2, col="green")
    title(main="Mortgage payments vs costs", col.main="red", font.main=4)
    
    
    # Create a legend at (1, g_range[2]) that is slightly smaller 
    # (cex) and uses the same line colors and points used by 
    # the actual plots 
    legend(1, g_range[2], c("Loan","Annuities","Interests"), cex=0.8, 
           col=c("blue","red","green"), pch=21:22, lty=1:2);
  })

})
