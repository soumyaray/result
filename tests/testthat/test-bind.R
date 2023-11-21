times3 <- function(x, succeeds = TRUE) {
  if (succeeds) {
    val <- x * 3
    success(val)
  } else {
    failure("func1 failed")
  }
}

times2 <- function(x, succeeds = TRUE) {
  if (succeeds) {
    success(x * 2)
  } else {
    failure("func2 failed")
  }
}

plus2 <- function(x) {
  x + 2
}

timesy_plusz <- function(x, y, z) {
  x * y + z
}

test_that("HAPPY: can bind two results together to return a result", {
  times3_times2_plus2 <- times3(5) |> bind(times2) |> value() + 2

  # expect fail_result to be a failure class
  expect_equal(times3_times2_plus2, 32)
})

test_that("HAPPY: can bind a result with a function to return a result", {
  times3_plus2 <- times3(5) |> bind(plus2)

  # expect fail_result to be a failure class
  expect_s3_class(times3_plus2, "success")
  expect_equal(value(times3_plus2), 17)
})

test_that("HAPPY: can bind a result with a function with more than one param", {
  times3_plus2 <- success(5) |> bind(timesy_plusz, 3, 2)

  # expect fail_result to be a failure class
  expect_s3_class(times3_plus2, "success")
  expect_equal(value(times3_plus2), 17)
})
