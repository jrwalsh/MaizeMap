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
## Output:
##        maize.genes.v3_to_v4_map.clean
##        corncyc.gene.frameid.clean
##        corncyc.reaction.frameid.clean
##        corncyc.pathway.frameid.clean
##
## Date: 2017-12-12
## Author: Jesse R. Walsh
####################################################################################################
library(tidyr)
library(dplyr)
# library(GenomicFeatures)

#==================================================================================================#
## maize.genes.v3_to_v4_map.raw
#--------------------------------------------------------------------------------------------------#
maize.genes.v3_to_v4_map.clean <- maize.genes.v3_to_v4_map.raw

maize.genes.v3_to_v4_map.clean <-
  maize.genes.v3_to_v4_map.clean %>%
  rename(v3_id = `v3 gene ID`, v4_id = `v4 gene ID (if present)`) %>%
  select(v3_id, v4_id)

maize.genes.v3_to_v4_map.clean$v3_id[maize.genes.v3_to_v4_map.clean$v3_id == "na"] <- NA
maize.genes.v3_to_v4_map.clean$v4_id[maize.genes.v3_to_v4_map.clean$v4_id == "na"] <- NA

maize.genes.v3_to_v4_map.clean$v3_id[startsWith(maize.genes.v3_to_v4_map.clean$v3_id, "AF")] <- NA
maize.genes.v3_to_v4_map.clean$v3_id[startsWith(maize.genes.v3_to_v4_map.clean$v3_id, "AY")] <- NA
maize.genes.v3_to_v4_map.clean$v3_id[startsWith(maize.genes.v3_to_v4_map.clean$v3_id, "EF")] <- NA
maize.genes.v3_to_v4_map.clean$v3_id[startsWith(maize.genes.v3_to_v4_map.clean$v3_id, "zma")] <- NA
maize.genes.v3_to_v4_map.clean$v4_id[startsWith(maize.genes.v3_to_v4_map.clean$v4_id, "zma")] <- NA
maize.genes.v3_to_v4_map.clean$v4_id[maize.genes.v3_to_v4_map.clean$v4_id == "not in v4"] <- NA

maize.genes.v3_to_v4_map.clean <-
  maize.genes.v3_to_v4_map.clean %>%
  filter(!is.na(v3_id) & !is.na(v4_id))

## v3 to v4 is 1 to many mapping
# maize.genes.v3_to_v4_map.clean$v4_id[duplicated(maize.genes.v3_to_v4_map.clean$v4_id)]

#==================================================================================================#
## txdb -> geneTranscript.map
#--------------------------------------------------------------------------------------------------#
# ## Only work with chromosomes, ignore unplaced contigs
# seqlevels(txdb) <- c("1","2","3","4","5","6","7","8","9","10")
#
# ## Get gene/transcript names
# geneTranscript.map <- data.frame(transcripts(txdb)$tx_name)
# # GRList <- exonsBy(txdb, by = "tx")
# # tx_ids <- names(GRList)
# # head(select(txdb, keys=tx_ids, columns=c("GENEID","TXNAME"), keytype="TXID"))
#
# ## Clean geneTranscript.map
# geneTranscript.map <-
#   geneTranscript.map %>%
#   rename(transcript=transcripts.txdb..tx_name)
# geneTranscript.map$transcript <- sub("transcript:", "", geneTranscript.map$transcript)
# geneTranscript.map$gene <- sub("(Zm[0-9]{5}d[0-9]{6}).*", "\\1", geneTranscript.map$transcript)
# geneTranscript.map <- geneTranscript.map[!startsWith(geneTranscript.map$transcript, "MI"),]
# geneTranscript.counts <-
#   geneTranscript.map %>%
#   select(gene) %>%
#   group_by(gene) %>%
#   summarise(n=n())
#
# rm(txdb)

#--------------------------------------------------------------------------------------------------#
# detach("package:GenomicFeatures", unload=TRUE)
detach("package:tidyr", unload=TRUE)
detach("package:dplyr", unload=TRUE)
