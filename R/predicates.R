#' Checks if an object is of \code{result} class
#'
#' @param obj object to check
#' @return \code{TRUE} if object is of \code{result} class,
#'    \code{FALSE} otherwise
#' @examples
#' is_result(success())
#' is_result(failure())
#' is_result(42)
#' @export
is_result <- function(obj) inherits(obj, "result")

#' Checks if an object is of \code{success} class
#'
#' @param obj object to check
#' @return \code{TRUE} if object is of \code{success} class,
#'    \code{FALSE} otherwise
#' @examples
#' is_success(success())
#' is_success(failure())
#' @export
is_success <- function(obj) UseMethod("is_success", obj)

#' Checks if an object is of \code{failure} class
#'
#' @param obj object to check
#' @return \code{TRUE} if object is of \code{failure} class,
#'    \code{FALSE} otherwise
#' @examples
#' is_failure(success())
#' is_failure(failure())
#' @export
is_failure <- function(obj) UseMethod("is_failure", obj)

#' @method is_success success
#' @export
is_success.success <- function(obj) TRUE

#' @method is_success failure
#' @export
is_success.failure <- function(obj) FALSE

#' @method is_failure result
#' @export
is_failure.result <- function(obj) !is_success(obj)

# Internal predicates

#' Checks if an object is of \code{result.monad} class
#'
#' @param obj object to check
#' @return \code{TRUE} if object is of \code{result.monad} class,
#'   \code{FALSE} otherwise
#' @examples
#' is_result_monad(result(mean))  # TRUE
#' is_result_monad(success())     # FALSE
#' is_result_monad(42)            # FALSE
#' @export
is_result_monad <- function(obj) UseMethod("is_result_monad", obj)

#' @method is_result_monad default
#' @export
is_result_monad.default <- function(obj) FALSE

#' @method is_result_monad monad.result
#' @export
is_result_monad.monad.result <- function(obj) TRUE
