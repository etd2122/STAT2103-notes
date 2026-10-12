# Inference for simple linear regression
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# Suppose researchers want to study the development of language skills in
# infants. In a collection of 30 households, they observe the number of words
# spoken to the infant daily (in 1000s), and the infant’s vocabulary size at
# age 24 months (in number of words).

# Suppose they want to study the relationship between these two quantities,
# using the number of infant-directed words as the predictor, and vocabulary
# size as the response.

# ------------------------------------------------------------
# Constructing confidence intervals manually
# ------------------------------------------------------------

# Load the data:
load("~/Documents/2026F/regression/examples 2103/older/language.Rdata")

# Look at a scatter plot of the data:
plot(x=language$spoken_words, y=language$vocab_size, 
     xlab = "infant-directed words", ylab="vocabulary size")

# Fit a linear regression model to estimate the relationship:
est_model<-lm(vocab_size ~ spoken_words, data=language)

# What is the estimated slope?
est_model$coefficients

# The estimated slope is approximately 16.9.

# To perform inference, we need to calculate the variance of the residuals.

# How do we get the residuals? We could manually calculate the point on the
# line \hat{y}_i for each data point (x_i, y_i) and calculate the residual y_i
# - \hat{y}_i.

# But the lm( ) function also calculates the residuals for us.
est_model$residuals

# To get the variance of the residuals (i.e. \hat{\sigma}^2), we need to
# calculate the sum of the squared residuals, then divide by n-2 (which is 28
# in this case).
sum((est_model$residuals)^2)
sigma2_hat<- sum((est_model$residuals)^2)/28
print(sigma2_hat)

# The variance of the residuals is approximately 2004. This is our estimate
# \hat{\sigma}^2.

# We also need to know the sample variance of the observed x values.
Sx2<-var(language$spoken_words)
print(Sx2)

# If we want to construct a 95% confidence interval for the slope \beta_1, we
# need to find the 97.5th percentile of a t distribution with n-2=28 degrees
# of freedom:
qt(0.975, df=28)

# Combining the quantities we have calculated…
qt(0.975, df=28) * sqrt(sigma2_hat/((30-1)*Sx2))

# … a 95% confidence interval for the slope would be 16.9 \pm 5.7.
est_model$coefficients[2] + 
  c(-1,1)*qt(0.975, df=28) * sqrt(sigma2_hat/((30-1)*Sx2))

# What if we wanted a 90% confidence interval instead? All we need to change
# is the percentile of the t distribution that we are using.

# This time, we would need to find the 95th percentile.
qt(0.95, df=28)

# The 95th percentile is approximately 1.7, so the new confidence interval is:
est_model$coefficients[2] + 
  c(-1,1)*qt(0.95, df=28) * sqrt(sigma2_hat/((30-1)*Sx2))

# ------------------------------------------------------------
# Constructing confidence intervals automatically
# ------------------------------------------------------------

# Instead of calculating a confidence interval manually, we can use the built-
# in confint( ) function.

# To use the confint( ) function, we need to input the name that we saved our
# model as, and the level of confidence interval that we want.
confint(est_model)

# This tells us that a 95% confidence interval for the true intercept is
# approximately 119 to 197, and a 95% confidence interval for the true slope
# is approximately 11.1 to 22.6.

# We could ask for 90% confidence intervals instead:
confint(est_model, level=0.9)

# ------------------------------------------------------------
# Performing hypothesis tests manually
# ------------------------------------------------------------

# Suppose we wanted to test the null hypothesis that the true slope equals
# zero, against the alternative that it is not equal to zero, with a rejection
# threshold \alpha = 0.05.

# We can calculate the test statistic:

# \dfrac{\hat{\beta}_1 }{\sqrt{\dfrac{\hat{\sigma}^2}{(n-1) S_{x}^2}}}
est_model$coefficients[2] / sqrt(sigma2_hat/(29*Sx2))

# Then, we could check the probability of getting a value at least this far
# away from zero, in a t distribution with 28 degrees of freedom:
2*(1-pt(6.03538, df=28))

# The probability is very close to zero, smaller than our rejection threshold
# of 0.05. We would reject the null hypothesis, and conclude that there is
# evidence of a non-zero linear relationship between x and y.

# ------------------------------------------------------------
# Performing hypothesis tests automatically
# ------------------------------------------------------------

# Just like for confidence intervals, R will perform hypothesis tests for us.

# The model we fit to the data has a “summary” that we can display:
summary(est_model)

# We can also display just the portion of the summary that concerns the model
# coefficients (intercept and slope):
summary(est_model)$coefficients

# This summary of the coefficients reports the estimates of the intercept and
# slope in the first column.

# The second column is the standard error of the estimator.

# For each model coefficient (i.e. the intercept and the slope), R performs a
# two-sided test of the null hypothesis that the coefficient is equal to zero.

# For the intercept, the test is

# \[H_0: \beta_0 = 0 \qquad vs \qquad H_a: \beta_0 \neq 0 \]

# In the third column of the summary output, R reports the T value for that
# test, i.e.

# \[\dfrac{\hat{\beta}_0 - 0}{se(\hat{\beta}_{0})} = 8.315\]

# The p value for the test is in the fourth column: 4.77 \times 10^{-9}. With
# a rejection threshold of 0.05, we would reject the null hypothesis that the
# true intercept equals zero.

# The next row of the summary output is labeled “spoken_words”, which is the
# name of our x variable. The estimated slope is 16.876, and its standard
# error is se(\hat{\beta}_{1}) = 2.796.

# Just like for the intercept, R performs a test about the slope: \[ H_{0} :
# \beta_1 = 0 \qquad vs \qquad H_{a} : \beta_{1} \neq 0 \]

# The T value for that test is 6.035 (the value in the third column), and the
# p value for the test is 1.66 \times 10^{-6} (the value in the fourth
# column). With a rejection threshold of 0.05, we would reject the null
# hypothesis that the true slope equals zero.
