####################################################################################################
## Project:         MaizeMap
## Script purpose:  Create functions to be sourced and used for this project
##
## Input:
## Output:
## Date: 2017-12-12
## Author: Jesse R. Walsh
####################################################################################################
getSplitGeneModels.v3_to_v4 <- function() {
  df <-
    maize.genes.v3_to_v4_map.clean %>%
    group_by(v4_id) %>%
    summarise(v3_id = paste(v3_id, collapse = ", "))

  df <- df[grepl(",", df$v3_id),]

  return(df)
}

getMergedGeneModels.v3_to_v4 <- function() {
  df <-
    maize.genes.v3_to_v4_map.clean %>%
    group_by(v3_id) %>%
    summarise(v4_id = paste(v4_id, collapse = ", "))

  df <- df[grepl(",", df$v4_id),]

  return(df)
}
