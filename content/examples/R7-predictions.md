---
id: R7
key: predictions
title: Predictions and prediction intervals
lecture: L10
topics: read.csv, lm, summary, predict, newdata, interval = "confidence", interval = "prediction", level, extrapolation, simulation
summary: Rainfall vs. runoff at a Texas highway (15 days). Fit the model, read the tests for slope and intercept, then use predict() for point predictions, confidence intervals for the average runoff, and wider prediction intervals for one day. Intervals widen away from x̄. An optional simulation shows where the CI's uncertainty comes from.
takeaways:
- `predict(model, newdata = data.frame(rainfall = 50))` gives $\hat y$. The column name must match the predictor in the model exactly.
- Several $x$ values at once: `data.frame(rainfall = c(25, 50, 75))`.
- `interval = "confidence"` → CI for the **average** $y$ at that $x$. `interval = "prediction"` → interval for **one** new $y$. Add `level = 0.99` for other levels (default 95%).
- Output columns: `fit` (prediction), `lwr`, `upr`.
- At $x = 50$ (near $\bar x = 53.2$): 99% CI is 36.1–44.3, but the 99% prediction interval is 23.9–56.5.
- 95% CI width grows with distance from $\bar x$: 5.9 at $x = 50$, 12 at $x = 120$, 31 at $x = 250$ (extrapolation).
- An intercept test with a large p-value means $\beta_0 = 0$ is plausible, and here that makes sense: no rain, no runoff.
---

## Fitting the model

### box: Load and plot the rainfall data
items: 2-7
what: Rainfall and runoff volumes (m³) on 15 days at one highway location.
explain:
- `read.csv()` loads the data; change the path to your copy of `rain.csv`.
- `head(rain)` shows the columns `rainfall` and `runoff`.
- Rainfall (predictor) on x, runoff (response) on y. The relationship looks strongly linear.

### box: Fit the model and read the summary
items: 9-12
key: true
what: Fit runoff ~ rainfall and look at the tests for the slope and intercept.
explain:
- $\widehat{\text{runoff}} = -1.13 + 0.827\cdot\text{rainfall}$.
- **Slope:** t = 22.6, p = $7.9\times10^{-12}$. Reject $H_0: \beta_1 = 0$; there's strong evidence of a linear relationship.
- **Intercept:** t = −0.48, p = 0.642. **Fail to reject** $H_0: \beta_0 = 0$; the intercept could be 0. In context that makes sense: on days with no rain there should be no runoff.
- Residual standard error 5.24 on 13 df ($n - 2 = 13$); $R^2 = 0.975$, so rainfall explains about 98% of the variation in runoff.

## Making predictions

### box: Predict by hand from the coefficients
items: 23-24
what: Predicted runoff on a day with rainfall 50.
explain:
- `coefficients[1]` is the intercept and `coefficients[2]` the slope, so intercept + 50 × slope = 40.22.

### box: Predict with predict()
items: 27-28
key: true
what: Same prediction using `predict()`.
explain:
- `predict(model, newdata = ...)` needs a **data frame** of new $x$ values.
- The column must have **the same name as the predictor in the model** (`rainfall`), or R won't find it.
- Gives 40.22, same as by hand, without any copy-pasting of coefficients.

### box: Several predictions at once
items: 30-31
what: Predicted runoff for rainfall 25, 50 and 75.
explain:
- Put the values in `c()` inside the data frame: `data.frame('rainfall' = c(25, 50, 75))`.
- You get one prediction per row: 19.5, 40.2, 60.9.

## Intervals

### box: 95% confidence interval for the average runoff
items: 36-37
key: true
what: Plausible range for the **average** runoff over all days with rainfall 50.
explain:
- `interval = "confidence"` adds the columns `lwr` and `upr` next to `fit`.
- "We're 95% confident the true average runoff on days with rainfall of 50 is between 37.3 and 43.2."
- The default level is 95%.

### box: 99% confidence interval
items: 41-42
what: Same, at 99%.
explain:
- `level = 0.99` changes the confidence level.
- 36.1 to 44.3: wider than the 95% CI, and centered at the same value (40.22). Higher confidence, wider interval.

### box: 99% prediction interval for one day
items: 46-47
key: true
what: Plausible range for the runoff on **one individual** day with rainfall 50.
explain:
- `interval = "prediction"` instead of `"confidence"`.
- 23.9 to 56.5, much wider than the 99% CI (36.1 to 44.3), with the **same center**.
- Why wider: one day can land well above or below the average **and** we don't know the true average exactly. The CI only has the second source of uncertainty.

### box: Is x = 120 near the middle of the data?
items: 51-52
what: Check where the observed rainfall values are centered.
explain:
- $\bar x$ = 53.2, so $x = 50$ was near the middle of the data, where predictions are most precise.
- 120 is near the largest observed rainfall, so we expect less precision there.

### box: CI at x = 120: wider
items: 55-56
key: true
what: 95% CI for the average runoff on days with rainfall 120.
explain:
- 92.1 to 104.1, width ≈ 12.
- At $x = 50$ the 95% CI was 37.3 to 43.2, width ≈ 5.9. Same level, but twice as wide here because 120 is far from $\bar x$.

### box: CI at x = 250: extrapolation
items: 61-65
key: true
what: Plug in a rainfall far beyond anything observed.
explain:
- R happily returns 205.6 (189.8 to 221.4), width ≈ 31, much wider again.
- The formula only accounts for uncertainty **if the linear model still holds** out there. At $x = 250$ we have no data to check that, so the real uncertainty is even bigger. That's extrapolation.
- The plots show the confidence band (and the wider prediction band) flaring out away from $\bar x$.

## Simulations (optional)

### box: The fitted line and x = 50
items: 69-70
what: Original data with its fitted line and a red dashed line at rainfall 50.
explain:
- `abline(est_model)` can take the model directly.
- `abline(v = 50, ...)` marks where we're predicting.

### box: A new sample gives a new prediction
items: 73-76
what: Pretend to sample 15 new days from the full population and refit.
explain:
- This code needs a `rain_population` data frame and `N` (its row count), which aren't defined in the notebook as shared. It's illustrative; you can't run it as is.
- The new sample predicts 40.72 at $x = 50$ vs. 40.22 from the original. The estimated average moves from sample to sample.

### box: Compare the two lines
items: 79-80
what: Plot both fitted lines and their predictions at $x = 50$.
explain:
- `points(x = c(50, 50), y = c(...))` marks the two predicted values.
- The two lines cross $x = 50$ at slightly different heights.

### box: 20 samples, 20 estimated averages
items: 83-90
key: true
what: Repeat 20 times; store each fitted line and its prediction at $x = 50$, then plot (and zoom in).
explain:
- Same loop pattern as before, plus `y_preds[i] <- predict(newmodel, newdata = data.frame('rainfall' = 50))`.
- The red dots are 20 estimates of the **average** runoff at rainfall 50.
- Their spread is exactly what the **confidence interval** for the mean response measures. It doesn't include the day-to-day scatter of individual points, which is why prediction intervals are wider.
