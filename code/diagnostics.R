# Diagnostics and Remedial Measures
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# ------------------------------------------------------------
# Example 1
# ------------------------------------------------------------

# Start by looking at a scatter plot of the data, x and y.
plot(x,y)

# The relationship between x and y appears to be non-linear. It is not obvious
# whether the y values are more spread out for different values of x.

# What do the residuals from a fitted linear regression model look like?
model1<-lm(y~x)
plot(x=x, y=model1$residuals, ylab="residual")
abline(h=0)

# There is a clear pattern in the residuals: they tend to be negative for very
# small and very large values of x, and positive in the middle.

# Both plots suggest that the true relationship is not linear.

# Because we aren’t sure if the error terms have constant variance or not,
# let’s try transforming the x variable. (Transforming y changes how spread
# out the y values are.)

# In general, popular transformations include log and square root.
plot(sqrt(x), y)

# This looks better, but the relationship still looks a bit curved rather than
# linear.
model2<-lm(y~sqrt(x))

plot(sqrt(x), model2$residuals, ylab="residual")
abline(h=0)

# If we try fitting a model to (sqrt(x), y), the residuals plot indicates that
# we haven’t fixed the non-linearity problem. The residuals still have an
# obvious pattern depending on the value of x.

# We can try a different transformation of x:
plot(log(x), y)

# The relationship between log(x) and y looks linear. What happens when we fit
# a linear regression to log(x) and y?
model3<-lm(y~log(x))
plot(log(x), model3$residuals, ylab="residual")
abline(h=0)

# Using log(x) instead of x, the residuals from the fitted linear model look
# randomly scattered around zero, and appear to have similar variance across
# different values of log(x). This is satisfactory.

# ------------------------------------------------------------
# Example 2
# ------------------------------------------------------------

# Start by looking at a scatter plot of the data, x and y.
plot(x,y, ylim=c(-2,20))

# Based on the scatter plot, it looks like the relationship between x and y
# may be somewhat curved, rather than a straight line. Not extremely clear.

# Suppose we fit a linear model to this x and y data. What do the residuals
# from that model look like?
model1<-lm(y~x)
plot(x=x, y=model1$residuals, xlab="x", ylab="residual")
abline(h=0)

# If the model assumptions were correct, the residuals should be scattered
# evenly above and below zero, across all values of x, and should have similar
# magnitude for all values of x.

# That does not seem to be the case here. It looks like the residuals for
# small values of x are mostly positive, and mostly small in value. The
# residuals are much more spread out at larger values of x, which should not
# happen when the model assumptions are correct.

# There are two potential issues here: violation of linearity, and non-
# constant variance of the error terms.

# Idea: try transforming x and/or y, and fitting a new model to the
# transformed variables, to reflect a non-linear relationship.

# Popular transformations to try: log (of x, or y, or both), square
# root/squared

# Try taking the log of x:
plot(log(x), y)

# That didn’t help- relationship between log(x) and y is nonlinear.

# What about log of y?
plot(x, log(y))

# The relationship between x and log(y) doesn’t look linear either.

# What about taking the square root of y?
plot(x, sqrt(y))

# This actually does look more like a linear relationship. Let’s try fitting a
# model to x and sqrt(y).
model2<-lm(sqrt(y)~x)
plot(x, sqrt(y), xlab="x", ylab="sqrt y")
abline(model2)

# How does the plot of the residuals look now?
plot(x, y=model2$residuals, ylab="residual")
abline(h=0)

# The residuals now look more evenly scattered around zero. There is less of
# an obvious pattern in the residuals based on the value of x. This is
# satisfactory.

# ------------------------------------------------------------
# Example 3
# ------------------------------------------------------------
plot(x,y)

# Non-linear relationship between x and y.

# Try replacing y with log(y):
plot(x, log(y))

# Relationship still non-linear.

# Try replacing x with log(x):
plot(log(x), y)

# Still non-linear.

# Try log(x) and log(y)
plot(log(x), log(y))

# This looks better. Try fitting a linear model.
model1<-lm(log(y)~log(x))

plot(x=log(x), y=model1$residuals, ylab="residual")
abline(h=0)

# The residuals appear to be evenly scattered around zero, with no clear
# pattern. Nothing in this plot is concerning.

# ------------------------------------------------------------
# Example 4
# ------------------------------------------------------------

# Start by looking at a scatter plot of the data, x and y.
plot(x,y, ylim=c(-3, 25))

# It seems like the relationship between x and y IS linear, but the y values
# are more spread out at larger values of x.
model1<-lm(y~x)

plot(x, y, ylim=c(-3, 25))
abline(model1)

# What does a plot of the residuals look like for the linear regression model?
plot(x=x, y=model1$residuals, ylab="residual")
abline(h=0)

# There appear to be a roughly equal number of positive and negative residuals
# at any x value, but the residuals tend to be larger in magnitude for larger
# values of x.

# This suggests the error terms in the true model do NOT all have the same
# variance.

# Transforming the x or y variables will typically not be useful in cases like
# this, because the relationship between x and y already appears to be linear.

# What can we do in this case?

# Still ok to use least squares estimates of slope and intercept, and use
# those to make predictions.

# But we shouldn’t use the usual confidence intervals and hypothesis tests
# (for any aspect of the model).

# ------------------------------------------------------------
# Example 5
# ------------------------------------------------------------

# Start by looking at a scatter plot of the data, x and y.
plot(x,y, xlim=c(2.05,3.1), ylim=c(6,13))

# The relationship between x and y looks roughly linear.

# If we fit a linear regression model to x and y, what do the residuals look
# like?
model1<-lm(y~x)

plot(x, model1$residuals, ylab="residual")
abline(h=0)

# The residuals look randomly scattered above and below zero.

# Suppose the data consists of sequential observations, e.g. measurements
# taken in order over time.

# How do the residuals look, plotted against the index? If each data point
# (x_i, y_i) is a measurement from day i, we may be interested in plotting the
# residuals with i itself (the index) on the x axis.
plot(x=1:length(x), y=model1$residuals, xlab="Observation index", ylab="residual", type="l")
points(1:length(x), model1$residuals)
abline(h=0)

# We tend to get clusters of several positive residuals in a row, or several
# negative residuals in a row. This suggests that the errors may be positively
# correlated.

# We could also look at a plot of the lagged residuals. On the x axis we put
# the residual for day i, and on the y axis the residual for the following
# day. If the values had no association, this plot would look like a symmetric
# round blob.
n<-length(x)
plot(x=model1$residuals[1:(n-1)], y=model1$residuals[2:n], xlab="residual i", ylab="residual i+1")

# This plot supports our suspicion that the error terms may be correlated.

# What are the implications?

# The estimated slope and intercept are still valid, and using the fitted
# regression line to make predictions is also acceptable.

# Confidence intervals and hypothesis tests related to the model
# (coefficients, predictions) are not correct.

# Alternative types of models exist for this situation, but we have not
# learned about them yet.

# ------------------------------------------------------------
# Example 6
# ------------------------------------------------------------
plot(x,y)

# The relationship between x and y looks roughly linear.
model1<-lm(y~x)

plot(x, model1$residuals, ylab="residual")
abline(h=0)

# The residuals from the fitted model seem to be evenly spread above and below
# zero, and are not obviously different in magnitude for different values of
# x.

# However, in this example the residuals do not look like they follow a normal
# distribution.
hist(model1$residuals, probability=TRUE, main = "Histogram of residuals", xlab="residual")

# Q-Q plot can also be used to assess normality
plot(model1, which=2)

# Points on the Q-Q plot deviate from a straight line, which indicates
# possible violation of normality assumption.

# What are the implications?

# Estimated slope and intercept are still valid, and using the fitted
# regression line to make predictions is also acceptable.

# Technically, confidence intervals and hypothesis tests related to the model
# are not correct…

# …but in practice, everything except prediction intervals for a new y value
# are probably close to correct.
