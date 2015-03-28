#' Knit a single .Rmd snippet
#'
#' Knit a .Rmd snippet into a .md file. A snippet is like a "mini-vignette"
#'
#' @param input a .Rmd file to compile
#' @param output the .md file to write
#' @param images_dir directory to save images to
#' @param base_url base_url of site
#' @param ... extra arguments passed on to knitr's chunk options
#'
#' @details This makes sure in the process
#' that the images go into an accessible directory, and add an "image:" tag to
#' the front-matter displaying one of the snippet's images (to use as a
#' teaser on the main gallery page)
#'
#' This function was originally inspired by:
#' http://jfisher-usgs.github.com/r/2012/07/03/knitr-jekyll/
#'
#' @import knitr
#'
#' @export
build_snippet <- function(input, output, images_dir = "images", base_url = "/",
                            ...) {
    opts_knit$set(base.url = base_url)
    bname <- sub(".Rmd$", "", basename(input))
    fig.path <- file.path(images_dir, bname, "")
    opts_chunk$set(fig.path = fig.path, fig.cap = "center", ...)
    render_jekyll()
    knit(input, output, envir = new.env())

    # add the image field to the yaml header. First find it
    # right now it's just first alphabetical image. Will find a smarter way
    # in the future.
    images <- list.files(fig.path)
    if (length(images) == 0) {
        # no image. Later should set up default
        warning(paste("No image to use for teaser found in", bname))
    }
    image_path <- paste(bname, images[1], sep = "/")
    extra_line <- paste("image:", image_path)

    yaml_spl <- partition_yaml_front_matter(readLines(output))
    yaml_header <- c(head(yaml_spl$front_matter, -1), extra_line, "---")
    writeLines(c(yaml_header, yaml_spl$body), output)
}
