context("test-export_list.R")

l <- list(a = c("a", "b"),
          b = c(1, 2, 3))

v <- c(1, 2, 3)

test_that("fail if no list is provided", {
  expect_error(export_list = v)
})


