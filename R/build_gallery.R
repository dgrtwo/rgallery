#' Use knitr to build all the snippets in a gallery
#'
#' Snippets are stored as .Rmd files in one directory, and are compiled into
#' a new directory. The convention in this package is to store inputs in _R and
#' outputs in "snippets".
#'
#' @param gallery directory in which to build snippets
#' @param infolder input directory
#' @param outfolder directory
#' @param images_dir directory to store images
#' @param caches_dir directory to store caches
#' @param cache whether to cache knitr chunks
#' @param ... extra arguments for knitr's chunk options
#'
#' @details Figures end up stored in multiple images directories, one for each
#' snippet, in the given images directory. Caches are stored, one directory for
#' each snippet, in the given caches directory.
#'
#' @export
build_gallery <- function(gallery = ".", infolder = "_R", outfolder = "snippets",
                          images_dir = "images", caches_dir = "_caches",
                          cache = FALSE, ...) {
    # perform all operations in the gallery directory
    with_wd(gallery, {
        dir.create(outfolder, showWarnings = FALSE)

        # check if we need a custom URL or knitr options.
        # Jekyll _config.yml may contain one
        url <- NULL
        knitr_args <- list(...)
        knitr_args$cache = cache
        if (file.exists("_config.yml")) {
            y <- yaml::yaml.load_file("_config.yml")
            url <- y$url
            # check for knitr options
            knitr_opts <- y[["knitr-options"]]
            if (!is.null(knitr_opts)) {
                knitr_args <- modifyList(knitr_args, knitr_opts)
            }
        }
        url <- paste0(url %||% "", "/")

        infiles <- list.files(infolder, pattern = "*.Rmd", recursive = TRUE)
        category <- NULL
        for (f in infiles) {
            nested <- stringr::str_count(f, "/")
            if (nested > 1) {
                stop(f, "is nested too deeply in", infolder)
            } else if (nested == 1) {
                # make sure output directory exists
                category <- dirname(f)
                dir.create(file.path(outfolder, category), showWarnings = FALSE)
            }

            sans_ext <- tools::file_path_sans_ext(f)
            infile <- file.path(infolder, f)
            outfile <- file.path(outfolder, paste0(sans_ext, ".md"))

            # knit only if the input file is the last one modified
            if (!file.exists(outfile) |
                file.info(infile)$mtime > file.info(outfile)$mtime) {
                fig.path <- file.path(images_dir, sans_ext, "")
                cache.path <- file.path(caches_dir, sans_ext, "")

                # call build_snippet, along with extra knitr arguments
                do.call(build_snippet,
                        c(list(infile, outfile, base_url = url,
                               category = category,
                               fig.path = fig.path,
                               cache.path = cache.path,
                               ...), knitr_args))
            }
        }
    })
    invisible()
}
