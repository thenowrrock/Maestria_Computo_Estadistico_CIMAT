\name{generate}
\alias{generate}
\title{Generation of sample paths}
\description{This function generates the sample paths of a sequence of random variables.}
\usage{
generate(randomgen,nmax=1000,M=500,argsgen=NULL)
}

\arguments{
	\item{nmax}{ number of points in each sample path.}
	\item{M}{ number of sample paths to be generated.}
	\item{randomgen}{ a function that generates the Xn-X values.}
	\item{argsgen}{ a list of arguments to \code{randomgen}.}
}


\value{
\item{data }{matrix containing in each row a sample path of Xn-X values.}
}

\references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation-Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}

\seealso{
  \code{\link{check.convergence}}, \code{\link{criterion}},  \code{\link{investigate}},
  \code{\link{law.plot2d}}, \code{\link{law.plot3d}},
  \code{\link{p.as.plot}}, \code{\link{visualize.crit}}, \code{\link{visualize.sp}}
}


\examples{
myrbinom<-function(n,alpha){rbinom(n,1,1/(1:n))*((1:n)**alpha)}
data <- generate(randomgen=myrbinom,argsgen=list(alpha=0.5))$data
}

\keyword{distribution} % Probability Distributions and Random Numbers
