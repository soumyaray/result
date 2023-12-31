% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predicates.R
\name{is_success}
\alias{is_success}
\title{Checks if an object is of \code{success} class}
\usage{
is_success(obj)
}
\arguments{
\item{obj}{object to check}
}
\value{
\code{TRUE} if object is of \code{success} class,
\code{FALSE} otherwise
}
\description{
Checks if an object is of \code{success} class
}
\examples{
is_success(success())
is_success(failure())
}
