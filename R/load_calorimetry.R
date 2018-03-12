#' @title Load calorimetry files
#' @description This function will load all calorimeter files in the same directory,
#'  into R as a dataframe.
#' @param .path Path to files, Default: NULL
#' @param .pattern Regex pattern for the filenames. Default (e.g. InsuSO-01-N2): '([[:alnum:]]+)-([[:digit:]]+)-([[:alnum:]]+)'
#' @param col_names Names for the columns. Default: c("study_name", "id", "session")
#' @return A dataframe.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[tibble]{tibble}}
#'  \code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}}
#'  \code{\link[stringr]{str_match_all}},\code{\link[stringr]{str_subset}}
#'  \code{\link[purrr]{map_df}},\code{\link[purrr]{set_names}}
#'  \code{\link[tidyr]{unnest}}
#' @rdname load_calorimetry
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr mutate select
#' @importFrom stringr str_match_all str_subset
#' @importFrom purrr map map_df set_names
#' @importFrom tidyr unnest
#' @importFrom magrittr "%>%"

load_calorimetry <- function(.path = NULL,
                             .pattern = "([[:alnum:]]+)-([[:digit:]]+)-([[:alnum:]]+)",
                             col_names = c("study_name", "id", "session")) {


df <- tibble::tibble(fpath = list.files(
  .path,
  pattern = "*.txt",
  all.files = TRUE,
  full.names = TRUE
)) %>%
  dplyr::mutate(
    ## extract study name, id and session from the filename
    cnames = purrr::map(fpath, ~ purrr::map_df(., ~ stringr::str_match_all(., .pattern)[[1]] %>%
      as.list(.) %>%
      .[2:length(.)] %>%
      set_names(col_names))),
    ## read the relevant lines (starting with "00:") from each file and give
    ## the columns the proper names
    imp_data = purrr::map(fpath, ~ purrr::map_df(., ~ readLines(.) %>%
      stringr::str_subset(., "00:") %>%
      purrr::map_df(., ~ scan(
        text = ., quiet = TRUE,
        what = list(
          character(), double(), double(),
          double(), double(), double(),
          double(), double(), double(), double()
        )
      )[c(1:10)] %>%
        purrr::set_names(c(
          "hour", "REE", "VO2", "VCO2",
          "RQVE", "BTPS", "FIO2", "FEO2",
          "FICO2", "FECO2"
        )))))
  ) %>%
  tidyr::unnest(cnames) %>%
  tidyr::unnest(imp_data) %>%
  dplyr::select(-fpath)

}
