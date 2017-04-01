#' GetMap
#' 
#' @description Gets a grob of a ggplot map, with no legend.
#'
#' @param map_object GGplot object. 
#' 
#' @param xbounds A 2-item vector corresponding to the X min/max limits 
#'    of the extent you want for your map. Default=NULL.
#'    
#' @param ybounds A 2-item vector corresponding to the y min/max limits 
#'    of the extent you want for your map. Default=NULL.
#
#'
#' @return A ggplotgrob of a map object with no legend. 
#'
#' @examples 
#' 
#' GetMap(map_obj)
#' 
#' @export


GetMap<-function(map_object, xbounds=NULL, ybounds=NULL){
  mapgrob<-ggplot2::ggplotGrob(map_object+
                                 theme(legend.position="none")+
                                 coord_fixed(ratio=1,
                                             xlim = xbounds,
                                             ylim = ybounds))
  return(mapgrob)
}
