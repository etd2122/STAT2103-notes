---
id: R4
key: simulating-regression
title: Simulating regression
lecture: L07
topics: read.csv, sample, row subsetting, lm, abline, lwd, col, lty, mean, plot(NULL), for loop, sampling variability of the slope
summary: Treat a big SAT/GPA data set as the "population," draw random samples of 50 students, and fit a line to each. Every sample gives a slightly different line, and every fitted line passes through (x̄, ȳ). Repeating it 20 times shows the sampling variability of β̂₀ and β̂₁.
takeaways:
- `df[rows, ]` keeps the chosen rows (and all columns). `sample(1:N, size = 50)` picks 50 random row numbers.
- A new random sample gives a new $\hat\beta_0, \hat\beta_1$. The estimates are random variables.
- The least squares line **always** passes through $(\bar x, \bar y)$, since $\hat\beta_0 = \bar y - \hat\beta_1\bar x$.
- `abline(v = ...)` vertical line, `abline(h = ...)` horizontal line, `lty = 2` dashed, `lwd` thickness, `col` color.
- `plot(NULL, xlim, ylim)` makes an empty plot to draw lines onto.
- Storing results in a data frame inside a loop: `regression_coefs[i, ] <- model$coefficients`.
---

## One sample of 50 students

### box: Load the "population" and draw 50 students
items: 1-7
what: Load the full data set (the pretend population), then randomly choose 50 students.
explain:
- `read.csv(file = ...)` reads a .csv into a data frame. Change the path to where `academics.csv` is on your computer.
- `dim(academics)[1]` is the number of rows, i.e. the population size $N$. (`nrow(academics)` does the same.)
- `sample(1:N, size = 50)` picks 50 different row numbers at random (without replacement by default).
- `academics[samples, ]` keeps those rows and **all** columns (the blank after the comma means "every column").
- In real life you only ever have the sample. Here we can see the whole population, which lets us check how well samples do.

### box: Scatter plot of the sample
items: 9-11
what: Plot GPA against SAT score for the 50 sampled students.
explain:
- SAT is the predictor (x), GPA the response (y).
- `pch = 19` gives solid points; it's only cosmetic.

### box: Fit and draw the regression line
items: 13-20
key: true
what: Estimate the SAT–GPA relationship from this sample and draw the line.
explain:
- `lm(GPA ~ SAT, data = sample_data)` gives $\hat\beta_0 \approx 1.85$ and $\hat\beta_1 \approx 0.00114$.
- Interpretation: students whose SAT scores differ by 100 points have GPAs that differ by about 0.11 on average.
- `lwd = 3` thickens the line; `col = 2` (or `col = "red"`) colors it.

### box: The line passes through (x̄, ȳ)
items: 22-24
key: true
what: Add dashed lines at the sample's average SAT score and average GPA.
explain:
- `abline(v = value)` draws a **vertical** line; `abline(h = value)` a **horizontal** line. `lty = 2` makes it dashed.
- The regression line crosses exactly where the two dashed lines meet: the point $(\bar x, \bar y)$.
- Why: $\hat\beta_0 = \bar y - \hat\beta_1\bar x$, so plugging in $x = \bar x$ gives $\hat y = \bar y$. (HW 4 #1(g) checks this.)

## A second sample

### box: New sample, new line
items: 27-34
key: true
what: Draw a different random 50 students and fit again.
explain:
- New coefficients: $\hat\beta_0 \approx 1.61$, $\hat\beta_1 \approx 0.00143$. Similar to the first sample but not identical.
- The fitted slope and intercept are **random variables**: they depend on which students we happened to sample.

### box: This line also passes through its own (x̄, ȳ)
items: 36-37
what: Mark the new sample's averages.
explain:
- The least squares line always passes through $(\bar x, \bar y)$ for **any** data. Here it's the new sample's averages.

### box: Compare the two lines
items: 40-41
what: Draw both fitted lines on one blank plot.
explain:
- `plot(NULL, xlim = c(400, 1600), ylim = c(0, 4), ...)` makes an empty plot with the axis ranges you want (`NULL` = no data points).
- `abline()` can then be called repeatedly to add lines.

## Twenty samples

### box: Repeat 20 times and save the coefficients
items: 44
key: true
what: Draw 20 samples of 50 students, fit a line to each, and store each intercept and slope.
explain:
- `data.frame('intercept' = rep(0, nrep), 'slope' = rep(0, nrep))` creates a 20-row table of zeros to fill.
- Inside the loop: sample, subset, fit, then `regression_coefs[i, ] <- newmodel$coefficients` writes row `i`.
- Afterwards `mean(regression_coefs$slope)` should be close to the true population slope, because $\hat\beta_1$ is **unbiased**.

### box: Plot all 20 lines
items: 46-47
key: true
what: Draw the 20 fitted lines on one plot.
explain:
- `abline(coef = regression_coefs[i, ])` draws line `i`.
- The lines fan out around the true relationship. That spread is the **sampling variability** of the estimates, which $\text{var}(\hat\beta_1)$ measures.
- The lines are closest together near the middle of the SAT range (near $\bar x$) and spread out at the extremes, another reason extrapolation is risky.
