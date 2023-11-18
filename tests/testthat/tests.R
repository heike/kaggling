# Generated from make-the-kaggling-package.Rmd: do not edit by hand  
testthat::test_that("get_search_page works", {
  # good behavior
  res_full <- get_search_page("diamond", 2)
  testthat::expect_s3_class(res_full, "data.frame")
  testthat::expect_equal(dim(res_full), c(20, 7))
  testthat::expect_named(res_full, 
                         c('ref', 'title', 'size', 'lastUpdated', 'downloadCount', 
                           'voteCount', 'usabilityRating'))
  
  # check that all bad behavior is stopped
  res_fail <- get_search_page("diamond", 100)
  testthat::show_failure(testthat::expect_equal(dim(res_fail), c(20, 7)))
  testthat::expect_named(res_fail, "No.datasets.found")
  testthat::expect_error(get_search_page(c("diamond", "s"), 2)) # length(search_str) == 1 is not TRUE
  testthat::expect_error(get_search_page("diamonds", 2.5)) # as.integer(page) == page is not TRUE
  testthat::expect_message(get_search_page("diamond", 2, quiet=FALSE))
})

testthat::test_that("search_kaggle works", {
  # good behavior
  res_full <- search_kaggle("diamond")
  testthat::expect_s3_class(res_full, "data.frame")
  testthat::expect_equal(ncol(res_full), 7)
  testthat::expect_named(res_full, 
                         c('ref', 'title', 'size', 'lastUpdated', 'downloadCount', 
                           'voteCount', 'usabilityRating'))
  
  # check that all bad behavior is stopped
  res_fail <- search_kaggle("ewqhgljkdsio")
  testthat::show_failure(testthat::expect_equal(dim(res_fail), c(20, 7)))
  testthat::expect_named(res_fail, "No.datasets.found")
  testthat::expect_error(search_kaggle(c("diamond", "s"))) # length(search_str) == 1 is not TRUE
})

