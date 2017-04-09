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
  
  n_legend_items<-0
  
  legend_grobs<-list()
    for (leg in seq(1,length(legends))){
      legend_grob<-GetLegend(legends[[leg]])
      l<-length(legend_grob)
      
      # Check to make sure there is a legend at all
      if(l<=1){
        if(legend_grob=="Map has no legend."){
          stop(paste0("One of your maps does not contain a legend; please exclude any basemaps or non-variable based outlines from this list."))
        }
      }else{
        n_legend_items<-n_legend_items+(l-1)
        legend_grob_length_list<-list("grob"=legend_grob,"n"=(l-1))
        legend_grobs[[leg]]<-legend_grob_length_list
     }
    }
  
  increment<- 1/(n_legend_items)
  
  # Start legend plot
  legend<-cowplot::ggdraw()
  
  i<-0
  for (leg in seq(1,length(legend_grobs))){
    specific_legend<-legend_grobs[[leg]][["grob"]]
    n_items<-legend_grobs[[leg]][["n"]]
    
    legend<-legend+
      cowplot::draw_plot(specific_legend,0,(increment*i),1,increment*n_items)
    i<-i+n_items
  }

  return(legend)
}