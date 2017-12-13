####################################################################################################
## Project:         MaizeMap
## Script purpose:  Create and combine objects to use for analysis and plots.
##
## Input:
## Output:
## Date: 2017-12-12
## Author: Jesse R. Walsh
####################################################################################################
library(tidyr)
library(dplyr)

## Save data objects
devtools::use_data(maize.genes.v3_to_v4.map)
devtools::use_data(corncyc.gene.map)
devtools::use_data(corncyc.reaction.gene.map)
devtools::use_data(corncyc.pathway.reaction.map)

#--------------------------------------------------------------------------------------------------#
detach("package:tidyr", unload=TRUE)
detach("package:dplyr", unload=TRUE)
