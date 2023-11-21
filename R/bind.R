#' @export
bind <- function(result1, f2) {
  if (is_success(result1)) {
    f2(value(result1))
  } else {
    result1
  }
}
