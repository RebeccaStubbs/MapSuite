#' GetLegend
#'
#' @description Description of function here
#'
#' @param ggplot A ggplot object 
#'
#' @return A Grob of the ggplot's legend if one exists,
#'         or a string of text "Map has no legend."
#'
#' @examples 
#' 
#' GetLegend(your_map)
#' 
#' @export


GetLegend<-function(ggplot){
  tmp <- ggplot2::ggplot_gtable(ggplot2::ggplot_build(ggplot))
  if ("guide-box" %in% sapply(tmp$grobs, function(x) x$name)){
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
    legend <- tmp$grobs[[leg]]
    return(legend)
  }else{
    return("Map has no legend.")
  }
}