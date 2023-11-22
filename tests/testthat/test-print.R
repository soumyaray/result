test_that("HAPPY: result() creates result monad from an error-prone function", {
  expect_output(print(success()), "ok: done")
  expect_output(print(failure()), "error: failed")
})
