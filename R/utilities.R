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

