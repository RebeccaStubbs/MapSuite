#' Check your SpatialPolygonDataFrame's compatibility with PolygonMap() function.
#'
#' @description Checks the spatial object you intend to use with the PolygonMap() function
#' for valid geometry and projection
#' 
#'
#' @param shp A SpatialPolygonsDataFrame
#' 
#' @export
#' 
#' @return TRUE, or function will STOP with print statements about what requirements were not met.
#' 
#' @examples check_wmapshp(a_SpatialPolygonsDataFrame)

CheckPoly<-function(shp){
  
  if (!class(shp)=="SpatialPolygonsDataFrame"){
    stop("The object is not a SpatialPolygonsDataFrame.")
  }
  
  # checking to see if the geometry is all valid
  validity<-data.table(valid=rgeos::gIsValid(shp,byid=TRUE))
  if(!sum(!validity$valid)==0){
    stop(paste0("Hmm, looks like you have some invalid geometry in your shapefile. ",
                " Consider trying out ArcGIS' 'repair geometry' tools if you have access to them,",
                " or consider using the shp_to_Rpolygons function to bring in your spatial data-",
                " it has code to dissolve your polygons based on the primary key, which sometimes ",
                " fixes geometry validity problems."))}
 
  # Checking to make sure the object is projected.
  if(is.null(proj4string(shp))) stop("Looks like you don't have a projection assigned yet-- please assign a proj4string.")
  
  return(TRUE)
}
