#' ShptoSPDF
#'
#' @description Brings in a shapefile (from a directory on the computer) as a SpatialPolygonsDataFrame
#' with a data.table as the data attributes. 
#' 
#' @param shp_dir The directory where your shapefile is
#' 
#' @param shp_layer The name of the shapefile (ex: "census_tracts"), with no .shp or any other extension
#' 
#' @param id_field Character string of the column that is the primary key (what defines polygons as being
#' different from one another) in the shapefile. If a field that is not a primary key is provided, the polygons
#' will be collapsed such that there will be 1 polygon object (possibly multi-part) for each of the primary keys
#' you have identified, but the rest of the data table will no longer attach to the shapefile. 
#' 
#' @param all_data Logical; Whether you want the rest of the data attributes (other than the id_field provided)
#' to remain in the @data slot of the SpatialPolygonsDataFrame.
#' 
#' @export
#' 
#' @return A SpatialPolygonsDataFrame with a data.table 
#' @examples shp_to_Rpolygons("C:/Users/username/Documents/spatial_data/","shapfile_name","fipscode")

ShptoSPDF<-function(shp_dir,shp_layer,id_field,all_data=T){
  
  # Check to make sure that the required elements of the shapefile are
  # actually within that directory
  for (extension in c(".shp",".dbf",".prj")){
    if(!file.exists(paste0(shp_dir,"/",shp_layer,extension))){
      stop(paste0("The directory you've listed as the source for your data does not contain ",
                  "  the following file: ",shp_layer,extension," This is a problem- a shapefile ",
                  "  needs the following extensions: .shp (where the geometry is, .dbf (where ",
                  "  the attribute data is, and .prj (where the projection information is). "))
    }
  }  
  
  # Reading in the shapefile
  shp<-rgdal::readOGR(paste0(shp_dir, "/",shp_layer,".shp"), layer=shp_layer)
  full_data<-data.table(shp@data) # saving the "full" data from the shapefile attributes
  shp@data<-data.table(id_field=shp@data[[id_field]])
  
  # Doing a "Union Spatial Polygons"-- basically, turning all the polygon
  # objects with the same ID into 1 (possibly mutli-part) polygon.
  # This sometimes helps deal with null geometry issues. 
  map<-maptools::unionSpatialPolygons(shp,shp@data$id_field)
  data<-data.table(id_field=shp@data$id_field)
  rownames(data) <- data$id_field
  shp<-sp::SpatialPolygonsDataFrame(map, data)
  shp@data<-copy(shp@data)
  setnames(shp@data,"id_field",id_field)
  
  # Creating a column that will represent the correct order the data should ALWAYS
  # be in after ANY merge using the full polygon object.
  rows_orig<-nrow(shp@data)
  shp@data[,polygon_order:=seq(1:rows_orig)]
  print(paste0("Note: There is a new column in the @data slot called polygon_order. Remember that the attributes (values and IDs) for each ",
               "polygon are only linked to the polygons by sorting order-- if you ever merge anything onto your data, make sure that ",
               "you re-order the data by this polygon_order field afterwards."))
  
  ## Adding back in the rest of the data, if desired
  
  if(all_data){
    if(!nrow(full_data)==rows_orig){stop("Whoah--the id_field you chose doesn't seem to be the primary key for the shapefile. 
                                         To keep the full data set of the shapefile attached to the SpatialPolygonsDataFrame,
                                         you need to have the id_field be what defines each polygon-- if you put in a different
                                         field (for example, a field that represents states rather than counties when loading in
                                         a shapefile of counties), this function will spit out a SpatialPolygonsObject with only a
                                         data.table with the id_field you've chosen as the data. Keep in mind you can always use the
                                         read.dbf function in the foregin library to read in and explore the attributes alone.")}
    shp@data<-merge(shp@data,full_data,by=id_field)[order(polygon_order)]
    }
  
  # Check the geometric validity   
  validity<-data.table(valid=rgeos::gIsValid(shp,byid=TRUE))
  if(!sum(!validity$valid)==0){
    stop(paste0("Hmm, looks like you have some invalid geometry in your shapefile. ",
                " Consider trying out 'repair geometry' tools if you have access to them."))}
  return(shp)
  }
