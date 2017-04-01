#' StackLegends
#' 
#' @description Stacks legends from different plots into 1 ggplot object. 
#'
#' @param legends List of maps/ggplots with legends. If you give the function
#'  an object without a legend in this list, it will error out, noting that 
#'  one of the maps does not contain a legend. List order is significant: 
#'  first map's legend will be on the bottom, second map's legend above it, etc. 
#'
#' @return A ggplot object with legends vertically stacked. 
#' 
#' 
#' @export


# Legends will stack bottom-to-top. 
StackLegends<-function(legends){
  
  increment<- 1/(1+(length(legends)))
  
  # Start legend plot
  legend<-cowplot::ggdraw()
  
  i<-1
  for (leg in legends){
    item<-deparse(substitute(legends[1][i]))
    legend_grob<-GetLegend(leg)
    length(legend_grob)
    if(length(legend_grob)==1){
      if(legend_grob=="Map has no legend."){
        stop(paste0("One of your maps does not contain a legend; please exclude any basemaps or non-variable based outlines from this list."))
      }
    }
    legend<-legend+
      cowplot::draw_plot(legend_grob,0,0,1,increment*i)
    i<-i+1
    
  }
  return(legend)
}