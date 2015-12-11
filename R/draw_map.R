##' draw a map 
##'
##' 
##' @title draw_map
##' @param database name of map provided by 'maps' package.  These include
##'                 'county', 'france', 'italy', 'nz', 'state', 'usa', 'world',
##'                 'world2'. 
##' @param regions name of subregions to include. Defaults to '.' which includes all subregion.
##'                See documentation for 'map' for more details
##' @param fill color to fill
##' @param color border color
##' @param xlim xlim
##' @param ylim ylim
##' @param ... additional parameter
##' @importFrom ggplot2 map_data
##' @importFrom ggplot2 ggplot
##' @importFrom ggplot2 geom_polygon
##' @importFrom ggplot2 coord_quickmap
##' @importFrom ggplot2 aes_
##' @export
##' @return ggplot2 object 
##' @author Guangchuang Yu
draw_map <- function(database="world", regions=".", fill=NA, color="grey50", xlim=NULL, ylim=NULL, ...) {
    map.df <- map_data(database, regions=regions, xlim=xlim, ylim=ylim)
    ggplot(map.df, aes_(~long, ~lat, group=~group)) + geom_polygon(fill=fill, color=color, ...) + coord_quickmap()
}



