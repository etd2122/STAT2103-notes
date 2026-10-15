# R squared and correlation
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# What is R^{2}? Consider the following example data set.
plot(x, y, xlim=c(0.5, 5.5), ylim=c(-5, 10))
abline(model1, lwd=3)
legend("bottomright", legend=c("least squares \n regression line"), 
       lty=1, lwd=2, bty='n', cex=0.8)

# The cor( ) function gives the sample correlation between a specified set of
# x and y values.
cor(x,y)

# This is a relatively large correlation. For a relationship between a single
# predictor variable x and response y, the R^{2} value can be obtained by
# squaring the correlation value.
cor(x,y)^2

# An R^{2} value of 0.7 means that in the fitted linear model, 70% of the
# variation in the observed y values is explained by the difference in x
# values.

# Another way to calculate the R^{2} value is by calculating the sum of
# squared residuals from the fitted model, dividing by the sum of squared
# deviations of the y variable from its mean, and subtracting that ratio from
# 1.
# amount of y variation not explained by the linear model
sum(model1$residuals^2)
# total variation in y
sum((y-mean(y))^2)
# percentage of y variation not explained by the model
sum(model1$residuals^2)/sum((y-mean(y))^2)
# percentage of y variation that IS explained by the model
1-sum(model1$residuals^2)/sum((y-mean(y))^2)

# The summary output of the linear regression model also provides this value
# automatically.
summary(model1)

# It is the value labeled ``Multiple R-squared” in the second-to-last line.

# An R^{2} value of 0.7 is relatively high. What would a model with a lower
# value look like?
plot(x2, y2, xlim=c(0.5, 5.5), ylim=c(-10, 15), pch=16)
abline(model2, lwd=3)
legend("topleft", legend=c("least squares \n regression line"), 
       lty=1, lwd=2, bty='n',cex=0.8)

# For this new data set, the correlation is lower:
cor(x2,y2)

# And the R^{2} value is lower:
summary(model2)

# We can plot the two data sets side by side to see how they differ visually:
par(mfrow=c(1,2))
plot(x,y, main="higher correlation", 
     xlim=c(0.5, 5.5), ylim=c(-10,15), pch=20)
abline(model1)
plot(x2,y2, xlab="x", ylab="y", main = "lower correlation", 
     xlim=c(0.5, 5.5), ylim=c(-10,15), pch=20)
abline(model2)

# When displayed over the same range of x- and y-axis values, it is clear that
# the data points are more spread out around the line in the second example,
# with the lower R^{2} value.

# This method of calculating R^{2} and the correlation between x and y
# specifically measures the strength of linear associations between the two
# variables.

# In both of the previous examples, the association between x and y was
# linear, but the strength of the association differed.

# What happens when the association between x and y is NOT linear?
plot(x3, y3, xlim=c(0.5, 5.5), ylim=c(-5, 10),
     xlab="x", ylab="y")
abline(model3, lwd=3)
legend("topleft", legend=c("least squares \n regression line"),
       lty=1, lwd=2, bty='n')

# Visually, there is clearly an association between x and y, and the
# association appears to be fairly strong.

# But the least squares regression line does not capture that relationship,
# because the association is not linear.

# The correlation between x and y is low:
cor(x3, y3)

# And the R^{2} value is close to zero:
summary(model3)

# A low R^{2} can occur in scenarios where there is a weak linear association
# between predictor and response, and also in scenarios where the association
# between predictor and response is NON-linear.
