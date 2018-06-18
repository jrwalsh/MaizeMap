####################################################################################################
## Project:         MaizeMap
## Script purpose:  Create and combine data/objects to use.  Output data for packaging.
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
devtools::use_data(maize.genes.v3_to_v4.map, overwrite = TRUE)
devtools::use_data(maize.genes.classical_to_v3.map, overwrite = TRUE)
devtools::use_data(maize.genes.uniprot_to_v3.map, overwrite = TRUE)
devtools::use_data(maize.genes.uniprot_to_v4.map, overwrite = TRUE)
devtools::use_data(corncyc.gene.map, overwrite = TRUE)
devtools::use_data(corncyc.reaction.gene.map, overwrite = TRUE)
devtools::use_data(corncyc.pathway.reaction.map, overwrite = TRUE)
devtools::use_data(maize.v4.37.chromosomal.gene.positions, overwrite = TRUE)
devtools::use_data(gene.transcript.map, overwrite = TRUE)

devtools::document(roclets=c('rd', 'collate', 'namespace'))

#--------------------------------------------------------------------------------------------------#
detach("package:tidyr", unload=TRUE)
detach("package:dplyr", unload=TRUE)
