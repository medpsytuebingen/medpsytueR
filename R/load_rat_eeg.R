#' @title Load sleep rat sleep scoring (Spike2)
#' @description Load all .txt files with sleep scoring done with Spike2.
#' @param .path Path to files, Default: NULL
#' @param .pattern Regex pattern for the filenames. Default (e.g. InsuSO-01-N2): '([[:alnum:]]+)-([[:alnum:]]+)-([[:alnum:]]+)'
#' @param col_names Names for the columns. Default: c("study_name", "id", "session")
#' @param drop_cols The Spike2 script will produce files with columns (e.g. T1EEG_PR)
#' for each electrode and animal recorded. Since usually the information is the
#' same across all electrodes Default: TRUE
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
#'  \code{\link[tidyr]{unnest}},\code{\link[tidyr]{gather}},\code{\link[tidyr]{separate}}
#' @rdname load_rat_eeg
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr mutate select
#' @importFrom purrr map map_df set_names map_lgl
#' @importFrom stringr str_match_all str_subset
#' @importFrom tidyr unnest gather separate
#' @importFrom readr read_table2
#' @importFrom magrittr "%>%"
load_rat_eeg <- function(.path = NULL,
                     .pattern = "([[:alnum:]]+)-([[:alnum:]]+)-([[:alnum:]]+)",
                     col_names = c("study_name", "id", "session"),
                     drop_cols = TRUE) {


  df <- tibble::tibble(fpath = list.files(
    .path,
    pattern = "*.txt",
    all.files = TRUE,
    full.names = TRUE
  )) %>%
    dplyr::mutate(
      ## extract info (e.g. study name, id, session) from the filename
      cnames = purrr::map(fpath, ~ purrr::map_df(., ~ stringr::str_match_all(., .pattern)[[1]] %>%
                                                   as.list(.) %>%
                                                   ## first element of the list
                                                   ## is the full filename, so
                                                   ## we skip it
                                                   .[2:length(.)] %>%
                                                   set_names(col_names))),
      ## read the files
      imp_data = purrr::map(fpath,
                            ~ purrr::map_df(., ~ readr::read_table2(.)))) %>%
    tidyr::unnest(cnames) %>%
    tidyr::unnest(imp_data) %>%
    dplyr::select(-fpath) %>%
    dplyr::select_if(., ~ !(all(is.na(.)))) %>%
    tidyr::gather(type, transition, matches("T[12]")) %>%
    tidyr::separate(type, into = c("rec", "electrode"), sep = 2)

  ## Depending on whether we want to drop the columns with rec and electrode
  if(drop_cols){
    df <- df %>%
      dplyr::select(-c(rec, electrode))
  } else {
    df
  }
}
