test_that("HAPPY: result() creates result monad from an error-prone function", {
  fail_fn <- \() {
    stop("This is my error message")
  }

  safely_fail <- result(fail_fn)
  fail_result <- safely_fail()

  # expect fail_result to be a failure class
  expect_s3_class(fail_result, "failure")
  expect_equal(status(fail_result), "error")
  expect_equal(value(fail_result), "This is my error message")
})

test_that("HAPPY: result() takes function and its arguments", {
  fail_fn <- \(msg) {
    stop(msg)
  }

  safely_fail <- result(fail_fn)
  fail_result <- safely_fail("This is my error message")

  # expect fail_result to be a failure class
  expect_s3_class(fail_result, "failure")
  expect_equal(status(fail_result), "error")
  expect_equal(value(fail_result), "This is my error message")
})

test_that("HAPPY: result() can fail_on_warning = TRUE", {
  warn_fn <- \(msg) {
    warning(msg)
  }

  safely_warn <- result(warn_fn, fail_on_warning = TRUE)
  warn_result <- safely_warn("This is my warning message")

  # expect warn_result to be a failure class
  expect_s3_class(warn_result, "failure")
  expect_equal(status(warn_result), "warn")
  expect_equal(value(warn_result), "This is my warning message")
})

test_that("HAPPY: result() can fail_on_warning = FALSE", {
  warn_fn <- \(msg) {
    warning(msg)
  }

  safely_warn <- result(warn_fn, fail_on_warning = FALSE)
  warn_result <- safely_warn("This is my warning message")

  # expect warn_result to be a failure class
  expect_s3_class(warn_result, "success")
  expect_equal(status(warn_result), "warn")
  expect_equal(value(warn_result), "This is my warning message")
})
