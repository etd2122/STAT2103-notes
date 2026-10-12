# simulating regression, part 2
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# Suppose the population relationship between X and Y is described by

# \[y = 150 + 17.5x + \varepsilon,\]

# where \[\varepsilon \sim N(0,\sigma^2).\]

# If we specify a value of \sigma^2, we can simulate drawing sample
# observations from the population.

# Suppose \sigma^2 = 100.
# model parameters
b0<-150
b1<-17.5

sigma<-10

# We can sample an observation by first choosing an x value (could choose a
# specific value, or generate a random number).
# 'runif' draws a (r)andom sample, from a (unif)orm distribution
# which just means that every value in the specified range is equally likely

x<-runif(n=1, min=1, max=12)
x

# For this value of x, what is the expected value of y? The expected value
# corresponds to the point on the line:
b0+b1*x

# On average, for that value of x, we expect this value of y.

# We can sample an observation by also sampling a value for the random error
# term \varepsilon_i \sim N(0,10^2):
y <- b0 + b1*x + rnorm(n=1, mean=0, sd=sigma)
print(y)

# We can plot the line for the true population relationship, and display our
# simulated data point with it:
plot(NULL, xlim=c(0,12.5), ylim=c(0,500), xlab="x", ylab="y")
abline(a=b0, b=b1)
points(x,y, pch=16, cex=2)

# We can simulate sampling a new data point in the same fashion:
x_new<-runif(n=1, min=1, max=12)

y_new <- b0+b1*x_new + rnorm(n=1, mean=0, sd=sigma)
plot(NULL, xlim=c(0,12.5), ylim=c(0,500), xlab="x", ylab="y")
abline(a=b0, b=b1)
points(x,y, pch=16, cex=2)
points(x_new, y_new, pch=16, cex=2)

# We can repeat this several times to simulate drawing a sample data set from
# this population model:
n_samp<-50

# draw 'n_samp'-many x values
x_samples<-runif(n=n_samp, min=1, max=12)

# calculate the corresponding y_hat values,
# i.e. the y coordinate of the point on the line,
# and add randomly-sampled error terms to those values

y_samples<-b0 + b1*x_samples + rnorm(n=n_samp, mean=0, sd=sigma)

# We can plot the simulated sample data together with the true population
# regression line:
plot(NULL, xlim=c(0,12.5), ylim=c(0,500), xlab="x", ylab="y")
abline(a=b0, b=b1)

points(x_samples, y_samples, cex=1.75)

legend("bottomright", legend=c("true pop. relationship"), lty=1, bty='n')

# We can also find the least squares regression line for the sample data:
est_model<-lm(y_samples~x_samples)
print(est_model)

# We can add the least squares regression line to the plot:
plot(NULL, xlim=c(0,12.5), ylim=c(0,500), xlab="x", ylab="y")
abline(a=b0, b=b1)

points(x_samples, y_samples)
abline(est_model$coefficients, col=2)

legend("bottomright", legend=c("true pop. relationship", "est. line"), lty=1:2, bty='n', cex=0.8)

# The estimated regression line is very close to the line that decribes the
# true population relationship.

# What if we change the model we are simulating drawing observations from?

# We will keep the slope and intercept the same, but change the variance of
# the error terms.

# \[y = 150 + 17.5x + \varepsilon\] \[\varepsilon \sim N(0, 50^2)\]

# The standard deviation of the error terms is now 50 instead of 10.

# We can simulate drawing several observations in the same way as before:
n_samp<-50

# draw 'n_samp'-many x values
x_new<-runif(n=n_samp, min=1, max=12)

# calculate the corresponding y_hat values,
# i.e. the y coordinate of the point on the line,
# and add randomly-sampled error terms to those values

y_new<-b0 + b1*x_samples + rnorm(n=n_samp, mean=0, sd=50)
plot(NULL, xlim=c(0,12.5), ylim=c(0,500), xlab="x", ylab="y", main="sampled data, sigma=50")
#abline(a=b0, b=b1)

points(x_new, y_new)

legend("bottomright", legend=c("true pop. relationship"), lty=1, bty='n', cex=0.8)

# Compared to before, the data points are spread out more around the line.

# Increasing the variance of the error terms means that on average, the errors
# tend to be larger, and the data points are more spread out around the line
# like this.

# We can plot the simulated data with sigma = 10 and sigma = 50 together to
# compare them more directly:
plot(NULL, xlim=c(0,12.5), ylim=c(0,500), xlab="x", ylab="y", main="sampled data, different error variance")
abline(a=b0, b=b1)

points(x_samples, y_samples, col="gray", pch=16, cex=1.75)
points(x_new, y_new)

legend("bottomright", legend=c("samples, sigma=10", "samples, sigma=50", "true pop. relationship"), lty=c(NA, NA, 1), col=c("gray", "black", "black"), pch=c(16, 1, NA), bty='n', cex=0.8)

# How do the estimated regression lines compare for the two simulated data
# sets? The true slope and intercept are the same in both cases.
newmodel<-lm(y_new~x_new)
print(newmodel)

# The estimated slope and intercept were much closer to the truth in the model
# with smaller error term variance.
plot(NULL, xlim=c(0,12.5), ylim=c(0,500), xlab="x", ylab="y", main="sampled data, different error variance")
abline(a=b0, b=b1, lwd=4, col="gray")

abline(est_model$coefficients, col="cornflowerblue", lwd=4, lty=2)
abline(newmodel$coefficients, col="orange", lwd=4, lty=2)

legend("bottomright", legend=c("est. line, sigma=10", "est. line, sigma=50", "true pop. relationship"), lty=1, col=c("cornflowerblue", "orange", "black"), bty='n', cex=0.8)

# This might not be too surprising: when data points are more spread out
# around the line, it can be harder to estimate the true line as precisely.
