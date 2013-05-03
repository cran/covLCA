\name{covLCA}
\alias{covLCA}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Latent Class Models with Covariate Effects on Underlying and Measured Variables
}
\description{
Fits latent class models with covariate effects on underlying and measured variables. The measured variables are dichotomous or polytomous, all with the same number of categories.
}
\usage{
covLCA(formula1, formula2, data, nclass = 2, maxiter = 1000, tol = 1e-10, 
beta.start = NULL, alpha.start = NULL, gamma.start = NULL, beta.auto = TRUE, 
alpha.auto = TRUE, gamma.auto = TRUE, nrep = 1, verbose = TRUE, calc.se = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{formula1}{
The formula where the dependent variables are the manifest variables, grouped by \code{cbind()}, and the independent variables are the covariates for the latent class probabilities.
}
  \item{formula2}{
The formula where the dependent variables are the manifest variables, grouped by \code{cbind()}, and the independent variables are the covariates for the conditional probabilities.
}
  \item{data}{
a dataframe containing all variables appearing in \code{formual1} and \code{formula2}.  Manifest variables must contain only integer values, and must be coded with consecutive values from 1 to the maximum number of outcomes for each variable. All missing values should be entered as NA and all cases containing missing values (in the manifest variables or in the covariates) are removed before estimating the model.
}
  \item{nclass}{
the number of latent classes assumed in the model.
}
  \item{maxiter}{
the maximum number of iterations through which the estimation algorithm will cycle.
}
  \item{tol}{
A tolerance value for judging when convergence has been reached. When the one-iteration change in the estimated log-likelihood is less than \code{tol}, the estimation algorithm stops updating and considers the maximum log-likelihood to have been found.
}
  \item{beta.start}{
a vector of parameters \eqn{\beta_{jp}} to be used as the starting values for the estimation algorithm. There is one parameter for each pair latent class-covariate (the index of the covariate moving faster), except the last class, considered as the reference, for which \eqn{\beta_{Jp}=0 \forall p}. The default is \code{NULL}, leading either to an automatic search for ``reasonable'' initial values (when \code{beta.auto=TRUE}, the default) or to the generation of random starting values (when \code{beta.auto=FALSE}). Note that if \code{nrep} $>1$, then any user-specified \code{beta.start} values are only used in the first of the \code{nrep} attempts.
}
  \item{alpha.start}{
an \eqn{M \times L(K-1)} matrix of parameters \eqn{\alpha_{mlk}} to be used as the starting values for the estimation algorithm. Rows correspond to manifest variable \eqn{m}. Within each row, columns correspond to covariates \eqn{l} and categories of manifest variables \eqn{k} (except the last category, for which \eqn{\alpha_{mlK_m}=0}), the index of the latter moving faster. The default is \code{NULL}, leading either to an automatic search for ``reasonable'' initial values (when \code{alpha.auto=TRUE}, the default) or to the generation of random starting values (when \code{alpha.auto=FALSE}). Note that if \code{nrep} \eqn{>1}, then any user-specified \code{alpha.start} values are only used in the first of the \code{nrep} attempts.
}
  \item{gamma.start}{
an \eqn{M \times J(K-1)} matrix of parameters \eqn{\gamma_{mjk}} to be used as the starting values for the estimation algorithm. Rows correspond to manifest variable \eqn{m}. Within each row, columns correspond to latent classes \eqn{j} and categories of manifest variables \eqn{k} (except the last category, for which \eqn{\gamma_{mjK_m}=0}), the index of the latter moving faster. The default is \code{NULL}, leading either to an automatic search for ``reasonable'' initial values (when \code{gamma.auto=TRUE}, the default) or to the generation of random starting values (when \code{gamma.auto=FALSE}). Note that if \code{nrep} \eqn{>1}, then any user-specified \code{gamma.start} values are only used in the first of the \code{nrep} attempts.
}
  \item{beta.auto}{
logical, indicating whether \code{covLCA()} should calculate ``reasonable'' initial values for parameters \eqn{\beta}. If \code{TRUE}, the approach advised by Huang and Bandeen-Roche (2004) is applied: a standard latent class model assuming \code{nclass} latent classes is estimated, then each individual is assigned to a class with the posterior probabilities of class membership from this model, and finally a multinomial logistic regression model relating the latent classes to covariates \eqn{x} is fitted, whose coefficient estimates give initial estimates of \eqn{\boldsymbol{\beta}}. If \code{FALSE}, either random initial values are generated (if \code{beta.start=NULL}) or values provided by the user are used.
}
  \item{alpha.auto}{
logical, indicating whether \code{covLCA()} should calculate ``reasonable'' initial values for parameters \eqn{\alpha}. If \code{TRUE}, the approach advised by Huang and Bandeen-Roche (2004) is applied: \eqn{M} different multinomial logistic regression models for \eqn{(Y_{i1}, \mathbf{z}_{i1})}, \eqn{\ldots}, \eqn{(Y_{iM},\mathbf{z}_{iM})} are fitted and the corresponding estimated coefficients are initial values for parameters \eqn{\alpha}. If \code{FALSE}, either random initial values are generated (if \code{alpha.start=NULL}) or values provided by the user are used.
}
  \item{gamma.auto}{
logical, indicating whether \code{covLCA()} should calculate ``reasonable'' initial values for parameters \eqn{\gamma}. If \code{TRUE}, the approach advised by Huang and Bandeen-Roche (2004) is applied: \eqn{M} different multinomial logistic regression models for \eqn{(Y_{i1},\mathbf{z}_{i1})}, \eqn{\ldots}, \eqn{(Y_{iM}, \mathbf{z}_{iM})} are fitted and the corresponding estimated coefficients are initial values for parameters \eqn{\gamma}. If \code{FALSE}, either random initial values are generated (if \code{gamma.start=NULL}) or values provided by the user are used.
}
  \item{nrep}{
number of times the model is estimated, using different values of \code{beta.start}, \code{alpha.start} and \code{gamma.start}. The default is one. Setting \code{nrep}\eqn{>1} automates the search for the global (rather than just a local) maximum of the log-likelihood function. \code{covLCA()} returns the parameter estimates corresponding to the model with the greatest log-likelihood.
}
  \item{verbose}{
logical, indicating wheter \code{covLCA()} should output to the screen the results of the model.
}
  \item{calc.se}{
logical, indicating whether \code{covLCA()} should calculate the standard errors of the estimated parameters \eqn{\beta_{jp}}, \eqn{\alpha_{mlk}} and \eqn{\gamma_{mjk}}.
}
}
\details{
We denote individuals by \eqn{i} (\eqn{i=1,\ldots,N}), manifest variables (items) by \eqn{Y_m} (\eqn{m=1,\ldots,M}), levels of the manifest variables by \eqn{k} (\eqn{k=1,\ldots,K} ), the latent variable by \eqn{S} (\eqn{S=j} and \eqn{j=1,\ldots,J}).
There are two sets of covariates: those related with the latent class probabilities, \eqn{\mathbf{x_i}=(1,x_{i1},\ldots,x_{iP})^T}, and those which can have a direct effect on the manifest variables, \eqn{\mathbf{z_i}=(\mathbf{z_{i1}},\ldots,\mathbf{z_{iM}})} with \eqn{\mathbf{z_{im}}=(1,z_{im1},\ldots,z_{imL})^T}, \eqn{m=1,\ldots,M}. 
The parameters of the model are the latent class probabilities \eqn{\pi_j(\mathbf{x}'_i\boldsymbol{\beta})=P(S_i=j;\mathbf{x}_i)} and the conditional probabilities \eqn{p_{mkj}(\boldsymbol{\gamma}_{mj}+\boldsymbol{z}'_{im}\boldsymbol{\alpha}_m)=P(Y_{im}=k|S_i=j;\boldsymbol{z}_{im})}.

The model is
%%  ~~ If necessary, more details than the description above ~~
\deqn{P(\mathbf{Y_i}=\mathbf{y}|\mathbf{x}_i, \mathbf{z}_i)=P(Y_{i1}=y_{1},\ldots,Y_{iM}=y_M|\mathbf{x}_i, \mathbf{z}_i)}
                                                     \deqn{=\sum_{j=1}^{J} \left\{\pi_j(\mathbf{x}'_i\boldsymbol{\beta}) \prod_{m=1}^{M} p_{mkj}^{y_{imk}}(\boldsymbol{\gamma}_{mj}+\boldsymbol{z}'_{im}\boldsymbol{\alpha}_m)\right\}}
with \deqn{\log\left(\frac{\pi_j(\mathbf{x}'_i\boldsymbol{\beta})}{\pi_J(\mathbf{x}'_i\boldsymbol{\beta})}\right)= \mathbf{x}'_i\boldsymbol{\beta}_j \qquad i=1,\ldots,N ;\quad j=1,\ldots,(J-1)}
and \deqn{\log\left(\frac{p_{mkj}(\boldsymbol{\gamma}_{mj}+\mathbf{z}'_{im}\boldsymbol{\alpha}_m)}{p_{mKj}(\boldsymbol{\gamma}_{mj}+\boldsymbol{z}'_{im}\boldsymbol{\alpha}_m)}\right)=\gamma_{mkj}+\mathbf{z}'_{im}\boldsymbol{\alpha}_{mk}}
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
The output of function \code{covLCA()} is a list containing the following elements:
\item{llik}{The log-likelihood value of the estimated model.}
\item{attempts}{A vector containing the maximum loglikelihood values found in each of the \code{nrep} attempts to fit the model.}
\item{beta.start}{A vector containing the initial values for parameters \eqn{\beta} when such values were provided by the user (in \code{beta.start}) or when they were randomly generated (when \code{beta.start=NULL} and \code{beta.auto=FALSE}).}
\item{alpha.start}{A vector containing the initial values for parameters \eqn{\alpha} when such values were provided by the user (in \code{alpha.start}) or when they were randomly generated (when \code{alpha.start=NULL} and \code{alpha.auto=FALSE}).}
\item{gamma.start}{A vector containing the initial values for parameters \eqn{\gamma} when such values were provided by the user (in \code{gamma.start}) or when they were randomly generated (when \code{gamma.start=NULL} and \code{gamma.auto=FALSE}).}
\item{beta.auto}{Logical, indicating whether the user asked for ``reasonable'' initial estimates of parameters \eqn{\beta} to be automatically computed (with the argument \code{beta.auto}).}
\item{alpha.auto}{Logical, indicating whether the user asked for ``reasonable'' initial estimates of parameters \eqn{\alpha} to be automatically computed (with the argument \code{alpha.auto}).}
\item{gamma.auto}{Logical, indicating whether the user asked for ``reasonable'' initial estimates of parameters \eqn{\gamma} to be automatically computed (with the argument \code{gamma.auto}).}
\item{beta.initAuto}{A vector containing the initial values for parameters \eqn{\beta} when ``reasonable'' values are automatically computed (when \code{beta.auto=TRUE}).}
\item{alpha.initAuto}{A vector containing the initial values for parameters \eqn{\alpha} when ``reasonable'' values are automatically computed (when \code{alpha.auto=TRUE}).}
\item{gamma.initAuto}{A vector containing the initial values for parameters \eqn{\gamma} when ``reasonable'' values are automatically computed (when \code{gamma.auto=TRUE}).}
\item{probs}{An \eqn{N\times M\times K\times J} array containing the estimated conditional probabilities \eqn{\hat{p}_{imkj}=\hat{p}_{mkj}(\boldsymbol{\gamma}_{mj}+\mathbf{z}'_{im}\boldsymbol{\alpha}_m)}, where the first to fourth dimensions correspond to individuals, manifest variables, categories of manifest variables and latent classes, respectively.}
\item{prior}{An \eqn{N \times J} matrix containing the estimated latent class probabilities \eqn{\hat{\pi}_{ij}=\hat{\pi}_j(\mathbf{x}'_i\boldsymbol{\beta})}, where rows correspond to individuals and columns, to latent classes.}
\item{posterior}{An \eqn{N \times J} matrix containing the estimated posterior latent class probabilities \eqn{h_{ij}(\hat{\phi})}, where rows correspond to individuals and columns to latent classes.}
\item{predclass}{A vector of length \eqn{N} of predicted class memberships, by modal assignment.}
\item{P}{The respective size of each latent class, equal to the mean of the priors.}
\item{numiter}{The number of iterations required by the estimation algorithm to achieve convergence.}
\item{coeffBeta}{An \eqn{P\times J} matrix of estimated \eqn{\beta_{pj}}, where rows correspond to covariates and columns, to latent classes.}
\item{param.se}{A vector containing the standard error of each estimated parameter, in the following order: \eqn{\beta_{jp}}, \eqn{\gamma_{mjk}}, \eqn{\alpha_{mlk}} where the last index always moves faster.}
\item{param.V}{The covariance matrix of the coefficient estimates (in the same order as in \code{param.se}).}
\item{coeffGamma}{An \eqn{M \times J(K-1)} matrix of estimated parameters \eqn{\gamma_{mjk}}. Each row corresponds to manifest variable \eqn{m}. Within each row, columns correspond to latent classes \eqn{j} and categories of manifest variables \eqn{k} (except the last category, for which \eqn{\gamma_{mjK_m}=0}), the index of the latter moving faster.}
\item{coeffAlpha}{An \eqn{M \times L(K-1)} matrix of estimated parameters \eqn{\alpha_{mlk}}. Each row corresponds to manifest variable \eqn{m}. Within each row, columns correspond to covariates \eqn{l} and categories of manifest variables \eqn{k} (except the last category, for which \eqn{\alpha_{mlK_m}=0}), the index of the latter moving faster.}
\item{meanProbs}{An \eqn{M \times K \times J} array of estimated conditional probabilities evaluated at the sample mean of the covariates. The first to third dimensions correspond to manifest variables, categories of manifest variables and latent classes, respectively.}
\item{eflag}{Logical, error flag. \code{TRUE} if estimation algorithm needed to automatically restart with new initial parameters, otherwise \code{FALSE}. A restart is caused in the event of computational/rounding errors that result in nonsensical parameter estimates.}
\item{npar}{The number of estimated parameters.}
\item{aic}{Value of the AIC criterion for the estimated model.}
\item{bic}{Value of the BIC criterion for the estimated model.}
\item{Nobs}{Number of fully observed cases.}
\item{x}{A dataframe containing the covariates for the latent class probabilities.}
\item{z}{A dataframe containing the covariates for the conditional probabilities.}
\item{y}{A dataframe containing the manifest variables.}
\item{identifiability}{A list containing the eigenvalues and the inverse condition number of the matrices involved in conditions (iii') and (iv') of Theorem 1 (Local Identifiability) in Huang and Bandeen-Roche (2004).}
\item{maxiter}{The maximum number of iterations of the estimation algorithm.}
\item{resid.df}{The number of residual degrees of freedom, equal to the lesser of \eqn{N} and \eqn{MK}, minus \code{npar}.}
\item{time}{Computation time of model estimation.}
%% ...
}
\references{
Bertrand, A., Hafner, C.M. (2011) On heterogeneous latent class models with applications to the analysis of rating scores. Louvain-la-Neuve: Universite catholique de Louvain, Institute of Statistics, Biostatistics and Actuarial Sciences. Discussion paper 2011/28. Available at: \url{http://uclouvain.be/cps/ucl/doc/stat/documents/ISBADP2011-28_On_heterogeneous_latent_class_models...pdf}

Huang, G.-H., Bandeen-Roche K. (2004) Building an identifiable latent class model with covariate effects on underlying and measured variables. \emph{Psychometrika}, \bold{69}(1), 5--32.

Linzer, D.A., Lewis J. (2011) poLCA: Polytomous Variable Latent Class Analysis. R package version 1.3.1.

Linzer, D.A., Lewis J. (2011) poLCA: an R Package for Polytomous Variable Latent Class Analysis. \emph{Journal of Statistical Software}, \bold{42}(10), 1--29. \url{http://www.jstatsoft.org/v42/i10}
}
%\author{
%%  ~~who you are~~
%}
\note{
This function is an extension of the source code of the R package \code{poLCA} (Linzer and Lewis, 2011) to the methodology proposed by Huang and Bandeen-Roche (2004).
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
## 2 models for a subset of dataset election in package poLCA
library("poLCA")
data("election",package="poLCA")
election$GENDER <- factor(election$GENDER)
elec <- election[,c(1:3,7:12,16:17)]
elec <- na.omit(elec)
elec <- elec[1:200,]
## Model 1: 3 classes, 1 covariate for modelling latent class membership
fm1 <- cbind(MORALG,CARESG,KNOWG,MORALB,CARESB,
KNOWB)~PARTY
poLCA1 <- poLCA(formula=fm1,data=elec,nclass=3,nrep=10)

## Model 2: 3 classes, 1 covariate in the model for latent class membership,
## 1 covariate in the model for the manifest variables probabilities
fm2 <- cbind(MORALG,CARESG,KNOWG,MORALB,CARESB,
KNOWB)~1+PARTY
fm3 <- cbind(MORALG,CARESG,KNOWG,MORALB,CARESB,
KNOWB)~1+GENDER

covLCA1 <- covLCA(formula1=fm2,formula2=fm3,data=elec,nclass=3,
beta.auto=TRUE,gamma.auto=TRUE,alpha.auto=TRUE,maxit=10000)

\dontrun{## 2 models for dataset election in package poLCA
library("poLCA")
data("election",package="poLCA")
election$GENDER <- factor(election$GENDER)
elec <- election[,c(1:12,16:17)]
elec <- na.omit(elec)

## Model 1: 3 classes, 1 covariate for modelling latent class membership
fm1 <- cbind(MORALG,CARESG,KNOWG,LEADG,DISHONG,INTELG,MORALB,CARESB,
KNOWB,LEADB,DISHONB,INTELB)~PARTY
poLCA1 <- poLCA(formula=fm1,data=elec,nclass=3,nrep=10)

## Model 2: 3 classes, 1 covariate in the model for latent class membership,
## 1 covariate in the model for the manifest variables probabilities
fm2 <- cbind(MORALG,CARESG,KNOWG,LEADG,DISHONG,INTELG,MORALB,CARESB,
KNOWB,LEADB,DISHONB,INTELB)~1+PARTY
fm3 <- cbind(MORALG,CARESG,KNOWG,LEADG,DISHONG,INTELG,MORALB,CARESB,
KNOWB,LEADB,DISHONB,INTELB)~1+GENDER

covLCA1 <- covLCA(formula1=fm2,formula2=fm3,data=elec,nclass=3,
beta.auto=TRUE,gamma.auto=TRUE,alpha.auto=TRUE,maxit=10000)
}
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
