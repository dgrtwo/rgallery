#' Create a gallery in a new directory
#'
#' This clones and sets up a new gallery directory. By default it installs
#' the one found at http://github.com/dgrtwo/rgallery-default.
#'
#' @param directory directory in which to create the gallery
#' @param repository repository to clone the initial gallery from. Either
#' a username/repo from github, or a full URL starting with \code{http://}
#' @param set_wd whether to set the working directory to the gallery afterwards
#'
#' @export
create_gallery <- function(directory, repository = "dgrtwo/rgallery-default",
                           set_wd = FALSE) {
    if (!grepl("^http://", repository)) {
        repository <- paste("http://github.com", repository, sep = "/")
    }
    git2r::clone(repository, directory)

    if (set_wd) {
        message("Setting working directory to ", directory)
        setwd(directory)
    }
}
