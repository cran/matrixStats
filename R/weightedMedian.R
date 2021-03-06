#' Weighted Median Value
#'
#' Computes a weighted median of a numeric vector.
#'
#' @inheritParams weightedMad
#'
#' @param na.rm a logical value indicating whether \code{\link[base]{NA}}
#' values in \code{x} should be stripped before the computation proceeds, or
#' not.  If \code{\link[base]{NA}}, no check at all for \code{\link[base]{NA}}s
#' is done.
#'
#' @param interpolate If \code{\link[base:logical]{TRUE}}, linear interpolation
#' is used to get a consistent estimate of the weighted median.
#'
#' @param ties If \code{interpolate == FALSE}, a character string specifying
#' how to solve ties between two \code{x}'s that are satisfying the weighted
#' median criteria.  Note that at most two values can satisfy the criteria.
#' When \code{ties} is \code{"min"} ("lower weighted median"), the smaller
#' value of the two is returned and when it is \code{"max"} ("upper weighted
#' median"), the larger value is returned.  If \code{ties}
#' is \code{"mean"}, the mean of the two values is returned.  Finally, if
#' \code{ties} is \code{"weighted"} (or \code{\link[base]{NULL}}) a weighted
#' average of the two are returned, where the weights are weights of all values
#' \code{x[i] <= x[k]} and \code{x[i] >= x[k]}, respectively.
#'
#' @return Returns a \code{\link[base]{numeric}} scalar.
#'
#' For the \code{n} elements \code{x = c(x[1], x[2], ..., x[n])} with positive
#' weights \code{w = c(w[1], w[2], ..., w[n])} such that \code{sum(w) = S}, the
#' \emph{weighted median} is defined as the element \code{x[k]} for which the
#' total weight of all elements \code{x[i] < x[k]} is less or equal to
#' \code{S/2} and for which the total weight of all elements \code{x[i] > x[k]}
#' is less or equal to \code{S/2} (c.f. [1]).
#'
#' When using linear interpolation, the weighted mean of \code{x[k-1]} and
#' \code{x[k]} with weights \code{S[k-1]} and \code{S[k]} corresponding to the
#' cumulative weights of those two elements is used as an estimate.
#'
#' If \code{w} is missing then all elements of \code{x} are given the same
#' positive weight. If all weights are zero, \code{\link[base:NA]{NA_real_}} is
#' returned.
#'
#' If one or more weights are \code{Inf}, it is the same as these weights have
#' the same weight and the others have zero. This makes things easier for cases
#' where the weights are result of a division with zero.
#'
#' If there are missing values in \code{w} that are part of the calculation
#' (after subsetting and dropping missing values in \code{x}), then the final
#' result is always \code{NA} of the same type as \code{x}.
#'
#' The weighted median solves the following optimization problem:
#'
#' \deqn{\alpha^* = \arg_\alpha \min \sum_{i = 1}^{n} w_i |x_i-\alpha|} where
#' \eqn{x = (x_1, x_2, \ldots, x_n)} are scalars and
#' \eqn{w = (w_1, w_2, \ldots, w_n)} are the corresponding "weights" for each
#' individual \eqn{x} value.
#'
#' @example incl/weightedMedian.R
#'
#' @author Henrik Bengtsson and Ola Hossjer, Centre for Mathematical Sciences,
#' Lund University.  Thanks to Roger Koenker, Econometrics, University of
#' Illinois, for the initial ideas.
#'
#' @seealso \code{\link[stats]{median}}, \code{\link[base]{mean}}() and
#' \code{\link{weightedMean}}().
#'
#' @references [1] T.H. Cormen, C.E. Leiserson, R.L. Rivest, Introduction to
#' Algorithms, The MIT Press, Massachusetts Institute of Technology, 1989.
#'
#' @keywords univar robust
#' @export
weightedMedian <- function(x, w = NULL, idxs = NULL, na.rm = FALSE,
                           interpolate = is.null(ties), ties = NULL, ...) {

  # Argument 'w':
  if (is.null(w)) {
    w <- rep(1, times = length(x))
  } else {
    w <- as.double(w)
  }

  # Argument 'na.rm':
  na.rm <- as.logical(na.rm)
  if (is.na(na.rm)) na.rm <- FALSE

  # Argument 'interpolate':
  interpolate <- as.logical(interpolate)

  # Argument 'ties':
  if (is.null(ties)) {
    ties_id <- 1L
  } else {
    if (ties == "weighted") {
      ties_id <- 1L
    } else if (ties == "min") {
      ties_id <- 2L
    } else if (ties == "max") {
      ties_id <- 4L
    } else if (ties == "mean") {
      ties_id <- 8L
    } else {
      stop(sprintf("Unknown value of argument '%s': %s", "ties", ties))
    }
  }

  .Call(C_weightedMedian, x, w, idxs, na.rm, interpolate, ties_id)
}
