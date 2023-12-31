% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bind.R
\name{bind}
\alias{bind}
\alias{then_try}
\title{Binds a result with another result or function to return a result}
\usage{
bind(last_result, next_obj, ...)

then_try(last_result, next_obj, ...)
}
\arguments{
\item{last_result}{\code{result} object of subclass \code{success}
or \code{failure}}

\item{next_obj}{\code{result} monad or plain function to bind with}

\item{...}{additional arguments to pass to \code{next_obj}}
}
\value{
\code{result} object of subclass \code{success} or \code{failure}

\code{result} object of subclass \code{success} or \code{failure}
}
\description{
If the second object is a function, its return value will be wrapped in a
\code{result} object of subclass \code{success} or \code{failure} depending
on whether the function produces an error or warning. Bind is aliased with
\code{\link{then_try}}.

If the second object is a function, its return value will be wrapped in a
\code{result} object of subclass \code{success} or \code{failure} depending
on whether the function produces an error or warning. \code{then_try} is
aliased with \code{\link{bind}}.
}
\examples{
times3 <- function(x, succeeds = TRUE) {
  if (succeeds) success(x * 3)
  else failure("func1 failed")
}

success(5) |> bind(times3) |> value()
success(5) |> bind(times3, succeeds = FALSE) |> is_failure()
failure("failed from the start") |> bind(times3) |> is_failure()
failure("failed from the start") |> bind(times3) |> value()
times3 <- function(x, succeeds = TRUE) {
  if (succeeds) success(x * 3)
  else failure("func1 failed")
}

success(5) |> then_try(times3) |> value()
success(5) |> then_try(times3, succeeds = FALSE) |> is_failure()
failure("failed from the start") |> then_try(times3) |> is_failure()
failure("failed from the start") |> then_try(times3) |> value()
}
\seealso{
\code{\link{then_try}}

\code{\link{bind}}
}
