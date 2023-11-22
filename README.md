
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- Use devtools::build_readme() to render README.Rmd to README.md -->

# result

<!-- badges: start -->

[![R-CMD-check](https://github.com/soumyaray/result/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/soumyaray/result/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `result` type captures expressions and functions that might cause
error or otherwise fail to produce a value. Using `result` can make code
more readable and less error-prone by abstracting away the need for
nested `if` statements and `tryCatch` blocks. At its most powerful,
`result` can be used to build a composable pipeline of functions that
will either end with a `success` object, or stop gracefully with a
`failure` object as soon as an error is detected.

## Example

### Safe functions

Make your own functions fault-tolerant by wrapping your results in
`success` or `failure` for downstream users to safely use:

``` r
library(result)

# A function that might fail
risky_fn <- function(good = TRUE) {
  if (good) success(42)
  else failure("cannot find good answer")
}

# Downstream users are now encouraged to inspect the result for success
risky_result <- risky_fn(good = TRUE)
if (is_success(risky_result)) {
  print(paste0("The answer: ", value(risky_result)))
}
#> [1] "The answer: 42"

risky_result <- risky_fn(good = FALSE)
if (is_failure(risky_result)) {
  cat(paste0("Failed because ", value(risky_result)))
}
#> Failed because cannot find good answer
```

### Smart Results

If you are using others’ functions, wrap their results safely for
immediate inspection, or wrap the whole function for safe use later:

``` r
# A third-party function that might crash with error
external_api <- function(good = TRUE) {
  if (good) 42
  else stop("Cannot connect to API")
}

# We can either safely inspect the results:
api_result <- as_result(external_api(good = TRUE))
is_success(api_result)
#> [1] TRUE
value(api_result)
#> [1] 42

# Or we can wrap the risky function for safe use later!
safely_call_api <- result(external_api)
safely_call_api(good = FALSE) |> is_failure()
#> [1] TRUE
```

### Pipelines

We can chain together functions to create a pipeline that will either
complete successfully or else stop gracefully at the first sign of
failure.

Operations for our pipeline:

``` r
# Start by wrapping the first operation in a result to evaluate later
safely_call_api <- result(external_api)

# Other (risky) operations we want to safely use
add_some <- function(x, y) x + y
times_some <- function(x, y) x * y
times_too_much <- function(x, y) {
  z <- x * y
  if (z > 100) stop("Result has become too big") else z
}
```

A successful pipeline binding `result` operations together:

``` r
process <-
  safely_call_api(good = TRUE) |>
  then_try(times_some, 2) |>
  then_try(add_some, 10)

if (is_success(process)) {
  print(paste0("Processed: ", value(process)))
} else {
  cat(paste0("Could not process: ", value(process)))
}
#> [1] "Processed: 94"
```

A failing pipeline that should fail gracefully at the second step
(`times_too_much`):

``` r
process <-
  safely_call_api(good = TRUE) |>
  then_try(times_too_much, 50) |>
  then_try(add_some, 10)

if (is_success(process)) {
  print(paste0("Processed: ", value(process)))
} else {
  cat(paste0("Could not process: ", value(process)))
}
#> Could not process: Result has become too big
```

## Installation

You can install the released version of result from CRAN:

``` r
install.packages("result")
```

You can install the development version of result from
[GitHub](https://github.com/soumyaray/result) with:

``` r
# install.packages("devtools")
devtools::install_github("soumyaray/result")
```

## Why not Either or Maybe?

`Result` is a generalization of the **`Maybe`** type that is available
to R devs from the [`maybe`](https://github.com/armcn/maybe) package.
Conversely, the `Maybe` type is a special case of the `Result` type
where the error type is `Nothing`. `Maybe` shines in situations when an
operation might return something or nothing. But `Result` can convey
more information than `Maybe` in error situations (e.g., a status code
or message explaining the error). In this R implementation, the
`result()` and `as_result()` functions also capture errors
automatically, sparing developers from having to wrap expressions in
their own `tryCatch` blocks.

The `Result` type is a special case of the **`Either`** type. Whereas
`Either` resolves to `Left` or `Right`, `Result` usually resolves to
notions of “Ok’ or”Error”. Use of `Left` and `Right` can be confusing to
newcomers to functional concepts, and do not express the relevance of
outcomes. In this R implementation of `Result`, the `result()` and
`as_result()` functions resolve to `success` and `failure` respectively,
which should be intuitive to many developers. Implementations of
`Result` in other languages (such as Rust) sometimes use `ok` and
`error` (or `err`), but these can conflict with variable names and
keywords in other languages.
