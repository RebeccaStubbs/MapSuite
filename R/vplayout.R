#' Grid viewport function wrapper.
#'
#' @description A wrapper for the viewport function that overwrites the original
#' parameters.
#'
#' @param x float > 0
#' @param y float > 0
#' @param ... further argumenst to be passed to the grid::viewport function
#' @export
#' 
#' @return An R object of class viewport.
#' 
vplayout <- function(x, y, ...) {
    grid::viewport(layout.pos.row = x, layout.pos.col = y, ...)
}
