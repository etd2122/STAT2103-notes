---
id: R9
key: diagnostics
title: Diagnostics and remedial measures
lecture: L11
topics: residual plot, abline(h = 0), transformations, log, sqrt, lm with transformed variables, non-constant variance, observation index, lagged residuals, histogram of residuals, Q-Q plot
summary: Six small data sets, each breaking a different assumption. For each one, plot the data and the residuals, diagnose the problem, and either fix it with a transformation (Examples 1–3) or decide what you can and can't trust (Examples 4–6).
takeaways:
- Residual plot recipe: `model <- lm(y ~ x)`, then `plot(x, model$residuals); abline(h = 0)`.
- You can transform inside `lm()`: `lm(y ~ log(x))`, `lm(sqrt(y) ~ x)`, `lm(log(y) ~ log(x))`. Plot the residuals against the **transformed** x you used.
- Workflow: plot → fit → residual plot → spot a pattern → try a transformation → re-plot → repeat until the residuals look like random noise around 0.
- Transform **x** to fix shape without changing the vertical spread; transform **y** when the spread also needs fixing.
- Non-constant variance, correlated errors and non-normal errors: keep the estimates and predictions, but don't trust the usual CIs and tests (for non-normality with large n, only prediction intervals are clearly off).
- Ordered data: `plot(1:n, model$residuals, type = "l")` and the lag plot `plot(res[1:(n-1)], res[2:n])`.
- Normality: `hist(model$residuals, probability = TRUE)` and `plot(model, which = 2)` for the Q-Q plot.
---

## Example 1 · Non-linear: transform x

### box: Look at the data
items: 2-3
what: Scatter plot of the first data set.
explain:
- The data (`x`, `y`) for each example were created in the instructor's notebook and aren't shown. The code works the same on any `x`, `y` you have.
- The relationship bends: it rises steeply at first, then levels off. It's not obvious whether the spread changes with x.

### box: Residuals from a straight line
items: 6-7
key: true
what: Fit `lm(y ~ x)` and plot the residuals against x.
explain:
- `model1$residuals` are $y_i - \hat y_i$. `abline(h = 0)` draws the zero line to judge them against.
- Clear pattern: **negative** for small and large x, **positive** in the middle. The line overshoots at the ends and undershoots in the middle.
- A systematic pattern like this means the **linearity** assumption fails.

### box: Try √x
items: 12-16
what: Plot y against √x, fit `lm(y ~ sqrt(x))`, and check its residuals.
explain:
- They transform **x** rather than y because it's unclear whether the spread changes; transforming y would also change the vertical spread.
- Better, but still curved, and the residuals still show a pattern. √x isn't a strong enough transformation.
- Plot the residuals against `sqrt(x)`, the predictor you actually used in the model.

### box: Try log(x)
items: 19-23
key: true
what: Plot y against log(x), fit `lm(y ~ log(x))`, and check its residuals.
explain:
- y vs. log(x) looks like a straight line.
- The residuals are randomly scattered around 0 with similar spread at all log(x). **Satisfactory.**
- The final model is $\hat y = \hat\beta_0 + \hat\beta_1 \log(x)$. Its slope means "y differs by $\hat\beta_1$ when log(x) differs by 1", i.e. when x is multiplied by $e \approx 2.72$.

## Example 2 · Non-linear and fanning out: transform y

### box: Data and residuals
items: 27-32
key: true
what: Scatter plot, then residuals from `lm(y ~ x)`.
explain:
- Scatter: maybe somewhat curved, not extremely clear.
- Residuals: mostly small and positive at small x, then **much more spread out** at large x.
- Two problems at once: **non-linearity** and **non-constant variance**. A residual plot often reveals what the scatter plot hides.

### box: log(x) and log(y) don't help
items: 39-44
what: Try y vs. log(x), and log(y) vs. x.
explain:
- Neither looks linear. Not every transformation works, so you try a few and look.

### box: √y works
items: 47-54
key: true
what: Plot √y vs. x, fit `lm(sqrt(y) ~ x)`, draw the line, then check the residuals.
explain:
- √y vs. x looks much more linear.
- The residuals are now evenly scattered around 0, with no obvious pattern and similar spread. **Satisfactory.**
- Transforming **y** fixed both problems, because it compresses large y values and so shrinks the spread where it was biggest.
- Note: predictions from this model are for √y. Square them to get back to y.

## Example 3 · Transform both

### box: The data
items: 57-59
what: A strongly curved relationship.
explain:
- (The first image is a scatter plot drawn before the code chunk in the original notebook.)

### box: log(y) alone, log(x) alone
items: 62-67
what: Try each single-log transformation.
explain:
- log(y) vs. x: still curved. y vs. log(x): still curved.

### box: log(x) and log(y): the log–log model
items: 70-74
key: true
what: Plot log(y) vs. log(x), fit `lm(log(y) ~ log(x))`, and check the residuals.
explain:
- Straight-looking, and the residuals are evenly scattered with no pattern. **Nothing concerning.**
- Interpretation: multiplying x by $k$ multiplies predicted y by $k^{\hat\beta_1}$. A 1% difference in x goes with about a $\hat\beta_1$% difference in y.

## Example 4 · Non-constant variance

### box: Linear but fanning out
items: 78-82
key: true
what: Scatter plot with the fitted line.
explain:
- The relationship **is** linear, but the y values spread out more at larger x.

### box: The residual plot confirms it
items: 84-85
key: true
what: Residuals vs. x.
explain:
- Roughly equal numbers of positive and negative residuals at each x, so the line is in the right place.
- But the residuals get **larger in magnitude** as x increases: a fan shape. The errors don't all have the same variance.
- **What to do:** transformations usually don't help here (the relationship is already linear, and transforming could bend it). It's still fine to use the estimated slope and intercept and to make predictions, but **don't use the usual CIs or hypothesis tests**.

## Example 5 · Correlated errors

### box: Looks fine against x
items: 94-99
what: Scatter plot and residuals vs. x.
explain:
- Roughly linear; the residuals look randomly scattered around 0. Nothing wrong yet.

### box: Residuals in time order
items: 103-104
key: true
what: If the observations were taken in order (day 1, 2, …), plot the residuals against the observation index.
explain:
- `x = 1:length(x)` puts the index on the x-axis; `type = "l"` connects consecutive residuals with lines, and `points()` adds the dots.
- **Runs** of several positive residuals, then several negative: a sign of **positive correlation** between consecutive errors.
- With negative correlation you'd see the sign flip almost every step instead.

### box: Lagged residual plot
items: 107-108
key: true
what: Plot each residual against the next one.
explain:
- `res[1:(n-1)]` is days 1 to n−1 and `res[2:n]` is days 2 to n, so each point is (today's residual, tomorrow's residual).
- Independent errors would give a round blob. Here the points line up along a **diagonal**, supporting correlated errors.
- **Implications:** the estimates and predictions are still fine; CIs and tests (for coefficients and predictions) are not correct. Models for correlated errors come later.

## Example 6 · Non-normal errors

### box: Linear with even spread
items: 115-119
what: Scatter plot and residuals vs. x.
explain:
- Linear, and the residuals are evenly spread with similar size at every x. Linearity and constant variance look fine.

### box: Histogram of residuals
items: 122-123
key: true
what: Check the **shape** of the residuals' distribution.
explain:
- `probability = TRUE` puts density on the y-axis so it can be compared to a Normal curve.
- The shape doesn't look like a bell curve.

### box: Q-Q plot
items: 125-126
key: true
what: `plot(model1, which = 2)` makes the Normal Q-Q plot of the standardized residuals.
explain:
- If the errors were Normal, the points would lie along the dashed diagonal.
- Here they bend away from it, especially in the tails, so normality is possibly violated. R labels the few most extreme points with their row numbers.
- **Implications:** the estimates and predictions are valid. Technically inference isn't, but in practice (with a reasonable sample size) everything **except prediction intervals for a new y** is probably close to correct.
