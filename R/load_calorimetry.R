#' @title Load calorimetry files
#' @description This function will load all calorimeter files in the same directory,
#'  into R as a dataframe.
#' @param path Path to files, Default: NULL
#' @param col_names Names for the columns. Default: c("study_name", "id", "session")
#' @param file_ext The file extension of your files. Default: ".dat"
#' @param ... extra parameters to pass to tidyr::separate
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
load_calorimetry <- function(path = NULL,
                             col_names = c("study_name", "id", "session"),
                             file_ext = ".txt",
                             ...) {

  df <- add_path_fname(path,
                       col_names,
                       file_ext, ...) %>%
    ## read the relevant lines (starting with "00:") from each file and give
    ## the columns the proper names
    mutate(imp_data = purrr::map(fpath, ~ purrr::map_df(., ~ readLines(.) %>%
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
  tidyr::unnest(imp_data) %>%
  dplyr::select(-fpath)

  df
}


