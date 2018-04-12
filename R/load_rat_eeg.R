#' @title Load sleep rat sleep scoring (Spike2)
#' @description Load all .txt files with sleep scoring done with Spike2.
#' @param .path Path to files, Default: NULL
#' @param .pattern Regex pattern for the filenames. Default (e.g. InsuSO-01-N2): '([[:alnum:]]+)-([[:alnum:]]+)-([[:alnum:]]+)'
#' @param col_names Names for the columns. Default: c("study_name", "id", "session")
#' @param drop_cols The Spike2 script will produce files with columns (e.g. T1EEG_PR)
#' for each electrode and animal recorded. Since usually the information is the
#' same across all electrodes Default: TRUE
#' @title Load sleep rat sleep scoring (Spike2)
#' @description Load all .txt files with sleep scoring done with Spike2.
#' @param path Path to files as a string, Default: NULL
#' @param col_names Names for the columns corresponding to the information on the
#' filename, Default: c("study", "id", "condition")
#' @param drop_cols The Spike2 script will produce files with columns (e.g. T1EEG_PR)
#' for each electrode and animal recorded. Since usually the information is the
#' same across all electrodes Default: TRUE
#' @param file_ext The extension of the files you want to import, Default: '.txt'
#' @param ... PARAM_DESCRIPTION
#' @return A data-frame
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[tibble]{tibble}}
#'  \code{\link[fs]{dir_ls}},\code{\link[fs]{path_ext_remove}},\code{\link[fs]{path_file}}
#'  \code{\link[dplyr]{mutate}},\code{\link[dplyr]{select}},\code{\link[dplyr]{select_if}},\code{\link[dplyr]{matches}}
#'  \code{\link[tidyr]{separate}},\code{\link[tidyr]{unnest}},\code{\link[tidyr]{gather}}
#'  \code{\link[purrr]{map}}
#'  \code{\link[readr]{read_table2}}
#' @rdname load_rat_eeg
#' @export
#' @importFrom tibble tibble
#' @importFrom fs dir_ls path_ext_remove path_file
#' @importFrom dplyr mutate select select_if matches
#' @importFrom tidyr separate unnest gather
#' @importFrom purrr map
#' @importFrom readr read_table2
load_rat_eeg <- function(
  path = NULL,
  col_names = c("study", "id", "condition"),
  drop_cols = TRUE,
  file_ext = ".txt",
  ...
){
  ## collect the path for all files and create new colum with only filename
  df_init <- tibble::tibble(fpath = fs::dir_ls(path, regexp = file_ext)) %>%
    dplyr::mutate(fnames = fs::path_ext_remove(fs::path_file(fpath)))

  df <- df_init %>%
    tidyr::separate(col = "fnames", into = col_names, ...) %>%
    dplyr::mutate(data_imp = purrr::map(fpath, ~ readr::read_table2(.))) %>%
    tidyr::unnest(data_imp) %>%
    dplyr::select(-fpath) %>%
    dplyr::select_if(., ~ !(all(is.na(.)))) %>%
    tidyr::gather(type, transition, dplyr::matches("T[12]")) %>%
    tidyr::separate(type, into = c("rec", "electrode"), sep = 2)

  ## Depending on whether we want to drop the columns with rec and electrode
  if(drop_cols){
    df <- df %>%
      dplyr::select(-c(rec, electrode))
  } else {
    df
  }

  # if(length(str_extract(df_init$fnames, "[^[:alnum:]]+") %>% unique(.)) > 1){
  #   df
  #   warning("Some files have more than one separator.")
  # }
}
