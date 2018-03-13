[![Travis build status](https://travis-ci.org/medpsytuebingen/medpsytueR.svg?branch=master)](https://travis-ci.org/medpsytuebingen/medpsytueR)

# medpsytueR

The goal of medpsytueR is to provide an easy way of sharing functions commonly
used in the Insitute of Medical Psychology. Feel free to contribute to this package,
and don't forget to add a short description below.

## Installation

You can install medpsytueR from GitHub with:


``` r
# install.packages("devtools")
devtools::install_github("medpsytuebingen/medpsytueR")
```

## Functions included

`load_calorimetry`: will import all files from the calorimeter, so long they all
follow the same naming convention. For example for files named "study-id-session", e.g. insuso-03-N3:

``` r
df <- load_calorimetry(path = "myproject/data", pattern = "([[:alnum:]]+)-([[:digit:]]+)-([[:alnum:]]+)")
```


`load_excel`: will import all sheets from an excel file into separate dataframes. You can specify sheets to skip with the `skip_sheets` argument. This function only works properly if all sheets are _perfectly tabular_, without any special formatting. Make sure the
spreadsheet is clean before attempting to import.

``` r
load_excel(path = "myproject/data/allmydata.xlsx", skip_sheets = c("README", "intermediate_calc"))
```
