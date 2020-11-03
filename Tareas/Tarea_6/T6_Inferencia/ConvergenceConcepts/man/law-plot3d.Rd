\name{law.plot3d}
\alias{law.plot3d}
\title{Static 3D convergence in law}
\description{This function enables one to draw the static 3D plot to
  investigate convergence in law.}
\usage{
law.plot3d(data,probfunc,tinf=-5,tsup=5)
}

\arguments{
	\item{data}{ matrix containing the sample paths of Xn values.}
	\item{probfunc}{ function to compute the distribution function of X.}
	\item{tinf}{ lower limit for investigating convergence in law.}
	\item{tsup}{ upper limit for investigating convergence in law.}
}

\references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation-Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}
    

\seealso{
  \code{\link{check.convergence}}, \code{\link{criterion}},
  \code{\link{generate}},  \code{\link{investigate}},
   \code{\link{law.plot2d}},
  \code{\link{p.as.plot}}, \code{\link{visualize.crit}}, \code{\link{visualize.sp}}
}


\examples{
rand <- function(n){(cumsum(rchisq(n,df=1))-(1:n))/sqrt(2*(1:n))}
data <- generate(randomgen=rand,nmax=500,M=5000)$data
law.plot3d(data,pnorm)
}

\keyword{dplot} % Computations Related to Plotting
\keyword{distribution} % Probability Distributions and Random Numbers
\keyword{htest} % Statistical Inference
