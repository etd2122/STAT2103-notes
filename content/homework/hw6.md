---
id: HW6
num: 6
title: Transformations, outliers and multiple regression
pdf: assignments/hw6.pdf
lectures: L11, L12
data: mileage.csv, voting.csv, SENIC.csv
topics: residual plot, log transformation, interpreting log(y) slope, back-transforming predictions, y outlier, leverage point, influence, multiple regression, holding other variables fixed, t test in multiple regression, F test
summary: Fix a curved, fanning residual plot with log(mpg); find and judge two outliers in voting data and see which one moves the slope; then a first multiple regression on hospital infection risk, where a coefficient's meaning changes once other variables are held fixed. Parts 3(f)–(g) use the F test from the Nov 4 lecture.
---

## Problem 1 · Car weight and fuel efficiency

### box: Problem 1(a)–(b) · Fit mpg on weight, predict at 5000 lb
question: Fit mpg ~ weight (398 cars). Report the coefficients and predict mpg for a 5000-lb car.
code:
```r
mileage <- read.csv("mileage.csv")
fit1 <- lm(mpg ~ weight, data = mileage)
fit1$coefficients
predict(fit1, newdata = data.frame(weight = 5000))
```
explain:
- $\widehat{\text{mpg}} = 46.32 - 0.00768 \cdot \text{weight}$: each extra 1,000 lb goes with about 7.7 fewer mpg on average.
- At 5000 lb: $46.32 - 0.00768(5000) \approx$ **7.9 mpg**.
idea: An ordinary straight-line fit. Hold onto the 7.9 mpg prediction; part (g) will show the straight line is too pessimistic for heavy cars.
walk:
- Response first in the formula: `mpg ~ weight`.
- Plug 5000 into the line. 5000 lb is near the top of the observed range (about 1,600–5,100 lb), so it's not extrapolation, but it's where a wrong shape would hurt most.
pitfall:
- Interpreting the intercept (a 0-lb car).

### box: Problem 1(c) · Residual plot for the straight-line model
question: Plot the residuals against weight. Are any assumptions violated?
code:
```r
plot(x = mileage$weight, y = fit1$residuals,
     xlab = "weight (lbs)", ylab = "residual")
abline(h = 0, lty = 2)
```
explain:
- **Curve:** residuals are positive for light cars, negative in the middle, positive again for heavy cars, so **linearity** is violated.
- **Fan:** the spread is wider for light cars than heavy ones, so **constant variance** looks violated too.
idea: The residual plot shows what the line missed. A U-shape means the true relationship bends; a fan means the noise isn't the same size everywhere.
walk:
- Look for **shape** first (a pattern in where the points are centered), then **spread** (whether the vertical scatter changes with x).
- Here both problems appear. Linearity breaks everything (estimates, predictions, inference); the fan breaks inference.
pitfall:
- Calling the U-shape "non-constant variance." The curve is about the center, the fan about the spread.

### box: Problem 1(d)–(e) · log(mpg) model and its slope
question: Fit log(mpg) ~ weight. Report the coefficients and interpret the slope.
code:
```r
fit2 <- lm(log(mpg) ~ weight, data = mileage)
fit2$coefficients
exp(fit2$coefficients[2] * 1000)   # ratio for 1,000 lb heavier
```
explain:
- $\widehat{\log(\text{mpg})} = 4.145 - 0.000351 \cdot \text{weight}$.
- Slope: cars 1 lb heavier have mpg about $e^{-0.000351} \approx 0.99965$ times as large, i.e. **0.035% lower** on average. More usefully, **1,000 lb heavier → mpg about 0.70 times as large (30% lower)**.
idea: With log(y), the slope describes a **percent (multiplicative)** difference in y, not a fixed number of mpg. That fits cars better: an extra 1,000 lb costs a light car more mpg than a heavy one.
walk:
- `log()` in R is the natural log, which is what the class uses.
- Ratio for a $k$-unit difference in x: $e^{k\hat\beta_1}$. Use a sensible k (1,000 lb) so the number means something.
- Small-slope shortcut: $100 \times \hat\beta_1$ ≈ percent change per unit, so −0.035% per lb.
pitfall:
- Saying "mpg drops by 0.000351 per pound." That's the change in **log** mpg.

### box: Problem 1(f)–(g) · Residuals after the log, and predicting at 5000 lb
question: Plot residuals of the log model against weight; is it better? Predict mpg for a 5000-lb car.
code:
```r
plot(x = mileage$weight, y = fit2$residuals,
     xlab = "weight (lbs)", ylab = "residual (log scale)")
abline(h = 0, lty = 2)
exp(predict(fit2, newdata = data.frame(weight = 5000)))
```
explain:
- The U-shape is mostly gone and the spread is more even across weights: **an improvement**. Some slight curvature may remain; say what you see.
- Prediction: $e^{4.145 - 0.000351(5000)} = e^{2.389} \approx$ **10.9 mpg**, vs. 7.9 from the straight line.
idea: `predict()` gives a prediction of **log(mpg)**. You have to undo the log with `exp()` to get back to mpg.
walk:
- Compare the two residual plots side by side: is there still a pattern in the center? Is the vertical spread more even?
- Back-transform: $\hat y = e^{\hat\beta_0 + \hat\beta_1 x}$.
- The curved model predicts more mpg for heavy cars because the straight line kept falling too fast at the high end (that's what the positive residuals there were telling you).
pitfall:
- Reporting 2.39 as the predicted mpg (forgetting `exp`).

## Problem 2 · Voting stations and outliers

### box: Problem 2(a)–(b) · Fit, plot, find the two outliers
question: Fit dem_votes ~ turnout (70 stations), draw the line, and find the y outlier and the x outlier.
code:
```r
voting <- read.csv("voting.csv")
fit_all <- lm(dem_votes ~ turnout, data = voting)
fit_all$coefficients
plot(voting$turnout, voting$dem_votes, xlab = "turnout", ylab = "Democratic share")
abline(fit_all)
head(voting, 3)
```
explain:
- $\widehat{\text{dem}} = -0.077 + 1.039 \cdot \text{turnout}$.
- **Unusual y:** (0.70, **1.15**), row 1: typical turnout, but a vote share of 115%.
- **Unusual x:** (**0.33**, 0.40), row 2: turnout far below every other station (the rest are about 0.56–0.80).
idea: "Unusual in y" and "unusual in x" are different problems. One sits far above the cloud; the other sits far to the side of it.
walk:
- Look at the scatter plot: one point floats above everything; one sits alone at the far left.
- The tip says print the first rows: both are rows 1 and 2.
pitfall:
- Mixing up which coordinate is unusual. Name each by what's odd about it.

### box: Problem 2(c) · Can you justify removing them?
question: Can you justify removing either outlier?
explain:
- **y outlier: yes.** A vote share of 1.15 (115%) is **impossible**: it must be a recording error.
- **x outlier: no clear justification.** A 33% turnout is low but possible (bad weather, a small or remote station). Unusual ≠ wrong.
idea: The rule from Oct 21: delete a point **only** if it's impossible or clearly a mistake. Otherwise, fit with and without it and report both.
walk:
- For each point, ask: could this value actually happen? A share above 100% can't; a low turnout can.
pitfall:
- Removing a point just because it doesn't fit the pattern.

### box: Problem 2(d)–(g) · Remove each outlier and compare slopes
question: Refit without the y outlier, then without the x outlier. Plot all three lines. Which point has more influence on the slope?
code:
```r
fit_noY <- lm(dem_votes ~ turnout, data = voting[-1, ])   # drop row 1 (y outlier)
fit_noX <- lm(dem_votes ~ turnout, data = voting[-2, ])   # drop row 2 (x outlier)
c(fit_all$coefficients[2], fit_noY$coefficients[2], fit_noX$coefficients[2])

plot(voting$turnout, voting$dem_votes, xlab = "turnout", ylab = "Democratic share")
abline(fit_all, lty = 1)
abline(fit_noY, lty = 2, col = "blue")
abline(fit_noX, lty = 3, col = "red")
legend("topleft", c("all data", "no y outlier", "no x outlier"),
       lty = 1:3, col = c("black", "blue", "red"))
```
explain:
- Slopes: all data **1.039**; without the y outlier **0.996** (barely moves); without the x outlier **1.237** (moves a lot).
- **The x outlier (leverage point) has more influence on the slope.**
idea: A point at a typical x can only push the line up or down a little; a point far out in x acts like a lever and can tilt the whole line.
walk:
- `voting[-1, ]` means "all rows except row 1."
- Compare each new slope with 1.039. The size of the change is the influence.
- This matches the Oct 21 notes: y outliers mainly inflate $\hat\sigma$; leverage points move $\hat\beta_0, \hat\beta_1$.
pitfall:
- Dropping both points in (e). The question says keep the y outlier in that fit.
- Assuming the "worse-looking" point is the influential one.

## Problem 3 · Hospital infection risk (multiple regression)

### box: Problem 3(a)–(b) · Histogram, then IR on Beds alone
question: Histogram of IR. Then fit IR ~ Beds; give and interpret the slope.
code:
```r
senic <- read.csv("SENIC.csv")
hist(senic$IR, xlab = "infection risk (%)", main = "")
fit_beds <- lm(IR ~ Beds, data = senic)
fit_beds$coefficients
```
explain:
- The histogram is roughly bell-shaped, centered near 4–5%.
- $\widehat{\text{IR}} = 3.724 + 0.00250 \cdot \text{Beds}$. Hospitals with 100 more beds have infection risk about **0.25 percentage points higher**, on average.
idea: A simple regression compares hospitals of different sizes, ignoring everything else about them. Bigger hospitals also differ in length of stay, services and staffing.
walk:
- Scale the slope to a sensible difference: 1 bed is tiny, 100 beds is meaningful.
- Observational data: "differ by," not "adding beds causes."
pitfall:
- Units: IR is already in percentage points, so 0.25 means 0.25 points (e.g. 4.0% vs. 4.25%), not 25%.

### box: Problem 3(c) · All five predictors: the Beds coefficient
question: Fit IR on Age, Stay, Beds, Services and Nurses. What's the Beds coefficient now, and what does it mean?
code:
```r
fit_all <- lm(IR ~ Age + Stay + Beds + Services + Nurses, data = senic)
summary(fit_all)
```
explain:
- Beds coefficient: **−0.00285**. Among hospitals with the **same** average age, length of stay, services and nurses, 100 more beds goes with infection risk about **0.29 points lower**, on average.
- It flipped sign from part (b) (+0.0025 → −0.0029).
idea: In multiple regression, each slope compares units that are alike on all the **other** predictors. Bigger hospitals have more nurses, longer stays and more services, which go with higher infection risk. Once those are held fixed, the remaining association with beds is slightly negative.
walk:
- Read the coefficient from the `Beds` row of `summary()`.
- Always say "holding the other variables fixed" (or "among hospitals with the same …").
- The sign flip is omitted variable bias in action: model (b) left out variables related to both Beds and IR.
pitfall:
- Interpreting the multiple-regression slope as if the other variables weren't there.

### box: Problem 3(d) · Predict with both models
question: Predict IR for Stay = 7, Age = 45, Beds = 550, Nurses = 115, Services = 40, using models (b) and (c). Compare.
code:
```r
new <- data.frame(Stay = 7, Age = 45, Beds = 550, Nurses = 115, Services = 40)
predict(fit_beds, newdata = new)
predict(fit_all, newdata = new)
```
explain:
- Model (b): **5.10%**. Model (c): **2.48%**.
- Very different. Model (c) uses the short stay and few nurses; model (b) sees only a big hospital.
- Caution: 550 beds with only 115 nurses is an unusual **combination**. In the data, hospitals that big have about 200–650 nurses, so model (c) is extrapolating even though each value alone is in range.
idea: More predictors can sharpen a prediction, but only for combinations like those in the data.
walk:
- `predict()` needs every predictor in the model, with the same names.
- Compare the numbers, then ask whether this hospital looks like the ones the models were fit to.
pitfall:
- Assuming the bigger model is automatically right. Check for hidden extrapolation.

### box: Problem 3(e) · t test for Age
question: Test $H_0: \beta_{\text{Age}} = 0$ at 5% in the five-predictor model. Interpret.
explain:
- From `summary(fit_all)`: Age estimate −0.0217, t ≈ −0.91, p ≈ **0.36**.
- p > 0.05: **fail to reject.** Holding stay, beds, services and nurses fixed, there's no significant linear association between patients' average age and infection risk.
idea: In multiple regression, each t test asks: does this variable add anything **once the others are already in the model**?
walk:
- df = n − (number of coefficients) = 113 − 6 = 107; R does this for you.
- Say "holding the others fixed" in the conclusion.
pitfall:
- Concluding age doesn't matter at all. It may be related to IR on its own; it just adds nothing beyond the other four (and failing to reject isn't proof of 0).

### box: Problem 3(f)–(g) · Is the model useful overall? (F test)
question: State the hypotheses for "is the model useful?", run the test, and conclude at 5%. (Covered Nov 4.)
explain:
- $H_0: \beta_1 = \beta_2 = \beta_3 = \beta_4 = \beta_5 = 0$ (none of the predictors helps). $H_A$: at least one $\beta_j \ne 0$.
- The **F-statistic** at the bottom of `summary(fit_all)`: F ≈ 12.8 on 5 and 107 df, **p ≈ 9.4 × 10⁻¹⁰**.
- p < 0.05: **reject** $H_0$. The model is useful: at least one predictor is linearly associated with infection risk. ($R^2 \approx 0.37$.)
idea: The F test checks all the slopes at once. It answers "is anything here?", not "which one?"
walk:
- Find the last line of `summary()`: `F-statistic: … on 5 and 107 DF, p-value: …`.
- The individual t tests then show which predictors matter given the others (Stay, Beds, Nurses at 5% here).
pitfall:
- Writing $H_A$ as "all $\beta_j \ne 0$." It's **at least one**.
- Using the intercept in the hypotheses. The F test is about the slopes only.

=== wrap-up ===

## Every formula used

:::formula Transformations
- log(y) model: $\widehat{\log y} = \hat\beta_0 + \hat\beta_1 x$; a $k$-unit difference in x multiplies predicted y by $e^{k\hat\beta_1}$ (#1e)
- Back-transform a prediction: $\hat y = e^{\hat\beta_0 + \hat\beta_1 x^*}$ (#1g)
:::

:::formula Multiple regression
- $\hat y = \hat\beta_0 + \hat\beta_1 x_1 + \cdots + \hat\beta_p x_p$ (#3c–d)
- t test for one coefficient: $t = \hat\beta_j / \text{se}(\hat\beta_j)$, df $= n - p - 1$ (#3e)
- F test: $H_0: \beta_1 = \cdots = \beta_p = 0$ vs. $H_A$: at least one $\ne 0$ (#3f–g)
:::

## Learning summary

- **Answers:** mpg = 46.32 − 0.00768·weight, 7.9 mpg at 5000 lb; log model 4.145 − 0.000351·weight, 1,000 lb heavier ≈ 30% lower mpg, 10.9 mpg at 5000 lb. Voting slope 1.039; without the y outlier 0.996; without the x outlier 1.237. SENIC: Beds alone +0.0025; with all five −0.00285; predictions 5.10% vs. 2.48%; Age p ≈ 0.36; F p ≈ 9×10⁻¹⁰.
- A residual plot with a **curve and a fan** calls for a transformation of y; log(y) fixed both here.
- After log(y), slopes are **percent** differences and predictions need `exp()`.
- A **leverage point** (unusual x) moved the slope far more than a **y outlier**. Only the impossible point (115% vote share) can be justified for removal.
- In multiple regression a coefficient means "**holding the others fixed**," and it can even change sign from the simple regression.

## What to take away from the R output

:::r Reading the R
- `lm(log(mpg) ~ weight)` fits on the log scale; `predict()` returns log(mpg), so wrap it in `exp()`.
- `data[-1, ]` drops row 1; refitting with and without a point shows its influence.
- `summary()` of a multiple regression has one row per predictor: Estimate, Std. Error, t value, Pr(>|t|), each **given the other predictors**.
- The bottom line `F-statistic: … p-value: …` is the overall usefulness test.
- `predict(fit, newdata = data.frame(...))` needs a value for every predictor.
:::

## Common mistakes

:::tip Watch for these
- Reporting a log-scale prediction without `exp()`.
- Calling a U-shaped residual plot "non-constant variance."
- Deleting an outlier because it's inconvenient rather than impossible.
- Interpreting a multiple-regression slope without "holding the others fixed."
- Writing the F test alternative as "all slopes ≠ 0."
- Trusting a prediction for an unusual combination of predictor values.
:::
