[![Travis build status](https://img.shields.io/travis/medpsytuebingen/medpsytueR.svg?style=flat-square)](https://travis-ci.org/medpsytuebingen/medpsytueR)
[![AppVeyor build status](https://img.shields.io/appveyor/ci/jcpsantiago/medpsytueR.svg?style=flat-square)](https://ci.appveyor.com/project/jcpsantiago/medpsytuer-4aalo)
![License](https://img.shields.io/badge/license-MIT-blue.svg?longCache=true&style=flat-square)

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

`clean_cases`: this function will exclude data from subjects with any missing values
in a specified column.

``` r
df_nomiss <- clean_cases(df, id, value)
```


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


`load_pvt`: will import all .dat files with data from an ePrime Psychomotor Vigilance Task into a single dataframe, so long they all follow the same naming convention. For example for files named "study-id-session", e.g. insuso-03-N3:

``` r
df <- load_pvt(path = "myproject/data", pattern = "([[:alnum:]]+)-([[:alnum:]]+)-([[:alnum:]]+)")
```


`load_rat_eeg`: will import all .txt files with data from sleep scoring with Spike2.

``` r
df <- load_rat_eeg(path = "myproject/data", pattern = "([[:alnum:]]+)-([[:alnum:]]+)-([[:alnum:]]+)")
```
