#' Download meta information for a kaggle dataset
#'
#' @param datasets either a dataset returned from the function `search_kaggle`
#' or a (vector) of (character) references of the form <kaggle user>/<data set>.
#' @param expand_meta boolean, should the set of meta information be returned as a
#' list variable (default, `expand_meta` set to FALSE) or expanded into the data frame?
#' @importFrom utils unzip
#' @importFrom tidyr unnest
#' @return tibble of the input expanded by a list column `meta` (if `expand_meta` is set to FALSE).
#' If `expand_meta` is set to TRUE, a set of about 40 variables from Kaggle's `dataset-metadata.json` file
#' is added to the input.
#' The names of all meta variables start with "meta_" an in-depth discussion of these variables
#' can be found in Kaggle's [Dataset Metadata](https://github.com/Kaggle/kaggle-api/wiki/Dataset-Metadata) description.
#' @export
get_meta <- function(datasets, expand_meta=FALSE) {
  # helper function
  get_meta_i <- function(ref_i) {
    tmp <- tempdir()
    tmp_err <- tempfile()

    # kaggle_cmd <- sprintf("kaggle datasets metadata -p %s-meta/%s %s", search_string, ref_i, ref_i)
    kaggle_args <- sprintf("datasets metadata -p %s %s", tmp, ref_i)

    # this only works if ref_i is valid
    check_meta <- system2("kaggle", args=kaggle_args, stderr=tmp_err, stdout=TRUE)

    warning <- grep("Warning: Your Kaggle API", check_meta, value=TRUE) # surpress
    error <- grep("Error", readLines(tmp_err), value=TRUE)
    if (length(error) != 0) {
      # stop with error message
      stop(error)
    }

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
  meta <- NULL

  if (is.factor(datasets)) datasets <- as.character(datasets)
  if (is.character(datasets)) datasets <- data.frame(ref=datasets)
  if (is.data.frame(datasets)) {
    stopifnot("ref" %in% names(datasets))
  }

  datasets <- datasets %>% mutate(
    meta = ref %>% purrr::map(progress=TRUE,
      .f = function(r) get_meta_i(r))
  ) %>% as_tibble()
  if (expand_meta) datasets <- datasets %>% unnest(cols=meta, names_sep = "_")
  datasets
}
