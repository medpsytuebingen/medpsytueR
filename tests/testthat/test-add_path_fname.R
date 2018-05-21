context("test-add_path_fname.R")

test_that("information in filename is correctly separated", {
  test_path <- test_path("test_data")
  test_file <- test_path("test_data", "02-tx-N2.txt")

  out <- add_path_fname(path = test_path,
                        col_names = c("id", "treatment", "session"),
                        file_ext = ".txt")

  expect_equal(colnames(out), c("fpath", "id", "treatment", "session"))
  expect_equal(out$fpath, test_file)
  expect_equal(out$id, "02")
  expect_equal(out$treatment, "tx")
  expect_equal(out$session, "N2")
})
