#' Calculates the sum for each row (column) in a matrix
#'
#' Calculates the sum for each row (column) in a matrix.
#'
#' The implementation of \code{rowSums2()} and \code{colSums2()} is
#' optimized for both speed and memory.
#'
#' @inheritParams rowAlls
#'
#' @return Returns a \code{\link[base]{numeric}} \code{\link[base]{vector}} of
#' length N (K).
#'
#' @author Henrik Bengtsson
#'
#' @keywords array iteration robust univar
#' @export
rowSums2 <- function(x, rows = NULL, cols = NULL, na.rm = FALSE,
                       dim. = dim(x), ...) {
  dim. <- as.integer(dim.)
  na.rm <- as.logical(na.rm)

  has_nas <- TRUE
  .Call(C_rowSums2, x, dim., rows, cols, na.rm, has_nas, TRUE)
}

#' @rdname rowSums2
#' @export
colSums2 <- function(x, rows = NULL, cols = NULL, na.rm = FALSE,
                       dim. = dim(x), ...) {
  dim. <- as.integer(dim.)
  na.rm <- as.logical(na.rm)

  has_nas <- TRUE
  .Call(C_rowSums2, x, dim., rows, cols, na.rm, has_nas, FALSE)
}
