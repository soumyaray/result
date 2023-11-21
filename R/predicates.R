is_result <- function(obj) inherits(obj, "result")
is_success <- function(obj) UseMethod("is_success", obj)
is_failure <- function(obj) UseMethod("is_failure", obj)

#' @export
is_success.success <- function(obj) TRUE

#' @export
is_success.failure <- function(obj) FALSE

#' @export
is_failure.result <- function(obj) !is_success(obj)
