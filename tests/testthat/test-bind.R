test_that("HAPPY: can bind two results together", {
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

  times3_times2_plus2 <- times3(5) |> bind(times2) |> value() + 2

  # expect fail_result to be a failure class
  expect_equal(times3_times2_plus2, 32)
})
