# Generated from make-the-kaggling-package.Rmd: do not edit by hand

#' Helper function: get page X from the search results
#' 
#' This function accesses one page of the returned search results, downloads the information,
#'  and returns a dataset of this page's results. 
#' The user should not have to call this function directly in interactive use. 
#' @param search_str character value, key word of the search
#' @param page integer value, page number 
#' @param quiet boolean, does the function keep (debugging) messages to itself, defaults to TRUE
#' @return data.frame
#' @importFrom utils read.csv
get_search_page <- function(search_str, page, quiet=TRUE) {
  stopifnot(is.character(search_str), as.integer(page) == page, 
            length(search_str) == 1, length(page) == 1)
  # what values can search_str be?
  # tbd: multiple words?
  tmp <- tempfile(fileext = "csv")
  
#  kaggle_cmd <- sprintf("kaggle datasets list -s '%s' -p%s --csv > %s/%s-%s.csv", 
#                        search_str, page, search_str, search_str, page)
  kaggle_cmd <- sprintf("kaggle datasets list -s '%s' -p%s --csv > %s", 
                        search_str, page, tmp)
  if (!quiet) {
    message(sprintf("Trying to write to file %s ...", tmp))
  }
  system(kaggle_cmd)
  if (!quiet) {
    message("done\n")
  }
  
  
#  results <- read.csv(sprintf("%s/%s-%s.csv", search_str, search_str, page))
  results <- read.csv(tmp)
  results
}
