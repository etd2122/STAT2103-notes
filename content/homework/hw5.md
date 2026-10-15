---
id: HW5
num: 5
title: Inference, prediction intervals and R²
pdf: assignments/hw5.pdf
lectures: L09, L10
data: plants.csv, hurricanes.csv, salmonella.csv
topics: one-sided slope test, p-value, confidence interval for slope, confidence interval for mean response, prediction interval, inverse prediction, R-squared, nonlinear association
summary: A one-sided test and 90% CI for the slope (nitrogen and plant biomass), confidence vs. prediction intervals at a given pressure (hurricanes), and interpreting R² when the relationship may not be linear (salmonella). Submit code, output and plots.
---

### box: Problem 1(a)–(b) · Plot nitrogen vs. biomass
question: plants.csv, 26 plants with randomly assigned nitrogen doses. Scatter plot with the least squares line, then describe the association.
code:
```r
plants <- read.csv("plants.csv")
fit <- lm(biomass ~ nitrogen, data = plants)
plot(x = plants$nitrogen, y = plants$biomass,
     xlab = "nitrogen (mg)", ylab = "biomass (g)")
abline(fit)
```
explain:
- (b) Describe the **direction** (positive or negative) and **strength** (points tight or scattered around the line), and whether it looks linear.

### box: Problem 1(c)–(e) · One-sided test for a positive slope
question: Test for a **positive** linear association: hypotheses, p-value, and conclusion at α = 0.05 in context.
code:
```r
summary(fit)$coefficients
t_stat <- summary(fit)$coefficients[2, "t value"]
n <- nrow(plants)
1 - pt(t_stat, df = n - 2)    # one-sided p-value for H_A: beta1 > 0
```
explain:
- $H_0: \beta_1 = 0$ vs. $H_A: \beta_1 > 0$.
- `summary()`'s `Pr(>|t|)` is **two-sided**. For the one-sided test use `1 - pt(t, df = n - 2)` (half the two-sided p when $t > 0$).
- The plants were **randomly assigned** doses, so this is an experiment, not an observational study. If you reject, you can say more about nitrogen's effect than in the observational examples (Oct 5 notes).

### box: Problem 1(f) · 90% CI for the slope
question: 90% confidence interval for the slope, interpreted in context.
code:
```r
confint(fit, level = 0.90)
```
explain:
- Use the `nitrogen` row.
- Interpretation template: "We're 90% confident that plants whose nitrogen doses differ by 1 mg differ in average biomass by between __ and __ grams."

### box: Problem 2(a)–(b) · CI for average wind speed at 959 mb
question: Using the HW 4 model: 95% and 99% CIs for the **average** max wind speed of hurricanes with central pressure 959 mb. Wider or narrower? Same center?
code:
```r
hur <- read.csv("hurricanes.csv")
fit_h <- lm(windspeed ~ pressure, data = hur)
new <- data.frame(pressure = 959)
predict(fit_h, newdata = new, interval = "confidence", level = 0.95)
predict(fit_h, newdata = new, interval = "confidence", level = 0.99)
```
explain:
- "Average among hurricanes with…" → `interval = "confidence"`.
- Compare `fit` (the center) and `upr - lwr` (the width) between the two levels.

### box: Problem 2(c) · Prediction interval for Hurricane Isaias
question: 95% prediction interval for one specific hurricane (Isaias) at 959 mb, compared to (a).
code:
```r
predict(fit_h, newdata = new, interval = "prediction", level = 0.95)
```
explain:
- One specific storm → `interval = "prediction"`.
- Same center as (a) but wider: it adds storm-to-storm scatter on top of not knowing the true line.

### box: Problem 2(d)–(e) · Which pressure predicts 115 knots?
question: Find the pressure where the model predicts 115 knots, then a 95% prediction interval there. Wider or narrower than (c)?
code:
```r
b <- fit_h$coefficients
x115 <- (115 - b[1]) / b[2]     # solve 115 = b0 + b1 * x for x
x115
predict(fit_h, newdata = data.frame(pressure = x115), interval = "prediction")
mean(hur$pressure)              # compare both x values to x-bar
```
explain:
- Solve $115 = \hat\beta_0 + \hat\beta_1 x$ for $x$.
- Interval width depends on how far $x^*$ is from $\bar x$. Whichever of 959 and your new pressure is **closer to $\bar x$** gives the narrower interval.

### box: Problem 3(a)–(b) · Temperature vs. salmonella
question: salmonella.csv. Scatter plot with the least squares line; describe the association.
code:
```r
sal <- read.csv("salmonella.csv")
fit_s <- lm(salmonella ~ temperature, data = sal)
plot(x = sal$temperature, y = sal$salmonella,
     xlab = "temperature (C)", ylab = "salmonella density")
abline(fit_s)
```
explain:
- Look closely at the **shape**: does a straight line follow the points, or is there a curve (e.g. growth peaking at some temperature)?

### box: Problem 3(c)–(e) · R², and is it useful?
question: Report and interpret $R^2$. Is the regression model useful for predicting salmonella? Is temperature useful for predicting salmonella?
code:
```r
summary(fit_s)$r.squared
cor(sal$temperature, sal$salmonella)^2   # same number
```
explain:
- (c) "About __% of the variation in salmonella density is explained by temperature in the linear model."
- (d) asks about **this linear model**. A low $R^2$ means it doesn't predict well.
- (e) asks about **temperature** itself. If the plot shows a strong **non-linear** pattern, temperature can still be very informative even though the linear model's $R^2$ is low (see the *R² and correlation* R example, last section).
