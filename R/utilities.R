`%||%` <- function(a, b) if (!is.null(a)) a else b


#' temporarily evaluate an expression in a directory
#'
#' Temporarily evaluate an expression in a directory, then set the directory
#' back to the original.
#'
#' @param dir a directory to perform an expression within
#' @param expr expression to evaluate
#'
#' @details See here: http://plantarum.ca/code/setwd-part2/
with_wd <- function(dir, expr) {
    wd <- getwd()
    on.exit(setwd(wd))
    setwd(dir)
    eval(expr, envir = parent.frame())
}


#' Modify yaml front matter of a file
#'
#' Modify the yaml front matter of a file. Can be used to change a file
#' in place. If no front matter yet exists, this creates one.
#'
#' @param infile file to be modified
#' @param outfile file to write
#' @param ... fields to change in front matter
modify_yaml_front_matter <- function(infile, outfile = infile, ...) {
    yaml_spl <- partition_yaml_front_matter(readLines(infile))

    front_matter <- yaml_spl$front_matter

    # modify the header
    if (is.null(front_matter)) {
        yaml_header <- list(...)
    } else {
        yaml_header <- front_matter[!grepl("^---", front_matter)]
        yaml_header <- yaml::yaml.load(paste(yaml_header, collapse = "\n"))
        yaml_header <- modifyList(yaml_header, list(...))
    }
    out_header <- stringr::str_trim(yaml::as.yaml(yaml_header))

    writeLines(c("---", out_header, "---", yaml_spl$body), outfile)
}


#' Partition yaml front matter
#'
#' This function comes directly from the rmarkdown package
#'
#' @param input_lines input lines
partition_yaml_front_matter <- function(input_lines) {

    validate_front_matter <- function(delimeters) {
        if (length(delimiters) >= 2 && (delimiters[2] - delimiters[1] > 1)) {
            # verify that it's truly front matter (not preceded by other content)
            if (delimeters[1] == 1)
                TRUE
            else
                is_blank(input_lines[1:delimeters[1]-1])
        } else {
            FALSE
        }
    }

    # is there yaml front matter?
    delimiters <- grep("^---\\s*$", input_lines)
    if (validate_front_matter(delimiters)) {

        front_matter <- input_lines[(delimiters[1]):(delimiters[2])]

        input_body <- c()

        if (delimiters[1] > 1)
            input_body <- c(input_body,
                            input_lines[1:delimiters[1]-1])

        if (delimiters[2] < length(input_lines))
            input_body <- c(input_body,
                            input_lines[-(1:delimiters[2])])

        list(front_matter = front_matter,
             body = input_body)
    }
    else {
        list(front_matter = NULL,
             body = input_lines)
    }
}


file_name <- function(x) {
    if (length(x) == 0) return(NULL)
    tools::file_path_sans_ext(basename(x))
}


is_blank <- function (x)
{
    if (length(x))
        all(grepl("^\\s*$", x))
    else TRUE
}

