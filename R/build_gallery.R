#' Use knitr to build all the snippets in a gallery
#'
#' Snippets are stored as .Rmd files in one directory: save them into
#' a new directory.
#'
#' @param infolder input directory
#' @param outfolder directory
#' @param images_dir directory to store resulting images
#' @param ... extra arguments passed on to knitr's chunk options
#'
#' @export
build_gallery <- function(infolder = "_R", outfolder = "snippets",
                           images_dir = "images", ...) {
    dir.create(outfolder, showWarnings = FALSE)

    infiles <- list.files(infolder, pattern = "*.Rmd", full.names = TRUE)
    for (infile in infiles) {
        outfile <- file.path(outfolder, sub(".Rmd$", ".md", basename(infile)))

        # knit only if the input file is the last one modified
        if (!file.exists(outfile) |
            file.info(infile)$mtime > file.info(outfile)$mtime) {
            build_snippet(infile, outfile, images_dir)
        }
    }
}
