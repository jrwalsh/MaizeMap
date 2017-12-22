####################################################################################################
## Project:         MaizeMap
## Script purpose:  Clean up raw datafiles needed for this project, including renaming column and
##        selecting relevant columns, handling missing data and incomplete rows, and any global
##        conversions or modification to data to make it usable.
##
## Input:
##        maize.genes.v3_to_v4_map.raw
##        corncyc.gene.frameid.raw
##        corncyc.reaction.frameid.raw
##        corncyc.pathway.frameid.raw
##        txdb
## Output:
##        maize.genes.v3_to_v4.map
##        corncyc.gene.map
##        corncyc.reaction.gene.map
##        corncyc.pathway.reaction.map
##        gene.transcript.map
##
## Date: 2017-12-12
## Author: Jesse R. Walsh
####################################################################################################
library(tidyr)
library(dplyr)
library(GenomicFeatures)

#==================================================================================================#
## maize.genes.v3_to_v4_map.raw
#--------------------------------------------------------------------------------------------------#
maize.genes.v3_to_v4.map <- maize.genes.v3_to_v4_map.raw

## Select relevant columns
maize.genes.v3_to_v4.map <-
  maize.genes.v3_to_v4.map %>%
  rename(v3_id = `v3 gene ID`, v4_id = `v4 gene ID (if present)`) %>%
  select(v3_id, v4_id)

## Remove empty values
maize.genes.v3_to_v4.map$v3_id[maize.genes.v3_to_v4.map$v3_id == "na"] <- NA
maize.genes.v3_to_v4.map$v4_id[maize.genes.v3_to_v4.map$v4_id == "na"] <- NA

## Remove specific associations that are not useful for this mapping
maize.genes.v3_to_v4.map$v3_id[startsWith(maize.genes.v3_to_v4.map$v3_id, "AF")] <- NA
maize.genes.v3_to_v4.map$v3_id[startsWith(maize.genes.v3_to_v4.map$v3_id, "AY")] <- NA
maize.genes.v3_to_v4.map$v3_id[startsWith(maize.genes.v3_to_v4.map$v3_id, "EF")] <- NA
maize.genes.v3_to_v4.map$v3_id[startsWith(maize.genes.v3_to_v4.map$v3_id, "zma")] <- NA
maize.genes.v3_to_v4.map$v4_id[startsWith(maize.genes.v3_to_v4.map$v4_id, "zma")] <- NA
maize.genes.v3_to_v4.map$v4_id[maize.genes.v3_to_v4.map$v4_id == "not in v4"] <- NA

## Remove non-matches
maize.genes.v3_to_v4.map <-
  maize.genes.v3_to_v4.map %>%
  filter(!is.na(v3_id) & !is.na(v4_id))

#==================================================================================================#
## corncyc.gene.frameid.raw
#--------------------------------------------------------------------------------------------------#
corncyc.gene.map <- corncyc.gene.frameid.raw

## Collect only GRMZM and Zm names which can be in either the Accession1 or Accession2 column
corncyc.gene.map$v3_id <- NA
corncyc.gene.map$v4_id <- NA
corncyc.gene.map$v3_id <- ifelse(startsWith(corncyc.gene.map$Accession1, "GRMZM"),
                                      corncyc.gene.map$Accession1,
                                      ifelse(startsWith(corncyc.gene.map$Accession2, "GRMZM"),
                                             corncyc.gene.map$Accession2,
                                             NA))
corncyc.gene.map$v4_id <- ifelse(startsWith(corncyc.gene.map$Accession1, "Zm"),
                                      corncyc.gene.map$Accession1,
                                      ifelse(startsWith(corncyc.gene.map$Accession2, "Zm"),
                                             corncyc.gene.map$Accession2,
                                             NA))

## Remove the transcript/protein suffix.
# For GRMZM, it is _, T or P, 2 numbers, and sometimes a "." and another number.
# For Zm, it is _, T or P, and 3 numbers
corncyc.gene.map <-
  corncyc.gene.map %>%
  mutate(v3_id=gsub("_[PT]\\d\\d.*\\d*", "", v3_id, perl=TRUE)) %>%
  mutate(v4_id=gsub("_[PT]\\d\\d\\d.\\d", "", v4_id, perl=TRUE)) %>%
  # select(FrameID, v4_id) %>%
  # subset(!is.na(v4_id))
  select(FrameID, v3_id, v4_id) %>%
  subset(!is.na(v3_id) | !is.na(v4_id))

## CornCyc8 was built on B73_v4, so we trust this id and not the v3 id
#TODO Consider checking accuracy of v3 IDs against the v3_v4 map
corncyc.gene.map <-
  corncyc.gene.map %>%
  select(FrameID, v4_id) %>%
  subset(!is.na(v4_id))

#==================================================================================================#
## corncyc.reactions.raw
#--------------------------------------------------------------------------------------------------#
corncyc.reaction.gene.map <- corncyc.reaction.frameid.raw

# Remove reactions with no genes, unnest the gene list
corncyc.reaction.gene.map <-
  corncyc.reaction.gene.map %>%
  subset(!is.na(Genes)) %>%
  mutate(GeneID = strsplit(as.character(Genes), " // ")) %>%
  unnest(GeneID) %>%
  select(ReactionID, GeneID)

#==================================================================================================#
## corncyc.pathways.raw
#--------------------------------------------------------------------------------------------------#
corncyc.pathway.reaction.map <- corncyc.pathway.frameid.raw

# Remove superpathways, remove pathways with no reactions, unnest the reaction list
corncyc.pathway.reaction.map <-
  corncyc.pathway.reaction.map %>%
  subset(is.na(SubPathways)) %>%
  subset(!is.na(Reactions)) %>%
  select(PathwayID, Reactions) %>%
  mutate(Reactions = gsub("\"","",Reactions)) %>%
  mutate(ReactionID = strsplit(as.character(Reactions), " // ")) %>%
  unnest(ReactionID) %>%
  select(PathwayID, ReactionID)

#==================================================================================================#
## txdb -> gene.transcript.map
#--------------------------------------------------------------------------------------------------#
## Only work with chromosomes, ignore unplaced contigs
seqlevels(txdb) <- c("1","2","3","4","5","6","7","8","9","10")

## Get gene/transcript names
gene.transcript.map <- data.frame(transcripts(txdb)$tx_name)

## Clean gene.transcript.map
gene.transcript.map <-
  gene.transcript.map %>%
  rename(transcript=transcripts.txdb..tx_name)
gene.transcript.map$transcript <- sub("transcript:", "", gene.transcript.map$transcript)
gene.transcript.map$gene <- sub("(Zm[0-9]{5}d[0-9]{6}).*", "\\1", gene.transcript.map$transcript)
gene.transcript.map <- gene.transcript.map[!startsWith(gene.transcript.map$transcript, "MI"),]

## Reorder columns to gene:transcript
gene.transcript.map <-
  gene.transcript.map %>%
  select(gene, transcript)

#--------------------------------------------------------------------------------------------------#
detach("package:tidyr", unload=TRUE)
detach("package:dplyr", unload=TRUE)
detach("package:GenomicFeatures", unload=TRUE)
