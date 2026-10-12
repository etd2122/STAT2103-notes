---
id: HW4
num: 4
title: Simple linear regression
pdf: assignments/hw4.pdf
lectures: L06, L07, L08
data: hurricanes.csv
topics: least squares, interpretation, units, prediction, extrapolation, line through means, slope and correlation, residual, precision of the slope
summary: A full regression of hurricane wind speed on central pressure (fit, plot, interpret, predict, extrapolate, residual), then three picture questions about which sample gives a more precise slope.
---

### box: Problem 1(a)–(b) · Fit and plot
question: hurricanes.csv: `pressure` (mb) as X, `windspeed` (knots) as Y, 62 storms. Find the least squares line and plot it on the scatter plot.
code:
```r
hur <- read.csv("hurricanes.csv")
fit <- lm(windspeed ~ pressure, data = hur)
fit$coefficients
plot(x = hur$pressure, y = hur$windspeed,
     xlab = "central pressure (mb)", ylab = "max wind speed (knots)")
abline(fit$coefficients)
```
explain:
- Formula is `response ~ predictor`: `windspeed ~ pressure`.
- Expect a **negative** slope: lower pressure, stronger storm.

### box: Problem 1(c)–(d) · Interpret and give units
question: Interpret the slope and intercept. What are their units?
explain:
- Slope: "Hurricanes whose central pressures differ by 1 mb have max wind speeds that differ by $|\hat\beta_1|$ knots on average, with the lower-pressure storm faster." Say "differ by", not "increasing pressure causes" (Oct 5).
- Units: slope = knots per millibar; intercept = knots.
- Intercept = predicted wind speed at 0 mb. Is that meaningful? (No hurricane has 0 mb pressure.)

### box: Problem 1(e)–(f) · Predict, and extrapolation
question: Predicted wind speed at 945 mb, and at 750 mb. Is the second reasonable?
code:
```r
predict(fit, newdata = data.frame(pressure = c(945, 750)))
range(hur$pressure)   # what x values did we actually observe?
```
explain:
- 945 is inside the observed range, so this is a normal prediction.
- 750 is far outside it: that's **extrapolation**, risky because the linear pattern may not hold there.

### box: Problem 1(g) · The line through (x̄, ȳ)
question: Compute $\bar x$, predict at $\bar x$, compare to $\bar y$.
code:
```r
xbar <- mean(hur$pressure)
predict(fit, newdata = data.frame(pressure = xbar))
mean(hur$windspeed)
```
explain:
- They're equal: the least squares line always passes through $(\bar x, \bar y)$ (see the *Simulating regression* R example).

### box: Problem 1(h)–(i) · One SD of x
question: For pressures differing by $s_x$, how much do predicted wind speeds differ? Compare to $s_y$.
code:
```r
sx <- sd(hur$pressure); sy <- sd(hur$windspeed)
fit$coefficients[2] * sx
cor(hur$pressure, hur$windspeed) * sy   # same number
sy
```
explain:
- $\hat\beta_1 s_x = r_{xy} s_y$ (Oct 5). Since $|r| < 1$, the predicted difference is smaller in size than $s_y$.

### box: Problem 1(j) · Harvey's residual
question: Harvey: 937 mb, 115 knots. Residual?
code:
```r
115 - predict(fit, newdata = data.frame(pressure = 937))
```
explain:
- Residual = observed − predicted $= y_i - \hat y_i$. Positive means Harvey was faster than the line predicts.

### box: Problems 2–4 · Which sample gives a more precise slope?
question: Three pairs of scatter plots. Which sample would give a more precise estimate of the true linear relationship?
explain:
- Use $\text{var}(\hat\beta_1) = \dfrac{\sigma^2}{(n-1)S_x^2}$ (Oct 7). The slope is more precise when:
- the points are **less scattered** around the line (smaller $\sigma^2$);
- there are **more points** (larger $n$);
- the $x$ values are **more spread out** (larger $S_x^2$).
- For each pair, figure out which of these differs between (a) and (b) and say so in your justification.
