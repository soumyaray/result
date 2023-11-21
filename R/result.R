#' @export
as_result <- function(obj, detect_warning = TRUE, fail_on_warning = TRUE) {
  expr <- \() {
    if (is_result(obj)) return(obj)
    success(status = "ok", value = obj)
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

#' @export
result <- function(.f, ..., detect_warning = TRUE, fail_on_warning = TRUE) {
  expr <- \() {
    success("ok", value = .f(...))
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

  \() {
    if (detect_warning) {
      tryCatch(expr = expr(), error = error, warning = warning)
    } else {
      tryCatch(expr = expr(), error = error)
    }
  }
}

#' @export
success <- function(value = "done", status = "ok") {
  new_result(successful = TRUE, status = status, value = value)
}

#' @export
failure <- function(value = "failed", status = "error") {
  new_result(successful = FALSE, status = status, value = value)
}

#' @export
new_result <- function(successful, status, value) {
  result_type <- ifelse(successful, "success", "failure")
  obj <- list(status = status, value = value)
  class(obj) <- c(result_type, "result", class(obj))
  obj
}

is_result <- function(obj) inherits(obj, "result")

is_success <- function(obj) UseMethod("is_success", obj)
is_failure <- function(obj) UseMethod("is_failure", obj)
value <- function(obj) UseMethod("value", obj)
status <- function(obj) UseMethod("status", obj)

#' @export
is_success.success <- function(obj) TRUE

#' @export
is_success.failure <- function(obj) FALSE

#' @export
is_failure.result <- function(obj) !is_success(obj)

status.result <- function(obj) obj$status
value.result <- function(obj) obj$value
