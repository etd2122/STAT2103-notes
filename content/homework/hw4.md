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

=== big picture ===
## Problem 1: the big picture

Problem 1 has ten parts, but it asks **one question**: *how does a hurricane's wind speed relate to its central pressure?* Every part is one step in the same story. You **build** a summary of 62 storms, **read** what it says, **use** it, then check **what it can and can't tell you**.

[![Every part of Problem 1 marked on the hurricane scatter plot: the least squares line, the center point, a one-SD step, Harvey's residual, the 945 mb prediction and the 750 mb extrapolation](img/homework/hw4-problem1-concept.png)](img/homework/hw4-problem1-concept.png)

*Tap or click the picture to open it full size.*

:::def The one idea behind everything
The regression line is a model for **averages**: $E(\text{wind} \mid \text{pressure}) = \beta_0 + \beta_1 \cdot \text{pressure}$. It doesn't describe any single storm. It describes the **typical** storm at each pressure. Every part of Problem 1 either builds that line, reads it, uses it, or measures how real storms differ from it.
:::

### 1 · Build the summary (a–b)

A scatter plot of 62 storms is a cloud. Least squares replaces the cloud with **one straight line**: the one whose **vertical** misses, squared and added up, are as small as possible. The misses are vertical because the job is to predict **wind** (y) from pressure (x), so a miss is measured in knots.

*Why it matters:* you can't interpret, predict or do inference until you've decided a straight line is a sensible summary, so look at the plot first.

### 2 · Read the summary (c–d)

- **The slope is a comparison between storms, not a change within one storm.** Storms whose pressures differ by 1 mb have max winds that differ by about 0.9 knots on average, with the lower-pressure storm faster. Nobody turned a dial on one hurricane, so this is observational data and the wording is "differ by," not "causes."
- **Units carry the meaning.** The slope is in knots per mb (how much y changes per unit of x); the intercept is in knots.
- **The intercept is an anchor, not a fact about storms.** It's the line's height at 0 mb, a pressure no storm has ever had. It's there to place the line, not to be interpreted.

### 3 · Use the summary (e–f)

A prediction is the line's answer to "what's the **average** wind for storms like this?" The line only earned that right **where it saw data** (919–993 mb).

- 945 mb is inside the data: an **interpolation** you can trust as much as the line itself.
- 750 mb is far outside it. R still prints 282 knots, but nothing tells us the straight-line pattern continues out there. That's **extrapolation**: the math works; the evidence doesn't.

### 4 · Find where the line is anchored (g)

The line always passes through the **center of the data**, $(\bar x, \bar y)$. It's built into the intercept formula, $\hat\beta_0 = \bar y - \hat\beta_1 \bar x$. Think of the line as a **seesaw pivoting at the center**: the slope sets the tilt, and the pivot never moves. That's also why predictions are most reliable near $\bar x$ and get shakier farther out.

### 5 · How hard x "pulls" y (h–i)

Move one standard deviation in pressure (18.7 mb). The line predicts wind changes by $\hat\beta_1 s_x = r\,s_y \approx 17$ knots, **less** than one SD of wind (20.3 knots), because $\lvert r\rvert = 0.84 < 1$.

This is **regression to the mean**. An extreme storm (in pressure) is predicted to be extreme in wind, but **less** extreme, because pressure doesn't explain everything about wind. Only if every point sat exactly on the line ($\lvert r\rvert = 1$) would 1 SD in x predict a full 1 SD in y. The weaker the relationship, the more the predictions hug $\bar y$.

### 6 · What the line misses (j)

A **residual** is one storm's "surprise": observed − predicted. Harvey (937 mb) actually hit 115 knots; the line expected 112.6 for a typical 937-mb storm, so Harvey's residual is **+2.4 knots**, a little stronger than typical.

Residuals are the part of each storm that pressure **doesn't** explain. Their typical size ($\hat\sigma$) measures how good the summary is. Their **patterns** (Oct 19) tell you whether a straight line was the right summary at all.

### The whole problem in one table

| Part | The question it really asks | The idea |
|---|---|---|
| (a–b) | What's the best straight-line summary? | Least squares: minimize squared vertical misses |
| (c–d) | What does the line say? | Slope = average difference between groups of storms; units; intercept is just an anchor |
| (e) | What does it predict inside the data? | A prediction is an **average** for storms like that |
| (f) | Can it predict far outside the data? | No evidence there: **extrapolation** |
| (g) | Where is the line pinned? | Always through $(\bar x, \bar y)$ |
| (h–i) | How strongly does x move y? | $\hat\beta_1 s_x = r s_y$: **regression to the mean** |
| (j) | How does one real storm compare? | Residual = observed − predicted |

:::tip If you remember one sentence
"The regression line describes how the **average** y differs across x, **within the range of the data**. Individual points scatter around it, and how much they scatter is how much x leaves unexplained."
:::

=== problems ===

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
