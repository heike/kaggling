#' Convert size character vector to a size in byte
#'
#' Size should really be an S3 object but here's my compromise:
#' convert the humanly-readable character string to something we can
#' work with analytically.
#' @param col vector of characters with size information
#' @return numeric vector of the same length as col with the size information in kilobyte.
#' @importFrom readr parse_number
#' @export
size_KB <- function(col) {
  col <- as.character(col)
  unit <- gsub("[0-9]*([KMG]?B)", "\\1", col)

  size_value <- parse_number(col)
  size <- ifelse(unit=="B", size_value/1024,
                 ifelse(unit=="MB", size_value*1024,
                        ifelse(unit=="GB", size_value*1024*1024, size_value)))
  if (any(unit==col)) warning(sprintf("No unit information for records %s",
                                        paste(which(unit==col), collapse=", ", sep=", ")))

  size
}
