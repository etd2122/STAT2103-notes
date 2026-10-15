# prediction with linear models
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# ------------------------------------------------------------
# Fitting the model
# ------------------------------------------------------------

# Researchers record the rainfall and runoff volumes at a highway location in
# Texas on 15 different days. Load the measurements:
rain<-read.csv(file="~/Documents/2026F/regression/examples 2103/older/rain.csv")

# Take a quick look at the contents of the data:
head(rain)

# The data frame has a column called ‘rainfall’ and a column called ‘runoff’.
plot(x=rain$rainfall, y=rain$runoff, 
     xlab="rainfall volume", ylab = "runoff volume")

# Fit a linear regression model to estimate the relationship between rainfall
# volume and runoff volume:
est_model <- lm(runoff~rainfall, data = rain)

# Take a look at the model ‘summary’:
summary(est_model)

# The estimated slope is approximately 0.83, estimated intercept is approx
# -1.13.

# The output above includes two-sided hypothesis tests:

# H_{0}: \beta_1 = 0 \qquad vs \qquad H_{a}: \beta_{1} \neq 0

# The hypothesis test for the slope has a very small p value. There is
# evidence of a non-zero linear relationship between rainfall and runoff.

# \[ H_{0}: \beta_{0} = 0 \qquad vs \qquad H_{a}: \beta_{0} \neq 0 \]

# The hypothesis test for the intercept, however, has a large p value. With a
# rejection threshold of 0.05, we would fail to reject the hypothesis that
# \beta_{0}=0. Based on the observed data, the intercept could be zero.

# In context, that does make sense: an intercept of zero would mean there
# tends to be no water runoff from the highway on days with no rain.

# ------------------------------------------------------------
# Making predictions
# ------------------------------------------------------------

# Suppose we want to predict the runoff volume for a day with rainfall of 50.

# We could manually construct this from the estimated slope and intercept of
# the regression line:
## intercept + 50*slope

est_model$coefficients[1] + 50*est_model$coefficients[2]

# We can also use the predict( ) function.

# To use the predict( ) function, we specify the name of the model to use to
# make the predictions, and supply a new data frame containing the x values we
# want to make predictions for. The x variable in that data frame needs to
# have the same name as the x variable in the model.
new_rainfall <- data.frame('rainfall'=50)

y_pred <- predict(est_model, newdata = new_rainfall)
print(y_pred)

# We can also use the predict( ) function to generate predicted y values for
# multiple new x values at the same time. Suppose we want to predict the
# runoff volume for rainfall values 25, 50, and 75:
# to include multiple new x values, we enclose them in c( )

new_rainfall = data.frame('rainfall'=c(25,50,75))

predict(est_model, newdata = new_rainfall)

# This returns the predicted y value for each of the new x values we
# specified.

# ------------------------------------------------------------
# Intervals
# ------------------------------------------------------------

# Now suppose we’re interested in the average amount of runoff for days with
# 50 m^3 of rainfall.

# The predict( ) function will also give confidence intervals for that
# quantity.
predict(est_model, newdata= data.frame('rainfall'=50), 
        interval="confidence")

# The output includes the “fitted value” i.e. prediction, and the lower (lwr)
# and upper (upr) bounds of the confidence interval.

# This output tells us that the estimated runoff volume is 40.22, and that we
# are 95% confident that the true average runoff on days with rainfall of 50
# is between 37.3 and 43.2.

# By default, this function gives 95% confidence intervals. If we want a
# different level, we can specify that instead:
predict(est_model, newdata= data.frame('rainfall'=50), 
        interval="confidence", level = 0.99)

# Now the output includes a 99% confidence interval for the average runoff
# instead of 95%.

# Next, suppose we’re interested in the amount of runoff on an individual day
# with rainfall of 50. We describe this with a “prediction interval” instead
# of a confidence interval.

# The predict( ) function will also give prediction intervals. To get a
# prediction interval, change the “interval” option:
predict(est_model, newdata= data.frame('rainfall'=50), 
        interval="prediction", level = 0.99)

# We are 99% confident that the runoff volume on an individual day with
# rainfall of 50 will be between 23.9 and 56.5.

# Notice that the 99% prediction interval is wider than the 99% confidence
# interval. There is more uncertainty about the amount of runoff on an
# individual day, than about the average across days.

# What if we were interested in the amount of runoff on a day with 120m^3 of
# rainfall, instead?
mean(rain$rainfall)

# The average value of rainfall in the sample data was 53.2, close to the
# value we were considering previously (x=50).

# 120 is close to the maximum x value in the observed data set, so we are less
# confident about our ability to make predictions about runoff on days with
# 120m^3 of rainfall.
predict(est_model, newdata= data.frame('rainfall'=120), 
        interval="confidence", level = 0.95)

# The predicted amount of runoff is 98, and we are 95% confident that on days
# with rainfall of 120, the true average runoff is between 92 and 104.

# The width of this 95% confidence interval is 104 - 92 = 12.

# The 95% confidence interval for average runoff on days with rainfall of 50
# was 37.3 to 43.2. The width of that interval is only 5.9, much smaller
# compared to the confidence interval when x=120.

# Hypothetically, we could plug in an unreasonably large x value and get a
# prediction…
predict(est_model, newdata= data.frame('rainfall'=250), 
        interval="confidence", level = 0.95)

# A 95% confidence interval for runoff volume on days with rainfall=250 (much
# larger than the observed values) is approximately 190 to 221. The width of
# that interval is 31, much larger than either of the previous examples (x=50,
# x=120).

# ------------------------------------------------------------
# Simulations (optional section)
# ------------------------------------------------------------

# We can explore simulations to illustrate the confidence interval for the
# average y value.

# Above, we found the slope and intercept of the estimated regression line for
# the original data sample.
plot(x=rain$rainfall, y=rain$runoff, xlab="rainfall volume", ylab="runoff volume")
abline(est_model, lwd=3)
legend("bottomright", legend=c("est regression line"), lty=1, col=1, bty='n')
abline(v=50, col="red", lty=2, lwd=3)

# With this estimated regression line, the predicted runoff volume on a day
# with rainfall of 50 was 40.22.

# We can imagine collecting a NEW sample of 15 measurements, and fitting a new
# regression line:
# sample a new 15 measurements from the population
# assuming we have a database of the entire population of measurements
# for purposes of illustration



# choose the points to sample
samples<- sample(1:N, size=15)

# extract their data values
sample_data<-rain_population[samples,]

# fit a regression line to the new sample data
new_model<-lm(runoff ~ rainfall, data= sample_data)

# Based on this new sample data, what is our estimate of the runoff when
# rainfall = 50?
y_pred_new <- predict(new_model, newdata=data.frame('rainfall'=50))
print(y_pred_new)

# The prediction is slightly different now.

# We can plot the two different estimated regression lines together to
# illustrate this:
plot(NULL, xlim=c(0,130), ylim=c(0,100), xlab="rainfall volume", ylab="runoff volume")
abline(est_model, lwd=3, col="cornflowerblue")
abline(new_model, lwd=3, col="orange")
legend("bottomright", legend=c("first sample", "second sample" ), lty=1, col=c("cornflowerblue", "orange"), bty='n')
points(x=c(50,50), y=c(y_pred, y_pred_new), cex=1.2, pch=20)

# Based on the two different data samples, the point on the regression line
# for x=50 varies slightly.

# Next, imagine taking many different samples of 15 measurements, and fitting
# a regression line to each of them. Each of those regression lines will have
# a slightly different y value for x=50.
nrep<-20

# create a data frame full of zeros
# that we can store the intercepts and slopes in
# once we obtain them
# and a vector full of zeros, to store the predicted y values for x=50

regression_coefs<-data.frame('intercept'=rep(0, nrep), 'slope'=rep(0,nrep))

y_preds<-rep(0, length=nrep)


for(i in 1:nrep){
  # draw the new samples
  samples<- sample(1:N, size=15)

  # obtain the rows of the data frame corresponding to those samples
  sample_data<-rain_population[samples,]
  
  # fit regression model
  newmodel<-lm(runoff~rainfall, data=sample_data)
  
  # save the coefficients of the new model
  regression_coefs[i,]<-newmodel$coefficients
  
  # save the prediction for x=50
  
  y_preds[i]<-predict(newmodel, newdata = data.frame('rainfall'=50))
}

# The point on the line for x=50 represents our estimate of the average runoff
# on days with rainfall of 50.

# The red dots are the estimated average runoff, estimated in each of the 20
# different random data samples.
plot(NULL, xlim=c(0, 100), ylim=c(0, 130), xlab="rainfall", ylab="runoff")
abline(v=50, lty=2, col="gray")
for(i in 1:nrep){
  abline(coef = regression_coefs[i,])
}
points(x=rep(50, nrep), y=y_preds, col="red", pch=20)

# We can also zoom in to see the points more clearly:
plot(NULL, xlim=c(45, 55), ylim=c(25, 55), xlab="rainfall", ylab="runoff")
abline(v=50, lty=2, col="gray")
for(i in 1:nrep){
  abline(coef = regression_coefs[i,])
}
points(x=rep(50, nrep), y=y_preds, col="red", pch=20)

# The variability in the red dots corresponds to the confidence interval for
# the true average runoff on a day with rainfall of 50.
