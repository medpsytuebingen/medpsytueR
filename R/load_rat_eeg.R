#' @title Load sleep rat sleep scoring (Spike2)
#' @description Load all .txt files with sleep scoring done with Spike2.
#' @param .path Path to files, Default: NULL
#' @param .pattern Regex pattern for the filenames. Default (e.g. InsuSO-01-N2): '([[:alnum:]]+)-([[:alnum:]]+)-([[:alnum:]]+)'
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
#' @importFrom purrr map map_df set_names map_lgl
#' @importFrom stringr str_match_all str_subset
#' @importFrom tidyr unnest
#' @importFrom magrittr "%>%"
load_rat_eeg <- function(.path = NULL,
                     .pattern = "([[:alnum:]]+)-([[:alnum:]]+)-([[:alnum:]]+)",
                     col_names = c("study_name", "id", "session")) {


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
                            ~ purrr::map_df(., ~ read_table2(.)))) %>%
    tidyr::unnest(cnames) %>%
    tidyr::unnest(imp_data) %>%
    dplyr::select(-fpath) %>%
    dplyr::select_if(., ~ !(all(is.na(.))))

  dT1_T2 <- purrr::map_lgl(colnames(df), ~ any(str_detect(., "T[12]")))

  ## Depending on whether
  if(sum(dT1_T2) == 6){

    df <- df %>%
      gather(type, transition, T1EEG_PL:T2EEG_PR) %>%
      separate(type, into = c("rec", "electrode"), sep = 2)

  } else if(sum(dT1_T2) == 3){

    df <- df %>%
      gather(type, transition, T1EEG_PL:T1EEG_PR) %>%
      separate(type, into = c("rec", "electrode"), sep = 2)

  }
}
