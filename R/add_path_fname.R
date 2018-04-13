#' @title Add paths and filenames to a df
#' @description This helper function wraps `fs` functions to add the path and
#' filename without extension as columns in a df.
#' @param path Path to files, Default: NULL
#' @param col_names Names for the columns. Default: NULL
#' @param file_ext File extension, Default: NULL
#' @param ... extra parameters to pass to tidyr::separate
#' @return A data-frame.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[tibble]{tibble}}
#'  \code{\link[fs]{dir_ls}},\code{\link[fs]{path_ext_remove}},\code{\link[fs]{path_file}}
#'  \code{\link[dplyr]{mutate}}
#' @rdname add_path_fname
#' @export
#' @importFrom tibble tibble
#' @importFrom fs dir_ls path_ext_remove path_file
#' @importFrom dplyr mutate
add_path_fname <- function(path = NULL, col_names = NULL, file_ext = NULL, ...){
  ## collect the path for all files and create new colum with only filename
  df <- tibble::tibble(fpath = fs::dir_ls(path, regexp = file_ext)) %>%
    dplyr::mutate(fnames = fs::path_ext_remove(fs::path_file(fpath))) %>%
    tidyr::separate(col = "fnames", into = col_names, ...)
}
