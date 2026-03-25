x <- rnorm (1e6)
y <- x ^ 2
y [x < 0] <- -y [x < 0]
saveRDS (sd (y), file = 'myresult.Rds')
