#' Download a kaggle dataset
#'
#' @param datasets either a dataset returned from the function `search_kaggle`
#' or a (vector) of (character) references of the form <kaggle user>/<data set>.
#' @param check_size boolean, check that the size is not in GB
#' @return tibble of the input expanded by a list variable `data`
#' @importFrom utils unzip
#' @export
get_data <- function(datasets, check_size=TRUE) {
  # helper function
  get_data_i <- function(ref_i) {
    tmp <- tempdir()

    # does this data exist?
    kaggle_cmd <- sprintf("kaggle datasets download -p %s/ %s", tmp, ref_i)
    system(kaggle_cmd) # this only works if ref_i is valid
    list_files <- unzip(zipfile = file.path(tmp, paste0(basename(ref_i), ".zip")), list=TRUE)

    # let's do a couple of checks before we unzip
    csv_name <- grep("csv$", list_files$Name, value = TRUE)
    # - it's a csv file
    if (length(csv_name)==0)
      return (data.frame(`No Data Reason`="Not a csv file"))
    # - we have exactly one file?
    if (length(csv_name) > 1)
      return (data.frame(Reason="Multiple files to choose from: <%s>", paste(csv_name, collapse=", ")))

    # - size is not too big?
    if (list_files$Length/(1024^2) > 10) { # size in mega byte
      cat("File is more than 10 MB. Proceed? (y/n) ")
      char <- scan(1)
      while (!(char %in% c("y", "n"))) char <- scan(1)
      if (char == "n") return (data.frame(`No Data Reason`="Data too big"))
    }

    unzip(zipfile = file.path(tmp, paste0(basename(ref_i), ".zip")), files = csv_name)
    results <- read.csv(csv_name)
    results
  }

  ref <- NULL
  size <- NULL

  if (is.factor(datasets)) datasets <- as.character(datasets)
  if (is.character(datasets)) datasets <- data.frame(ref=datasets)
  if (is.data.frame(datasets)) {
    stopifnot("ref" %in% names(datasets))
    if (check_size) stopifnot("size" %in% names(datasets))
    if (!("size" %in% names(datasets))) datasets$size <- "dummy value"
  }


  datasets %>% mutate(
    data = purrr::map2(.x = ref, .y=size, .f = function(r, s) {
      if (length(grep("GB", s) > 0))  return(data.frame(`No Data Reason`="Data too big"))

      get_data_i(r)})
  ) %>% as_tibble()
}
