\name{visualize.sp}
\alias{visualize.sp}
\title{Visualisation of sample paths}
\description{This function enables one to visualize the sample paths.}
\usage{
visualize.sp(data,epsilon=0.05,nb.sp=10,plotfunc=plot,...)
}

\arguments{
	\item{data}{ matrix containing the sample paths of Xn-X values.}
	\item{epsilon}{ a numeric value giving the interval endpoint.}
	\item{nb.sp}{ number of sample paths to draw on the plot.}
	\item{plotfunc}{ R function used to draw the plot: for example \code{plot} or \code{points}.}
	\item{...}{ optional arguments to \code{plotfunc}.}
}

\references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation-Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}

\seealso{
  \code{\link{check.convergence}}, \code{\link{criterion}}, \code{\link{generate}}, \code{\link{investigate}},
  \code{\link{law.plot2d}}, \code{\link{law.plot3d}},
  \code{\link{p.as.plot}}, \code{\link{visualize.crit}}
}


\examples{
myrand <- function(n,...){cumsum(rnorm(n,...))/(1:n)}
data <- generate(randomgen=myrand,nmax=1000,M=500)$data
visualize.sp(data,main="Ten sample paths",col="grey")
}

\keyword{dplot} % Computations Related to Plotting
\keyword{distribution} % Probability Distributions and Random Numbers
\keyword{htest} % Statistical Inference
