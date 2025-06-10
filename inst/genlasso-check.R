# This script creates the stored test data used in package tests
# (tests/testthat/genlasso-dat.rds)
# It uses genlasso 1.6.1 from CRAN
library(genlasso)
set.seed(1234)
y = rnorm(100)
path = fusedlasso1d(y)
lambda = 5
result1 = as.numeric(coef(path, lambda)$beta)
saveRDS(
  list(y = y, result1 = result1, lambda = lambda),
  test_path("genlasso-dat.rds")
)
