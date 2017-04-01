#' GetExtent
#' 
#' @description Gets the x and y coordinates of the full extent of a ggplot.
#'
#' @param map_object A ggplot object
#' 
#' @param return_table Boolean; Default=F. If T, returns a table where
#'     xbounds1 is the xmin, xbounds2 is the xmax, ybounds1 is the ymin,
#'     and ybounds2 is the ymax. 
#'
#' @return Either a named list where the results has an $xbounds and
#'       $ybounds named list (with a min/max in each), or a table (see
#'       return_table parameter).
#'
#' @examples 
#' 
#' GetExtent(map_obj)
#' 
#' @export

GetExtent<-function(map_object, return_table=F){
  bounds<-list()
  tmp <- ggplot2::ggplot_build(map_object)
  xbounds<-tmp$layout$panel_ranges[[1]]$x.range
  ybounds<-tmp$layout$panel_ranges[[1]]$y.range
  bounds[["xbounds"]]<-xbounds
  bounds[["ybounds"]]<-ybounds
  if(return_table==T){
    bounds<-data.table(t(unlist((bounds))))
    return(bounds) 
  }else{
    return(bounds)
  }
}
