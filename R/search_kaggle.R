# Generated from make-the-kaggling-package.Rmd: do not edit by hand

#' Keyword search kaggle datasets
#' 
#' This function searches the kaggle platform for all datasets fitting the keyword search <search_str> 
#' and returns available meta information.
#' @param search_str character value, key word of the search
#' @export
#' @return data.frame
search_kaggle <- function(search_str) {
  i <- 1
  res <- get_search_page(search_str, 1)
  results <- res
  
  # kaggle page size is 20 by default
  while(nrow(res) == 20) {
    i <- i+1
    res <- get_search_page(search_str, i)
    if (nrow(res) != 0) {
      results <- rbind(results, res)
    } 
  }  
  results
}
