##' get map data of China or province(s) of China
##'
##'
##' @title get_map_data
##' @param province selected province(s) or 'all'
##' @return map data of China, in data.frame
##' @importFrom ggplot2 fortify
##' @importFrom utils data
##' @export
##' @author ygc
get_map_china <- function(province='all') {
    tryCatch(data("china", package='mapr'))
    china <- get("china", envir=.GlobalEnv)

    ## n <- sapply(china@polygons, function(x) nrow(x@Polygons[[1]]@coords))
    ## lcoords <- lapply(china@polygons, function(x) x@Polygons[[1]]@coords)
    ## coords <- do.call('rbind', lcoords)
    ## coords <- as.data.frame(coords)
    ## colnames(coords) <- c("long", "lat")

    cn <- fortify(china)
    locations <- iconv(china$NAME, from='GBK')
    ## coords$province <- rep(locations, times=n)
    cn$province=locations[as.numeric(cn$id)+1]

    if (province == 'all') {
        res <- cn
    } else {
        idx <- grep(province, locations)
        if (length(idx) == 0) {
            stop("province not matched...")
        }
        res <- cn[cn$province %in% province,]
    }
    return(res)
}

##' extract map data of selected country from 'world' map
##'
##'
##' @title get_map_by_country
##' @param country selected country or countries
##' @return map data in data.frame
##' @export
##' @author ygc
get_map_by_country <- function(country) {
    region = NULL
    wdf <- map_data('world')
    subset(wdf, region %in% country)
}

##' extract map data of selected region(s) from 'world' map
##'
##'
##' @title get_map_by_region
##' @param region selected region(s)
##' @return map data in data.frame
##' @importFrom ggplot2 map_data
##' @export
##' @author ygc
get_map_by_region <- function(region) {
    wdf <- map_data('world')
    wdf[wdf$subregion %in% region,]
}
