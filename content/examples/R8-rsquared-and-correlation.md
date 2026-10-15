---
id: R8
key: rsquared-and-correlation
title: R² and correlation
lecture: L10
topics: cor, R-squared, residuals, sum of squares, summary, Multiple R-squared, par(mfrow), nonlinear association
summary: Three small data sets show what R² measures. A strong linear pattern (r = 0.83, R² = 0.69), a weak linear pattern (r = 0.42, R² = 0.18), and a clear curved pattern where the line misses entirely (r = −0.21, R² = 0.04). R² is computed three ways: cor()², 1 − SSE/SST, and summary().
takeaways:
- `cor(x, y)` = sample correlation $r$. In simple regression $R^2$ = `cor(x, y)^2`.
- $R^2 = 1 - \dfrac{\text{sum of squared residuals}}{\text{total sum of squares}}$ = `1 - sum(model$residuals^2) / sum((y - mean(y))^2)`.
- `summary(model)` reports it as **Multiple R-squared** (second-to-last line).
- Interpretation: "$R^2$ × 100% of the variation in $y$ is explained by $x$ in the linear model."
- Lower $R^2$ = points more spread out around the line.
- $r$ and $R^2$ only measure **linear** association. A strong curved relationship can have $R^2 \approx 0$, so always plot the data.
---

## A strong linear association

### box: Plot the first data set with its regression line
items: 1-2
what: A data set with a clear linear trend and its least squares line.
explain:
- The data `x`, `y` and the fitted `model1 <- lm(y ~ x)` were created earlier in the instructor's notebook (not shown). To run this yourself, make your own `x`, `y` and fit `model1` first.
- `legend(..., "least squares \n regression line")`: `\n` breaks the label onto two lines.

### box: Correlation, and R² as its square
items: 4-8
key: true
what: Compute $r$ and square it.
explain:
- `cor(x, y)` = 0.833, a fairly strong positive correlation.
- With one predictor, $R^2 = r^2$ = 0.694.
- **Interpretation:** about 70% of the variation in the observed $y$ values is explained by the differences in $x$, in the fitted linear model.

### box: R² from sums of squares
items: 11-18
key: true
what: Compute $R^2 = 1 - \dfrac{\sum (y_i - \hat y_i)^2}{\sum (y_i - \bar y)^2}$ step by step.
explain:
- `sum(model1$residuals^2)` = 41.9: variation in $y$ **not** explained (left over around the line).
- `sum((y - mean(y))^2)` = 137.2: **total** variation in $y$ before fitting anything.
- Their ratio, 0.306, is the fraction **not** explained; 1 − 0.306 = 0.694, the same as $r^2$.

### box: R² in summary()
items: 20-21
key: true
what: Find $R^2$ in the regression summary.
explain:
- Look for **Multiple R-squared: 0.6943** on the second-to-last line. That's the number to report.
- (Adjusted R-squared matters once there are several predictors; you can ignore it for now.)

## A weaker linear association

### box: Second data set
items: 24-25
what: Data scattered more widely around a line.
explain:
- `pch = 16` draws solid points.
- There's still an upward trend, but the points are much more spread out.

### box: Lower correlation and R²
items: 27-31
key: true
what: $r$ and $R^2$ for the second data set.
explain:
- `cor(x2, y2)` = 0.424 → $R^2$ = 0.18 (the summary shows **Multiple R-squared: 0.1799**).
- Only 18% of the variation in $y$ is explained by $x$.
- The slope is still significant (p = 0.0195). A real but weak linear relationship: a low $R^2$ doesn't mean the slope is 0.

### box: Side by side on the same axes
items: 33-34
what: Plot both data sets with identical axis ranges.
explain:
- `par(mfrow = c(1, 2))` puts the next two plots in 1 row, 2 columns.
- Using the same `xlim`/`ylim` makes it a fair comparison: the lower-$R^2$ data are clearly more spread out around their line.

## A non-linear association

### box: Curved data
items: 39-40
key: true
what: $x$ and $y$ are clearly related, but not along a straight line.
explain:
- The association looks strong, but the least squares line misses the curved pattern completely.

### box: Correlation and R² miss it
items: 44-48
key: true
what: $r$ and $R^2$ for the curved data.
explain:
- `cor(x3, y3)` = −0.21 and **Multiple R-squared: 0.043**, nearly 0; the slope's p = 0.27.
- A low $R^2$ can mean a **weak linear** association **or** a relationship that's **not linear**. The numbers alone can't tell you which; the scatter plot can.
- For HW 5 #3: if the plot shows a clear curve, $x$ may still be useful for predicting $y$, even though this **linear** model isn't.
