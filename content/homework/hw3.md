---
id: HW3
num: 3
title: Confidence intervals and hypothesis tests
pdf: assignments/hw3.pdf
lectures: L04, L05, L06
data: cars.csv
topics: t interval, standard normal, one-sided proportion test, two-sided z test, scatter plot, least squares line, prediction
summary: A small-sample t interval, standardizing a Normal, a one-sided test for a proportion, a two-sided test for a mean with known σ, and a first regression on car weight vs. 0–60 time.
---

### box: Problem 1 · Triathlete heart rate (t interval)
question: $n = 9$, $\bar x = 188$, $s = 7.2$, heart rates Normal. (a) 90% CI for the mean. (b) Normal or t? Why?
code:
```r
n <- 9; xbar <- 188; s <- 7.2
xbar + c(-1, 1) * qt(0.95, df = n - 1) * s / sqrt(n)
```
explain:
- 90% → 5% in each tail → `qt(0.95, ...)`.
- df = $n - 1 = 8$.
- (b) t, because $\sigma$ is **estimated** by the sample SD (and $n$ is small, so it matters).
idea: A confidence interval is estimate ± (how many SEs) × SE. With only 9 athletes and an estimated SD, you need the t distribution, which is wider than the Normal, to stay honest about the extra uncertainty.
walk:
- Estimate: the sample mean, 188.
- SE: how much a mean of 9 bounces around, $s/\sqrt n = 7.2/3 = 2.4$.
- Multiplier: 90% in the middle leaves 5% in each tail, so use the 95th percentile of t with n − 1 = 8 df.
- Interval = 188 ± multiplier × 2.4. Interpret it as a range for the **true average** heart rate of triathletes while swimming.
- (b) t, because σ is unknown and replaced by s. With n = 9 that substitution adds noticeable uncertainty.
pitfall:
- Using `qt(0.90, ...)` for a 90% interval. You need 0.95, because the 10% is split into two tails.
- Saying "90% of triathletes have heart rates in this interval." The CI is about the mean, not individuals.

### box: Problem 2 · Distribution of Z
question: $X \sim N(\mu, \sigma^2)$. What is the distribution of $Z = (X - \mu)/\sigma$?
explain:
- Linear transformations of a Normal are Normal (Sep 16). Combine with HW 1 #2 for the mean and variance.
- State the family **and** both parameters.
idea: Linear transformations of a Normal stay Normal. Standardizing just picks the specific transformation that lands on mean 0, SD 1.
walk:
- Family: Z is a linear function of a Normal, so Z is Normal.
- Parameters: from HW 1 #2, E(Z) = 0 and var(Z) = 1.
- So Z ~ N(0, 1), the standard Normal. That's why one table (or `pnorm` with defaults) works for every Normal.
pitfall:
- Only giving the mean and variance. The question also asks for the **type** of distribution.

### box: Problem 3 · Bottle breakage (one-sided proportion test)
question: Old breakage rate 8%. New packaging: 16 of 300 break. Test whether the new rate is less than 8% at $\alpha = 0.05$.
code:
```r
p0 <- 0.08; n <- 300; p_hat <- 16 / n
z <- (p_hat - p0) / sqrt(p0 * (1 - p0) / n)
pnorm(z)        # lower-tail p-value
```
explain:
- $H_0: p = 0.08$ vs. $H_A: p < 0.08$ (one-sided).
- Under $H_0$ use $p_0$ in the SD, not $\hat p$.
- Lower one-sided → `pnorm(z)`. Compare to 0.05 and state the conclusion **in context** (packaging, breakage).
idea: A hypothesis test asks: "if nothing changed, how weird is what we saw?" Here, "nothing changed" means the breakage rate is still 8%, and we're only interested in evidence that it went **down**.
walk:
- Set up: $H_0: p = 0.08$ (new packaging is no better) vs. $H_A: p < 0.08$. One-sided, because the manufacturer only cares about improvement.
- Observed: 16/300 ≈ 5.3%, lower than 8%. But is that lower than random chance would explain?
- Under $H_0$, $\hat p$ has SD $\sqrt{0.08 \cdot 0.92/300}$. Count how many SDs below 0.08 your 5.3% is: that's z.
- The p-value is the area **below** z (lower tail): the chance of a result this low or lower if the packaging didn't help.
- Decide at 0.05, then translate: "There is / isn't enough evidence that the new packaging reduces breakage."
pitfall:
- Using $\hat p$ in the SD. In a test you assume $H_0$, so use $p_0 = 0.08$.
- Doubling the p-value. This test is one-sided.

### box: Problem 4 · Uranium (two-sided z test)
question: 2016 level 20 µg/L. Now $\sigma = 3$ known, $n = 40$, $\bar x = 18.9$. Has it changed? Conclusions at $\alpha = 0.05$ and 0.01.
code:
```r
z <- (18.9 - 20) / (3 / sqrt(40))
2 * pnorm(-abs(z))   # two-sided p-value
```
explain:
- "Has it changed?" → $H_A: \mu \ne 20$, two-sided, so double the tail.
- $\sigma$ is known → Normal, not t.
- The same p-value can lead to different decisions at different $\alpha$.
idea: Same logic as #3, but for a mean, two-sided ("has it changed?"), and with σ known, so use the Normal. It also shows that the same evidence can lead to different decisions at different α.
walk:
- $H_0: \mu = 20$, $H_A: \mu \ne 20$. "Changed" could mean up or down.
- SE of the mean = $3/\sqrt{40}$. z = (18.9 − 20) / SE.
- Two-sided p-value: the area in *both* tails beyond |z|, i.e. 2 × the lower tail.
- Compare that **one** p-value to 0.05 and to 0.01. A stricter threshold (0.01) demands stronger evidence, so you may reject at one level but not the other.
pitfall:
- Using t: σ = 3 is given as known, so use the Normal.
- Thinking the p-value changes with α. Only the cutoff changes.

### box: Problem 5 · Car weight and 0–60 time
question: cars.csv, 15 cars. (a) Scatter plot with weight on x. (b) Least squares slope and intercept. (c) Expected time for a 4315-lb car.
code:
```r
cars <- read.csv("cars.csv")
names(cars)
plot(x = cars$weight, y = cars$acceleration, xlab = "weight (lbs)", ylab = "0-60 time (s)")
fit <- lm(acceleration ~ weight, data = cars)
fit$coefficients
fit$coefficients[1] + fit$coefficients[2] * 4315
```
explain:
- Same steps as the *Fitting lines* R example. Use the actual column names from `names(cars)`.
- (c) Plug into $\hat y = \hat\beta_0 + \hat\beta_1 x$. You can also use `predict(fit, newdata = data.frame(weight = 4315))`.
idea: Your first regression: summarize how 0–60 time changes with weight using the line that minimizes squared vertical misses, then use the line to predict.
walk:
- Plot first, always. Weight (the predictor) goes on x, acceleration time (the response) on y. Does it look roughly linear? Which direction?
- Fit with `lm(time ~ weight)`. The slope is the average change in time per extra pound; the intercept is where the line crosses weight = 0.
- Predict at 4315 lbs by plugging into $\hat y = \hat\beta_0 + \hat\beta_1 x$. Check that 4315 is within your weight range, so you're not extrapolating.
pitfall:
- Swapping x and y in `lm()`. The formula is `response ~ predictor`.
- Over-reading the intercept: a 0-lb car doesn't exist.

=== wrap-up ===

## Every formula used

:::formula Confidence intervals
- σ unknown (use s): $\bar x \pm t_{n-1}\,\dfrac{s}{\sqrt n}$ (#1)
- σ known: $\bar x \pm z\,\dfrac{\sigma}{\sqrt n}$
- 90% → 0.95 column; 95% → 0.975 column; 99% → 0.995 column
:::

:::formula Hypothesis tests
- Proportion: $z = \dfrac{\hat p - p_0}{\sqrt{p_0(1-p_0)/n}}$, using $p_0$ in the SE (#3)
- Mean, σ known: $z = \dfrac{\bar x - \mu_0}{\sigma/\sqrt n}$ (#4)
- p-value: lower one-sided $= P(Z \le z)$; upper $= P(Z \ge z)$; two-sided $= 2P(Z \ge \lvert z\rvert)$
- Reject $H_0$ when p-value < α
:::

:::formula Standardizing and least squares
- $X \sim N(\mu, \sigma^2)$ ⇒ $Z = (X - \mu)/\sigma \sim N(0, 1)$ (#2)
- $\hat\beta_1 = \dfrac{\sum (x_i - \bar x)(y_i - \bar y)}{\sum (x_i - \bar x)^2}$, $\hat\beta_0 = \bar y - \hat\beta_1\bar x$, $\hat y = \hat\beta_0 + \hat\beta_1 x$ (#5)
:::

## Learning summary

- **Answers:** 90% CI (183.5, 192.5) bpm using t with 8 df (#1); $Z \sim N(0, 1)$ (#2); bottles $z = -1.70$, p ≈ 0.044, reject at 0.05 (#3); uranium $z = -2.32$, two-sided p ≈ 0.020, reject at 0.05 but **not** at 0.01 (#4).
- **CI = estimate ± multiplier × SE.** Use **t** when σ is estimated by s, and z when σ is known or for proportions.
- A test asks **"if nothing changed, how surprising is this?"** The research question sets the direction (one- or two-sided); the data never do.
- The p-value doesn't depend on α. The same evidence can be "significant" at 0.05 but not at 0.01.
- First regression (#5): plot first, fit `response ~ predictor`, then predict inside the observed range.

## What to take away from the R output

:::r Reading the R
- `qt(0.95, df = n - 1)` = the t multiplier for a **90%** interval (5% in each tail). On paper, use the t table's 0.95 column, df row.
- `pnorm(z)` = **lower-tail** p-value; `2 * pnorm(-abs(z))` = **two-sided** p-value.
- `lm(y ~ x)` returns $\hat\beta_0$ (`(Intercept)`) and $\hat\beta_1$ (the x row). The formula is always `response ~ predictor`.
- `fit$coefficients[1] + fit$coefficients[2] * 4315` is just $\hat\beta_0 + \hat\beta_1 x$ written in R.
:::

## Common mistakes

:::tip Watch for these
- `qt(0.90, ...)` for a 90% interval. You need 0.95.
- "90% of triathletes are in this interval." A CI is about the **mean**.
- Using $\hat p$ in a test's SE. A test assumes $H_0$, so use $p_0$.
- Doubling a one-sided p-value, or not doubling a two-sided one.
- Using t when σ is given as known.
- Only giving mean and variance for #2. Also name the **family** (Normal).
- Swapping x and y in `lm()`, or over-interpreting the intercept (a 0-lb car).
:::
