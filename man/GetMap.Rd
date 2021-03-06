% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetMap.R
\name{GetMap}
\alias{GetMap}
\title{GetMap}
\usage{
GetMap(map_object, xbounds = NULL, ybounds = NULL)
}
\arguments{
\item{map_object}{GGplot object.}

\item{xbounds}{A 2-item vector corresponding to the X min/max limits 
of the extent you want for your map. Default=NULL.}

\item{ybounds}{A 2-item vector corresponding to the y min/max limits 
of the extent you want for your map. Default=NULL.}
}
\value{
A ggplotgrob of a map object with no legend.
}
\description{
Gets a grob of a ggplot map, with no legend.
}
\examples{

GetMap(map_obj)

}

