#' Helper function: get page X from the search results
#'
#' This function accesses one page of the returned search results, downloads the information,
#'  and returns a dataset of this page's results.
#' The user should not have to call this function directly in interactive use.
#' @param search_str character value, key word of the search
#' @param page integer value, page number
#' @return data.frame
#' @importFrom utils read.table read.csv
get_search_page <- function(search_str, page) {
  stopifnot(is.character(search_str), as.integer(page) == page,
            length(search_str) == 1, length(page) == 1)
  # what values can search_str be?
  # tbd: multiple words?
  tmp <- tempfile(fileext = ".csv")
  tmp_err <- tempfile()

  kaggle_args <- sprintf("datasets list -s '%s' -p%s --csv",
                         search_str, page)

  check_list <- system2("kaggle", args=kaggle_args, stdout=tmp, stderr=tmp_err)

  warning <- grep("Warning: Your Kaggle API", readLines(tmp), value=TRUE)
  if (check_list) {
    # stop with error message
    error <- grep("Error", readLines(tmp_err), value=TRUE)
    stop(error)
  }
  skip <- 0
  if(length(warning) >0) {
    skip <- 1
  }

#  results <- read.csv(sprintf("%s/%s-%s.csv", search_str, search_str, page))
  results <- read.table(tmp, header=TRUE, sep = ",", skip = skip, fill = TRUE,
                        quote = '\\"')
  results
}
