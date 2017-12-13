#' Expression data describing in the paper published by Walley 2016 PMID: 27540173
#'
#' This expression data is mapped to the B73 v2 WGS.  It is available as FPKM values.
#'
#' @docType data
#' @usage data(maize.walley.expression.replicate)
#' @keywords datasets
#'
#' @format A data frame with 32175 rows and 69 variables.
"maize.walley.expression.replicate"

#' Expression data describing in the paper published by Walley 2016 PMID: 27540173
#'
#' This expression data is mapped to the B73 v2 WGS.  It is available as FPKM values.
#' Replicates have been merged by taking the average of the 3 (except for one sample with only 2 replicates).
#' Tracking ID's have been replaced with the tissue sample used and are under the column "Sample".
#'
#' @docType data
#' @usage data(maize.walley.expression)
#' @keywords datasets
#'
#' @format A data frame in long format.
"maize.walley.expression"

#' Protein abundance data describing in the paper published by Walley 2016 PMID: 27540173
#'
#' This expression data is mapped to the B73 v2 FGS.  It is available as dNSAF values.
#' Replicates have been merged by taking the average of the 3 (except for one sample with only 2 replicates).
#' Tracking IDs have been replaced with the tissue sample used and are under the column "Sample".
#'
#' @docType data
#' @usage data(maize.walley.abundance)
#' @keywords datasets
#'
#' @format A data frame in long format.
"maize.walley.abundance"

#' Expression data describing in the paper published by Kaeppler 2015 PMID: 27898762
#'
#' This expression data is mapped to the B73 v2 FGS.  It is available as FPKM values and includes left/right gene positions.
#'
#' @docType data
#' @usage data(maize.kaeppler.expression.replicate)
#' @keywords datasets
#'
#' @format A data frame with 32193 rows and 80 variables.
"maize.kaeppler.expression.replicate"


#' Expression data describing in the paper published by Kaeppler 2015 PMID: 27898762
#'
#' This expression data is mapped to the B73 v2 FGS.  It is available as FPKM values and includes left/right gene positions.
#' Replicates have been merged by taking the average of the 3 (except for one sample with only 2 replicates).
#' Tracking IDs have been replaced with the tissue sample used and are under the column "Sample".
#'
#' @docType data
#' @usage data(maize.kaeppler.expression)
#' @keywords datasets
#'
#' @format A data frame with 32193 rows and 80 variables.
"maize.kaeppler.expression"
