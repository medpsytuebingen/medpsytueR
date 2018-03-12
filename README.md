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
follow the same naming convention.

``` r
df <- load_calorimetry(path = "myproject/data", pattern = "InsuSO-03-N2")
```

