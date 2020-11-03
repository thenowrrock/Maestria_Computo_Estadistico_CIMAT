\name{law.plot2d}
\alias{law.plot2d}
\title{Interactive 2D convergence in law}
\description{This function enables one to draw the interactive 2D plot
  to investigate convergence in law.}
\usage{
law.plot2d(data,density=FALSE,densfunc=dnorm,probfunc=pnorm,tinf=-5,tsup=5)
}

\arguments{
	\item{data}{ matrix containing the sample paths of Xn values.}
	\item{density}{ if density=TRUE, then the plot of the density of X and the histogram of Xn is returned. If density=FALSE, then the plot of the distribution function F(t) of X and the empirical distribution Fn(t) of Xn is returned.}
	\item{densfunc}{ function to compute the density of X.}
	\item{probfunc}{ function to compute the distribution function of X.}
	\item{tinf}{ lower limit for investigating convergence in law.}
	\item{tsup}{ upper limit for investigating convergence in law.}
}

\references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation-Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}

\seealso{
  \code{\link{check.convergence}}, \code{\link{criterion}},
  \code{\link{generate}},  \code{\link{investigate}},
   \code{\link{law.plot3d}},
  \code{\link{p.as.plot}}, \code{\link{visualize.crit}}, \code{\link{visualize.sp}}
}


\examples{
rand <- function(n){(cumsum(rchisq(n,df=1))-(1:n))/sqrt(2*(1:n))}
data <- generate(randomgen=rand,nmax=1000,M=500)$data
law.plot2d(data)
}

\keyword{dplot} % Computations Related to Plotting
\keyword{iplot} % Interacting with Plots
\keyword{distribution} % Probability Distributions and Random Numbers
\keyword{htest} % Statistical Inference
