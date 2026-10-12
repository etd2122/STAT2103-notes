# simple linear regression
# STAT 2103 Applied Linear Regression — R example
# Extracted from the rendered course example; prose kept as comments.


# This notebook explores data about economic voting behavior. It has been
# observed that in times of economic prosperity, the incumbent political party
# tends to get a larger share of the votes in elections. Below, we consider
# the relationship between the average growth in personal income, and the
# percent of votes received by the incumbent party in an election.

# Read in the data, and store it as a data frame called “voting_data”
voting_data<-read.table("~/Documents/2026F/regression/examples 2103/older/hibbs.dat", header=TRUE)

# We can print the first few rows of the data frame to see what’s in there:
head(voting_data)

# The variables we’re interested in are the “growth” column, and the “vote”
# column. There are other columns that we aren’t going to use.

# We could also print the names of the columns in the data frame:
names(voting_data)

# Let’s make a scatter plot, with growth on the X axis, and incumbent share of
# vote on the Y axis.

# How do we access the data in the data frame?

# To get the values of a column, the notation we use is the name of the data
# frame, then a dollar sign $, then the name of the column we want.
voting_data$growth

# The basic function to make a scatter plot is plot( )

# Within the plot function, we specify that “growth” goes on the x axis (it’s
# the predictor) and “vote” goes on the y axis (it’s the response)
plot(x=voting_data$growth, y=voting_data$vote, 
     xlab="avg personal income growth (%)", 
     ylab="incumbent vote share (%)", pch=16)

# We also added labels to the x axis and the y axis- that’s what the “xlab”
# and “ylab” parts do.

# Next, we want to find the best line through the data.

# In R, the function for fitting linear models is lm( ).

# To fit a linear model, we need to tell the function what our predictor
# variable is, and what the response is.

# This is what the syntax looks like:
lm(vote ~ growth, data=voting_data)

# The first part says that “vote” is the response, and “growth” is the
# predictor. The general syntax is y~x.

# Then, specifying “data=voting_data” tells the function where to actually
# find the “vote” and “growth” data values.

# What happens when we run this?
lm(vote~growth, data=voting_data)

# It gives us “coefficients”. The first one, labeled interecept, is the
# intercept of our line. The second one is the slope. It says the best fitting
# line through the data has the equation

# vote = 46.248 + 3.061*growth

# Instead of just printing this out, we can also store it as an object we can
# use for other purposes later.
bestfit<-lm(vote~growth, data=voting_data)

# Now we have an object called “bestfit” that contains info about the linear
# model we fit.

# We can print it out again:
bestfit

# We can print the coefficients:
bestfit$coefficients

# What if we want to draw the line on top of our scatter plot?

# In general, the function for plotting a line is abline( ).

# You tell abline what line to plot by specifying the intercept (a) and the
# slope (b).
plot(x=voting_data$growth, y=voting_data$vote, 
     xlab="avg personal income growth (%)", 
     ylab="incumbent vote share (%)", main="", pch=16)
abline(a=46.247648, b=3.060528)

# That drew our line on top of the scatter plot.

# Instead of copy-pasting the slope and intercept into abline( ), we can also
# tell it to use the coefficients in the “bestfit” model that we stored:
plot(x=voting_data$growth, y=voting_data$vote, 
     xlab="avg personal income growth (%)", 
     ylab="incumbent vote share (%)", main="", pch=16)
abline(bestfit$coefficients)
