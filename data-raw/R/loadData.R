####################################################################################################
## Project:         MaizeMap
## Script purpose:  Import raw dataset files relevant to this project
##
## Output:
##        maize.genes.v3_to_v4_map.raw
##        corncyc.gene.frameid.raw
##        corncyc.reaction.frameid.raw
##        corncyc.pathway.frameid.raw
##
## Date: 2017-12-12
## Author: Jesse R. Walsh
####################################################################################################
library(readr)
library(readxl)

## Mapping data provided by Maggie, based on synteny from SynMap
maize.genes.v3_to_v4_map.raw <- read_xlsx("./data-raw/B73_GeneModels/MaizeGDB_v3_v4.genes.xlsx")

## CornCyc gene frameID to v4 map
corncyc.gene.frameid.raw <- read_delim("data-raw/Pathways/CornCyc_8.0.1/CornCyc_8.0.1_GeneIDs.tab", "\t", escape_double = FALSE, trim_ws = TRUE)

## CornCyc reaction frameID to gene frameID map
corncyc.reaction.frameid.raw <- read_delim("data-raw/Pathways/CornCyc_8.0.1/CornCyc_8.0.1_Reactions.tab", "\t", escape_double = FALSE, trim_ws = TRUE)

## CornCyc pathway frameID to reaction frameID map
corncyc.pathway.frameid.raw <- read_delim("data-raw/Pathways/CornCyc_8.0.1/CornCyc_8.0.1_Pathways.tab", "\t", escape_double = FALSE, trim_ws = TRUE)

## Load maize GFF data
# txdb <- makeTxDbFromGFF("./Data/MaizeGFF3/Zea_mays.AGPv4.32.gff3.gz", format="gff3")

#--------------------------------------------------------------------------------------------------#
detach("package:readr", unload=TRUE)
detach("package:readxl", unload=TRUE)
