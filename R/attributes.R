value <- function(obj) UseMethod("value", obj)
status <- function(obj) UseMethod("status", obj)

status.result <- function(obj) obj$status
value.result <- function(obj) obj$value
