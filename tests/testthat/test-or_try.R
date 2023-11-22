good <- function() "good"
also_good <- function() "also good"
bad <- function() stop("bad")
also_bad <- function() stop("also bad")

test_that("HAPPY: or_else() can start with a failure result", {
  res <- as_result(bad()) |> or_try(good) |> or_try(also_good)
  expect_equal(is_success(res), TRUE)
  expect_equal(value(res), "good")
  expect_equal(status(res), "ok")
})

test_that("HAPPY: or_else() can handle multiple sequential failures", {
  res <- as_result(bad()) |>
    or_try(also_bad) |>
    or_try(good) |>
    or_try(also_good)

  expect_equal(is_success(res), TRUE)
  expect_equal(value(res), "good")
  expect_equal(status(res), "ok")
})

test_that("HAPPY: or_else() can start with a result monad that fails", {
  safe_bad <- result(bad)
  res <- safe_bad() |> or_try(good) |> or_try(also_good)
  expect_equal(is_success(res), TRUE)
  expect_equal(value(res), "good")
  expect_equal(status(res), "ok")
})

test_that("HAPPY: or_else() can start with a result monad that succeeds", {
  safe_good <- result(good)
  res <- safe_good() |> or_try(bad) |> or_try(also_good)
  expect_equal(is_success(res), TRUE)
  expect_equal(value(res), "good")
  expect_equal(status(res), "ok")
})

test_that("SAD: or_else() can chain only failures", {
  res <- as_result(bad()) |> or_try(also_bad)
  expect_equal(is_success(res), FALSE)
  expect_equal(value(res), "also bad")
  expect_equal(status(res), "error")
})
