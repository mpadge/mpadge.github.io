#include <Rcpp.h>

template <class T>
inline T mysquare (T &x)
{
    for (size_t i = 0; i < x.size (); i++)
        x (i) = x (i) * x (i);
    return x;
}

inline SEXP mysquare (SEXP &x)
{
    switch (TYPEOF (x))
    {
        case INTSXP: {
                         Rcpp::IntegerVector iv = Rcpp::as <Rcpp::IntegerVector> (x);
                         return mysquare (iv);
                     }
        case REALSXP: {
                         Rcpp::NumericVector nv = Rcpp::as <Rcpp::NumericVector> (x);
                         return mysquare (nv);
                     }
        default: { Rcpp::stop ("error");    }
    }
    return x; // this never happens
}

// [[Rcpp::export]]
SEXP rcpp_mysquare (SEXP &x)
{
    return mysquare (x);
}
