test_that("HAPPY: create a failure from an error-prone function", {
  fail_fn <- \() {
    stop("This is my error message")
  }

  fail_result <- result(fail_fn)

  # expect fail_result to be a failure class
  expect_s3_class(fail_result, "failure")
  expect_equal(status(fail_result), "error")
  expect_equal(value(fail_result), "This is my error message")
})

test_that("HAPPY: create a failure from an error-prone block", {
  fail_result <- result({
    stop("This is my error message")
  })

  # expect fail_result to be a failure class
  expect_s3_class(fail_result, "failure")
  expect_equal(status(fail_result), "error")
  expect_equal(value(fail_result), "This is my error message")
})
