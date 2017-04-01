#' Stack Maps
#' 
#' @description Stacks ggplot objects over one another to generate 1 multi-layered
#'      map object. 
#' @param maps A list of ggplot map objects all within the same coordinate reference system. Order of
#'     the list is significant- the first object will be on the bottom, second layered above it, etc.
#' 
#' @param xbounds Default=NULL. Takes a 2-item list of xmin and xmax of the area you want to plot.
#'      Leaving this parameter as null will default to having the bounds ofthe map be the 
#'      minimum and maximum x coordinates present in any of the map layers. 
#'      
#' @param ybounds Default=NULL. Takes a 2-item list of xmin and xmax of the area you want to plot.
#'      Leaving this parameter as null will default to having the bounds ofthe map be the 
#'      minimum and maximum y coordinates present in any of the map layers.
#' @param font_family The name of the font family you want to use for the title text
#'     on the plot. Default is 'serif'.
#'       
#' @param map_title String; the title of your map.
#' 
#' @param map_subtitle  String; Default=NULL
#' 
#' @param map_title_justification Numeric from 0-left to 1-right. Default is centeR-.5.
#' 
#' @param map_title_font_size Numeric, default is 20. Note that subtitle size will be 
#'     scaled to .8 of this parameter. 
#'     
#' @param map_title_font_face Default="plain". 
#' 
#' @return A ggplot object with maps stacked 
#' 
#' @examples 
#' 
#' StackMaps(list_of_maps)
#' 
#' @export


StackMaps<-function(maps,
                    xbounds=NULL,ybounds=NULL,
                    font_family="serif",
                    map_title=NULL,
                    map_subtitle=NULL,
                    map_title_justification=.5,
                    map_title_font_size=20,
                    map_title_font_face="plain"){
  
  # If no min/max boundaries are defined,
  # the extents of all maps included. 
  if(is.null(xbounds)|is.null(ybounds)){
    extents<-list()
    i<-1
    for(map in maps){
      extent<-GetExtent(map,return_table=T)
      extents[[i]]<-extent
      i<-i+1
    }
    extents<-rbindlist(extents)
    xbounds<-c(min(extents$xbounds1),max(extents$xbounds2))
    ybounds<-c(min(extents$ybounds1),max(extents$ybounds2))
  }
  
  # Start a blank map
  final_map<-cowplot::ggdraw()
  
  # Add in each of the maps
  for(map in maps){
    final_map<-final_map+
      cowplot::draw_plot(GetMap(map,xbounds=xbounds,ybounds=ybounds))
  }
  
  if(!is.null(map_title)){
    final_map<-final_map+
      cowplot::draw_label(map_title, 
                          x = map_title_justification,
                          y = .95,
                          fontfamily=font_family,
                          fontface=map_title_font_face,
                          size=map_title_font_size)
  }
  if(!is.null(map_subtitle)){
    final_map<-final_map+
      cowplot::draw_label(map_subtitle, 
                          x = map_title_justification,
                          y = .9,
                          fontfamily=font_family,
                          size=map_title_font_size*.8)
  }
  
  return(final_map)
}
