####################################################################################################
## Project:         MaizeMap
## Script purpose:  Clean up raw datafiles needed for this project, including renaming column and
##        selecting relevant columns, handling missing data and incomplete rows, and any global
##        conversions or modification to data to make it usable.
##
## Input:
##        maize.genes.v3_to_v4_map.raw
##        maize.genes.classical_to_v3_map.raw
##        maize.genes.uniprot_to_v4_map.raw
##        corncyc.gene.frameid.raw
##        corncyc.reaction.frameid.raw
##        corncyc.pathway.frameid.raw
##        txdb
## Output:
##        maize.genes.v3_to_v4.map
##        maize.genes.classical_to_v3.map
##        maize.genes.uniprot_to_v3.map
##        maize.genes.uniprot_to_v4.map
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
  rename(v3_id = X1, v4_id = X2, type = X3) %>%
  select(v3_id, v4_id, type)

## Remove empty values
maize.genes.v3_to_v4.map$type[is.na(maize.genes.v3_to_v4.map$type)] <- "match"

## Remove rows with v3 id's in the v4 column
maize.genes.v3_to_v4.map <- maize.genes.v3_to_v4.map[!startsWith(maize.genes.v3_to_v4.map$v4_id, "GRMZM"),]

## Merge the groups (split, split?) and (merged, merged?)
maize.genes.v3_to_v4.map$type[maize.genes.v3_to_v4.map$type == "split?"] <- "split"
maize.genes.v3_to_v4.map$type[maize.genes.v3_to_v4.map$type == "merged?"] <- "merged"

## Spread out split and merged cases so each entry is a single gene ID
match.genes <-
  maize.genes.v3_to_v4.map[maize.genes.v3_to_v4.map$type %in% c("match"),]
split.genes <-
  maize.genes.v3_to_v4.map[maize.genes.v3_to_v4.map$type %in% c("split"),] %>%
  mutate(v4_id = strsplit(as.character(v4_id), ",")) %>%
  unnest(v4_id) %>%
  select(v3_id, v4_id, type)
merged.genes <-
  maize.genes.v3_to_v4.map[maize.genes.v3_to_v4.map$type %in% c("merged"),] %>%
  mutate(v3_id = strsplit(as.character(v3_id), ",")) %>%
  unnest(v3_id) %>%
  select(v3_id, v4_id, type)

maize.genes.v3_to_v4.map <-
  bind_rows(match.genes, split.genes, merged.genes)

## Remove specific associations that are not useful for this mapping
maize.genes.v3_to_v4.map$v3_id[startsWith(maize.genes.v3_to_v4.map$v3_id, "AF")] <- NA
maize.genes.v3_to_v4.map$v3_id[startsWith(maize.genes.v3_to_v4.map$v3_id, "AY")] <- NA
maize.genes.v3_to_v4.map$v3_id[startsWith(maize.genes.v3_to_v4.map$v3_id, "EF")] <- NA

## Remove non-matches
maize.genes.v3_to_v4.map <-
  maize.genes.v3_to_v4.map %>%
  filter(!is.na(v3_id) & !is.na(v4_id))

#==================================================================================================#
## maize.genes.classical_to_v3_map.raw
#--------------------------------------------------------------------------------------------------#
maize.genes.classical_to_v3.map <- maize.genes.classical_to_v3_map.raw

## Rename and select relevant columns
maize.genes.classical_to_v3.map <-
  maize.genes.classical_to_v3.map %>%
  rename(classical = `Gene Symbol`, v3_id = `Gene Model ID`) %>%
  select(classical, v3_id)

## Manual review suggests there are 2 errors in this list that should be removed.
## gln3->GRMZM2G050514 is an inaccurate association (should be only gln6, which is included in this list)
## ssu1->GRMZM2G113033 is an inaccurate association (should be only ssu2, which is included in this list)
maize.genes.classical_to_v3.map <-
  maize.genes.classical_to_v3.map %>%
  subset(!(classical %in% c("gln3") & v3_id %in% c("GRMZM2G050514"))) %>%
  subset(!(classical %in% c("ssu1") & v3_id %in% c("GRMZM2G113033")))

#==================================================================================================#
## maize.genes.uniprot_to_v4_map.raw
#--------------------------------------------------------------------------------------------------#
maize.genes.uniprot_to_v4.map <- maize.genes.uniprot_to_v4_map.raw

## Rename and select relevant columns
maize.genes.uniprot_to_v4.map <-
  maize.genes.uniprot_to_v4.map %>%
  rename(UniProt_Acc = Entry, v4_id = `Cross-reference (Gramene)`) %>%
  select(UniProt_Acc, v4_id)

## We are mapping to gene models, not transcripts.  Remove the _T### designations, split lists, and deduplicate
maize.genes.uniprot_to_v4.map <-
  maize.genes.uniprot_to_v4.map %>%
  mutate(v4_id=gsub("_[PT]\\d\\d", "", v4_id, perl=TRUE)) %>%
  mutate(v4_id=gsub("_[PT]\\d\\d\\d", "", v4_id, perl=TRUE)) %>%
  mutate(v4_id=strsplit(as.character(v4_id), ";")) %>%
  unnest(v4_id) %>%
  distinct()

## Fix Errors: some v4_id have a reference to the uniprot accession inside square braces... remove them
##    Example: "GRMZM5G884960 [P05643-2]"
##        maize.genes.uniprot_to_v4.map$v4_id[maize.genes.uniprot_to_v4.map$v4_id %in% c("GRMZM5G884960 [P05643-2]")] <- "GRMZM5G884960"
maize.genes.uniprot_to_v4.map <-
  maize.genes.uniprot_to_v4.map %>%
  mutate(v4_id=gsub(" \\[.*\\]", "", v4_id, perl=TRUE)) %>% mutate(len = nchar(v4_id))

## Remove empty associations
maize.genes.uniprot_to_v4.map <-
  maize.genes.uniprot_to_v4.map %>%
  subset(!is.na(v4_id))

## Split the v3 and v4 associations
maize.genes.uniprot_to_v3.map <-
  maize.genes.uniprot_to_v4.map[!startsWith(maize.genes.uniprot_to_v4.map$v4_id, "Zm"),] %>%
  rename(v3_id = v4_id)
maize.genes.uniprot_to_v4.map <-
  maize.genes.uniprot_to_v4.map[startsWith(maize.genes.uniprot_to_v4.map$v4_id, "Zm"),]

## Double check length of ids
# View(maize.genes.uniprot_to_v4.map %>% mutate(v4_id=gsub(" \\[.*\\]", "", v4_id, perl=TRUE)) %>% mutate(len = nchar(v4_id)))

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
