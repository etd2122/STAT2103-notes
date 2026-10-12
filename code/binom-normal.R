# Working with Binomial and Normal distributions
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# ------------------------------------------------------------
# Binomial distribution
# ------------------------------------------------------------

# Suppose we randomly sample 10 people, and define Y = number of people in
# sample who are left-handed. The probability of a random person being left-
# handed is 0.15.

# What is the probability that exactly one person in the sample is left-
# handed?

# R has a built in function for evaluating binomial probabilities:
dbinom(x=1, size=10, prob=0.15)

# What is the probability that at most 2 people are left-handed?

# (That means either 0, 1, or 2 people in the sample are left-handed)
dbinom(x=0, size=10, prob=0.15) + dbinom(x=1, size=10, prob=0.15) + dbinom(x=2, size=10, prob=0.15)

# We can add up the individual probabilities (above), or we could use the
# cumulative distribution function:
pbinom(q=2, size=10, prob=0.15)

# We might also be interested in the 95th percentile of the distribution. In
# other words, what is the smallest number k such that the probability of
# having at most k left-handed people is at least 0.95?

# We know from the previous example that 2 isn’t enough to get us to 95%
# cumulative probability. Is 3 enough?
pbinom(q=2, size=10, prob=0.15) #probability of at most 2 left handed
pbinom(q=3, size=10, prob=0.15) #probability of at most 3 left handed

# Yes, the probability of having at most 3 left-handed people in a sample of
# 10 is >= 0.95.

# Another way to get the 95th percentile is to use the built-in quantile
# function:
qbinom(p=0.95, size=10, prob=0.15)

# ------------------------------------------------------------
# sampling from the binomial distribution
# ------------------------------------------------------------

# R also has built-in functions for drawing random samples from a binomial
# distribution.

# Imagine flipping a fair coin 5 times. The sum of the 5 flips is
# Binomial(n=5, p=0.5).

# We can simulate flipping a fair coin 5 times:
sample(c("heads", "tails"), size=5, replace=TRUE, prob=c(0.5,0.5))

# Replace “heads” and “tails” with 1 and 0:
sample(c(0,1), size=5, replace=TRUE, prob=c(0.5, 0.5))

# Take the sum to count the number of “heads” in the 5 flips:
sum(sample(c(0,1), size=5, replace=TRUE, prob=c(0.5, 0.5)))

# The sum of the 5 flips is Binomial(n=5, p=0.5).

# R has a built in function for sampling from a binomial distribution

# Draw one sample from Binom(n=5,p=0.5)- i.e., flip a coin 5 times and count
# the number of heads
rbinom(n=1, size=5, prob=0.5) # "size" and "prob" are the parameters of the binomial distribution
                      #"n" is the number of samples we want to draw from the binomial distribution

# Imagine we repeat the 5-coin-flip experiment 10 times, and record the number
# of heads each time.

# From the probability distribution, E(# heads) = 2.5
y_values<- rbinom(n=10, size=5, prob=0.5) 
print(y_values)

# What are the sample mean and variance for these 10 observations?
mean(y_values)
sd(y_values)^2 #sample variance = sample standard deviation ^2

# We could repeat this entire exercise and get 10 new samples from the
# Binomial (10, 0.5) distribution:
y_values<-rbinom(n=10, size=5, prob=0.5)
mean(y_values)
sd(y_values)^2

# The expected value and variance of the probability distribution don’t
# change.

# But the properties of the sample data are different each time we draw a new
# random sample.

# We can also visually compare the sampled data to the underlying binomial
# distribution.

# We can make a bar graph of the true probability distribution. First,
# calculate the probability of each possible number of heads in 5 flips:
y_probs<-dbinom(x=0:5, size=5, prob=0.5) # "x" is the value for which you want to evaluate the probability, i.e. P(X=x)

#the notation x=0:5 evaluates the function at each value from 0 to 5

# Then create a bar graph of those values:
barplot(y_probs, names.arg=0:5, xlab="y", ylab="P(Y=y)")

# Make a frequency histogram of the sample data:
hist(y_values, xlab="y", breaks=0:5)

# Note- the “breaks” argument controls how many buckets your range of values
# gets split into. If you don’t include that argument, R usually does a good
# job of choosing this automatically.

# Histograms can have frequency on the Y axis, or relative frequency, i.e. the
# proportion of times that outcome came up.
hist(y_values, xlab="y", breaks=0:5, probability=TRUE)

# ------------------------------------------------------------
# Normal distribution
# ------------------------------------------------------------

# Suppose the population distribution of systolic blood pressure is
# Normal(120, 15^2)

# What does the probability distribution function look like?
curve(dnorm(x, mean=120, sd=15), from=70, to=170, ylab="p(x)")

# What is the probability that a randomly chosen person has blood pressure
# less than 115?
pnorm(q=115, mean=120, sd=15)

# By default, the “pnorm” function gives us the area under the curve, to the
# LEFT of the specified value.

# What if we want the area under the curve, to the RIGHT of the specified
# value?

# What is the probability that a randomly chosen person has blood pressure
# higher than 115?
1-pnorm(q=115, mean=120, sd=15)

# What is the probability that a randomly chosen person has blood pressure
# between 120 and 130? P(120 < X < 130) = P(X < 130) - P(X < 120)
xvals<-seq(from=70, to=130, by=0.01)
yvals<-dnorm(xvals, mean=120, sd=15)

par(mfrow=c(1,2))
curve(dnorm(x, mean=120, sd=15), from=70, to=170, ylab="p(x)")
polygon(c(min(xvals), xvals[xvals<=130], 130), c(0,yvals[xvals<=130], 0), col="cornflowerblue")

curve(dnorm(x, mean=120, sd=15), from=70, to=170, ylab="p(x)")
polygon(c(min(xvals), xvals[xvals<=130], 130), c(0,yvals[xvals<=130], 0), col="cornflowerblue")
polygon(c(min(xvals), xvals[xvals<=120], 120), c(0,yvals[xvals<=120], 0), col="orange")

# First we find the blue shaded area, then subtract off the orange shaded
# area:
pnorm(q=130, mean=120, sd=15) - pnorm(q=120, mean=120, sd=15)

# What is the 95th quantile of the blood pressure distribution? I.e. what is
# the smallest value b such that P(X<b) >= 0.95?

# In the binomial example about left-handedness, we could manually check each
# value to figure this out. Here, blood pressure is continuous, so it’s not
# feasible to find the value that way.
pnorm(q=130, mean=120, sd=15)
pnorm(q=140, mean=120, sd=15)
pnorm(q=145, mean=120, sd=15)

# Instead we use the built-in quantile function:
qnorm(p=0.95, mean=120, sd=15)

# Now let’s draw samples from the normal distribution.

# Sample 10 people’s blood pressure:
bp_samples<- rnorm(n=10, mean=120, sd=15)
bp_samples

# What are the sample average and standard deviation?
mean(bp_samples)
sd(bp_samples)

# We can visualize the sample data with a histogram:
hist(bp_samples, probability=TRUE, breaks=10, xlab="blood pressure (systolic)")

# With only 10 samples, it’s quite chunky, and doesn’t look much like the bell
# curve of the underlying probability distribution.

# What if we sample 100 people instead of 10?
set.seed(3218) 

bp_samples<-rnorm(n=100, mean=120, sd=15)
hist(bp_samples, breaks=15, probability=TRUE, xlab="blood pressure (systolic)")

# The histogram of 100 sampled data points is starting to look a bit more like
# the shape of the normal distribution.

# We can superimpose the probability distribution function on the histogram of
# sample values:
hist(bp_samples, breaks=15, probability=TRUE, xlab="blood pressure (systolic)")
curve(dnorm(x, mean=120, sd=15), from=70, to=170, add=TRUE)
