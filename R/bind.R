#' Binds a result with another result or function to return a result
#'
#' If the second object is a function, its return value will be wrapped in a
#' \code{result} object of subclass \code{success} or \code{failure} depending
#' on whether the function produces an error or warning. Bind is aliased with
#' \code{\link{then_try}}.
#'
#' @param last_result \code{result} object of subclass \code{success}
#'  or \code{failure}
#' @param next_obj \code{result} monad or plain function to bind with
#' @param ... additional arguments to pass to \code{next_obj}
#' @return \code{result} object of subclass \code{success} or \code{failure}
#' @seealso \code{\link{then_try}}
#' @examples
#' times3 <- function(x, succeeds = TRUE) {
#'   if (succeeds) success(x * 3)
#'   else failure("func1 failed")
#' }
#'
#' success(5) |> bind(times3) |> value()
#' success(5) |> bind(times3, succeeds = FALSE) |> is_failure()
#' failure("failed from the start") |> bind(times3) |> is_failure()
#' failure("failed from the start") |> bind(times3) |> value()
#' @export
bind <- function(last_result, next_obj, ...) {
  if (is_success(last_result))
    next_obj(value(last_result), ...) |> as_result()
  else last_result
}

#' Binds a result with another result or function to return a result
#'
#' If the second object is a function, its return value will be wrapped in a
#' \code{result} object of subclass \code{success} or \code{failure} depending
#' on whether the function produces an error or warning. \code{then_try} is
#' aliased with \code{\link{bind}}.
#'
#' @param last_result \code{result} object of subclass \code{success}
#'  or \code{failure}
#' @param next_obj \code{result} monad or plain function to bind with
#' @param ... additional arguments to pass to \code{next_obj}
#' @return \code{result} object of subclass \code{success} or \code{failure}
#' @examples
#' times3 <- function(x, succeeds = TRUE) {
#'   if (succeeds) success(x * 3)
#'   else failure("func1 failed")
#' }
#'
#' success(5) |> then_try(times3) |> value()
#' success(5) |> then_try(times3, succeeds = FALSE) |> is_failure()
#' failure("failed from the start") |> then_try(times3) |> is_failure()
#' failure("failed from the start") |> then_try(times3) |> value()
#' @seealso \code{\link{bind}}
#' @rdname bind
#' @export
then_try <- bind
