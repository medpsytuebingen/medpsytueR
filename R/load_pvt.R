#' @title Load PVT reaction time task
#' @description Load all .dat files from the Psychomotor Vigilance Task (ePrime) in the same directory.
#' @param path Path to files, Default: NULL
#' @param col_names Names for the columns. Default: c("study_name", "id", "session")
#' @param file_ext The file extension of your files. Default: ".dat"
#' @param ... extra parameters to pass to tidyr::separate
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
#'  \code{\link[stringr]{str_subset}}
#'  \code{\link[tidyr]{unnest}}
#'  \code{\link[fs]{dir_ls}}\code{\link[fs]{path_ext_remove}}
#' @rdname load_pvt
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr mutate select
#' @importFrom purrr map map_df set_names
#' @importFrom stringr str_subset
#' @importFrom tidyr unnest
#' @importFrom magrittr "%>%"
#' @importFrom fs dir_ls path_ext_remove
load_pvt <- function(path = NULL,
                     col_names = c("study_name", "id", "session"),
                     file_ext = ".dat",
                     ...) {

  ## read all lines from the files, keep only the ones starting with "WAITING",
  ## import each column into a list and keep only what is needed (the reaction
  ## times). Finally name each resulting list and save everything into one df
  df <- add_path_fname(path,
                       col_names,
                       file_ext, ...) %>%
    dplyr::mutate(imp_data = purrr::map(fpath, ~ purrr::map_df(., ~ readLines(.) %>%
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
    tidyr::unnest(imp_data) %>%
    dplyr::select(-fpath)

  df
}
