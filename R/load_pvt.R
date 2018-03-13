#' @title Load PVT reaction time task
#' @description Load all .dat files from the Psychomotor Vigilance Task (ePrime) in the same directory.
#' @param .path Path to files, Default: NULL
#' @param .pattern Regex pattern for the filenames. Default (e.g. InsuSO-01-N2): '([[:alnum:]]+)-([[:digit:]]+)-([[:alnum:]]+)'
#' @param col_names Names for the columns. Default: c("study_name", "id", "session")
#' @return A dataframe
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[tibble]{tibble}}
#'  \code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}}
#'  \code{\link[purrr]{map}},\code{\link[purrr]{map_df}},\code{\link[purrr]{set_names}}
#'  \code{\link[stringr]{str_match_all}},\code{\link[stringr]{str_subset}}
#'  \code{\link[tidyr]{unnest}}
#' @rdname load_pvt
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr mutate select
#' @importFrom purrr map map_df set_names
#' @importFrom stringr str_match_all str_subset
#' @importFrom tidyr unnest
#' @importFrom magrittr "%>%"
load_pvt <- function(.path = NULL,
                             .pattern = "([[:alnum:]]+)-([[:digit:]]+)-([[:alnum:]]+)",
                             col_names = c("study_name", "id", "session")) {


  df <- tibble::tibble(fpath = list.files(
    .path,
    pattern = "*.dat",
    all.files = TRUE,
    full.names = TRUE
  )) %>%
    dplyr::mutate(
      ## extract study name, id and session from the filename
      cnames = purrr::map(fpath, ~ purrr::map_df(., ~ stringr::str_match_all(., .pattern)[[1]] %>%
                                                   as.list(.) %>%
                                                   .[2:length(.)] %>%
                                                   set_names(col_names))),
      ## read the relevant lines (starting with "WAITING") from each file and give
      ## the columns the proper names
      imp_data = purrr::map(fpath, ~ purrr::map_df(., ~ readLines(.) %>%
                                                     stringr::str_subset(., "WAITING") %>%
                                                     purrr::map_df(., ~ scan(
                                                       text = ., quiet = TRUE,
                                                       what = list(
                                                         character(), double(), character(),
                                                         character(), double(), character()
                                                       )
                                                     )[c(2,5)] %>%
                                                       purrr::set_names(c("waiting", "reaction")))))
    ) %>%
    tidyr::unnest(cnames) %>%
    tidyr::unnest(imp_data) %>%
    dplyr::select(-fpath)
}
