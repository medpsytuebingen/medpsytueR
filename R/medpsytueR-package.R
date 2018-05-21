#' \code{medpsytueR} package
#'
#' Commonly used functions in the Institute of Medical Psychology, Tuebingen
#'
#' See the README on
#' \href{https://github.com/medpsytuebingen/medpsytueR#readme}{GitHub}
#'
#' @docType package
#' @name medpsytueR
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1"){
  utils::globalVariables(c(".", "fpath", "imp_data", "sheet_names",
                           "type", "transition", "rec", "electrode"))}
