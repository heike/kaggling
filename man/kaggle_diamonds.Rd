% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kaggle_diamonds.R
\docType{data}
\name{kaggle_diamonds}
\alias{kaggle_diamonds}
\title{Kaggle search results for diamonds}
\format{
A data frame with 163 rows and 28 variables.
}
\usage{
kaggle_diamonds
}
\description{
Using the kaggle API, this dataset was created on Nov 18 2023 as the result
of searching for the keyword 'diamond'. The list of search results was expanded
by the meta information for each of the datasets.
}
\details{
The first eight variables are (slight) modifications of a dataset search through the
the kaggle API. Those variables are:
\describe{
\item{ref}{character vector of the form \if{html}{\out{<kaggle user name>}}/\if{html}{\out{<name of dataset>}}.}
\item{title}{character vector containing a title of the dataset.}
\item{size_value}{integer vector of the size of the dataset. }
\item{size_unit}{one-to-two-character vector of the unit in which the dataset is recorded. Each element is one of "B", "KB", "MB", "GB".}
\item{lastUpdated}{date and time of the last update.}
\item{downloadCount}{vector of integers of the number of downloads.}
\item{voteCount}{vector of integers of the number of votes. }
\item{usabilityRating}{vector of numeric values on a scale of 0 to 1 (extremely useable). }
}
The remaining 20 variables are part of the meta information uploaded with the datasets.
Kaggle meta data is described at https://github.com/Kaggle/kaggle-api/wiki/Dataset-Metadata.
It follows the Data Package specification suggested by \href{https://specs.frictionlessdata.io//data-package/}{Paul Walsh and Rufus Pollock}.
We removed any columns with duplicated data.
}
\examples{
# example code
library(ggplot2)
library(dplyr)
library(lubridate)

# number of data sets related to 'diamond' by year
kaggle_diamonds \%>\%
  group_by(year=year(lastUpdated)) \%>\%
  summarize(n = n()) \%>\%
  ggplot(aes(x = year, weight= n)) + geom_bar()
}
\keyword{datasets}
