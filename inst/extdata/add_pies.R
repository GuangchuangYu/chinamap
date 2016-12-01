##' pie plot by ggplot2
##'
##'
##' @title pie2
##' @param data data.frame
##' @param y y variable
##' @param fill color to fill
##' @param color border color
##' @param alpha transparency
##' @return ggplot2 object
##' @importFrom ggplot2 aes_
##' @importFrom ggplot2 geom_bar
##' @importFrom ggplot2 coord_polar
##' @importFrom ggplot2 scale_fill_manual
##' @importFrom ggplot2 xlab
##' @importFrom ggplot2 ylab
##' @importFrom ggplot2 scale_fill_manual
##' @importFrom ggtree theme_tree
##' @importFrom ggtree theme_transparent
##' @export
##' @author Guangchuang Yu
pie2 <- function(data, y, fill, color, alpha=1) {
    ggplot(data, aes_(x=1, y=y, fill=fill)) +
        geom_bar(stat='identity', alpha=alpha) +
        coord_polar(theta='y') +
        scale_fill_manual(values=color) +
        xlab(NULL) + ylab(NULL) +
        theme_tree() + theme_transparent()
}

##' add a list of pies to map
##'
##'
##' @title add_pies
##' @param map ggplot map
##' @param locations location data.frame
##' @param pies a list of pies
##' @param sizes size of pie to be added
##' @return ggplot2 object
##' @importFrom ggtree subview
##' @export
##' @author Guangchuang Yu
add_pies <- function(map, locations, pies, sizes) {
    rn <- rownames(locations)
    for (i in 1:nrow(locations)) {
        nn <- rn[i]
        pos <- locations[nn,] %>% unlist
        map %<>% subview(pies[[i]], x=pos[1], y=pos[2],
                       width  = sizes[nn],
                       height = sizes[nn])
    }
    return(map)
}

##' add pies to a map by user provided data
##'
##'
##' @title add_pies2
##' @param map map
##' @param data data contains column of place, longitude, latitude and other columns for drawing pie
##' @param cols columns of stats for drawing pie
##' @param color color of pie
##' @param alpha transpancy of pie
##' @param scale_fun function to scale pie size
##' @return ggplot2 object
##' @importFrom tidyr gather
##' @importFrom dplyr summarize
##' @export
##' @author Guangchuang Yu
add_pies2 <- function(map, data, cols, color, alpha=1,
                      scale_fun = function(x) x/sum(x)) {
    ## > print(data)
    ##        Place Longitude Latitude A B C
    ## 1  Argentina   58.3833  34.6000 4 6 3
    ## 2  Australia  149.1245  35.3080 1 1 9
    ## 3    Austria   16.3500  48.2000 4 5 5
    ## 4 Bangladesh   90.3500  23.7000 1 1 1
    ## 5    Belgium    4.3500  50.8500 1 1 1
    ## 6    Bolivia   64.6660  16.7120 7 7 1
    ## 7     Brazil   47.8667  15.7833 9 0 0
    ## 8   Cambodia  104.9167  11.5500 2 1 0

    type <- value <- NULL
    ldf <- gather(data, type, value, cols) %>% split(., data[,1])
    pies <- lapply(ldf, function(df) pie2(df, y=~value, fill=~type, color=color, alpha=alpha))

    sizes <- lapply(seq_along(ldf), function(i) {
        ss <- summarize(ldf[[i]], size=sum(value))
        names(ss) <- names(ldf)[i]
        ss
    }) %>% unlist %>% scale_fun
    names(sizes) <- names(ldf)

    locations <- data[, c(2,3)]
    rownames(locations) <- data[,1]

    add_pies(map, locations, pies, sizes)
}


## library(ggforce)
## df <- gather(data, type, value, cols)
## p+geom_arc_bar(aes(x0=Longitude, y0=Latitude, r0=0, r=5, amount = value, fill=type, group=Place),
##                data=df, stat='pie', inherit.aes=F, color=NA) + coord_quickmap()
