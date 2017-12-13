####################################################################################################
## Project:         MaizeMap
## Script purpose:  Create and combine objects to use for analysis and plots.
##
## Input:
## Output:
## Date: 2017-12-12
## Author: Jesse R. Walsh
####################################################################################################
source("./data-raw/R/loadData.R")
source("./data-raw/R/cleanData.R")
library(tidyr)
library(dplyr)

## Save data objects
devtools::use_data(maize.genes.v3_to_v4.map)
devtools::use_data(corncyc.gene.map)
devtools::use_data(corncyc.reaction.gene.map)
devtools::use_data(corncyc.pathway.reaction.map)

devtools::document(roclets=c('rd', 'collate', 'namespace'))

#--------------------------------------------------------------------------------------------------#
detach("package:tidyr", unload=TRUE)
detach("package:dplyr", unload=TRUE)
