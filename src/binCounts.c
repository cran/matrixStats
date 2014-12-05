/***************************************************************************
 Public methods:
 binCounts(SEXP x, SEXP bx, SEXP right)

 Copyright Henrik Bengtsson, 2012-2013
 **************************************************************************/
#include <Rdefines.h>
#include "types.h"
#include "utils.h"
#include <R_ext/Error.h>

#define BIN_BY 'L'
#include "binCounts-BINBY-template.h"

#define BIN_BY 'R'
#include "binCounts-BINBY-template.h"


SEXP binCounts(SEXP x, SEXP bx, SEXP right) {
  SEXP counts = NILSXP;
  R_xlen_t nbins;
  int closedRight;

  /* Argument 'x': */
  assertArgVector(x, (R_TYPE_REAL), "x");

  /* Argument 'bx': */
  assertArgVector(bx, (R_TYPE_REAL), "bx");

  /* Argument 'right': */
  closedRight = asLogicalNoNA(right, "right");

  nbins = xlength(bx)-1;
  PROTECT(counts = allocVector(INTSXP, nbins));

  if (closedRight) {
    binCounts_R(REAL(x), xlength(x), REAL(bx), nbins, INTEGER(counts));
  } else {
    binCounts_L(REAL(x), xlength(x), REAL(bx), nbins, INTEGER(counts));
  }

  UNPROTECT(1);

  return(counts);
} // binCounts()


/***************************************************************************
 HISTORY:
 2014-06-03 [HB]
  o Dropped unused variable 'count'.
 2013-10-08 [HB]
  o Now binCounts() calls binCounts_<Lr|lR>().
 2013-05-10 [HB]
  o SPEEDUP: binCounts() no longer tests in every iteration (=for every
    data point) whether the last bin has been reached or not.
 2012-10-10 [HB]
  o BUG FIX: binCounts() would return random/garbage counts for bins
    that were beyond the last data point.
  o BUG FIX: In some cases binCounts() could try to go past the last bin.
 2012-10-03 [HB]
  o Created.
 **************************************************************************/
