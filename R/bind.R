#' @export
bind <- function(last_result, next_result, ...) {
  if (is_success(last_result))
    next_result(value(last_result), ...) |> as_result()
  else last_result
}
