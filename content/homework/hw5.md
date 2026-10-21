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
idea: Start every regression problem by looking. The scatter plot tells you whether a straight line is even a sensible summary before any numbers are computed.
walk:
- Nitrogen (what the researchers controlled) goes on x; biomass (the outcome) goes on y.
- Fit the least squares line and add it to the plot.
- Describe four things: **direction** (up or down), **form** (straight or curved), **strength** (tight or scattered), and **unusual points**.
- Here: positive, roughly linear, moderate (r ≈ 0.65), with a few plants well above or below the line.
pitfall:
- Giving only one feature (e.g. just "moderate"). Direction and form matter too.
- Putting a written answer inside an R chunk, which breaks rendering.

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
idea: The test asks: if nitrogen truly had no linear effect (slope 0), how likely is a sample slope as large as ours? Because the researchers only care about nitrogen *helping*, the test is one-sided.
walk:
- Hypotheses: $H_0: \beta_1 = 0$ (no linear effect) vs. $H_A: \beta_1 > 0$ (more nitrogen, more biomass). The direction comes from the research question, not the data.
- Measure the estimate in SE units: $t = \hat\beta_1/\text{se}(\hat\beta_1) \approx 0.389/0.093 \approx 4.16$. The slope is about 4 SEs above 0.
- p-value: the area above 4.16 in a t distribution with n − 2 = 24 df, about 0.00018. R's `summary()` shows the two-sided value, so halve it or use `1 - pt()`.
- Decision: 0.00018 < 0.05, so reject $H_0$.
- Meaning: because doses were **randomly assigned**, this is an experiment, so you can say more nitrogen **causes** more growth, not just that they're associated.
pitfall:
- Reporting `summary()`'s Pr(>|t|) for a one-sided test. That's two-sided.
- Interpreting p as "the probability H₀ is true." It's the probability of data this extreme *if* H₀ were true.

### box: Problem 1(f) · 90% CI for the slope
question: 90% confidence interval for the slope, interpreted in context.
code:
```r
confint(fit, level = 0.90)
```
explain:
- Use the `nitrogen` row.
- Interpretation template: "We're 90% confident that plants whose nitrogen doses differ by 1 mg differ in average biomass by between __ and __ grams."
idea: The CI gives the range of slope values consistent with the data. It answers "how big is the effect?", which the p-value doesn't.
walk:
- `confint(fit, level = 0.90)` returns estimate ± t-multiplier × SE for each coefficient. Use the nitrogen row.
- The interval is about 0.23 to 0.55 g per mg.
- Interpret in context: plants whose doses differ by 1 mg differ in average biomass by between 0.23 and 0.55 g.
- Connection: the interval doesn't include 0, which agrees with rejecting $H_0$.
pitfall:
- Rounding 0.2288 down to 0.22. Round to 0.23.
- Interpreting it as a range for individual plants. It's about the average difference.

### box: Problem 2(a)–(b) · CI for average wind speed at 959 mb
question: Using the HW 4 model: 95% and 99% CIs for the **average** max wind speed of hurricanes with central pressure 959 mb. Wider or narrower? Same center?
code:
```r
hur <- read.csv("hurricanes.csv", fileEncoding = "UTF-8-BOM")  # file has a hidden BOM character
fit_h <- lm(windspeed ~ pressure, data = hur)
new <- data.frame(pressure = 959)
predict(fit_h, newdata = new,
        interval = "confidence", level = 0.95)
predict(fit_h, newdata = new,
        interval = "confidence", level = 0.99)
```
explain:
- "Average among hurricanes with…" → `interval = "confidence"`.
- Compare `fit` (the center) and `upr - lwr` (the width) between the two levels.
idea: "The average storm at 959 mb" is one fixed, unknown number: the height of the true line at 959. The confidence interval brackets that number. The only uncertainty is that our line came from 62 storms, not every storm.
walk:
- Point estimate: plug 959 into the fitted line, about 92.7 knots.
- The CI adds ± (t-multiplier × SE of the line's height at 959).
- 95% vs 99%: same center, but to be more sure you must reach further, so the 99% interval is wider.
- Write the sentence: "We are 95% confident the true **average** max wind speed of hurricanes at 959 mb is between __ and __ knots."
pitfall:
- Leaving out the interpretation sentence.
- Thinking a higher confidence level moves the center. It only stretches the width.

### box: Problem 2(c) · Prediction interval for Hurricane Isaias
question: 95% prediction interval for one specific hurricane (Isaias) at 959 mb, compared to (a).
code:
```r
predict(fit_h, newdata = new,
        interval = "prediction", level = 0.95)
```
explain:
- One specific storm → `interval = "prediction"`.
- Same center as (a) but wider: it adds storm-to-storm scatter on top of not knowing the true line.
idea: Isaias is one specific storm. Even if we knew the true average perfectly, Isaias could be well above or below it. The prediction interval covers both kinds of uncertainty: where the line is, *plus* how much individual storms scatter.
walk:
- Same point estimate as (a): 92.7 knots. Your best guess for one storm is still the average.
- Width: storm-to-storm scatter (residual SE ≈ 11 knots) dominates, giving roughly ±22 knots vs ±3 for the CI.
- Everyday analogy: you can estimate the average height of 20-year-olds to within a fraction of an inch, but the next person who walks in could be several inches off.
- Write: "We are 95% confident that Hurricane Isaias's max wind speed is between __ and __ knots."
pitfall:
- Using `interval = "confidence"` for a single storm.
- Expecting more data to shrink the PI to zero. Individual scatter never goes away.

### box: Problem 2(d)–(e) · Which pressure predicts 115 knots?
question: Find the pressure where the model predicts 115 knots, then a 95% prediction interval there. Wider or narrower than (c)?
code:
```r
b <- fit_h$coefficients
x115 <- (115 - b[1]) / b[2]     # solve 115 = b0 + b1 * x for x
x115
predict(fit_h, newdata = data.frame(pressure = x115),
        interval = "prediction", level = 0.95)
mean(hur$pressure)              # compare both x values to x-bar
```
explain:
- Solve $115 = \hat\beta_0 + \hat\beta_1 x$ for $x$.
- Interval width depends on how far $x^*$ is from $\bar x$. Whichever of 959 and your new pressure is **closer to $\bar x$** gives the narrower interval.
idea: Run the line backwards: instead of "given pressure, predict wind," ask "what pressure gives a prediction of 115?" Then see how interval width depends on *where* you predict.
walk:
- Solve $115 = \hat\beta_0 + \hat\beta_1 x$ for x: about 934 mb. The slope is negative, so a faster storm needs lower pressure.
- Build the 95% PI at 934 mb.
- Compare widths: intervals are narrowest at $\bar x$ (≈ 961 mb) and widen as you move away, because a slightly-off slope matters more far from the center (think of a seesaw pivoting at $\bar x$).
- 959 is right next to $\bar x$; 934 is about 27 mb away, so its interval is slightly wider. Only slightly, because individual scatter is the same everywhere and dominates the width.
pitfall:
- Saying the interval is wider "because 115 is a bigger number." Width depends on distance of x from $\bar x$, not on the size of y.
- Long code lines running off the PDF page. Break them across lines.

### box: Problem 3(a)–(b) · Temperature vs. salmonella
question: salmonella.csv. Scatter plot with the least squares line; describe the association.
code:
```r
sal <- read.csv("salmonella.csv", fileEncoding = "UTF-8-BOM")
fit_s <- lm(salmonella ~ temperature, data = sal)
plot(x = sal$temperature, y = sal$salmonella,
     xlab = "temperature (C)", ylab = "salmonella density")
abline(fit_s)
```
explain:
- Look closely at the **shape**: does a straight line follow the points, or is there a curve (e.g. growth peaking at some temperature)?
idea: This problem is designed to break the habit of trusting R² blindly. The pattern is strong but curved, so a straight line misses it entirely.
walk:
- Plot first: an upside-down U. Density rises to a peak near 40°C, then falls.
- The fitted line is nearly flat (about 3.3), because the rising half and the falling half cancel out.
- Describe: a strong, **non-linear** association, with no single direction.
pitfall:
- Calling the association "weak" because the line is flat. The *line* is weak; the relationship is strong.

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
idea: R² measures how much better the **straight line** predicts than just guessing the average every time. A low R² can mean a weak relationship **or** the wrong shape of model. You need the plot to know which.
walk:
- R² ≈ 0.0001: the line explains about 0.01% of the variation in density, basically nothing.
- (d) This **linear model** is not useful: it predicts about 3.3 at every temperature and misses by about 2.9 on average (the residual SE).
- (e) **Temperature** is very useful. Following the curve, density is about 1 at 10°C, about 8 at 40°C and about 1 at 65°C. A curved model would capture it.
- The lesson: R² and correlation only measure *linear* association. Always look at the scatter plot before concluding a variable doesn't matter.
pitfall:
- Answering (d) and (e) the same way. One asks about the model, the other about the variable.
- Saying R² ≈ 0 means temperature and salmonella are unrelated.

=== wrap-up ===

## Every formula used

:::formula Inference for the slope
- $t = \dfrac{\hat\beta_1 - 0}{\text{se}(\hat\beta_1)}$ with $n - 2$ df; $\text{se}(\hat\beta_1) = \dfrac{\hat\sigma}{\sqrt{\sum (x_i - \bar x)^2}}$ (#1c–e)
- One-sided p-value ($H_A: \beta_1 > 0$) = $P(T_{n-2} \ge t)$ = half the two-sided p when $t > 0$
- CI: $\hat\beta_1 \pm t_{n-2}\,\text{se}(\hat\beta_1)$ (#1f)
:::

:::formula Intervals at x*
- CI for the **mean** response: $\hat y^* \pm t_{n-2}\,\hat\sigma\sqrt{\dfrac1n + \dfrac{(x^* - \bar x)^2}{\sum (x_i - \bar x)^2}}$ (#2a–b)
- PI for **one** new observation: $\hat y^* \pm t_{n-2}\,\hat\sigma\sqrt{1 + \dfrac1n + \dfrac{(x^* - \bar x)^2}{\sum (x_i - \bar x)^2}}$ (#2c, #2e)
- Inverse prediction: $x = \dfrac{y - \hat\beta_0}{\hat\beta_1}$ (#2d)
:::

:::formula Model quality
- $R^2 = 1 - \dfrac{\text{SSE}}{\text{SST}} = r^2$ (#3c)
- Residual SE $\hat\sigma = \sqrt{\text{SSE}/(n-2)}$: typical size of a miss
:::

## Learning summary

- **Answers:** plants $t \approx 4.16$, one-sided p ≈ 0.00018 → reject $H_0$; 90% CI for the slope (0.23, 0.55) g per mg (#1). At 959 mb: $\hat y = 92.7$ knots; 95% CI (89.8, 95.5); 99% CI (88.9, 96.5); 95% PI (70.1, 115.2) (#2a–c). 115 knots ↔ about 934 mb, 95% PI (92.1, 137.9), slightly wider (#2d–e). Salmonella $R^2 \approx 0.0001$ (#3).
- **Direction of $H_A$ comes from the question.** Because nitrogen doses were **randomly assigned**, rejecting $H_0$ supports a **causal** conclusion.
- **CI vs. PI:** same center. The PI adds individual scatter, so it's much wider (±22 vs. ±3 knots), and it never shrinks to 0 with more data.
- Higher confidence → wider interval, same center.
- Intervals are narrowest at $\bar x$ and widen farther away.
- **Low $R^2$ ≠ no relationship.** Salmonella has a strong curved pattern that a straight line completely misses. The *linear model* is useless; *temperature* is very useful.

## What to take away from the R output

:::r Reading the R
- `summary(fit)$coefficients`: Estimate, Std. Error, t value ($= \text{Estimate}/\text{SE}$) and `Pr(>|t|)`, which is **always two-sided**.
- `1 - pt(t, df = n - 2)` gives the one-sided p-value for $H_A: \beta_1 > 0$.
- `confint(fit, level = 0.90)`: read the **predictor's** row, not the intercept's.
- `predict(..., interval = "confidence")` → the **average** at x*. `interval = "prediction"` → **one** individual. Output columns are `fit` (center), `lwr` and `upr`.
- `summary(fit)$r.squared` equals `cor(x, y)^2` in simple regression.
- `fileEncoding = "UTF-8-BOM"` fixes the hidden character that made a column read as `ï..pressure`.
:::

## Common mistakes

:::tip Watch for these
- Reporting `summary()`'s two-sided p-value for a one-sided test.
- "p = probability H₀ is true." It's the probability of data this extreme *if* H₀ is true.
- Using `"confidence"` for a single hurricane like Isaias. One storm needs `"prediction"`.
- Thinking a higher confidence level moves the center.
- Saying the 115-knot interval is wider "because 115 is bigger." Width depends on the distance of x from $\bar x$.
- Saying a near-zero $R^2$ means temperature and salmonella are unrelated, or answering (d) and (e) the same way.
- Leaving out interpretation sentences, or putting written answers inside R chunks.
:::
