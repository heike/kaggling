.onAttach <- function(libname, pkgname){

  check_kaggle <- system2("which", args = "kaggle", input = "", stdout=T)

  if (check_kaggle == "") {
    packageStartupMessage(
      "kaggle.py installed? ... Error: no installation of kaggle found.
      This package uses the kaggle API.
      Follow the installation instructions at
      https://github.com/Kaggle/kaggle-api#api-credentials.")
    return()
  } else {
    packageStartupMessage("kaggle.py installed? ... yes")
  }

#  browser()
  suppressWarnings({
    check_api <- system2("kaggle", args= "config view", stdout=TRUE,
                       stderr=TRUE)})

  #follow the installation instructions at https://github.com/Kaggle/kaggle-api#api-credentials."
  error <- grep("OSError", check_api, value = TRUE) # "OSError: Could not find kaggle.json. Make sure it's located in ~/.kaggle. Or use the environment method."
  warning <- grep("Warning", check_api, value = TRUE)

  if (length(error)!=0) {
  # there is an error
    error <- gsub("Or use the environment method.", "Follow instructions at https://github.com/Kaggle/kaggle-api#api-credentials", error)
    packageStartupMessage(paste0("Kaggle API use authorized? ... ", error))

    return()
  }
  if (length(warning) != 0) {
    packageStartupMessage(paste0("Kaggle API use authorized? ... ", warning))

    return()
  }

  check_api <- try(system("kaggle config view", intern=TRUE,
                      ignore.stderr = TRUE, ignore.stdout = TRUE), silent=TRUE)
  packageStartupMessage("Kaggle API use authorized? ... yes")
}

