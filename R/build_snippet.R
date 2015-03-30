#' Knit a single .Rmd snippet
#'
#' Knit a .Rmd snippet into a .md file. A snippet is like a "mini-vignette"
#'
#' @param input a .Rmd file to compile
#' @param output the .md file to write
#' @param base_url base_url of site
#' @param category snippet's category
#' @param fig.path directory where figures will be stored
#' @param ... extra arguments for knitr's chunk options, such as cache = TRUE
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
build_snippet <- function(input, output, base_url = "/", category = NULL,
                          fig.path, ...) {
    opts_knit$set(base.url = base_url)
    opts_chunk$set(fig.path = fig.path, fig.cap = "center", ...)
    render_jekyll()
    knit(input, output, envir = new.env(), quiet = TRUE)

    # add the image field to the yaml header. First find it
    # right now it's just first alphabetical image. Will find a smarter way
    # in the future.
    images <- list.files(fig.path)
    if (length(images) == 0) {
        # no image. Later should set up default
        warning(paste("No image to use for teaser found in", fig.path))
    }
    image_path <- file.path(fig.path, images[1])
    print(image_path)

    # add image link and category
    modify_yaml_front_matter(output, image = image_path, category = category)
}
