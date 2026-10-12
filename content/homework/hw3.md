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

### box: Problem 2 · Distribution of Z
question: $X \sim N(\mu, \sigma^2)$. What is the distribution of $Z = (X - \mu)/\sigma$?
explain:
- Linear transformations of a Normal are Normal (Sep 16). Combine with HW 1 #2 for the mean and variance.
- State the family **and** both parameters.

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
