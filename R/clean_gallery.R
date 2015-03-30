#' clean out snippet output from a gallery
#'
#' Clean out the .md files, along with image and cache directories,
#' from an R-gallery. This doesn't remove the files in the _R directory
#' itself.
#'
#' @param gallery directory of the gallery to be cleaned
#' @param infolder input directory
#' @param outfolder directory
#' @param images_dir directory to store images
#' @param caches_dir directory to store caches
#'
#' This will not remove a .md file, image directory, or cache directory that
#' does not have a corresponding .Rmd file in the input (it will show a
#' message).
#'
#' @export
clean_gallery <- function(gallery, infolder = "_R", outfolder = "snippets",
                          images_dir = "images", caches_dir = "_caches") {
    infolder <- file.path(gallery, infolder)
    outfolder <- file.path(gallery, outfolder)
    images_dir <- file.path(gallery, images_dir)
    caches_dir <- file.path(gallery, caches_dir)

    to_clean <- list(outfolder, images_dir, caches_dir)
    types <- c("Output file", "Image directory", "Cache directory")
    for (i in 1:length(to_clean)) {
        for (output in list.files(to_clean[[i]],
                                  full.names = TRUE, include.dirs = TRUE)) {
            print(output)
            # check whether it exists in input folder, as either .Rmd or a
            # category
            catfolder <- file.path(infolder, paste0(file_name(output)))
            infile <- paste0(catfolder, ".Rmd")
            if (file.exists(catfolder) || file.exists(infile)) {
                # can remove the output
                unlink(output, recursive = TRUE)
            } else {
                message(types[i], " ", basename(output),
                        " does not have corresponding input file in ", infolder,
                        ", not deleting")
            }
        }
    }
}
