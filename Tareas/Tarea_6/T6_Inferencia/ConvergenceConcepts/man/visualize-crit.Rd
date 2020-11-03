\name{visualize.crit}
\alias{visualize.crit}
\title{Visualisation of convergence criterion curves}
\description{This function enables one to visualize the convergence criterion curve.}
\usage{
visualize.crit(crit,plotfunc=plot,...)
}

\arguments{
	\item{crit}{ vector containing the criterion values.}
	\item{plotfunc}{ R function used to draw the plot: for example \code{plot} or \code{points}.}
	\item{...}{ optional arguments to \code{plotfunc}.}
}

\references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation-Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}
    
\seealso{
  \code{\link{check.convergence}}, \code{\link{criterion}}, \code{\link{generate}}, \code{\link{investigate}},
  \code{\link{law.plot2d}}, \code{\link{law.plot3d}},
  \code{\link{p.as.plot}}, \code{\link{visualize.sp}}
}


\examples{
myrbinom <- function(n,alpha){rbinom(n,1,1/(1:n))*((1:n)**alpha)}
data <- generate(randomgen=myrbinom,nmax=1000,M=500,argsgen=list(alpha=0.5))$data
critr1 <- criterion(data,epsilon=0.05,mode="r",r=2)$crit
visualize.crit(critr1,main="Convergence in 2-th mean?",col="red")
legend(0,5,legend=expression(hat(e)["n,2"]),lty=1,col="red")
}

\keyword{dplot} % Computations Related to Plotting
\keyword{distribution} % Probability Distributions and Random Numbers
\keyword{htest} % Statistical Inference
