library(tidyverse)
kaggle_diamonds <- search_kaggle("diamond")

kaggle_diamonds <- get_meta(kaggle_diamonds)

kaggle_diamonds <- kaggle_diamonds %>% tidyr::unnest(col="meta", names_sep="_")

kaggle_diamonds <- kaggle_diamonds %>%
  tidyr::separate_wider_regex(cols=size, patterns=c(size_value="[0-9]*", size_unit="[KMG]?B")) %>%
  mutate(
    size_value = as.integer(size_value),
    lastUpdated = lubridate::ymd_hms(lastUpdated)
  )

# remove columns with (almost all) the same values
hases <- grep("_has", names(kaggle_diamonds), value = TRUE)
hases %>% sapply(function(var_name) var(kaggle_diamonds[,var_name]))

kaggle_diamonds <- kaggle_diamonds %>% select(-all_of(hases))

hases <- grep("has", names(kaggle_diamonds), value = TRUE)
hases %>% sapply(function(var_name) var(kaggle_diamonds[,var_name]))

kaggle_diamonds <- kaggle_diamonds %>% select(-all_of(hases))


# there are a couple of (near) duplicates in the columns
nullables <- grep("Nullable", names(kaggle_diamonds), value = TRUE)
not_null <- gsub("Nullable", "", nullables)

for (i in 1:length(nullables)) {
 res <- all(kaggle_diamonds[,not_null[i]]==kaggle_diamonds[,nullables[i]])
 print(sprintf("%s: %s", not_null[i], res))
}
kaggle_diamonds$meta_ownerUser[which(is.na(kaggle_diamonds$meta_ownerUserNullable))]

# empty strings in meta_ownerUser are NAs in meta_ownerUserNullable
kaggle_diamonds <- kaggle_diamonds %>% select(-all_of(nullables))

# ref and meta_id are the same except for 5 (ill-formed) meta_id
all(kaggle_diamonds$ref == kaggle_diamonds$meta_id)

idx <- which(kaggle_diamonds$ref != kaggle_diamonds$meta_id)
kaggle_diamonds$meta_id[idx]
# remove meta_id
kaggle_diamonds <- kaggle_diamonds %>% select(-meta_id)


all(kaggle_diamonds$meta_id_no == kaggle_diamonds$meta_datasetId)
kaggle_diamonds <- kaggle_diamonds %>% select(-meta_datasetId)


all(kaggle_diamonds$title == kaggle_diamonds$meta_title)
kaggle_diamonds <- kaggle_diamonds %>% select(-meta_title)

all(near(kaggle_diamonds$usabilityRating, kaggle_diamonds$meta_usabilityRating, tol=5*.Machine$double.eps^0.5))

idx <- which(!near(kaggle_diamonds$usabilityRating, kaggle_diamonds$meta_usabilityRating, tol=5*.Machine$double.eps^0.5))
kaggle_diamonds$usabilityRating[head(idx)]
kaggle_diamonds$meta_usabilityRating[head(idx)]
# one dataset has a different rating

all(kaggle_diamonds$meta_totalVotes == kaggle_diamonds$voteCount)
kaggle_diamonds <- kaggle_diamonds %>% select(-meta_totalVotes)

use_data(kaggle_diamonds, overwrite=TRUE)

