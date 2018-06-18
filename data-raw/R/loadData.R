####################################################################################################
## Project:         MaizeMap
## Script purpose:  Import raw dataset files relevant to this project
##
## Output:
##        maize.genes.v3_to_v4_map.raw
##        maize.genes.classical_to_v3_map.raw
##        maize.genes.uniprot_to_v4_map.raw
##        corncyc.gene.frameid.raw
##        corncyc.reaction.frameid.raw
##        corncyc.pathway.frameid.raw
##        maize.v4.37.chromosomal.gene.positions.raw
##        txdb
##
## Date: 2017-12-12
## Author: Jesse R. Walsh
####################################################################################################
library(readr)
library(readxl)
library(GenomicFeatures)

## Mapping data provided by Maggie, based on synteny from SynMap.
maize.genes.v3_to_v4_map.raw <- read_delim("data-raw/B73_GeneModels/B73v3_v4+rejected_association_mw1-8-18.tab",
                                           "\t", escape_double = FALSE, col_names = FALSE,
                                           trim_ws = TRUE, skip = 2)

## Mapping classical genes to gene models, provided by MaizeGDB.org site
maize.genes.classical_to_v3_map.raw <- read_delim("data-raw/B73_GeneModels/genes_classical.txt",
                                                  "\t", escape_double = FALSE, trim_ws = TRUE)

## Mapping uniprot accessions to v4 gene models (Gramene), downloaded UniProt. Also has limited maizegdb and kegg ids.
maize.genes.uniprot_to_v4_map.raw <- read_delim("data-raw/UniProt/uniprot-organism__Zea+mays+(Maize)+[4577].tab",
                                                    "\t", escape_double = FALSE, trim_ws = TRUE)

## CornCyc gene frameID to v4 map
corncyc.gene.frameid.raw <- read_delim("data-raw/Pathways/CornCyc_8.0.1/CornCyc_8.0.1_GeneIDs.tab", "\t", escape_double = FALSE, trim_ws = TRUE)

## CornCyc reaction frameID to gene frameID map
corncyc.reaction.frameid.raw <- read_delim("data-raw/Pathways/CornCyc_8.0.1/CornCyc_8.0.1_Reactions.tab", "\t", escape_double = FALSE, trim_ws = TRUE)

## CornCyc pathway frameID to reaction frameID map
corncyc.pathway.frameid.raw <- read_delim("data-raw/Pathways/CornCyc_8.0.1/CornCyc_8.0.1_Pathways.tab", "\t", escape_double = FALSE, trim_ws = TRUE)

## Load Maize GFF data
maize.v4.37.chromosomal.gene.positions.raw <- read_delim("data-raw/MaizeGFF3/Zea_mays.AGPv4.37.gff3.gz",
                                                     "\t", escape_double = FALSE, col_names = FALSE,
                                                     comment = "#", trim_ws = TRUE, col_types = "ccciicccc")

## Load maize GFF data into txdb object
txdb <- makeTxDbFromGFF("./data-raw/MaizeGFF3/Zea_mays.AGPv4.37.gff3.gz", format="gff3")

#--------------------------------------------------------------------------------------------------#
detach("package:readr", unload=TRUE)
detach("package:readxl", unload=TRUE)
detach("package:GenomicFeatures", unload=TRUE)
