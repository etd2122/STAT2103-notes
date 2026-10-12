# simulating regression
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# Suppose we randomly sample 50 students and record their SAT score and first-
# year GPA
# this is the 'population data' we will sample from
# (this is a simulation exercise, in practice we do not have this)

academics<-read.csv(file="~/Documents/2025F/regression/notes/examples/academics.csv")

N<-dim(academics)[1]

# Simulate choosing 50 people from the population at random:
samples<- sample(1:N, size=50)

# Get their data values from the ‘population’
#take out the rows of the data frame corresponding to those 50 people

sample_data<-academics[samples,]

# The sample data for these 50 people is formatted as a data frame:
head(sample_data)

# We can plot the data for these 50 sampled people:
plot(x=sample_data$SAT, y=sample_data$GPA, xlab="SAT score", ylab="GPA", pch=19)
# xlab and ylab are the axis labels
# pch refers to what type of point is displayed on the scatter plot
# We changed it to make the points a filled-in solid color. This is not important.

# We can fit a regression line to this sample data, to estimate the true
# relationship between SAT scores and GPA:
est_model<-lm(GPA~SAT, data=sample_data)

# What is the least squares regression line for this data?
est_model$coefficients

# Draw this regression line on the scatter plot:
plot(x=sample_data$SAT, y=sample_data$GPA, xlab="SAT score", ylab="GPA", pch=19)
abline(est_model$coefficients, lwd=3, col=2)
# lwd controls the line width, i.e. makes the line thicker
# col controls the color, which can be stated as a number or the name of a color
# enclosed in quotation marks, e.g. col="red"

# We can also indicate the average values of X and Y in this sample. Let’s
# draw a line on the plot at the average SAT score and the average GPA.
plot(x=sample_data$SAT, y=sample_data$GPA, xlab="SAT score", ylab="GPA", pch=19)
abline(est_model$coefficients, lwd=3, col=2)

abline(v=mean(sample_data$SAT), lty=2)
# v means 'draw a vertical line at this value'
# lty controls the line type. line type 2 is a dotted line

abline(h=mean(sample_data$GPA), lty=2)
# h means 'draw a horizontal line at this value'

# Notice that the regression line passes through the point (\bar{x}, \bar{y})

# What if we collected a new random sample of students, and used their data to
# estimate the relationship between GPA and SAT score?
# choose the new students to sample
samples<- sample(1:N, size=50)

# obtain the rows of the data frame corresponding to those 50 people
sample_data<-academics[samples,]

# The least squares regression line for the new sample is :
newmodel<-lm(GPA~SAT, data=sample_data)
newmodel$coefficients

# The coefficients are similar to the regression line from the previous
# sample, but not identical.

# Plotting this new sample:
plot(x=sample_data$SAT, y=sample_data$GPA, xlab="SAT score", ylab="GPA", pch=19)
abline(newmodel$coefficients, lwd=3, col=2)

# If we indicate the average values of X and Y on the plot, we will see that
# the regression line for this sample also passes through (\bar{x},\bar{y}),
# the average values in this new sample.
plot(x=sample_data$SAT, y=sample_data$GPA, xlab="SAT score", ylab="GPA", pch=19)
abline(newmodel$coefficients, lwd=3, col=2)

abline(v=mean(sample_data$SAT), lty=2)
abline(h=mean(sample_data$GPA), lty=2)

# In fact, the least squares regression line always passes through the point
# (\bar{x}, \bar{y}), for any data.

# We could also make a plot showing both of the regression lines together, to
# compare them.
# start by generating a blank plot, with the right range of x and y axis values
plot(NULL, xlim=c(400, 1600), ylim=c(0,4), xlab='SAT score', ylab='GPA')

# NULL means there is no data being plotted
# xlim sets the lower and upper limits of the x axis
# ylim sets the lower and upper limits of the y axis

abline(est_model$coefficients, lwd=2)
abline(newmodel$coefficients, lwd=2, col="red")

# What if we continued drawing samples of 50 students, and fitting regression
# lines to their data?

# Let’s repeat this process 20 times, and save the estimated slope and
# intercept we get each time.
nrep<-20

# create a data frame full of zeros
# that we can store the intercepts and slopes in
# once we obtain them

regression_coefs<-data.frame('intercept'=rep(0, nrep), 'slope'=rep(0,nrep))


for(i in 1:nrep){
  # choose the new students to sample
  samples<- sample(1:N, size=50)

  # obtain the rows of the data frame corresponding to those 50 people
  sample_data<-academics[samples,]
  
  # fit regression model
  newmodel<-lm(GPA~SAT, data=sample_data)
  
  # save the coefficients of the new model
  regression_coefs[i,]<-newmodel$coefficients
}

# We can plot all 20 regression lines from the different data samples:
plot(NULL, xlim=c(400, 1600), ylim=c(0,4), xlab='SAT score', ylab='GPA')

for(i in 1:nrep){
  abline(coef = regression_coefs[i,])
}
