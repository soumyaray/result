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

new_result <- function(successful, status, value) {
  result_type <- ifelse(successful, "success", "failure")
  obj <- list(status = status, value = value)
  class(obj) <- c(result_type, "result", class(obj))
  obj
}
