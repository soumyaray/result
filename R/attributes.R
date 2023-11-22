#' Extracts the value of a \code{result}
#'
#' @param obj \code{result} object
#' @return value object wrapped by \code{result}
#' @examples
#' value(success(42))
#' @export
value <- function(obj) UseMethod("value", obj)

#' Extracts the status of a \code{result}
#'
#' @param obj \code{result} object
#' @return status of the \code{result}
#' @examples
#' status(success("datafile.md", status = "created"))
#' @export
status <- function(obj) UseMethod("status", obj)

#' @method status result
#' @export
status.result <- function(obj) obj$status

#' @method value result
#' @export
value.result <- function(obj) obj$value
