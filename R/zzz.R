.onLoad <- function(libname, pkgname){

  message("where is kaggle installed?")
  check_kaggle <- system("which kaggle")
  if (check_kaggle != 0) {
    message("\nNo installation of kaggle found. This package uses the kaggle API. Follow the installation instructions at https://github.com/Kaggle/kaggle-api#api-credentials.")
    return()
  }

  message("Is API use authorized? Address any warnings.")
  check_api <- system("kaggle config view")
  if (check_api != 0) {
    return()
  }
}
