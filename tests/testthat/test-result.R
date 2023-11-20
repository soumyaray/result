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

  safely_fail <- result(fail_fn, "This is my error message")
  fail_result <- safely_fail()

  # expect fail_result to be a failure class
  expect_s3_class(fail_result, "failure")
  expect_equal(status(fail_result), "error")
  expect_equal(value(fail_result), "This is my error message")
})

test_that("HAPPY: as.resuilt() captures failure from an error-prone block", {
  fail_result <- as.result(stop("This is my error message"))

  # expect fail_result to be a failure class
  expect_s3_class(fail_result, "failure")
  expect_equal(status(fail_result), "error")
  expect_equal(value(fail_result), "This is my error message")
})
