\name{criterion}
\alias{criterion}
\title{Convergence criterion computation}
\description{This function computes the values of the criterion
  convergence function for convergence in probability, almost surely or
  in r-th mean, given the sample paths.}
\usage{
criterion(data,epsilon=0.05,mode="p",r=2)
}

\arguments{
	\item{data}{ matrix containing the sample paths of Xn-X values.}
	\item{epsilon}{ a numeric value giving the interval endpoint.}
	\item{mode}{ a character string specifying the mode of
	convergence to be investigated, must be one of "p" (default), "as" or "r".}
	\item{r}{ a numeric value (r>0) if convergence in r-th mean is to be studied.}
}

\details{
The \code{data} matrix contains the \eqn{$X_n-X$}{X_n-X} values. If mode="p",
\code{criterion} approximates \eqn{$p_n=P[|X_n-X|>\epsilon]$}{p_n=P[|X_n-X|>\epsilon]}. If mode="as",
\code{criterion} approximates \eqn{$a_n=P[\exists k\geq
  n;|X_k-X|>\epsilon]$}{a_n=P[it exists k>= n;|X_k-X|>\epsilon]}. If mode="r",
\code{criterion} approximates
\eqn{$e_{n,r}=E|X_n-X|^r$}{e_{n,r}=E|X_n-X|^r}. The approximations are
based on the frequentist approach.
}


\value{
\item{crit }{the vector of criterion values.}
}

\references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}

  \seealso{
  \code{\link{check.convergence}}, \code{\link{generate}}, \code{\link{investigate}},
  \code{\link{law.plot2d}}, \code{\link{law.plot3d}},
  \code{\link{p.as.plot}}, \code{\link{visualize.crit}}, \code{\link{visualize.sp}}
}


\examples{
myrbinom <- function(n,alpha){rbinom(n,1,1/(1:n))*((1:n)**alpha)}
data <- generate(nmax=1000,M=500,myrbinom,args=list(alpha=0.5))$data
critr1 <- criterion(data,mode="r",r=1)$crit
}

\keyword{distribution} % Probability Distributions and Random Numbers
\keyword{htest} % Statistical Inference
