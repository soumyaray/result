#' Tries another result if previous one failed (meant to be used with pipe)
#'
#' @param last_result \code{result} object of subclass \code{success} or
#'   \code{failure}
#' @param next_obj \code{result} monad or plain function to bind with
#' @param ... additional arguments to pass to \code{next_obj}
#' @return \code{result} object of subclass \code{success} or \code{failure}
#' @examples
#' bad <- function() stop("bad")
#' good <- function() "good"
#' also_good <- function() "also good"
#' also_bad <- function() stop("also bad")
#'
#' res <- as_result(bad()) |> or_try(good) |> or_try(also_good)
#' is_success(res)    # TRUE
#' value(res)         # "good"
#' status(res)        # "ok"
#'
#' safely_bad <- result(bad)
#' res <- safely_bad() |> or_try(good) |> or_try(also_good)
#' is_success(res)    # TRUE
#' value(res)         # "good"
#' status(res)        # "ok"
#' @export
or_try <- function(last_result, next_obj, ...) {
  if (is_failure(last_result)) next_obj(...) |> as_result()
  else last_result
}
