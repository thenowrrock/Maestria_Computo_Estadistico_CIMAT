\name{check.convergence}
\alias{check.convergence}
\title{Check convergence}
\description{This function enables one to investigate the four classical
  modes of convergence on simulated data: in probability, almost surely,
in r-th mean and in law.}
\usage{
check.convergence(nmax,M,genXn,argsXn=NULL,mode="p",epsilon=0.05,r=2,nb.sp=10,
  density=FALSE,densfunc=dnorm,probfunc=pnorm,tinf=-3,tsup=3,plotfunc=plot,...)
}

\arguments{
	\item{nmax}{ number of points in each sample path.}
	\item{M}{ number of sample paths to be generated.}
	\item{genXn}{ a function that generates the Xn-X values, or only the Xn values in the law case.}
	\item{argsXn}{ a list of arguments to \code{genXn}.}
	\item{mode}{ a character string specifying the mode of
	convergence to be investigated, must be one of "p" (default), "as", "r" or "L".}
	\item{epsilon}{ a numeric value giving the interval endpoint.}
	\item{r}{ a numeric value (r>0) if convergence in r-th mean is to be studied.}
	\item{nb.sp}{ number of sample paths to be drawn on the left plot.}
	\item{density}{ if density=TRUE, then the plot of the density of X and the histogram of Xn is returned. If density=FALSE, then the plot of the distribution function F(t) of X and the empirical distribution Fn(t) of Xn is returned.}
	\item{densfunc}{ function to compute the density of X.}
 	\item{probfunc}{ function to compute the distribution function of X.}
 	\item{tinf}{ lower limit for investigating convergence in law.}
 	\item{tsup}{ upper limit for investigating convergence in law.}
 	\item{plotfunc}{ R function used to draw the plot: for example \code{plot} or \code{points}.}
 	\item{...}{ optional arguments to \code{plotfunc}.}
       }

       
\details{
The objective of this function is to investigate graphically the convergence of some
random variable Xn to some random variable X. In order to use it, you
should be able to provide generators of Xn and X (or of Xn-X). The four modes of
convergence that you can try are: in probability, almost surely, in r-th
mean and in law. For the convergence in law, we compute \eqn{$\hat(l)_n(t)=|\hat{F}_n(t)-F(t)|$}{hat(l)_n(t)=|\hat{F}_n(t)-F(t)|}
for ten values equally distributed between \code{tinf} and \code{tsup}.
}


\references{Lafaye de Micheaux, P. (\email{plafaye@club.fr}), Liquet, B. "Understanding Convergence Concepts: a Visual-Minded and Graphical Simulation-Based Approach", The American Statistician , submitted.}


\author{P. Lafaye de Micheaux and B. Liquet}
    

\seealso{
  \code{\link{criterion}}, \code{\link{generate}}, \code{\link{investigate}},
   \code{\link{law.plot2d}}, \code{\link{law.plot3d}}, \code{\link{p.as.plot}}, 
  \code{\link{visualize.crit}}, \code{\link{visualize.sp}}
}


\examples{

\dontrun{

####################### Exercise 3 ##############################
# Let X1, X2, ..., Xn be independent random variables such that #
# P[Xn=sqrt(n)]=1/n and P[Xn=0]=1-1/n                           #
# Does Xn converges to 0 in 2-th mean? in probability?          #
#################################################################

       options(example.ask=FALSE)

       pnotrgen<-function(n){rbinom(n,1,1/(1:n))*sqrt(1:n)}

       check.convergence(nmax=1000,M=500,genXn=pnotrgen,mode="r",r=2)
       legend(100,6,legend=expression(hat(e)["n,2"]),lty=1)
       tt3.1 <<- check.convergence(nmax=1000,M=500,genXn=pnotrgen,mode="p")

}

}


\keyword{dplot} % Computations Related to Plotting
\keyword{iplot} % Interacting with Plots
\keyword{distribution} % Probability Distributions and Random Numbers
\keyword{htest} % Statistical Inference
