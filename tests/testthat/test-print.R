test_that("HAPPY: can print success and failure results", {
  expect_output(print(success()), "ok: done")
  expect_output(print(failure()), "error: failed")
})

test_that("HAPPY: can print result monads", {
  expect_output(print(result(mean)), "result monad")
})
