#' Map Colors Palettes
#'
#' @description A suite of color ramps designed for beautiful chloropleth maps and other
#' data visualizations, especially where value differentiation over a wide range is desired.
#'
#' @param color Name of the color ramp. Default is NULL, which will return the whole list,
#' so you should probably enter in a color name! Use the funciton view_pal() to see your options.
#' 
#' @param n How many colors are returned from the ramp. Default is NULL, which will provide the number
#' of colors generated when the ramp is created.
#' 
#' @param noblack Logical; Defines whether the color black is to be excluded from your color ramp. Default value is FALSE. 
#' @export 
#' 
#' @return A list of color values.
#' 
#' @examples MapColors("cool_toned")


#http://www.mrao.cam.ac.uk/~dag/CUBEHELIX/cubewedges.html for more info on cubehelix

wpal<-function(color=NULL,n=NULL,noblack=FALSE){
  pal<-list()
  pal[["earth"]]<-rev(c("#000000", "#5b2c44", "#826737", "#67af6d", "#90c6de", "#ffff4c"))
  pal[["sky"]]<-rev(c("#000000", "#3E350C", "#9D4B60" , "#AB86D0" ,"#97E4DF","#ffff4c"))
   
  # Half-Rotation Colors
  pal[["ocean"]]<-rev(cubeHelix(11, start = 0.5, r = -.5, hue = 1.5, gamma = 1)[1:10])
  pal[["berries"]]<-rev(cubeHelix(11, start = 1, r = -.5, hue = 1.5, gamma = 1)[1:10])
  pal[["foliage"]]<-rev(cubeHelix(11, start = 1, r = .5, hue = 1.5, gamma = 1)[1:10])
  pal[["thanksgiving"]]<-rev(cubeHelix(11, start = 0.5, r = .5, hue = 1.5, gamma = 1)[1:10])
  pal[["salmon_run"]]<-rev(cubeHelix(11, start = 2, r = -.5, hue = 1.5, gamma = 1)[1:10])
  pal[["sky_to_sea"]]<-rev(cubeHelix(11, start = 2, r = .5, hue = 1.5, gamma = 1)[1:10])
  pal[["tropical_sunrise"]]<-rev(cubeHelix(11, start = 2, r = .8, hue = 1.5, gamma = 1)[1:10])
  pal[["parrotfish"]]<-rev(cubeHelix(11, start = 2, r = -.8, hue = 1.5, gamma = 1)[1:10])
  pal[["seaglass"]]<-rev(cubeHelix(11, start = 1, r = .8, hue = 1.5, gamma = 1)[1:10])
  pal[["betafish"]]<-rev(cubeHelix(11, start = 1, r = -.8, hue = 1.5, gamma = 1)[1:10])
  pal[["seaside"]]<-rev(cubeHelix(11, start = 0.5, r = -.8, hue = 1.5, gamma = 1)[1:10])
  pal[["skyforest"]]<-rev(cubeHelix(11, start = .5, r = .8, hue = 1.5, gamma = 1)[1:10])
  
  pal[["bright_greens"]]<-rev((cubeHelix(8, start = -0.5, r = -.3, hue = 3, gamma = 1.5)[2:7])) #bright_greens
  pal[["bright_fire"]]<-rev((cubeHelix(8, start = .5, r = .4, hue = 3, gamma = 1.3)[2:7])) # Bright fire
  pal[["bright_cool"]]<-rev((cubeHelix(8, start = .95, r = -.7, hue = 3, gamma = 1.3)[2:7])) # eggplant_to_teal
  pal[["bright_roygbiv"]]<-c("#3F004C","#8D1026","#DC2000","#ED6500","#FFAA00","#FFD400","#FFFF00","#BDFD69","#7CFBD3","#46EFDF","#11E3EB")
  
  
  # Small Rotation colors (for low-n data)
  pal[["cool_blue_deepindigo"]]<-rev(cubeHelix(8, start = -2.8, r = -.15, hue = 2.5, gamma = 2)[2:7])
  pal[["cool_blue_aqua"]]<-rev(cubeHelix(8, start = -.35, r = -.15, hue = 2.5, gamma = 1.3)[2:7])
  pal[["cool_blue_bright"]]<-rev(cubeHelix(8, start = 0, r = -.15, hue = 2.5, gamma = 1.3)[2:7])
  pal[["cool_blue_steel"]]<-rev(cubeHelix(8, start = 2.1, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  pal[["cool_blue_jeans"]]<-rev(cubeHelix(8, start = 2.45, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  pal[["cool_green_grassy"]]<-rev(cubeHelix(8, start = -1.05, r = -.15, hue = 2.5, gamma = 1.3)[2:7])
  pal[["cool_green_happy"]]<-rev(cubeHelix(8, start = -.7, r = -.15, hue = 2.5, gamma = 1.3)[2:7])
  pal[["cool_green_deepforest"]]<-rev(cubeHelix(8, start = 1.4, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  pal[["cool_green_deeplake"]]<-rev(cubeHelix(8, start = 1.75, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  pal[["cool_earthtones"]]<-rev(cubeHelix(8, start = .5, r = .8, hue = .5, gamma = 1)[2:7])
  pal[["cool_stormy"]]<-rev(cubeHelix(8, start = 1, r = .8, hue = .5, gamma = 1)[2:7])
  pal[["warm_fire"]]<-rev((cubeHelix(8, start = .5, r = .3, hue = 3, gamma = 1.3)[2:7]) )
  pal[["warm_darkfire"]]<-rev((cubeHelix(8, start = .5, r = .3, hue = 3, gamma = 2)[2:7])) 
  pal[["warm_purple1"]]<-rev(cubeHelix(8, start = -2.45, r = -.15, hue = 2.5, gamma = 1.3)[2:7])
  pal[["warm_purple2"]]<-rev(cubeHelix(8, start = 0, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  pal[["warm_adultpink"]]<-rev(cubeHelix(8, start = 0.35, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  pal[["warm_kidpink"]]<-rev(cubeHelix(8, start = -2.1, r = -.15, hue = 2.5, gamma = 1.3)[2:7])
  pal[["warm_redpink"]]<-rev(cubeHelix(8, start = -1.75, r = -.15, hue = 2.5, gamma = 1.3)[2:7])
  pal[["warm_mauve"]]<-rev(cubeHelix(8, start = 0.7, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  pal[["warm_darkpeach"]]<-rev(cubeHelix(8, start = 0.7, r = .2, hue = 2, gamma = 1.7)[2:7])
  pal[["warm_brown"]]<-rev(cubeHelix(8, start = 1.05, r = .15, hue = 1.5, gamma = 1.4)[2:7])
  
  
  # A bunch of different, single-rotation color helix patterns:
  pal[["ld_reg1"]]<-rev(cubeHelix(11, start = -.5, r = -1, hue = 1, gamma = 1)[1:10] )
  pal[["ld_reg2"]]<-rev(cubeHelix(11, start = .5, r = -1, hue = 1, gamma = 1)[1:10] )
  pal[["ld_reg3"]]<-rev(cubeHelix(11, start = 1.5, r = -1, hue = 1, gamma = 1)[1:10] )  
  pal[["ld_bright1"]]<-rev(cubeHelix(11, start = 0, r = 1, hue = 1.5, gamma = 1)[1:10]   )
  pal[["ld_bright2"]]<-rev(cubeHelix(11, start = 1, r = 1, hue = 1.5, gamma = 1)[1:10]   )
  pal[["ld_bright3"]]<-rev(cubeHelix(11, start = 2, r = 1, hue = 1.5, gamma = 1)[1:10]   )
  pal[["ld_muted1"]]<-rev(cubeHelix(11, start = 0, r = 1, hue = .5, gamma = 1)[1:10]   )
  pal[["ld_muted2"]]<-rev(cubeHelix(11, start = 1, r = 1, hue = .5, gamma = 1)[1:10]   )
  pal[["ld_muted3"]]<-rev(cubeHelix(11, start = 2, r = 1, hue = .5, gamma = 1)[1:10] )
  
  
  # Diverging Pallettes Based on Intensity Pallettes
  pal[["diverging_intensity_purple_green"]]<-append(rev(IntensityPalette(start=.2,r=.4,gamma=1)), IntensityPalette(start=1.75,r=.5,gamma=1))
  pal[["diverging_intensity_blue_red"]]<-append(rev(IntensityPalette(start=.5,r=-.5,gamma=1)), IntensityPalette(start=0.5,r=.5,gamma=1))
  
  # Diverging from black
  pal[["diverging_pink_black_blue"]]<-append(rev(cubeHelix(11, start = 1.5, r = -.4, hue = 1.75, gamma = 1)[1:9]), cubeHelix(11, start = .5, r = -.4, hue = 1.75, gamma = 1)[1:10])
  pal[["diverging_orange_black_blue"]]<-append(rev(cubeHelix(11, start = .5, r = -.4, hue = 1.75, gamma = 1)[1:9]), cubeHelix(11, start = .5, r = .4, hue = 1.75, gamma = 1)[1:10])
  pal[["diverging_green_black_purple"]]<-append(rev(cubeHelix(11, start = 0, r = -.4, hue = 1.75, gamma = 1)[1:9]), cubeHelix(11, start = 1, r = -.4, hue = 1.75, gamma = 1)[1:10])
  pal[["diverging_tan_black_green_multi"]]<-append(rev(cubeHelix(11, start = 2, r = -.4, hue = 1.75, gamma = 1)[1:9]), cubeHelix(11, start = .5, r = -.4, hue = 1.75, gamma = 1)[1:10])
  
  # Diverging from white
  pal[["diverging_pink_white_blue_mutli"]]<-append(cubeHelix(11, start = 1.5, r = -.4, hue = 1.75, gamma = 1)[3:11], rev(cubeHelix(11, start = .5, r = -.4, hue = 1.75, gamma = 1)[3:10]))
  pal[["diverging_purple_white_blue"]]<-append(cubeHelix(11, start = 1, r = -.4, hue = 1.75, gamma = 1)[3:11], rev(cubeHelix(11, start = 0, r = -.4, hue = 1.75, gamma = 1)[3:10]))
  pal[["diverging_tan_white_green_multi"]]<-append(cubeHelix(11, start = 2, r = -.4, hue = 1.75, gamma = 1)[3:11], rev(cubeHelix(11, start = .5, r = -.4, hue = 1.75, gamma = 1)[3:10]))
  
  # Diverging from Colors 
  pal[["diverging_green_purple_pink"]]<-append(rev(cubeHelix(11, start = 3, r = -.4, hue = 1.75, gamma = 1)[3:10]), 
                                                (cubeHelix(11, start = 3, r = .4, hue = 1.75, gamma = 1)[3:10]))
  pal[["diverging_orange_purple_blue"]]<-append(rev(cubeHelix(11, start = .5, r = -.4, hue = 1.75, gamma = 1)[3:10]), 
                                                 (cubeHelix(11, start = .5, r = .4, hue = 1.75, gamma = 1)[3:10]))
  pal[["diverging_tan_green_blue"]]<-append(rev(cubeHelix(11, start = 2, r = -.4, hue = 1.75, gamma = 1)[3:10]), 
                                             (cubeHelix(11, start = 2, r = .4, hue = 1.75, gamma = 1)[3:10]))
  pal[["diverging_green_blue_purple"]]<-append(rev(cubeHelix(11, start = 2.5, r = -.4, hue = 1.75, gamma = 2)[3:10]), 
                                                (cubeHelix(11, start = 2.5, r = .4, hue = 1.75, gamma = 2)[3:10]))
  pal[["diverging_pink_brown_green"]]<-append(rev(cubeHelix(11, start = 1.5, r = -.2, hue = 1.75, gamma = 1)[3:10]), 
                                               (cubeHelix(11, start = 1.5, r = .2, hue = 1.75, gamma = 1)[3:10]))
  pal[["diverging_blue_green_pink"]]<-append(rev(cubeHelix(11, start = .3, r = -.2, hue = 1.75, gamma = 1.6)[3:10]), 
                                              (cubeHelix(11, start = .3, r = .2, hue = 1.75, gamma = 1.6)[3:10]))
  pal[["diverging_blue_lightpurple_pink"]]<-append((cubeHelix(11, start = .3, r = -.2, hue = 1.75, gamma = 1.6)[3:10]), 
                                                    rev(cubeHelix(11, start = .3, r = .2, hue = 1.75, gamma = 1.6)[3:10]))
  pal[["diverging_pink_light_green"]]<-append((cubeHelix(11, start = 1.3, r = -.5, hue = 1.75, gamma = 1)[3:10]), 
                                               rev(cubeHelix(11, start = 1.3, r = .5, hue = 1.75, gamma = 1)[3:10]))
  
  # Intensity Pallettes  
  pal[["intensity_tan_red"]]<-IntensityPalette(start=0.5,r=.5,gamma=1)
  pal[["intensity_deepgreen_lavender"]]<-IntensityPalette(start=1.75,r=.5,gamma=1)
  pal[["intensity_pink_purple"]]<-IntensityPalette(start=3,r=.5,gamma=1)
  pal[["intensity_lightgreen_darkbrown"]]<-IntensityPalette(start=1,r=.5,gamma=1)
  pal[["intensity_lavender_darkgreen"]]<-IntensityPalette(start=1,r=.75,gamma=1)
  pal[["intensity_seagreen_purple"]]<-IntensityPalette(start=.5,r=-.5,gamma=1)
  pal[["intensity_pastel_purple"]]<-IntensityPalette(start=.2,r=.4,gamma=1)
  pal[["intensity_seagreen_blue"]]<-IntensityPalette(start=3,r=-.4,gamma=1)
  
  pal[["diverging_succulents"]]<-c("#BCF500","#D0E58B","#B4D681","#78975E","#8CB597","#ACCFB4","#C9E0C8","#00f5ff")
  
  if (!is.null(color)){ # if a specific color is requested
    
    requested_ramp<-pal[[color]]
    # Eliminating black from the color ramp, if requested.
    
    if(noblack){ # if the person has specified that they don't want pure black included in the color scheme:
      requested_ramp<-pal[[color]]
      requested_ramp<-copy(requested_ramp[!(requested_ramp %in% c("#000000"))]) # Eliminating black from the color ramp
    }
    if (!is.null(n)){ #If a specific number of colors are requested to be sampled
      # Creating a colorRampPallette function capable of interpolating N colors from the pallette
      pallette<-colorRampPalette(requested_ramp) 
      # Sampling n numbers of colors from that pallette (default will be 11)
      color_list<-pallette(n)
      return(color_list)
    }else{return(requested_ramp)}
    
  }else{ # If a specific color is *not* requested, return the whole list.
    return(pal)}
  
} # End woodson pallettes storage function.
