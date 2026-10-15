---
id: L10
date: 2026-10-14
title: Prediction intervals and R²
pdf: notes/2026-10-14-prediction.pdf
part: Part II
examples: R7, R8
topics: prediction, average response, confidence interval for the mean response, prediction interval, interval width, extrapolation, residual standard error, R-squared, correlation, nonlinear association
summary: Two kinds of prediction at a new x. The average y (confidence interval) and one individual y (prediction interval) get the same point estimate, but the prediction interval is wider. Both are narrowest at x̄. Then, how good is the model? The residual standard error and R², which is r² in simple regression and the fraction of y's variation explained by x.
takeaways:
- At a new $x^*$, the point estimate is $\hat y = \hat\beta_0 + \hat\beta_1 x^*$ for **both** the average $Y$ and one individual $Y$.
- **Confidence interval** = plausible range for the **average** $E(Y \mid X = x^*) = \beta_0 + \beta_1 x^*$. The uncertainty comes only from not knowing $\beta_0, \beta_1$.
- **Prediction interval** = plausible range for **one new observation** $Y = \beta_0 + \beta_1 x^* + \varepsilon$. It adds the individual scatter $\sigma^2$, so it's **always wider** than the CI at the same $x^*$ and level.
- Both intervals are **narrowest at $x^* = \bar x$** and widen as $x^*$ moves away. That's why extrapolation is risky.
- In R: `predict(model, newdata = data.frame(x = ...), interval = "confidence")` or `interval = "prediction"`, plus `level =`. The column name in `newdata` must match the predictor's name.
- Residual standard error $\hat\sigma$ ≈ how far $y_i$ typically is from $\hat y_i$.
- $R^2 = r_{xy}^2 = 1 - \dfrac{\sum (y_i - \hat y_i)^2}{\sum (y_i - \bar y)^2}$, between 0 and 1: the **fraction of the variation in $y$ explained by $x$** in the linear model.
- Low $R^2$ means either a weak linear association **or** a non-linear relationship. $r$ and $R^2$ only measure **linear** association.
---

## Recap: inference for the slope

After fitting the least squares line to estimate the unknown population relationship $Y = \beta_0 + \beta_1 X + \varepsilon$:

- **Confidence intervals** for $\beta_0$ and $\beta_1$: estimator ± [percentile of $t_{n-2}$] × [standard error of estimator].
- **Hypothesis tests**, especially $H_0: \beta_1 = 0$ vs. $H_A: \beta_1 \ne 0$. A slope of 0 means no linear relationship: $y$ tends to take the same values regardless of $x$, and knowing $x$ wouldn't help predict $y$.
- Test statistic $T = \dfrac{\hat\beta_1 - \beta_1}{\text{se}(\hat\beta_1)}$ = # standard deviations from the expected value. Find the probability of a value at least that far from 0 under $t_{n-2}$.

Today: inference about **predictions** made by the model.

## Two things you might want to predict

:::example Highway runoff
$X$ = rainfall volume (m³), $Y$ = runoff volume (m³). Researchers measured both at one highway location on 15 days. Assume $Y = \beta_0 + \beta_1 X + \varepsilon$, $\varepsilon_i \overset{\text{iid}}{\sim} N(0, \sigma^2)$.
:::

For a particular amount of rainfall $x^{\text{new}}$, there are two different quantities we might want:

:::def A vs. B
- **(A) The average $Y$ when $X = x^{\text{new}}$:** $E(Y \mid X = x^{\text{new}}) = \beta_0 + \beta_1 x^{\text{new}}$, the average runoff over all days with that rainfall.
- **(B) One specific observation:** $y_i = \beta_0 + \beta_1 x^{\text{new}} + \varepsilon_i$, the runoff on one particular future day with that rainfall.
:::

Suppose the fitted line is $\hat y = -1 + 0.83x$. For a day with 100 m³ of rain, $\hat y = -1 + 0.83(100) = 82$ m³.

- (A) average runoff on days with $x = 100$: predict **82**
- (B) runoff on one specific day with $x = 100$: predict **82**

Same value. The line describes the **average** $Y$ at each $x$. On any particular day the runoff could be above or below average, but the average is still the best guess, since deviations from it are random and unpredictable.

**But the precision is different.** Neither prediction is exactly right (both come from sample data), and how close we expect to be is not the same for A and B.

## (A) Confidence interval for the average response

The true average runoff on days with 100 m³ of rain is the $Y$ value on the **population** line: $\beta_0 + 100\beta_1$. Estimating it with the point on our **estimated** line, $\hat\beta_0 + 100\hat\beta_1 = 82$, will be slightly off, because the estimated slope and intercept won't perfectly match $\beta_0, \beta_1$.

We know how precise $\hat\beta_0$ and $\hat\beta_1$ are, so we can also work out how far $\hat\beta_0 + 100\hat\beta_1$ tends to be from $\beta_0 + 100\beta_1$. That lets us build a confidence interval for $\beta_0 + 100\beta_1$, or in general for $\beta_0 + \beta_1 x$ at any $x$.

:::example Interpreting it
Suppose the 95% confidence interval is $[78, 86]$: "We are 95% confident the true average runoff on days with rainfall of 100 is between 78 and 86."
:::

We're uncertain about this quantity only because we don't know the exact slope and intercept of the population relationship.

## (B) Prediction interval for one observation

In the population model, runoff on a day with rainfall 100 is a Normal random variable centered at the point on the population line, with variance $\sigma^2$:
$$Y \mid X = 100 \sim N(\beta_0 + 100\beta_1,\; \sigma^2)$$
So on days with $x = 100$, $y$ is within $\pm 2\sigma$ of $\beta_0 + 100\beta_1$ with 95% probability.

**If we knew the true average**, we'd only have to account for how spread out the $y$ values are around it. **But we don't know the true average.** For a plausible range of runoff on some future day with rainfall 100, there are two sources of uncertainty:

1. individual days are spread out randomly around the average, **and**
2. we aren't exactly sure what the true average is.

:::example Plausible runoff on one future day with $x = 100$
- the average is probably between 78 and 86;
- one individual day can be below or above the average, so maybe 72 to 92.
:::

:::def Confidence interval vs. prediction interval
- Interval for the **average** $y$ when $x = x^*$: **confidence interval**.
- Interval for **one specific** $y$ observation when $x = x^*$: **prediction interval**.

For the **same** $x$ and the **same** confidence level, the **prediction interval is wider**, because of the extra variability of individual values around the average.
:::

:::formula Standard formulas (for reference; not written out in class)
With $\hat y^* = \hat\beta_0 + \hat\beta_1 x^*$ and $t = $ `qt(1 - α/2, df = n - 2)`:
$$\text{CI for the mean:}\quad \hat y^* \pm t\,\hat\sigma\sqrt{\frac1n + \frac{(x^* - \bar x)^2}{(n-1)S_x^2}}$$
$$\text{Prediction interval:}\quad \hat y^* \pm t\,\hat\sigma\sqrt{1 + \frac1n + \frac{(x^* - \bar x)^2}{(n-1)S_x^2}}$$
The extra "1" is the individual scatter $\sigma^2$. In practice use `predict()` in R.
:::

## Interval width depends on $x^*$

Both kinds of interval share an interesting property: **their width depends on the value of $x$ where you're predicting.**

- We're most confident near the middle of the observed data, $x^* = \bar x$, where the intervals are **smallest**.
- Further from the center of the observed $x$ values, we're less confident and the intervals are **wider**. (In the formulas above, that's the $(x^* - \bar x)^2$ term.)

This connects to **extrapolation**: we aren't confident the model makes good predictions for $x$ values very different from the observed range. Drawn around the fitted line, the interval bands curve outward like a bow tie, narrowest at $\bar x$.

See the *Predictions* R example for computing these.

## Assessing the model: is it good at predicting?

Each observation has a random error, so $y$ can't be perfectly predicted from $x$. How close do the predictions tend to be?

**Residual standard error** $\hat\sigma = \sqrt{\hat\sigma^2}$: roughly how far the actual $y_i$ is from the fitted $\hat y_i$, on average. If the $y$ values are very spread out around the true line, then no matter how well we estimate the line, our predictions can be far off.

Another measure of how useful the linear model is for predicting $y$ from $x$: **$R^2$**.

## $R^2$

:::formula $R^2$ in simple linear regression
$$R^2 = (r_{xy})^2, \qquad r_{xy} = \frac{\sum (x_i - \bar x)(y_i - \bar y)}{\sqrt{\sum (x_i-\bar x)^2\,\sum (y_i - \bar y)^2}}$$
$$-1 \le r_{xy} \le 1, \qquad 0 \le R^2 \le 1$$
:::

- $R^2 = 0$: no correlation between the observed $x$ and $y$; a linear model doesn't help predict $y$.
- $R^2 = 1$: $x$ and $y$ are perfectly positively **or** negatively correlated ($r = \pm1$), and the linear model predicts $y$ exactly.
- In between, **larger $R^2$** means the linear model is relatively more useful for predicting $y$.

**Why talk about $R^2$ instead of the correlation?** It has a special interpretation that also works later, with multiple predictor variables:

:::formula $R^2$ as variation explained
$$R^2 = 1 - \frac{\sum_{i=1}^n (y_i - \hat y_i)^2}{\sum_{i=1}^n (y_i - \bar y)^2} = 1 - \frac{\text{variation in } y \text{ NOT explained by the model}}{\text{total variation in } y}$$
:::

- **Numerator:** sum of squared residuals = how spread out $y$ is around the fitted line, i.e. variability that remains **after** fitting the model.
- **Denominator:** how spread out $y$ is overall, the inherent variability **before** fitting a model.
- So $R^2$ = 1 − fraction of $y$'s variability **not** explained = the **fraction of the variation in the observed $y$ values that is explained by $x$** in the fitted linear model.

If every data point fell exactly on a line, all residuals $y_i - \hat y_i$ would be 0, giving $R^2 = 1 - 0 = 1$: the model explains all the variation in $y$.

## Why might $R^2$ be small?

A small $R^2$ means the linear model isn't very successful at predicting $y$. Two possible reasons:

1. **Linear relationship, but a weak association:** points widely scattered around a line.
2. **Wrong model:** the linear regression model wasn't a good choice.

:::tip Important
The correlation $r_{xy}$ and $R^2$ measure the strength of **linear** relationships. If $x$ and $y$ are associated but the relationship isn't linear (a curve, a U-shape), the correlation can be small and a linear model can do a bad job predicting $y$, even though the association is strong. Always look at the scatter plot.
:::

:::tip Homework link
HW 5 #2 is all `predict()` with `interval = "confidence"` vs. `"prediction"`. HW 5 #3(c)–(e) asks you to interpret $R^2$ and to separate "is this **linear model** useful?" from "is **temperature** useful?"; the second can be yes even when $R^2$ is low, if the scatter plot shows a non-linear pattern.
:::
