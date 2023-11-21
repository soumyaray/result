
test_that("HAPPY: as_result() captures failure from an error-prone block", {
  fail_result <- as_result(stop("This is my error message"))

  # expect fail_result to be a failure class
  expect_s3_class(fail_result, "failure")
  expect_equal(status(fail_result), "error")
  expect_equal(value(fail_result), "This is my error message")
})

test_that("HAPPY: as_result(obj) returns same obj if it is already a result", {
  res <- success(42)
  res2 <- as_result(res)

  expect_s3_class(res2, "success")
  expect_equal(status(res2), "ok")
  expect_equal(value(res2), res$value)
})

test_that("HAPPY: as_result() can detect warnings as success", {
  warn_result <- as_result(
    {
      warning("This is my warning message")
      42
    },
    detect_warning = TRUE,
    fail_on_warning = TRUE
  )

  expect_s3_class(warn_result, "failure")
  expect_equal(status(warn_result), "warn")
  expect_equal(value(warn_result), "This is my warning message")
})

test_that("HAPPY: as_result() can detect warnings as failure", {
  warn_result <- as_result(
    {
      warning("This is my warning message")
      42
    },
    detect_warning = TRUE,
    fail_on_warning = FALSE
  )

  expect_s3_class(warn_result, "success")
  expect_equal(status(warn_result), "warn")
  expect_equal(value(warn_result), "This is my warning message")
})
