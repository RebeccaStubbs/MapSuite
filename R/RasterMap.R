#' Raster Map Plotting Utility
#'
#' @description Simplified plotting x/y coordinate data on a regular grid.
#'
#' @param coords A data table with an x and a y column with coordinates in the desired
#'  coordinate reference system/projection. This geometry table must also include a unique
#'  ID field to serve as the geographic identifier for the points/pixels. 
#'  
#' @param xcol String; the name of the column that is the x values for the grid
#' @param ycol String; the name of the column that is the y values for the grid
#'   
#' @param id string; the column name for the unique geogrpahic ID
#' 
#' @param variable string; the name of the column with values you wich to plot. Default is 
#' NULL, which will allow the user to create a layer with a single fill and outline color for
#' the main map.
#'    
#' @param data A data.table that contains the data you want to map
#'    (must contain id, and the variable of interest, if specified.
#'    If a series dimension and/or series sequence is defined,
#'    those must also exist in this data set)
#'    
#' @param verbose logical; Whether you want print statements from the function
#' 
#' 
#' @param return_objects This will return a list with named objects- $maps, $hists (if histogram==T), 
#'    $titles, and $subtitles. Each of these lists 
#'    if one ins included), as well as an outline (if one is included). 
#'    This will never return a histogram at the bottom of the map, if one is desired. If
#'    you need to modify the map, and you also would like a histogram using the same color
#'    scheme, see the function histogram_colorstats(), also within the Woodson library.
#'    
#' 
#' @param pdf_path A string file path to generate a PDF of the maps. If this argument is
#'    provided, the map(s) will be printed to the PDF.
#'    
#'    
#' @param map_colors A list of colors that will serve as the colors you
#'    "stretch" through based on your data values. This will default to a color
#'    scheme described in woodson pallettes called "Easter to Earth" that
#'    displays variation well when there are many geographic units. See woodson
#'    palletes for more options, or create your own. 
#'    When no variable is defined: Fill color is default set to dark grey.
#'    
#' @param map_NAcolor The color data values that are NA are portrayed as. Default="grey".
#' 
#' @param map_transparency Transparency/alpha of map and map outline. Must be between
#' 0 (entirely transparent) to 1 (entirely opaque). Default=1. 
#' 
#' @param map_colors_limits Values that will be used to stretch the color ramp
#'    instead of the min/max values present in the entire data set. Should
#'    either be structured "c(min,max)", with numeric values, or be
#'    "each_dimension", which will create a map series where each individual map
#'    in a series will based on the min/max from that subset of data.
#'    
#' @param map_colors_breaks How you want the colors "stretched" across the
#'    range of minimum/maximum values. Default is NULL/ uniform distribution
#'    stretched across the color ramp from the minimum and maximum data values
#'    provided. Vector must begin with 0 and end with 1.
#'    
#' @param map_diverging_centervalue Accepts any numeric value between the minimum
#'    and maximum of your data set. Sets the center of your color scheme to the
#'    value defined. This is meant to be used with diverging color schemes. It
#'    will override any previously defined map_colors_breaks. Default=NULL.
#'    
#' @param histogram logical; the plot will contain a histogram of the values
#' 
#' @param histogram_fill_color If a character string for a color (or colors) are entered
#'    (ex:"grey"), the histogram will be that color rather than the color ramp
#'    used for the main map.
#'    
#' @param histogram_stats Vertical lines on the histogram plot showing summary
#'    statistics. To show this, provide a vector of numeric values (between 0
#'    and 1) to serve as quantiles, and the options "mean" and "sd" can also be
#'    included. example: c("mean","sd",.1,.5,.9). Default=NULL.
#'    
#' @param histogram_stats_mean_color The color of lines you want to represent mean and standard
#'    deviation statistics, only relevant if histogram_stats!=NULL. Default="red".
#'    
#' @param histogram_stats_quantile_color The color of lines you want to represent the median and
#'    quantile lines on the histogram, only relevant if histogram_stats!=NULL.
#'    
#' 
#' @param outline A SpatialPolygons object that you want to use the
#'     outlines from. Make sure your outline map and main map have the same projection.
#'     
#' @param outline_color What color you want the outline of the additional
#'    geography to be (if provided). This can be any color r recognizes
#'    suggestions might be "black","yellow", or "white". Default is white.
#'    
#' @param outline_size A numeric value that specifies how large you want your
#'    white outlines to be if you have specified an outline you want shown on
#'    your map. Default value is .1.
#'
#' 
#' @param font_family The name of the font family you want to use for the text
#'     on the plot. Default is 'serif'.
#'     
#' @param font_size The base/minimum size of the text on your graphic. 
#'       Default is NULL. 
#'       
#' @param map_title String; the title of your map.
#' 
#' @param map_subtitle  String; Default=NULL. Subtitle of your map. 
#'        If there is no series being plotted, the map_subtitle will serve as the subtitle. 
#'        If you are mapping over a dimension, the map subtitle will automatically
#'        be set to the series_dimension being plotted. If you are mapping over a dimension,
#'        entering text for "map_subtitle" will become the prefix for the specific dimension being mapped.
#'        For example, if mapping over time, c(1990,2000), and the map_subtitle was "Year: ",
#'        the full subtitle would be "Year: 1990", and "Year: 2000", respectively.
#' 
#' @param map_title_justification Numeric from 0 (left) to 1 (right). Default is center (.5).
#'        
#' @param map_title_font_size How large you want the title font to be. No default;
#'    default values based on ggthemes tufte()'s default.
#'    
#' @param map_title_font_face Special properties of the title font.
#'    Options include "plain", "bold", "italic". Default is plain.
#'
#' @param include_titles Default=NULL. If unspecified, and return_objects=F, include_titles will
#'    be set to T, and titles will be plotted. If unspecified, and return_objects=T, titles will
#'    not be plotted (but will be included within the resulting object within the $title and 
#'    $subtitle slots).
#'    
#' 
#' @param series_dimension A string-- the name of the column that will serve as
#'    the variable you loop through to create a series map. For example, year.
#'    
#' @param series_sequence A vector c(x,y,z...) that specifies a subset of the
#'    series dimensions you want to map. For example, if you have a data set
#'    that contains all years between 1980-2014, you can specify that you only
#'    want to plot out every other year by setting series sequence to be
#'    seq(1980,2014,2). This function will make sure all of the items you
#'    speficy actually exist within your series_dimension.
#'  
#' 
#' @param legend_title Title above the legend. Default is NULL. 
#' 
#' @param legend_position Where you want the legend to go. Options are
#'    "top","bottom","right","left", and "none". Default is "bottom".
#'    
#' @param legend_font_size How large you want the legend font to be.
#'    Default is NULL, which corresponds to the scaling of the base-font.
#'    
#' @param legend_font_face Special properties of the legend font. Options
#'    include "plain", "bold", "italic". Default is plain.
#'    
#' @param legend_bar_width How fat you want the color bar that serves as the
#'    legend to be. Default value is unit(.03,"snpc"), or 3 percent of the viewport
#'    
#' @param legend_bar_legnth How long you want the color bar that serves as the
#'    legend to be. Default value is unit(.75,"snpc"), or 75 percent of the viewport
#'    
#' @param legend_label_breaks An optional vector of the values you want to label in
#'    your legend's color scale.
#'    
#' @param legend_label_values An optional vector of the character strings you want to
#'    use to label your legend's color scale (must be same length as
#'    legend_label_breaks)
#'      
#' @param legend_patch_width width of color swatches in legend when categorical data
#'      is used. Default is .25. 
#'      
#' @param legend_patch_height height of color swatches in legend when categorical data
#'      is used. Default is .25. 
#'      
#' @param legend_patch_label_position Position of category labels in legend when categorical
#'      data is used. Default= "right". 
#'      
#' @return ggplot object or None (plots written to pdf)
#' 
#' @examples see https://rpubs.com/BeccaStubbs/introduction_to_woodson_mapping_suite for more info.
#' 
#' @export

RasterMap<-function(
  
  # MAIN PARAMETERS
  coords,
  id,
  xcol,
  ycol,
  variable=NULL,
  data=NULL,
  verbose=F,
  
  # MAP COLOR AND OUTLINE AESTHETICS
  map_colors=wpal("earth"),
  map_NAcolor="grey",
  map_transparency=1,
  map_colors_limits=NULL,
  map_colors_breaks=NULL,
  map_diverging_centervalue=NULL,
  
  # WHAT IS RETURNED BY THE FUNCTION
  return_objects=FALSE,
  pdf_path=NULL,
  include_titles=NULL,
  
  # INCLUDING A HISTOGRAM
  histogram=FALSE,
  histogram_fill_color=NULL,
  histogram_stats=NULL,
  histogram_stats_mean_color="red",
  histogram_stats_quantile_color="black",
  
  # ADDING AN OUTLINE ON TOP OF THE MAP
  outline=NULL, 
  outline_size=.1,
  outline_color="white",
  
  # MAP TITLE AND FONT AESTHETICS
  font_family="serif",
  font_size=12,
  map_title=NULL,
  map_subtitle=NULL,
  map_title_justification=.5,
  map_title_font_size=NULL,
  map_title_font_face="plain",
  
  # MAKING MULTIPLE MAPS: MAPPING OVER DIMENSIONS
  series_dimension=NULL,
  series_sequence=NULL,
  
  # LEGEND AESTHETICS
  legend_title=NULL,
  legend_position="bottom",
  legend_orientation="horizontal",
  legend_font_size=NULL,
  legend_font_face="plain",
  legend_bar_width=unit(.03,"snpc"),
  legend_bar_length=unit(.75,"snpc"),
  legend_label_breaks=NULL,
  legend_label_values=NULL,
  legend_patch_width=.25,
  legend_patch_height=.25,
  legend_patch_label_position="right"){
  
  ## Copying the input objects
  # Creating these internal copies avoids the objects getting modified outside the function.
  data_is_null<-is.null(data)
  map<-copy(coords)
  outline<-copy(outline)
  data<-copy(data)
  
  # Determining whether to show the titles or not:
  if(is.null(include_titles)){
    if(return_objects==T){
      include_titles<-F
    }else{
      include_titles<-T
    }
  }
  
  ## Check and prep the 'map' object.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  if (!(id %in% names(map))){
    stop("The id variable name you specified does not appear to exist within the coord data frame.")
  }
  
  if (!(xcol %in% names(map))){
    stop("The xcol variable name you specified does not appear to exist within the coord data frame.")
  }
  
  if (!(ycol %in% names(map))){
    stop("The ycol variable name you specified does not appear to exist within the coord data frame.")
  }
  
  setnames(map,xcol,"lon")
  setnames(map,ycol,"lat")
  # If you want a simple, filled polygon map with no variable specified:
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (is.null(variable)){
    
    if(histogram==T){
      stop("You have not specified a variable, you cannot make a histogram.")
    }
    
    if(length(map_colors)>1){
      warning("You have not specified a variable, you  must specify 1 color as the 'map_colors' parameter. Main map fill color will be set to dark grey.")
      map_colors<-"darkgrey"
    }
    
    # Renaming the id variable to "id".
    setnames(map,id,"id")
    
    map_plot<-ggplot() + 
      geom_raster(data=map,aes(x=lon, y=lat),fill=map_colors) +
      scale_x_continuous("", breaks=NULL) + 
      scale_y_continuous("", breaks=NULL) + 
      coord_fixed(ratio=1)+
      theme_tufte(base_size = font_size, base_family = font_family)
    
    
    # if you aren't returning the map objects
    if(include_titles==T){
      map_plot<-map_plot+
        labs(title = map_title, subtitle=main_map_subtitle) +
        theme(plot.title = element_text(size = map_title_font_size, face=map_title_font_face, hjust = map_title_justification),
              plot.subtitle=element_text(hjust = map_title_justification),
              legend.text = element_text(size = legend_font_size, face=legend_font_face))
    }
    
    
    if (!is.null(outline)) {
      if (!class(outline) %in% c("SpatialPolygonsDataFrame","SpatialPolygons")){
        stop("The 'outline' object needs to be of class 'SpatialPolygons' or 'SpatialPolygonsDataFrame'.")
      }
      outline<-data.table(suppressWarnings(fortify(outline))) # If an outline map is specified, fortify the outline map as well.
    }
    
    if (!is.null(outline)){
      map_plot<-map_plot+
        geom_path(data = outline, 
                  aes(x = long, y = lat, group = group),
                  color = outline_color, size = outline_size)
    }
    
    map_plot<-map_plot+
      guides(fill=guide_legend(title=legend_title,
                               keywidth=legend_patch_width,
                               keyheight=legend_patch_height,
                               label.position = legend_patch_label_position))+
      theme(legend.position=legend_position)
    
    
    # Returning the simple map
    if(return_objects==T){
      
      wmap_results<-list()
      wmap_results$map<-map_plot
      wmap_results$title<-map_title
      wmap_results$subtitle<-map_subtitle
      
      return(wmap_results)
    } else {
      
      if (!is.null(pdf_path)){
        pdf(pdf_path)
      }
      
      print(map_plot)
      
      if (!is.null(pdf_path)){
        dev.off()
        print("PDF ready to view.")
      }
      
    }
    
    
    # If you want to map based on a variable:
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  } else {
    
    if (!is.data.table(map)){
      map<-copy(data.table(map))
      if (verbose){
        print("The @data slot in the 'map' object provided was not a data.table. It has been converted to one within the function.")
      }
    }
    
    
    if (id==variable){
      stop("The 'id' and 'variable' variables specified are the same. If you need to plot the 'id' as a variable, generate a new column with a copy of that variable and name it something different.")
    }
    
    # Renaming the id variable to "id".
    setnames(map,id,"id")
    map[,id:=as.character(id)]
    
    # Prepare the 'variable', check the 'data' object if provided for the 'id' variable.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    if(is.null(data)){ # If a 'data' object has NOT been passed to the function
      data<-copy(map)
      
    } else { # If a 'data' object HAS been passed to the function...
      
      if(!(id %in% names(data))){
        stop("The id variable name you specified does not appear to exist within the 'data' object provided.")
      }
      
      if(variable %in% names(map)){
        stop ("The variable you have provided is in the 'map' object provided- either do not provide a 'data' object, or remove the variable from the map object.")
      }
      
      if(! variable %in% names(data)){
        stop ("The variable you have specified is not in the 'data' object you have provided.")
      }  
      
      if(!is.data.table(data)){
        data<-copy(data.table(data))
        if(verbose){
          print("The 'data' object provided was not a data.table. It has been converted to one within the function.")
        }
      }
      
      # Changing the name of the 'id' variable to "id"
      setnames(data,id,"id")
    } # Closing "if external data is NOT provided" clause.
    
    # Changing the name of the variable to "variable" 
    setnames(data,variable,"variable")
    
    
    # Fortifying the Map objects 
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    if (!is.null(outline)) {
      if (!class(outline) %in% c("SpatialPolygonsDataFrame","SpatialPolygons")){
        stop("The 'outline' object needs to be of class 'SpatialPolygons' or 'SpatialPolygonsDataFrame'.")
      }
      outline<-data.table(suppressWarnings(fortify(outline))) # If an outline map is specified, fortify the outline map as well.
    }
    
    # Check individual aesthetic parameters if they have been provided
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if(!is.null(legend_label_breaks)){
      if (sum(!is.numeric(legend_label_breaks))>0){
        stop("All values provided to 'legend_label_breaks' must be numeric.")
      }
      if(!length(legend_label_breaks)==length(legend_label_values)){
        stop("The 'legend_label_breaks' and 'legend_label_names' provided need to be the same length.")
      }
    }
    # If the data is categorical
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
    # Check for categorical data
    if (is.factor(data[["variable"]])|is.ordered(data[["variable"]])){
      discrete_scale<-TRUE
    }else if (is.character(data[["variable"]])){
      discrete_scale<-TRUE
      data[,variable:=as.factor(variable)]
      if(verbose){
        print("The variable you specified is a character, not a factor. It has been convered to a factor. To order your levels, pass a correctly ordered factor to this function.")
      }  
    }else{
      discrete_scale<-FALSE
    }
    
    # If it is categorical data...
    if (discrete_scale){
      if (histogram){
        stop("Sorry, histogram/bar graph functionality is not yet supported in this version of the mapping suite for categorical data.")
      }
      
      # Make sure the color pallette has the right number of colors.
      pallette<-colorRampPalette(map_colors) 
      color_list<-pallette(nlevels(data[["variable"]]))
    }
    
    
    # If a series-dimension is provided (or not)
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
    # Defining the series dimension
    if (is.null(series_dimension)){ # If you plan to loop through miltiple dimensions...
      data[,series_dimension:="*&^! no dimensions"]
    }else{ # If series_dimension is provided to the function
      if(!(series_dimension %in% names(data))){
        stop("That series dimension (what you want to iterate through) does not appear to exist within your data set.")
      }
      setnames(data,series_dimension,"series_dimension")
    }
    
    # Restricting the mapping to only *some* levels of that dimension, if desired: the series_sequence parameter
    if (is.null(series_sequence)){
      map_dims<-unique(data$series_dimension)
    }else{ 
      if(sum(!(series_sequence %in% unique(data$series_dimension)))>0){
        stop("Not all of the dimensions you have provided in the 'series_sequence' exist in the 'series_dimension' provided.")
      }
      map_dims<-series_sequence
    }
    
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Joining on the Data
    
    # creating one long, huge object that you can subset by merging together the data and the forfified geometry
    data<-data[, list(id=as.character(id), variable, series_dimension)] # Sub-setting the data such that only the variables that matter are kept
    
    orig_rows<-nrow(map)
    map<-merge(data, map, by="id", allow.cartesian=T)
    after_rows<-nrow(map)
    
    if(orig_rows<after_rows&is.null(series_dimension)){
      stop("You are trying to map more than one data observation per geometry, and you have not specified a series dimension to map over. Did you intend to subset your data further before passing it to this function?")
    }  
    
    
    # Starting a PDF, if desired
    if (!is.null(pdf_path)){
      pdf(pdf_path)
    }
    
    # Creating lists in which to store results
    maps<-list()
    hists<-list()
    titles<-list()
    subtitles<-list()
    
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Starting the Loop
    if (verbose){
      print(paste0("Mapping ",map_title))
    }
    
    ###########################################
    ## LOOPING ACROSS DIMENSIONS
    ########################################### 
    for (select_dimension in map_dims){ #for each dimension you want to plot...
      
      # Determining map subtitle
      if (is.null(series_dimension)) {
        main_map_subtitle<-map_subtitle
        if (verbose){
          print(main_map_subtitle)
        }
      } else {
        main_map_subtitle<-paste0(map_subtitle,select_dimension)
        if (verbose){
          print(main_map_subtitle)
        }
      }
      
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Subsetting the Data
      subset<-copy(map[series_dimension==select_dimension]) # Sub-setting the fortified object to map out 1 layer/dimension (ex: year) of the variable of interest  
      
      
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # Creating the Base Map Plot in GGPlot2
    
      map_plot<-ggplot() + 
        geom_raster(data=map,aes(x=lon, y=lat, fill=variable),alpha=map_transparency)+
          scale_x_continuous("", breaks=NULL) + 
          scale_y_continuous("", breaks=NULL) + 
          coord_fixed(ratio=1)+
          theme_tufte(base_size = font_size, base_family = font_family)
      
      
      
      
      if(include_titles==T){
        map_plot<-map_plot+
          labs(title = map_title, subtitle=main_map_subtitle) +
          theme(plot.title = element_text(size = map_title_font_size, face=map_title_font_face, hjust = map_title_justification),
                plot.subtitle=element_text(hjust = map_title_justification),
                legend.text = element_text(size = legend_font_size, face=legend_font_face))
      }
      
      #####################
      # If Data is Numeric, find the appropriate scales
      #####################
      
      if(discrete_scale==F){ # If the data is numeric... 
        
        # DEFINING COLOR RAMP AESTHETICS
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        # Defining Color Min/Max      
        if (!is.null(map_colors_limits)){ # if x/y limits were provided..
          if(is.numeric(map_colors_limits)){
            minimum<-map_colors_limits[1]
            maximum<-map_colors_limits[2]
          } else { # If the input was NOT numeric... 
            if (!map_colors_limits=="each_dimension"){
              stop("Any character input other than 'each_dimension', which will produce a color ramp from the min/max of each dimension, is not recognized.")
            }
            maximum<-max(subset[["variable"]],na.rm=T)
            minimum<-min(subset[["variable"]],na.rm=T)
          }
        }else{ # if no map_colors_limits were provided, set the min/max of the scale to the min/max of ALL dimensions of the variable.
          maximum<-max(map[["variable"]],na.rm=T)
          minimum<-min(map[["variable"]],na.rm=T)
        }
        
        # Defining color breaks to make the correct Diverging centerpoint, if one was given, based on the min/max.
        if(!is.null(map_diverging_centervalue)){
          if(map_diverging_centervalue>maximum){
            stop("The diverging centerpoint provided is greater than the maximum value in the data set.")
          }
          if(map_diverging_centervalue<minimum){
            stop("The diverging centerpoint provided is less than the minimum value in the data set.")}
          # Finding what where the specified break point is as a fraction of the total color range 
          break_value<-(map_diverging_centervalue-minimum)/(maximum-minimum)
          map_colors_breaks<-c(0,break_value,1)
          if (verbose) {
            print(paste0("Centering color ramp at ",map_diverging_centervalue,". Any other color breaks provided have been overridden."))
          }
        }
        
        
        
        
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # Adding the color ramp!
        if(!is.null(legend_label_breaks)&!is.null(legend_label_values)){
          map_plot<-map_plot+scale_fill_gradientn(colours=map_colors, 
                                                   limits=c(minimum, maximum),
                                                   values=map_colors_breaks, 
                                                   breaks=legend_label_breaks, 
                                                   labels=legend_label_values,
                                                   na.value=map_NAcolor)
        } else {
          map_plot<-map_plot+scale_fill_gradientn(colours=map_colors, 
                                                   limits=c(minimum, maximum), 
                                                   values=map_colors_breaks) 
        }
        
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # Adding a legend
        
        if(legend_orientation=="horizontal"){
          legend_bar_x<-legend_bar_length
          legend_bar_y<-legend_bar_width
        }
        if(legend_orientation=="vertical"){
          legend_bar_x<-legend_bar_width
          legend_bar_y<-legend_bar_length
        }
        
        if (legend_position %in% c("none")){
          map_plot<-map_plot+theme(legend.position="none")
        } else {
            map_plot<-map_plot+
              guides(fill=guide_colourbar(title=legend_title, title.position="top", barheight=legend_bar_y, barwidth=legend_bar_x, label=TRUE, ticks=FALSE ,direction=legend_orientation)) + 
              theme(legend.position=legend_position,legend.title=element_text(size=legend_font_size))
        }
        
        
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # Making a histogram of the distribution of that dimension's values
        
        # If you have specified that you do want the histogram at the bottom:
        if (histogram==TRUE){ 
          
          # Histogram Color Scheme
          if(!is.null(histogram_fill_color)){
            histogram_colors<-histogram_fill_color
          }else{
            histogram_colors<-map_colors
          }
          
          # Build Histogram
          histo<-HistogramColorstats(datavector=subset$variable,
                                     color_ramp=histogram_colors,
                                     minimum=minimum,
                                     maximum=maximum,
                                     color_value_breaks=map_colors_breaks,
                                     dist_stats=histogram_stats,
                                     mean_color=histogram_stats_mean_color,
                                     quantile_color=histogram_stats_quantile_color)
        }# If histogam==T
        
      } # if data is numeric
      
      
      # If Data is Categorical/Ordinal
      #################################
      if (discrete_scale==T){
        
        # Adding the color ramp!
        map_plot<-map_plot+scale_fill_manual(values=color_list,drop = FALSE)
        
        # Adding a legend
        map_plot<-map_plot+
          guides(fill=guide_legend(title=legend_title,
                                   keywidth=legend_patch_width,
                                   keyheight=legend_patch_height,
                                   label.position = legend_patch_label_position,
                                   direction=legend_orientation))+
          theme(legend.position=legend_position)
        
        
        # Adding a "histogram" (really, in this case, a bar chart) to the bottom of the image: 
        # This is in BETA and is not currently a funcitonality in v 1.1. 
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if (histogram==TRUE){ # If you have specified that you do want the histogram at the bottom:          
          print("making histogram")
          histo<-ggplot(na.omit(subset), aes(x=variable, fill=variable)) +
            geom_bar() + 
            labs(x=NULL, y=NULL) +
            scale_fill_manual(values=rev(color_list))+
            theme_tufte(base_size = font_size, base_family = font_family)+theme(legend.position="none",
                                                                                axis.ticks.x=element_blank(),
                                                                                axis.ticks.y=element_blank())+theme(plot.title=element_text(hjust = 0.5))
        }# If histogam==T
        
      } # if it's ordinal/categorical
      
      
      # Adding Outline Map, if desired
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      if (!is.null(outline)){
        map_plot<-map_plot+
          geom_path(data = outline, 
                    aes(x = long, y = lat, group = group),
                    color = outline_color, size = outline_size,
                    alpha=map_transparency)
      }
      
      # Either saving or returning map output
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
      # Adding the histogram to a list of histograms if want the object returned
      if(return_objects==T){
        
        if(!is.null(series_dimension)){
          titles[[as.character(select_dimension)]]<-map_title
          subtitles[[as.character(select_dimension)]]<-main_map_subtitle
          maps[[as.character(select_dimension)]]<-map_plot
          if(histogram==T){
            hists[[as.character(select_dimension)]]<-histo
          }
        }
        
      } else { # If you don't want to return the objects
        
        # Printing the Plot (If you don't want the objects returned)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        if (histogram==TRUE){# Combining Histogram and Map to plot into a single image.
          grid.newpage() # Starting a new page
          pushViewport(viewport(layout = grid.layout(5, 1))) # Defining the ratio of the histogram to map to be 5 sections vertically, 1 horizontally
          vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y) # Defining a function that allows setting the layout of the viewport 
          print(map_plot, vp = vplayout(1:4, 1)) # Printing the map plot to the viewport in vertical slots 1-4, covering all the x-space
          print(histo, vp = vplayout(5, 1)) # Printing the histogram to the bottom of the map: 
        }else{
          print(map_plot) #If you didn't want the histogram, just print out the map!
        }
        
      } # Closing the "if return_objects=TRUE" clause if return_objects==T is false.
      
    } # Closing the loop of dimensions
    
    # Return the objects, close the PDF if necessary
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    # If you have been mapping series dimensions...
    if(return_objects==T){
      
      if(!is.null(series_dimension)){
        wmap_results<-list()
        wmap_results$map<-maps
        if(histogram==T){
          wmap_results$hist<-hists
        }
        wmap_results$title<-titles
        wmap_results$subtitle<-subtitles
      }else{
        wmap_results<-list()
        wmap_results$map<-map_plot
        wmap_results$title<-map_title
        wmap_results$subtitle<-map_subtitle
        if(histogram==T){
          wmap_results$hist<-histo
        }
      }
      return(wmap_results)
    }
    
    if (!is.null(pdf_path)){
      dev.off()
      print("PDF ready to view.")
    } #If you were writing this to a PDF, you can close it, and check it out!
    
    
  } # Closing clause for whether or not you wanted a simple, non-variable based map
  
} # Closing Function!

