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
idea: The least squares line is the single straight line that makes the total squared vertical distance from the points as small as possible. It's the best linear summary of how wind speed changes with pressure.
walk:
- Decide roles: pressure is the predictor (x), wind speed the response (y).
- Fit the line with `lm()`. R finds $\hat\beta_0, \hat\beta_1$ using the formulas from Sep 30.
- Plot the data, then add the line. Check that it actually runs through the middle of the cloud of points.
pitfall:
- Plotting the line before the scatter plot. `abline()` only draws on an existing plot.

### box: Problem 1(c)–(d) · Interpret and give units
question: Interpret the slope and intercept. What are their units?
explain:
- Slope: "Hurricanes whose central pressures differ by 1 mb have max wind speeds that differ by $|\hat\beta_1|$ knots on average, with the lower-pressure storm faster." Say "differ by", not "increasing pressure causes" (Oct 5).
- Units: slope = knots per millibar; intercept = knots.
- Intercept = predicted wind speed at 0 mb. Is that meaningful? (No hurricane has 0 mb pressure.)
idea: The slope compares **groups of storms**: how much faster, on average, are storms with 1 mb lower pressure? The units tell you what the numbers mean.
walk:
- Slope: about −0.9. Storms whose pressures differ by 1 mb have max winds that differ by about 0.9 knots on average, with the lower-pressure storm faster.
- Units: slope = response units per predictor unit = knots per mb. Intercept = response units = knots.
- Intercept = predicted wind at 0 mb. No hurricane is anywhere near 0 mb, so it's a mathematical anchor for the line, not a meaningful prediction.
pitfall:
- Causal wording: "lowering pressure increases wind speed." This is observational data, so say "differ by."
- Forgetting the negative sign in the interpretation.

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
idea: A regression line is only trustworthy where you have data. Inside the observed range you're interpolating; outside it you're guessing that the straight-line pattern continues.
walk:
- Plug 945 into the line. 945 is inside the observed pressures (about 919–993), so it's a reasonable prediction.
- Plug 750 into the line. You'll get a number, but 750 is far below anything observed.
- Ask: is there any reason to believe the relationship is still a straight line out there? No data means no evidence. That's **extrapolation**.
pitfall:
- Saying the 750 prediction is fine because R computed it. R will compute anything.

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
idea: The least squares line always passes through the "center of mass" of the data, the point $(\bar x, \bar y)$. It's built into the intercept formula.
walk:
- Compute $\bar x$ (average pressure) and plug it into the line.
- Compare with $\bar y$ (average wind speed). They match.
- Why: $\hat\beta_0 = \bar y - \hat\beta_1\bar x$, so $\hat y(\bar x) = \bar y - \hat\beta_1\bar x + \hat\beta_1\bar x = \bar y$.

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
idea: This is **regression to the mean**. A storm 1 SD more extreme in pressure is predicted to be less than 1 SD more extreme in wind, by a factor of |r|.
walk:
- Change in prediction for a 1-SD change in x: $\hat\beta_1 s_x$.
- Because $\hat\beta_1 = r\,s_y/s_x$, that equals $r\,s_y$.
- Since |r| < 1, the predicted difference is smaller than $s_y$. The line "pulls" predictions toward the average.
- Only if the points fell perfectly on a line (|r| = 1) would a 1-SD change in x predict a full 1-SD change in y.
pitfall:
- Dropping the sign. The difference is negative here, so lower pressure means faster wind.

### box: Problem 1(j) · Harvey's residual
question: Harvey: 937 mb, 115 knots. Residual?
code:
```r
115 - predict(fit, newdata = data.frame(pressure = 937))
```
explain:
- Residual = observed − predicted $= y_i - \hat y_i$. Positive means Harvey was faster than the line predicts.
idea: A residual is how far reality landed from the line's prediction: observed − predicted. It measures one storm's "surprise."
walk:
- Predict Harvey's wind from its pressure (937 mb).
- Subtract the prediction from Harvey's actual 115 knots.
- Interpret the sign: positive means Harvey was stronger than a typical 937-mb storm; negative means weaker.
pitfall:
- Computing predicted − observed. The convention is observed − predicted.

### box: Problems 2–4 · Which sample gives a more precise slope?
question: Three pairs of scatter plots. Which sample would give a more precise estimate of the true linear relationship?
explain:
- Use $\text{var}(\hat\beta_1) = \dfrac{\sigma^2}{(n-1)S_x^2}$ (Oct 7). The slope is more precise when:
- the points are **less scattered** around the line (smaller $\sigma^2$);
- there are **more points** (larger $n$);
- the $x$ values are **more spread out** (larger $S_x^2$).
- For each pair, figure out which of these differs between (a) and (b) and say so in your justification.
idea: How precisely you can pin down a slope depends on three things: how noisy the points are around the line, how many points you have, and how spread out the x values are. Think of balancing a ruler on points: a wide base and tight points make it steady.
walk:
- Use $\text{var}(\hat\beta_1) = \dfrac{\sigma^2}{(n-1)S_x^2}$. Smaller is more precise.
- Less vertical scatter around the line (small σ²) gives a more precise slope.
- More points (bigger n) gives a more precise slope.
- x values spread over a wider range (bigger $S_x^2$) give a more precise slope: a long lever is easier to tilt correctly than a short one.
- For each pair of plots, find which of these three differs and name it in your answer.
pitfall:
- Judging by how steep the line looks. Steepness is the slope's value, not its precision.

=== wrap-up ===

## Every formula used

:::formula The fitted line
- $\hat\beta_1 = \dfrac{\sum (x_i - \bar x)(y_i - \bar y)}{\sum (x_i - \bar x)^2} = r\,\dfrac{s_y}{s_x}$ and $\hat\beta_0 = \bar y - \hat\beta_1\bar x$ (#1a)
- Prediction: $\hat y = \hat\beta_0 + \hat\beta_1 x$ (#1e–f)
- The line passes through $(\bar x, \bar y)$: $\hat y(\bar x) = \bar y$ (#1g)
- One SD of x: $\hat\beta_1 s_x = r\,s_y$, smaller than $s_y$ in size since $\lvert r\rvert < 1$ (#1h–i)
- Residual: $e_i = y_i - \hat y_i$ (observed − predicted) (#1j)
:::

:::formula Units and precision
- Slope units = y-units per x-unit (knots per mb); intercept units = y-units (knots) (#1d)
- $\text{var}(\hat\beta_1) = \dfrac{\sigma^2}{(n-1)S_x^2}$: more precise with less scatter, more points and more spread-out x (#2–4)
:::

## Learning summary

- **Answers:** $\widehat{\text{wind}} = 961.5 - 0.906 \cdot \text{pressure}$; 945 mb → 105.4 knots; 750 mb → 282 knots, which is extrapolation (observed pressures are 919–993 mb); at $\bar x = 960.8$ the prediction equals $\bar y = 91.0$; $\hat\beta_1 s_x = -17.0$ vs. $s_y = 20.3$ ($r = -0.84$); Harvey's residual is about +2.4 knots.
- The slope compares **groups**: storms 1 mb apart in pressure differ by about 0.9 knots on average. Use "differ by," not causal language, for observational data.
- Predictions are trustworthy only **inside the range of x**.
- **Regression to the mean:** a storm 1 SD extreme in pressure is predicted to be only |r| = 0.84 SD extreme in wind.
- A residual measures one storm's "surprise": Harvey was a bit stronger than a typical 937-mb storm.
- Slope precision depends on **noise, sample size and x-spread**, not on how steep the line is.

## What to take away from the R output

:::r Reading the R
- `fit$coefficients` gives two numbers: `(Intercept)` = $\hat\beta_0$ and `pressure` = $\hat\beta_1$. The negative slope matches the physics (lower pressure, stronger storm).
- `abline(fit)` only works **after** `plot()`. Check that the line goes through the middle of the cloud.
- `predict(fit, newdata = data.frame(pressure = 945))` = plugging into the line. The column name in `newdata` must match the predictor's name exactly.
- `range(x)` tells you whether a prediction is interpolation or extrapolation.
- `cor(x, y) * sd(y)` printing the same number as `slope * sd(x)` confirms $\hat\beta_1 s_x = r s_y$.
:::

## Common mistakes

:::tip Watch for these
- Causal wording ("lowering pressure increases wind") for observational data.
- Dropping the negative sign when interpreting the slope or the one-SD difference.
- Trusting the 750-mb prediction because R computed it. R will compute anything.
- Residual as predicted − observed. It's **observed − predicted**.
- Wrong units: the slope is knots **per mb**, not just knots.
- Judging slope precision by steepness.
:::
