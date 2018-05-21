context("test-load_pvt.R")

test_that("file is read correctly", {
  test_path <- test_path("test_data", "pvt")

  out <- load_pvt(path = test_path,
                  col_names = c("study", "id", "session"))

  expect_equal(colnames(out), c("study", "id", "session", "waiting", "reaction"))
})

test_that("columns have the correct information", {
  test_path <- test_path("test_data", "pvt")

  out <- load_pvt(path = test_path,
                  col_names = c("study", "id", "session"))

  expect_equal(unique(out$id), c("1", "2"))
  expect_equal(unique(out$session), c("11", "12"))
  expect_equal(unique(out$study), "someStudy")
  expect_false(any(is.na(out$waiting)))
  expect_false(any(is.na(out$reaction)))
})
