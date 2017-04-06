#' View a Woodson Pallette color scheme. 
#'
#' @description This function shows a woodson pallette color scheme when the name is entered. 
#'  When no name of a wpal() color scheme is entered, all woodson pallette shemes are shown.
#'  
#' @param color the name of the color scheme
#
#' @return plots of one or all Woodson pallette schemes
#' @export
#'
#' @examples ViewPal()
#' @examples ViewPal("seaside")


ViewPal<-function(color=NULL, n=NULL, base_size = 11, listcolors=F, n_per_page=5, labelcolors=T){
  if (is.null(color)){
    print("No color specified; plotting all colors")
    index<-1
    for (color in names(wpal())){
      if (index==1){grid.newpage(); pushViewport(viewport(layout = grid.layout(n_per_page, 15)))}
      if (index<=n_per_page){print((PlotColors(wpal(color),color_list_name=color, n=n, base_size=base_size, listcolors=listcolors, labelcolors=labelcolors)), vp = vplayout(index, 1:15))}
      index <- index+1
      if (index>n_per_page){index<-1}
    }}else{
      print(paste0("Plotting wpal color scheme ",color))
      print((PlotColors(wpal(color),color_list_name=color, n=n, base_size=base_size, listcolors=listcolors, labelcolors=labelcolors)))}
} # Closing function