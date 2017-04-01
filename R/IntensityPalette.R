#' Histogram of data using color scheme
#'
#' @description This histogram function creates and returns a ggplot object with
#' a color scale dependent on the X value (default as all colors being grey)
#' as well as the possibility for vertical lines that describe different
#' properties of the distribution (mean, median, etc) added on top of the graph.
#'
#' @param start numeric start-point for cubehelix color ramp
#' @param r number of rotations through cubehelix color ramp
#' @param hue numeric;how bright you want the colors to be 1: normal, higher: brighter, lower: more demure
#' @param gamma numeric; how light or dark you want it to be 1: normal, higher:darker, lower: lighter
#' @param color_value_breaks values to break colors at
#' @param dist_stats which distribution to use
#' @return an adapted cubehelix color pallette, increasing in intensity.
#' @export
#'
#' @examples IntensityPalette(start=0.5,r=.5,gamma=1)


IntensityPalette<-function(start,r,gamma,hue_list=c(.5,1,3)){
  # This function creates a color pallette from a cubehelix that increases in Intensity/hue as it gets darker.
  # Start: what color you want to start with
  # hue: how bright you want the colors to be (1: normal, higher: brighter, lower: more demure)
  # R: How many "rotations" through color space you want it to do (how complicated do you want your color ramp to be?)
  # gamma: How light or dark you want it to be (1: normal, higher:darker, lower: lighter)
  # requires: library(rje) for the cubehelix function. 
  # Author: Rebecca Stubbs on 2/18/2016
  #low intensity pallette
  mellow<-cubeHelix(11, start = start, r = r, hue = hue_list[1], gamma = gamma)
  #middling intensity
  mid<-cubeHelix(11, start = start, r = r, hue = hue_list[2], gamma = gamma) 
  #strong intensity
  strong<-cubeHelix(11, start = start, r = r, hue = hue_list[3], gamma = gamma) #hues higher than 2 get weird
  # binding together the colors such that they are flipped (light to dark)
  colors<-(rbind(rev(mellow[2:8]),rev(mid[2:8]),rev(strong[2:8])))
  mellow_to_strong<-append(colors[1,1:2],colors[2,3:5]) #appending together the mellow and middling colors
  mellow_to_strong<-append(mellow_to_strong,colors[3,6:7]) # appending together the strong colors onto the mellow and middling
  return(mellow_to_strong)}
