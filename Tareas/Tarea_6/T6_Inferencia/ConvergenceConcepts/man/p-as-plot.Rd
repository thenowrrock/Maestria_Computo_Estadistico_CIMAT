\name{p.as.plot}
\alias{p.as.plot}
\title{Interactive plot for convergence in probability and almost surely}
\description{This function enables one to draw the interactive plots
  used to study convergence in probability and almost surely.}
\usage{
p.as.plot(data,critp,critas,epsilon=0.05,nb.sp=10,mode="p")
}

\arguments{
	\item{data}{ matrix containing the sample paths of Xn-X values.}
	\item{critp}{ vector containing the criterion values for convergence in probability.}
	\item{critas}{ vector containing the criterion values for convergence almost surely.}
	\item{epsilon}{ a numeric value giving the interval endpoint.}
	\item{nb.sp}{ number of sample paths to be drawn on the left plot.}
	\item{mode}{ a character string specifying the mode of
	convergence to investigate, must be one of "p" (default), "as" or "r".}
}

%       \value{
%ID and env (as with tktoplevel function call)
%	 }

	 \references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation-Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}
    

\seealso{
  \code{\link{check.convergence}}, \code{\link{criterion}}, \code{\link{generate}}, \code{\link{investigate}},
   \code{\link{law.plot2d}}, \code{\link{law.plot3d}},
  \code{\link{visualize.crit}}, \code{\link{visualize.sp}}
}


\examples{
myrbinom <- function(n,alpha){rbinom(n,1,1/(1:n))*((1:n)**alpha)}
data <- generate(randomgen=myrbinom,nmax=1000,M=500,argsgen=list(alpha=0.5))$data
critp <- criterion(data,epsilon=0.05,"p")$crit
critas <- criterion(data,epsilon=0.05,"as")$crit
p.as.plot(data,critp,critas,epsilon=0.05,nb.sp=10,mode="p")
}

\keyword{dplot} % Computations Related to Plotting
\keyword{iplot} % Interacting with Plots
\keyword{distribution} % Probability Distributions and Random Numbers
\keyword{htest} % Statistical Inference
