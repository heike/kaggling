#' Download meta information for a kaggle dataset
#'
#' @param datasets either a dataset returned from the function `search_kaggle`
#' or a (vector) of (character) references of the form <kaggle user>/<data set>.
#' @importFrom utils unzip
#' @return tibble of the input expanded by a list column `meta`
#' @export
get_meta <- function(datasets) {
  # helper function
  get_meta_i <- function(ref_i) {
    tmp <- tempdir()

    # kaggle_cmd <- sprintf("kaggle datasets metadata -p %s-meta/%s %s", search_string, ref_i, ref_i)
    kaggle_cmd <- sprintf("kaggle datasets metadata -p %s %s", tmp, ref_i)

    system(kaggle_cmd) # this only works if ref_i is valid
    dir(tmp, pattern="dataset-metadata.json", recursive = TRUE, full.names = TRUE)
    l <- jsonlite::read_json(file.path(tmp, "dataset-metadata.json"))
    flat_l <- purrr::list_flatten(l)
    # replace NULLs by NAs
    nulls <- sapply(flat_l, is.null)
    if (any(nulls)) {
      flat_l[nulls] <- NA
    }

    flat_l  %>% data.frame()
  }
  ref <- NULL

  if (is.factor(datasets)) datasets <- as.character(datasets)
  if (is.character(datasets)) datasets <- data.frame(ref=datasets)
  if (is.data.frame(datasets)) {
    stopifnot("ref" %in% names(datasets))
  }

  datasets %>% mutate(
    meta = ref %>% purrr::map(.f = function(r) get_meta_i(r))
  ) %>% as_tibble()
}
