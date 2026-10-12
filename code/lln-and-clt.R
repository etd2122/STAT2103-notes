# Law of Large Numbers and Central Limit Theorem
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# ------------------------------------------------------------
# STAT 2103
# ------------------------------------------------------------

# ------------------------------------------------------------
# Law of Large Numbers
# ------------------------------------------------------------

# Suppose the overall distribution of systolic blood pressure for adults in
# the US is approximately Normal(mean=120, sd=10).

# For any individual person, systolic blood pressure might be near 120, or
# above or below.

# We can randomly sample one person and measure their systolic blood pressure:
set.seed(6292)
x<-rnorm(n=1, mean=120, sd=10)
print(x)

# Instead, we could go out and measure the blood pressure of 5 randomly
# selected people, and record the average:
set.seed(6292) #setting the "seed" makes the random number generator 
            # give you the same values
            # every time you run this chunk of code

x<- rnorm(n=5, mean=120, sd=10) #this simulates sampling 5 people

print(x)
print(mean(x)) #this is the average of the sample

# The average for those randomly selected 5 people is roughly 126.

# What if we randomly select another 5 people and take the average of their
# blood pressure measurements?
x<- rnorm(n=5, mean=120, sd=10) #this simulates sampling 5 people

print(x)
print(mean(x)) #this is the average of the sample

# For this new random sample of 5 people, the average blood pressure was
# slightly different.

# Now, what if we keep doing this many times? Collect many different random
# samples of 5 people, and record the averages. What values of the sample
# average do we tend to get?
n_repetitions<- 200 # let's repeat the 5-person-sample exercise 200 times

sample_means<-rep(0,n_repetitions) #create a vector to store our 200 sample means

for(i in 1:n_repetitions){
  sample_means[i] <- mean(rnorm(n=5, mean=120, sd=10))
}

# The ``for loop” in this chunk does the following: for each of the 200
# repetitions we want to perform, draw a sample of 5 people’s blood pressure,
# then record the average, and store it in the “sample_means” vector. At the
# end, we have 200 sample means, each of which is the average blood pressure
# of a sample of 5 randomly-selected people.

# We can visualize the results with a histogram:
hist(sample_means, xlab="Average BP of 5 people", xlim=c(105, 135))

# What if, instead of taking 5 person samples, we take 20 person samples? That
# is, we randomly select 20 people, measure their blood pressure, and record
# the average.

# We can simulate one repetition of this process:
x <- rnorm(n=20, mean=120, sd=10)
print(x) #this prints all 20 of the blood pressure values
print(mean(x)) #this prints the sample average for the 20-person-sample

# We can repeat the above, drawing a new sample of 20 people:
x <- rnorm(n=20, mean=120, sd=10)
print(mean(x)) #this prints the sample average for the 20-person-sample

# Then, like above, we can imagine repeating this process, taking many
# different samples of 20 people, and recording the sample average for each
# sample:
n_repetitions<- 200 # repeat the 20-person-sample exercise 200 times

sample_means<-rep(0,n_repetitions) #create a vector to store our 200 sample means

for(i in 1:n_repetitions){
  sample_means[i] <- mean(rnorm(n=20, mean=120, sd=10))
}

# … and visualize the results with a histogram:
hist(x=sample_means, xlab="Average BP of 20 people", xlim=c(105, 135))

# Compared to the example with 5-person-samples, 20-person-samples tend to
# produce sample averages that are clustered more closely around 120, which is
# the average of the overall population.

# Taking this even further, what would it look like with 1000 person samples?
n_repetitions<- 200 # repeat the 20-person-sample exercise 200 times

sample_means<-rep(0,n_repetitions) #create a vector to store our 200 sample means

for(i in 1:n_repetitions){
  sample_means[i] <- mean(rnorm(n=1000, mean=120, sd=10))
}

hist(sample_means, xlab="Average BP of 1000 people", xlim=c(105, 135))

# The sample average blood pressure of 1000 people tends to be very close to
# the population average. For a sample of 1000 people, it’s rare for the
# sample average to be less than 118 or more than 122.

# (back to board)

# ------------------------------------------------------------
# Distribution of the Sample Average
# ------------------------------------------------------------

# Because blood pressure is normally distributed with mean 120 and standard
# deviation 10, the average blood pressure of a random sample of 5 people is
# also normally distributed, with mean 120 and standard deviation 10/sqrt(5).

# We can generate a large number of 5-person-samples and take their averages,
# like we did above, and compare it to the normal distribution with mean 120
# and standard deviation 10/sqrt(5)
n_repetitions<- 2000 # let's repeat the 5-person-sample exercise 2000 times

sample_means<-rep(0,n_repetitions) #create a vector to store our 2000 sample means

for(i in 1:n_repetitions){
  sample_means[i] <- mean(rnorm(n=5, mean=120, sd=10))
}
hist(sample_means, probability=TRUE, xlab="Average BP of 5 people") 
#this is a histogram of our 2000 observed sample averages

curve(dnorm(x, mean=120, sd=10/sqrt(5)), add=TRUE)
#this is the curve of the normal distribution probability density function

# ------------------------------------------------------------
# Central Limit Theorem
# ------------------------------------------------------------

# Next let’s consider a variable whose population distribution is NOT normal:
# income. In the US, the population distribution of adults’ income is skewed,
# with a long right tail (a small number of people with very large incomes).

# Suppose the expected value is 70, and the standard deviation is 37.4
# (thousands of dollars).
curve(dgamma(x, shape=70*0.05, rate=0.05), from=1, to=200, 
      main="Population Distribution of Income", 
      xlab= "Income (in 1000 USD)", ylab="p(x)")

# If we randomly sample people and record their income, the distribution of
# the individual incomes will be skewed, no matter how much data we collect.
hist(x= rgamma(n=50, shape=70*0.05, rate=0.05), 
     main="50 Randomly Sampled Incomes", xlab="Income (1000 USD)")
hist(x= rgamma(n=200, shape=70*0.05, rate=0.05), 
     main="200 Randomly Sampled Incomes", xlab="Income (1000 USD)")
hist(x= rgamma(n=1000, shape=70*0.05, rate=0.05), 
     main="1000 Randomly Sampled Incomes", xlab="Income (1000 USD)")

# The central limit theorem does NOT say that the individual samples become
# normally distributed when we collect enough data.

# But the sample AVERAGE starts to look normally distributed, for large enough
# samples.

# Suppose we randomly sample 3 adults and record their average income. What
# types of values do we get for that sample average?
n_repetitions<- 1000 # let's repeat the 3-person-sample exercise 1000 times

sample_means<-rep(0,n_repetitions) #create a vector to store our 1000 sample means

for(i in 1:n_repetitions){
  sample_means[i] <- mean(rgamma(n=3, shape=70*0.05, rate=0.05))
}
hist(x= sample_means, main="", xlab="Average Income of 3 people (1000 USD)", 
     probability = TRUE)

# The average income of a sample of 3 people still looks a bit skewed (longer
# right tail). This doesn’t look like a normal distribution.

# What about the sample average of 10 people?
n_repetitions<- 1000 # let's repeat the 10-person-sample exercise 1000 times

sample_means<-rep(0,n_repetitions) #create a vector to store our 1000 sample means

for(i in 1:n_repetitions){
  sample_means[i] <- mean(rgamma(n=10, shape=70*0.05, rate=0.05))
}
hist(x= sample_means, main="", xlab="Average Income of 10 people (1000 USD)", 
     probability=TRUE, breaks=15)

# What about the sample average of 50 people?
n_repetitions<- 1000 # let's repeat the 50-person-sample exercise 400 times

sample_means<-rep(0,n_repetitions) #create a vector to store our 400 sample means

for(i in 1:n_repetitions){
  sample_means[i] <- mean(rgamma(n=50, shape=70*0.05, rate=0.05))
}
hist(x= sample_means, main="", 
     xlab="Average Income of 50 people (1000 USD)", 
     probability=TRUE,breaks=15)
curve(dnorm(x, mean=70, sd=sqrt(20*70/50)), add=TRUE)
legend("topright", legend=c("Normal(70, 37.4/sqrt(50))"), bty='n', lty=1)

# Even though the population distribution of incomes is not normal, and is
# noticeably skewed, the average income of 50 random people is starting to
# look like a normal distribution.

# The curve superimposed on the histogram is the normal distribution pdf with
# expected value 70 and standard deviation 37.4/sqrt(50).
