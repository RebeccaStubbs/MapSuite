#' Plot colors of a color pallette
#'
#' @description This function creates colored swatches of a list
#' of colors for easy visualization. 
#'
#' @param color_list list or vector of valid R colors
#' @param color_list_name name of color scheme, optional, default is NULL. 
#' 
#' @return ggplot of color swatches and optional name of color pallette
#' @export
#'
#' @examples PlotColors(c("red","yellow","blue"),"primary colors")

PlotColors<-function(color_list,color_list_name=NULL, n=NULL, base_size = 11, listcolors=F, labelcolors=T){
  # color_list: list of colors
  # color_list_name: The title of the plot
  # requires: data.table,ggplot2,ggthemes
  
  if (!is.null(n)){ #If a specific number of colors are requested to be sampled
    # Creating a colorRampPallette function capable of interpolating N colors from the pallette
    pallette<-colorRampPalette(color_list) 
    # Sampling n numbers of colors from that pallette (default will be 11)
    color_list<-pallette(n)
  }
  
  data_table<-data.table(data.frame(x=letters[1:length(unique(color_list))]))
  data_table[, colors:=unique(color_list)]
  data_table[, bar_height:=1]
  p<-ggplot(data_table,aes(x=colors))+geom_bar(aes(fill=colors))+theme_tufte(base_size = base_size)+
    scale_fill_manual(values=color_list) + ggtitle(color_list_name) + 
    theme(
    legend.position = "none",
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank())
  
  if(labelcolors==F){
    p+theme(axis.text.x = element_blank())
  }
  
  if(listcolors==T){
  p+labs(x=paste(unique(color_list), collapse=', '))+
    theme(axis.text.x = element_blank())
  }
  

    
  return(p)
}