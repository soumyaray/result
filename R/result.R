#' @export
as.result <- function(obj) {
  tryCatch({
    success("ok", value = obj)
  }, error = \(e) {
    failure(status = "error", value = e$message)
  })
}

#' @export
result <- function(.f, ...) {
  \() {
    tryCatch({
      success("ok", value = .f(...))
    }, error = \(e) {
      failure(status = "error", value = e$message)
    })
  }
}

#' @export
success <- function(status = "ok", value = "done") {
  new_result(successful = TRUE, status = status, value = value)
}

#' @export
failure <- function(status = "error", value = "failed") {
  new_result(successful = FALSE, status = status, value = value)
}

#' @export
new_result <- function(successful, status, value) {
  result_type <- ifelse(successful, "success", "failure")
  obj <- list(status = status, value = value)
  class(obj) <- c(result_type, "result", class(obj))
  obj
}

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
