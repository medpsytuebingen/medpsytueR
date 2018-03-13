#' @title Keep only complete cases
#' @description If a participant has data for more than one session, and you want to keep only participants with complete datasets (i.e. no missing data in either condition), this function will exclude those with any missing values.
#' @param df A dataframe
#' @param id Column with the subject id key
#' @param value Column with the values
#' @return A dataframe
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[dplyr]{filter}}
#' @rdname clean_cases
#' @export
#' @importFrom dplyr filter
#' @importFrom rlang enquo "!!"
clean_cases <- function(df, id, value){
  id <- rlang::enquo(id)
  val <- rlang::enquo(value)

  dplyr::filter(df, !((!!id) %in% (!!id)[is.na((!!val))]))
}
