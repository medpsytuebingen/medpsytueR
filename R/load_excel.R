#' @title Load data from Excel
#' @description This function will load all sheets from an Excel file using readxl.
#' @param path Path to your Excel file, Default: NULL
#' @param skip_sheets A vector with the names of sheets you do not want to load, Default: NULL
#' @return One dataframe for each sheet in the original Excel file
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[readxl]{excel_sheets}},\code{\link[readxl]{read_excel}}
#'  \code{\link[dplyr]{setdiff}},\code{\link[dplyr]{mutate}}
#'  \code{\link[purrr]{map}}
#'  \code{\link[tidyr]{unnest}}
#' @rdname load_excel
#' @export
#' @importFrom readxl excel_sheets read_excel
#' @importFrom dplyr setdiff mutate
#' @importFrom purrr map
#' @importFrom tidyr unnest
#' @importFrom tibble tibble

load_excel <- function(path = NULL, skip_sheets = NULL) {

tibble::tibble(sheet_names = readxl::excel_sheets(path) %>%
  dplyr::setdiff(skip_sheets)) %>%
  dplyr::mutate(sheets_data = purrr::map(sheet_names, ~ readxl::read_excel(path, sheet = .))) %>%
  split(.$sheet_names) %>%
  purrr::map(., ~ tidyr::unnest(.)) %>%
  list2env(., envir = .GlobalEnv)
}
