#' Wraps an expression in \code{result} type, choosing between \code{success}
#' and \code{failure} based on the outcome of the expression.
#'
#' Use `as_result` on expressions whose outcomes are not known in advance or not
#' safe to be examined. The expression will be evualted immediately and wrapped
#' in \code{success} if it produces a value or \code{failure} if it produces an
#' error. If the expression produces a warning, it will be wrapped in
#' \code{success} or \code{failure} depending on the \code{fail_on_warning}
#' argument.
#'
#' @param .expr expression to evaluate
#' @param detect_warning logical, whether to detect warnings; note
#'    \code{as_result()} cannot capture the outcome of an expression if it
#'    catches warnings, so use \code{detect_warning = TRUE } only if you want
#'    to capture the warning message (e.g., after a side-effect).
#' @param fail_on_warning logical, whether to treat warnings as \code{failure}
#'    or \code{success}.
#' @return \code{result} object of subclass \code{success} or \code{failure}
#' @examples
#' as_result(42)
#' as_result(1 + 1)
#'
#' stopper <- as_result(stop("This is my error message"))
#' is_failure(stopper)
#' value(stopper)
#'
#' as_result(warning("You've been warned")) |> is_success()
#' as_result(warning("You've been warned"), fail_on_warning = FALSE) |> value()
#' @export
as_result <- function(.expr, detect_warning = TRUE, fail_on_warning = TRUE) {
  expr <- \() {
    evaluated <- .expr
    if (is_result(evaluated)) return(evaluated)
    success(status = "ok", value = evaluated)
  }

  error <- \(e) {
    failure(status = "error", value = e$message)
  }

  warning <- \(w) {
    if (fail_on_warning) {
      failure(status = "warn", value = w$message)
    } else {
      success("warn", value = w$message)
    }
  }

  if (detect_warning) {
    tryCatch(expr = expr(), error = error, warning = warning)
  } else {
    tryCatch(expr = expr(), error = error)
  }
}

#' Wraps a function in an \code{result} monad for later evaluation.
#'
#' Use `result` on functions whose outcomes are not known in advance or not
#' safe to be examined. The function will not be evaluated until the monad is
#' explicitly called.
#'
#' @param .fn function to wrap
#' @param detect_warning logical, whether to detect warnings; note \code{result}
#'  cannot capture the outcome value if it catches warnings, so use
#'  \code{detect_warning = TRUE } only if you want to capture the warning
#'  message (e.g., after a side-effect).
#' @param fail_on_warning logical, whether to treat warnings as \code{failure}
#'  or \code{success}.
#' @return function that returns a \code{result} object of subclass
#'  \code{success} or \code{failure}
#' @examples
#' crashy <- function() stop("Go no further")
#' safely_call_crashy <- result(crashy)
#' safely_call_crashy() |> is_failure()
#'
#' calculate <- function(x, y) x + y
#' safely_calculate <- result(calculate)
#' safely_calculate(1, 2) |> value()
#' @export
result <- function(.fn, detect_warning = TRUE, fail_on_warning = TRUE) {
  monad <- \(...) {
    expr <- \() {
      success("ok", value = .fn(...))
    }

    error <- \(e) {
      failure(status = "error", value = e$message)
    }

    warning <- \(w) {
      if (fail_on_warning) {
        failure(status = "warn", value = w$message)
      } else {
        success("warn", value = w$message)
      }
    }

    if (detect_warning) {
      tryCatch(expr = expr(), error = error, warning = warning)
    } else {
      tryCatch(expr = expr(), error = error)
    }
  }
  class(monad) <- c("monad", "result", class(monad))
  monad
}

#' Wraps a value in \code{success} type of \code{result}
#'
#' `success` is a constructor function for \code{result} class.
#'
#' @param value any object to wrap
#' @param status character string of the result (typically short)
#' @return \code{result} object of subclass \code{success}
#' @examples
#' success()
#' success(42)
#' @export
success <- function(value = "done", status = "ok") {
  new_result(successful = TRUE, status = status, value = value)
}

#' Wraps a value in \code{failure} type of \code{result}
#'
#' @param value any object to wrap
#' @param status character string of the result (typically short)
#' @return \code{result} object of subclass \code{failure}
#' @examples
#' failure()
#' failure(42)
#' @export
failure <- function(value = "failed", status = "error") {
  new_result(successful = FALSE, status = status, value = value)
}

new_result <- function(successful, status, value) {
  result_type <- ifelse(successful, "success", "failure")
  obj <- list(status = status, value = value)
  class(obj) <- c(result_type, "result", class(obj))
  obj
}

assert_result <- function(obj) {
  if (!is_result(obj)) {
    stop("Object is not of a result")
  }
  obj
}
