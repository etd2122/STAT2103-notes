---
id: R5
key: simulating-regression-2
title: Simulating regression, part 2
lecture: L08
topics: population model, runif, rnorm, error term, points, legend, error variance, lm
summary: Write down a true population model, y = 150 + 17.5x + ε with ε ~ N(0, σ²), and simulate data from it one point at a time and then 50 at once. Fitting lm() recovers a line close to the truth. Raising σ from 10 to 50 spreads the points out and makes the estimated line less accurate.
takeaways:
- Simulating from the model: pick $x$ (here `runif`), compute the point on the true line $\beta_0 + \beta_1 x$, then add an error drawn from `rnorm(n, 0, sigma)`.
- $E(Y \mid X = x) = \beta_0 + \beta_1 x$: the line gives the **average** $y$ at each $x$; the error moves each point above or below.
- With $\sigma = 10$ the fitted line almost matches the true line. With $\sigma = 50$ the points scatter more and the estimates are less precise.
- Larger error variance → larger $\text{var}(\hat\beta_1) = \sigma^2 / \sum(x_i - \bar x)^2$.
- `points()` adds points to an existing plot; `legend()` labels lines and points.
---

## The population model

### box: Set the true parameters
items: 5
what: Population model $y = 150 + 17.5x + \varepsilon$, $\varepsilon \sim N(0, \sigma^2)$ with $\sigma^2 = 100$.
explain:
- `b0`, `b1` are the **true** intercept and slope ($\beta_0, \beta_1$). In real data these are unknown; in a simulation we choose them.
- `sigma <- 10` is the error **SD** ($\sigma^2 = 100$). R's `rnorm` takes the SD.
- These are the language-acquisition numbers: vocabulary = 150 + 17.5 × (thousands of words).

## Simulating one observation at a time

### box: Choose an x value
items: 7-8
what: Draw one $x$ at random between 1 and 12.
explain:
- `runif(n, min, max)` draws from a **uniform** distribution: every value in the range is equally likely.
- The model doesn't say how $x$ is chosen; you could also just pick a value like `x <- 8`.

### box: The expected y at that x
items: 10-11
key: true
what: Compute the point on the true line for this $x$.
explain:
- `b0 + b1*x` is $E(Y \mid X = x) = \beta_0 + \beta_1 x$, about 342 here.
- On average, observations with this $x$ have this $y$.

### box: Add a random error to get an observed y
items: 14-15
key: true
what: Simulate the actual observed $y$ by adding $\varepsilon \sim N(0, 10^2)$.
explain:
- `rnorm(n = 1, mean = 0, sd = sigma)` is one random error term. Mean 0 is the "mean-zero errors" assumption.
- $y$ = 349.3: the point lands about 7 above the line this time. Run it again and it could land below.

### box: Plot the true line and the point
items: 17-18
what: Draw the population line and the simulated observation.
explain:
- `plot(NULL, xlim, ylim)` makes an empty plot; `abline(a = b0, b = b1)` draws the **true** line.
- `points(x, y, pch = 16, cex = 2)` adds a point to the existing plot; `cex` scales the size.

### box: A second observation
items: 20-22
what: Simulate and plot another point the same way.
explain:
- Each point = (random $x$, line value + new random error). The two points are independent, since each gets its own `rnorm` draw.

## A whole data set

### box: Simulate 50 observations at once
items: 24
key: true
what: Draw 50 $x$ values and their $y$ values from the model in two vectorized lines.
explain:
- `runif(n = 50, ...)` gives 50 $x$'s; `rnorm(n = 50, 0, sigma)` gives 50 independent errors.
- `b0 + b1*x_samples + rnorm(...)` works element by element, producing 50 $y$'s. That's exactly $y_i = \beta_0 + \beta_1 x_i + \varepsilon_i$ with $\varepsilon_i \;\overset{\text{iid}}{\sim}\; N(0, \sigma^2)$.

### box: Plot the sample with the true line
items: 26-27
what: Scatter the 50 simulated points around the population line.
explain:
- Points are spread above and below the line by roughly ±2σ = ±20 at every $x$ (constant variance).
- `legend("bottomright", legend = ..., lty = 1, bty = 'n')` labels the line; `lty = 1` shows a solid-line symbol.

### box: Fit the least squares line
items: 29-33
key: true
what: Estimate the line from the simulated sample and compare it to the truth.
explain:
- `lm(y_samples ~ x_samples)` works with plain vectors too, no `data =` needed.
- The estimated line is very close to the true line (true: 150 and 17.5).
- In real life you only see the dots and the estimated line. The simulation lets us check how good the estimate is.

## Bigger error variance

### box: Simulate with σ = 50
items: 40-42
key: true
what: Same slope and intercept, but error SD 50 instead of 10.
explain:
- Only the `sd` inside `rnorm` changed, so the true line is identical.
- The points are much more spread out around the line: larger $\sigma^2$ means larger errors on average.
- **Watch out:** the original code computes `y_new` from `x_samples` but plots it against `x_new`. To simulate correctly, the `y_new` line should use `x_new`: `y_new <- b0 + b1*x_new + rnorm(n = n_samp, mean = 0, sd = 50)`. As written, the points are paired with the wrong $x$'s, which makes the cloud look even noisier.

### box: Compare σ = 10 and σ = 50 data
items: 46-47
what: Plot both simulated data sets together.
explain:
- Gray filled points (σ = 10) hug the line; open points (σ = 50) are widely scattered.
- `legend` with `pch` and `lty` shows point symbols and line symbols; `NA` leaves a symbol out.

### box: Compare the two estimated lines
items: 49-53
key: true
what: Fit a line to the σ = 50 data and plot both estimated lines with the true line.
explain:
- The σ = 10 estimate (147.2 + 17.84x, blue) is close to the truth (150 + 17.5x). The σ = 50 estimate (orange) is further off.
- The idea to take away: when points are more spread out around the line, it's harder to pin down the true line, because $\text{var}(\hat\beta_1) = \sigma^2/\sum(x_i - \bar x)^2$ is larger.
- **Caveat:** the σ = 50 fit here comes out at 259.1 + 0.69x, which is nearly flat. That's mostly the `x_new`/`x_samples` mix-up: $y$ wasn't generated from the $x$ it's paired with, so there's no relationship left to find. With the fix you'd typically get a slope near 17.5 that's noticeably less accurate than the σ = 10 one.
