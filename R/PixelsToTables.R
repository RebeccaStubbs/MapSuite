#'  PixelsToTables
#' 
#' @description This function converts a RasterLayer or RasterStack/Brick to two objects returned in 
#' a list: a data.table that is the 'map', with x, y, and a point ID, and a data.table that contains
#' the variable the raster contained, and the dimension (if it's a RasterStack).
#' 
#' @param rast       A RasterStack or RasterLayer object
#' 
#' @param dimensions A vector of what each layer (in order, first to last) means-- 
#'                   for example, a list of years (seq(2000,2015)). Default value (if left null)
#'                   will be the names of the raster layers.
#'                   
#' @param dim_name   Only applicable/relevant if 'rast' is a RasterStack/Brick with multiple layers.
#'                   A character string (no spaces, please) that you want to use
#'                   to describe the dimensions in your raster (ex: "year"). This will
#'                   exist in the "data" object returned by the function. Default value (if left null)
#'                   is "dimension".
#'                   
#' @param var_name        A character string (no spaces, please) that you want to use to 
#'                   describe the variable that the raster represents. This will exist
#'                   in the "data" object returned by the function if the rast is a RasterStack,
#'                   or in the "map" object if the rast is a RasterLayer. Default value (if left null)
#'                   is "variable".                   
#'                   
#' @return This function will return a list with data tables: map, and data (only included if the rast object is a RasterStack/Brick). 
#' The map object will be a data.table with columns for x, y, a point ID column named "id", and the raster values in a column
#' named according to "var" (default if left null is "variable") with the raster values. 
#' The data object will a data.table with columns for X, Y, point ID, the variable represented in the raster, and 
#' a column with your dimension (named using the dim_name parameter), where the values in that dimension will be the dimensions 
#' provided to the dim_name parameter. 
#' 
#' Note that order of your dimensions provided to the function matters, if your rast object is a RasterStack/Brick -- 
#' if years are "stacked" earliest to lowest going from 1-16, you need to pass a sequence going from smallest to largest
#' years to dimensions-- the values for "dimension" are assigned, in order, to the layers of the RasterStack.
#' 
#' @examples
#' 
#' # For a single-band/RasterLayer
#'   single_rasterlayer<-raster::raster(results_tif_filepath)
#'   results_table<-PixelsToTables(rast=single_rasterlayer,var_name="value")
#' 
#' # For a multi-band/RasterStack
#'   annual_raster_stack<-raster::stack(results_tif_filepath)
#'   time_series<-PixelsToTables(rast=annual_raster_stack,var_name="mean",dimensions=seq(2000,2015),dim_name="year")
#'   map<-time_series$map
#'   data<-time_series$data
#' 
#' @export

PixelsToTables<-function(rast, # Must be RasterStack or RasterLayer
                         dimensions=NULL,
                         dim_name=NULL, 
                         var_name=NULL){
  
  if(is.null(var_name)){
    warning("You haven't provided a variable name, the variable will be represented by a variable named 'variable'")
    var_name<-"variable"
  }
  
  # If it is just a RasterLayer:
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if("RasterLayer" %in% class(rast)){
    message("'rast' seems to be a RasterLayer: This will return 1 data.table (map).")
    
    map <- data.table(rasterToPoints(rast)) # Create a data.table based on that year
    map[,id:=seq(1:nrow(map))] # Generate a point ID
    names(map)<-c("x","y",var,"id") # renaming columns
    return(map)  
    # Otherwise, if it is a RasterStack:
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  } else if ("RasterStack" %in% class(rast)|"RasterBrick" %in% class(rast)){
    results<-list()
    
    message("'rast' seems to be a RasterStack: This will return 2 data.tables (map, and data) in a list, with those names.")
    # Checking for validity and definitions of dimensions: 
    if(is.null(dim_name)){
      warning("You haven't provided a dim_name, the layers in the raster stack will be represented by a variable 'dimension'")
      dim_name<-"dimension"
    }
    
    if(!is.null(dimensions)){
      # Check to make sure the year range matches the number of layers in the raster stack
      ndims<-length(names(rast))
      if(length(dimensions)!=ndims){stop("Whoah, the number of layers in your raster doesn't seem to match up with the dimensions as specified...")}
    }else{
      warning("You have not provided a list of dimensions-- this means that the function will use the names of the layers in the RasterStack.")
      dimensions<-names(rast)
    }
    
    map<-list() # create empty list for the maps
    
    # For each layer in the raster stack, snag raster to points. 
    for (dim in seq(1:ndims)){
      message(paste0("Converting ",dimensions[[dim]]," to points.")) # print progress
      pts <- data.table(rasterToPoints(rast[[dim]])) # Create a data.table based on that year
      pts[,id:=seq(1:nrow(pts))] # Generate a point ID
      pts[,dimension:=dimensions[dim]] # Assign a dim to the dimensions column
      map[[as.character(dim)]]<-pts # add the data.table to the list
    }
    message("Combining different dimensions together to 1 data.table")
    map<-rbindlist(map)
    names(map)<-c("x","y",var_name,"id",dim_name) # renaming columns
    
    # Separating out the geographic and tabular information:
    data<-copy(map) # One data.table with the prevalence info
    map<-unique(map[,list(x,y,id)]) # One data.table with just the geographic boundary and ID information
    results[["map"]]<-map
    results[["data"]]<-data
    return(results)
    
    # If it is neither a RasterLayer or a RasterStack, error out:
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  }else{
    # If neither RasterStack or RasterLayer was in the list of classes for rast...
    stop("Object 'rast' needs to be of class RasterLayer, RasterStack or RasterBrick.")
  }
  
}# Closing raster conversion function