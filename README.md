# MaizeMap

This R package imports several mapping files relevant to Maize and processes them for use in downstream applications.  The intent of this package is to 1) provide reproducable and documented process for cleaning a limited few raw, publically available id maps to make them consistent and well formatted and 2) present this package in such a way that the data can be easily imported and incorporated into later applications.  In addition, having "pre-cleaned" the data means that downstream applications can be run much faster since they don't have to clean this dataset with each run.

## Getting Started

This R project produces data files that are intended to be imported into other projects using [devtools](https://www.r-project.org/nosvn/pandoc/devtools.html).

```
library(devtools)
install_github("jrwalsh/MaizeMap", force = TRUE)
data("maize.genes.v3_to_v4.map", package = "MaizeMap")
View(maize.genes.v3_to_v4.map)
```

You can import the latest version of this package using:
```
install_github("jrwalsh/MaizeMap", force = TRUE)
```

Or you can use a specific release:
```
install_github("jrwalsh/MaizeMap@v0.2.1", force = TRUE)
```

## Prerequisites

This code was produced with R v3.4.3 "Kite-Eating Tree". You will need [R](https://www.r-project.org/) and an R editor such as [RStudio](https://www.rstudio.com/). You will need [devtools](https://www.r-project.org/nosvn/pandoc/devtools.html) in order to import these datasets. 

Install devtools from inside the R command console:
```
install.packages("devtools")
```

## Datasets

This package contains 

1) Maize B73 v3 id to v4 id map based on work by Margaret Woodhouse
2) CornCyc gene, reaction, pathway maps based on CornCyc 8.0.1
3) Classical maize genes to v3 map provided by MaizeGDB
4) Gene to transcript map and gene locations on genome for AGPv4.32 and AGPv4.37

You can view the available data objects and their descriptions by using:
```
data(package = "MaizeMap")
```

You can view the help file by using:
```
help(package=MaizeMap)
```

## Authors

* **Jesse R. Walsh** - [jrwalsh](https://github.com/jrwalsh)

## Acknowledgments

* Margaret Woodhouse for providing the v3 to v4 mapping file
* The MaizeGDB team for providing the classical gene to v3 mapping file

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
