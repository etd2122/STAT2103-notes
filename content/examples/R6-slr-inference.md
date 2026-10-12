---
id: R6
key: slr-inference
title: Inference for simple linear regression
lecture: L09
topics: load, lm, residuals, sigma hat squared, var, qt, confidence interval, confint, test statistic, pt, p-value, summary, standard error
summary: Confidence intervals and hypothesis tests for the slope on the language-acquisition data (30 households). First by hand (residuals → σ̂², S²ₓ, t percentile, SE), then the same answers in one line with confint() and summary().
takeaways:
- $\hat\sigma^2$ = `sum(model$residuals^2) / (n - 2)`; $S_x^2$ = `var(x)`.
- SE of slope = `sqrt(sigma2_hat / ((n - 1) * Sx2))`. Here 2.796.
- 95% CI: `coef + c(-1, 1) * qt(0.975, df = n - 2) * SE` → [11.15, 22.60]. 90% uses `qt(0.95, ...)` → [12.12, 21.63].
- `confint(model)` and `confint(model, level = 0.9)` give the same intervals for both intercept and slope.
- Test $H_0: \beta_1 = 0$: $t$ = estimate / SE = 6.04; p-value = `2 * (1 - pt(6.04, df = 28))` ≈ $1.66\times10^{-6}$. Reject at 0.05.
- `summary(model)$coefficients` columns: **Estimate, Std. Error, t value, Pr(>|t|)**. The t value and p-value are for $H_0$: coefficient = 0, two-sided.
---

## Set up

### box: Load and plot the data
items: 4-7
what: Language data: $x$ = words spoken to the infant daily (1000s), $y$ = vocabulary at 24 months, for 30 households.
explain:
- `load("file.Rdata")` restores R objects saved earlier; here it creates a data frame called `language`. Change the path to your copy.
- Predictor `spoken_words` on x, response `vocab_size` on y.

### box: Fit the model
items: 9-12
key: true
what: Estimate the line and read off the slope.
explain:
- $\hat y = 158.17 + 16.88x$. Infants whose daily infant-directed speech differs by 1000 words differ in vocabulary by about 16.9 words, on average.

## Confidence intervals by hand

### box: Get the residuals
items: 17-18
what: The residuals $\hat e_i = y_i - \hat y_i$ for all 30 points.
explain:
- You could compute $\hat y_i$ and subtract, but `lm()` already stored them: `model$residuals`.
- They're the vertical distances to the **estimated** line and are our stand-ins for the unknown errors $\varepsilon_i$.

### box: Estimate σ² from the residuals
items: 20-23
key: true
what: $\hat\sigma^2 = \frac{1}{n-2}\sum \hat e_i^{\,2}$.
explain:
- `sum((est_model$residuals)^2)` = 56,122 is the sum of squared residuals (the quantity least squares minimized).
- Divide by $n - 2 = 28$, **not** $n - 1$: $\hat\sigma^2 \approx 2004$.
- $\sqrt{2004} \approx 44.8$ is the residual standard error that `summary()` reports.

### box: Sample variance of x
items: 26-27
what: $S_x^2$, the sample variance of the observed $x$ values.
explain:
- `var()` uses the $n - 1$ denominator, matching $S_x^2$ in the formula.
- Now we have everything for $\text{se}(\hat\beta_1) = \sqrt{\hat\sigma^2 / ((n-1)S_x^2)}$.

### box: The t percentile for 95%
items: 29-30
key: true
what: 97.5th percentile of $t_{28}$.
explain:
- 95% in the middle leaves 2.5% in each tail, so use `qt(0.975, ...)`.
- df = $n - 2$ = 28 for simple linear regression.
- 2.048 is a little bigger than the Normal's 1.96, because $\sigma^2$ was estimated.

### box: Margin of error and the 95% CI
items: 32-36
key: true
what: Combine the pieces: $\hat\beta_1 \pm t_{0.975, 28}\cdot\text{se}(\hat\beta_1)$.
explain:
- Margin of error = 2.048 × 2.796 = 5.73.
- `est_model$coefficients[2]` is the slope (element 2; element 1 is the intercept).
- `c(-1, 1) * ...` computes the minus and plus ends at once.
- 95% CI for $\beta_1$: **[11.15, 22.60]**. We're 95% confident the true average vocabulary difference per 1000 words is between about 11 and 23 words.

### box: 90% CI
items: 39-43
what: Change only the percentile.
explain:
- 90% in the middle → 5% in each tail → `qt(0.95, df = 28)` ≈ 1.70.
- 90% CI: **[12.12, 21.63]**, narrower than the 95% CI. Lower confidence, narrower interval.

## Confidence intervals automatically

### box: confint()
items: 47-52
key: true
what: Get CIs for the intercept and slope in one line.
explain:
- `confint(model)` defaults to 95%. Rows = coefficients, columns = lower and upper bounds.
- The slope row matches the hand calculation exactly: [11.148, 22.603].
- `confint(model, level = 0.9)` for 90%. The intercept's 95% CI is about [119, 197].
- On homework, use `confint()` unless the question asks you to show the calculation.

## Hypothesis tests by hand

### box: Test statistic for H₀: β₁ = 0
items: 57-58
key: true
what: How many standard errors is $\hat\beta_1$ from 0?
explain:
- $t = \dfrac{\hat\beta_1 - 0}{\sqrt{\hat\sigma^2/((n-1)S_x^2)}} = 16.88 / 2.796 = 6.04$.
- The slope estimate is about 6 standard errors away from 0.

### box: Two-sided p-value
items: 60-61
key: true
what: Probability of a $t_{28}$ value at least 6.04 away from 0 in either direction.
explain:
- `1 - pt(6.03538, df = 28)` is the upper tail; multiply by 2 for both tails. (Equivalently `2 * pt(-6.03538, df = 28)`.)
- p ≈ $1.66 \times 10^{-6}$ < 0.05 → **reject $H_0$**: there's evidence of a nonzero linear relationship between words spoken and vocabulary size.
- For a one-sided $H_A: \beta_1 > 0$, don't double: `1 - pt(6.04, df = 28)`.

## Hypothesis tests automatically

### box: summary() of the model
items: 66-67
key: true
what: The full regression summary.
explain:
- **Residuals:** five-number summary of the residuals.
- **Coefficients:** one row per coefficient, with the estimate, SE, t value and p-value (see next box).
- **Residual standard error: 44.77 on 28 degrees of freedom**: that's $\hat\sigma = \sqrt{2004}$ and $n - 2$.
- Stars mark how small each p-value is.

### box: Just the coefficient table
items: 69-70
key: true
what: `summary(model)$coefficients` pulls out only the coefficient table.
explain:
- **Estimate**: $\hat\beta_0 = 158.17$, $\hat\beta_1 = 16.88$.
- **Std. Error**: $\text{se}(\hat\beta_0) = 19.02$, $\text{se}(\hat\beta_1) = 2.796$ (matches the hand calculation).
- **t value** = Estimate / Std. Error, testing $H_0$: coefficient = 0 vs. $H_A$: ≠ 0. Slope: 6.035; intercept: 8.315.
- **Pr(>|t|)**: two-sided p-values. Slope $1.66\times10^{-6}$, intercept $4.77\times10^{-9}$; both < 0.05, so reject both nulls.
- To test a value other than 0, or a one-sided alternative, you have to compute it yourself: $t = (\hat\beta_1 - b)/\text{se}$, then use `pt`.
