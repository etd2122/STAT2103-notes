---
id: HW2
num: 2
title: Binomial, Normal and a first confidence interval
pdf: assignments/hw2.pdf
lectures: L02, L03, L04
data: scores.csv
topics: Normal pdf overlay, rnorm simulation, binomial probabilities, qnorm, sum of independent normals, proportion confidence interval
summary: Compare real GRE scores to a Normal model, binomial calculations about homeschooling, Normal percentiles for birdseed (one day and a week), and a sea-turtle sex-ratio question that previews confidence intervals and tests.
---

### box: Problem 1 · GRE verbal vs. Normal(151, 8²)
question: (a) Histogram of verbal scores with the $N(151, 8^2)$ pdf on top. (b) Simulate 3000 draws: what fraction < 130 and > 170? (c) Real scores are only 130–170. Is the Normal a good model or a good approximation?
code:
```r
hist(scores$verbal, probability = TRUE, xlab = "verbal score")
curve(dnorm(x, mean = 151, sd = 8), add = TRUE)

sims <- rnorm(n = 3000, mean = 151, sd = 8)
mean(sims < 130)   # fraction below 130
mean(sims > 170)   # fraction above 170
```
explain:
- Same pattern as the last box of the Binomial & Normal R example: `probability = TRUE` then `curve(..., add = TRUE)`.
- `mean(sims < 130)` works because `sims < 130` is a vector of TRUE/FALSE, and the mean of those is the fraction TRUE.
- (c) If only a tiny fraction of simulated scores fall outside 130–170, the Normal can still be a good **approximation** even though it isn't literally correct.
rknow:
- `hist(..., probability = TRUE)` :: Puts the histogram on the **density** scale (bar areas add to 1) instead of counts. Required so a pdf curve can sit on top of it.
- `curve(dnorm(x, mean = 151, sd = 8), add = TRUE)` :: Draws the N(151, 8²) bell curve over the histogram. `add = TRUE` means "on the existing plot." `dnorm` gives the **height** of the pdf, not a probability.
- `rnorm(n = 3000, mean = 151, sd = 8)` :: **r** = random draws: 3000 fake scores from the model.
- `sims < 130` :: Gives a TRUE/FALSE for each draw.
- `mean(sims < 130)` :: TRUE counts as 1 and FALSE as 0, so the mean is the **fraction** below 130. About **0.004** (it varies a little each run).
- `mean(sims > 170)` :: About **0.009**.
- Takeaway for (c) :: Under 1.5% of the model's scores are impossible values, so N(151, 8²) is not literally correct but is a good **approximation**.
paper: $P(X < 130) = P(Z < (130-151)/8) = P(Z < -2.63) \approx 0.004$. The simulation just estimates this z-table answer by brute force.
idea: A model is a simplification. The question isn't whether GRE scores are *exactly* Normal (they can't be, since they're capped at 130–170), but whether Normal is a *good enough* approximation.
walk:
- Overlaying the pdf on the histogram is a visual check: does the bell curve trace the bar heights? Use `probability = TRUE` so both are on the same scale.
- Simulating 3000 draws from N(151, 8²) shows what the model *predicts*: what fraction it would put below 130 or above 170.
- Compare: the real test makes those fractions exactly 0. If the model only puts a tiny sliver out there, the mismatch barely matters.
- Conclude: not literally Normal (impossible values exist under the model), but a reasonable approximation if the overlay fits and the tails are tiny.
pitfall:
- Saying "not Normal, so the model is useless." Almost no real data is exactly Normal.
- Comparing a count histogram to a density curve. Without `probability = TRUE` the curve looks flat.

### box: Problem 2 · Homeschooled children (binomial)
question: 16% of Alaskan children are homeschooled. (a) $P(\text{at least one of 4})$. (b) $P(\text{at least 20\% of 30})$. (c) Smallest $n$ so $P(\ge 2) \ge 0.75$.
code:
```r
1 - dbinom(0, size = 4, prob = 0.16)        # (a)
1 - pbinom(5, size = 30, prob = 0.16)       # (b) 20% of 30 = 6, so P(Y >= 6)
n <- 1:50
which(1 - pbinom(1, size = n, prob = 0.16) >= 0.75)[1]   # (c)
```
explain:
- "At least one" = 1 − P(none).
- $P(Y \ge 6) = 1 - P(Y \le 5)$. Watch the off-by-one.
- (c) `pbinom` accepts a vector of sizes; `which(...)[1]` finds the first $n$ that works.
rknow:
- `1 - dbinom(0, size = 4, prob = 0.16)` :: $1 - P(Y = 0) = 1 - 0.84^4 =$ **0.502**.
- `1 - pbinom(5, size = 30, prob = 0.16)` :: $P(Y \ge 6) = 1 - P(Y \le 5) =$ **0.345**. The cutoff is 5, not 6.
- `n <- 1:50` :: The vector 1, 2, …, 50: every sample size to try.
- `1 - pbinom(1, size = n, prob = 0.16)` :: $P(Y \ge 2)$ computed for **all 50** values of n at once.
- `which(... >= 0.75)[1]` :: `which` returns the positions where the condition is TRUE, and `[1]` takes the first one. Prints **16** (P = 0.751; n = 15 gives only 0.718).
paper: "at least one" = $1 - (1-p)^n$. For (c) you'd try values of n one at a time. That's exactly what the code automates.
idea: Every "how many out of n" question with a fixed success chance is a binomial. The trick is translating the words into the right inequality.
walk:
- (a) "At least one" is easiest as 1 − P(none). P(none) is just $(1 - 0.16)^4$.
- (b) 20% of 30 is 6, so you want P(Y ≥ 6) = 1 − P(Y ≤ 5).
- (c) Think backwards: as n grows, P(at least 2) grows. Try n = 1, 2, 3, … until it first reaches 0.75. R can try all n at once.
- Sanity-check (c): the expected count is 0.16n, so you'd guess n needs to be big enough that 0.16n is comfortably above 2.
pitfall:
- Off-by-one: P(Y ≥ 6) is 1 − pbinom(5), not 1 − pbinom(6).
- Treating "at least 20%" as exactly 20%.

### box: Problem 3 · Birdseed
question: Daily consumption $\sim N(400, 20^2)$ grams. (a) How much to put out so $P(\text{run out}) \le 5\%$? (b) For 7 independent days?
code:
```r
qnorm(0.95, mean = 400, sd = 20)                    # (a)
qnorm(0.95, mean = 7 * 400, sd = sqrt(7 * 20^2))    # (b)
```
explain:
- Running out means consumption > amount, so you want the 95th percentile.
- (b) Sum of 7 independent Normals: means add ($7 \times 400$) and **variances** add ($7 \times 20^2$). The SD is $\sqrt{7}\cdot20$, **not** $7 \cdot 20$.
rknow:
- `qnorm(0.95, mean = 400, sd = 20)` :: **q** = quantile: the value with 95% of the distribution **below** it. Prints **432.9 g**. It's the reverse of `pnorm`, going from a probability to a value.
- `qnorm(0.95, mean = 7 * 400, sd = sqrt(7 * 20^2))` :: Same idea for the 7-day total: mean 2800, SD $\sqrt{7}\cdot 20 \approx 52.9$. Prints **2887 g**.
- d / p / q / r :: `dnorm` = height of the curve, `pnorm` = area to the left (a probability), `qnorm` = value for a given area, `rnorm` = random draws.
paper: amount $= \mu + z_{0.95}\,\sigma = 400 + 1.64(20) \approx 433$ g; week: $2800 + 1.64(52.9) \approx 2887$ g. Use the 0.95 column of the Normal table.
idea: "Probability of running out ≤ 5%" means stocking enough to cover the consumption 95% of the time, which is the 95th percentile. For a week, add up 7 independent days, and the total is less variable *relative to its mean* than a single day.
walk:
- Running out = consumption > amount stocked. You want P(consumption > amount) = 0.05, so the amount is the 95th percentile, `qnorm(0.95, ...)`.
- For 7 days, the total is a sum of 7 independent Normals, so it's Normal too.
- Its mean is 7 × 400. Its **variance** is 7 × 20² (variances add), so the SD is √7 × 20 ≈ 53, not 7 × 20 = 140.
- Notice the weekly buffer above the mean (about 1.645 × 53 ≈ 87 g) is much less than 7 × the daily buffer (7 × 33 ≈ 230 g). High and low days partly cancel.
pitfall:
- Using SD = 7 × 20. That would assume every day is high or low together (perfect correlation).
- Using qnorm(0.05, ...): that's the amount you'd run *out* of 95% of the time.

### box: Problem 4 · Sea turtles
question: 56 of 90 hatchlings are female. (a) Expected # if $p = 0.5$. (b) $P(\ge 56)$ if $p = 0.5$. (c) 95% CI for $p$. (d) Is $p$ really 0.5?
code:
```r
90 * 0.5                                   # (a) E(Y) = np
1 - pbinom(55, size = 90, prob = 0.5)      # (b)
p_hat <- 56 / 90
p_hat + c(-1, 1) * 2 * sqrt(p_hat * (1 - p_hat) / 90)   # (c)
```
explain:
- (b) is effectively a one-sided p-value: how surprising is 56 or more if $p = 0.5$?
- (c) is the Sep 23 formula $\hat p \pm 2\sqrt{\hat p(1-\hat p)/n}$ (or use 1.96).
- (d) Use (b) and (c): is 0.5 inside the interval? Is the probability in (b) small?
rknow:
- `90 * 0.5` :: $E(Y) = np =$ **45**.
- `1 - pbinom(55, size = 90, prob = 0.5)` :: $P(Y \ge 56)$ if p = 0.5. Prints **0.013**: 56 or more females would be rare if p were 0.5.
- `p_hat <- 56 / 90` :: $\hat p = 0.622$.
- `p_hat + c(-1, 1) * 2 * sqrt(...)` :: `c(-1, 1)` makes the ± in one line: it returns the lower and upper limits together. Prints **(0.520, 0.724)**.
- Conclusion :: 0.5 is **outside** the interval and 0.013 is small, so the data are not consistent with p = 0.5. More hatchlings are female.
paper: $\hat p \pm 2\sqrt{\hat p(1-\hat p)/n} = 0.622 \pm 2(0.051) = 0.622 \pm 0.102$.
idea: This problem previews hypothesis testing and confidence intervals. First ask "if p were really 0.5, how surprising is 56 of 90?", then build the range of p values the data supports.
walk:
- (a) If p = 0.5, the expected count is np = 45. You saw 56, which is 11 more.
- (b) How unusual is 56 or more if p = 0.5? That's P(Y ≥ 56) = 1 − P(Y ≤ 55). A small number means 56 would be surprising.
- (c) Now flip it: use $\hat p = 56/90$ and the ±2 SE recipe to get a range of plausible p values.
- (d) Two angles, one answer: is 0.5 inside your interval? Is (b) small? If 0.5 is outside and (b) is tiny, the data don't support p = 0.5.
pitfall:
- Using p = 0.5 in the SE for the confidence interval. The CI uses $\hat p$, because you don't know p.
- Concluding that warmer oceans caused the change. The data can show p ≠ 0.5, but not why.

### box: R from HW 1–2 at a glance
key: true
question: You don't need to write this code on the exam, but you should be able to read it and say what it would print.
explain:
- Every R line in HW 1–2 is one of a few patterns, listed below.
rknow:
- `dbinom(k, n, p)` :: $P(Y = k)$ for a Binomial: one exact value.
- `pbinom(k, n, p)` :: $P(Y \le k)$, the cumulative probability. "More than k" = `1 - pbinom(k, ...)`; "at least k" = `1 - pbinom(k - 1, ...)`.
- `pnorm(x, mean, sd)` :: $P(X \le x)$ for a Normal: area to the **left**. On paper, use a z-score and the table.
- `qnorm(prob, mean, sd)` :: The reverse: the value with `prob` of the area to its left. `qnorm(0.975)` = 1.96 and `qnorm(0.95)` = 1.64.
- `dnorm(x, mean, sd)` :: The **height** of the bell curve. Only used for drawing it, never as a probability.
- `rnorm(n, mean, sd)`, `rbinom(n, size, p)` :: Random draws (simulation). Results change slightly every run.
- `mean(x > c)` :: The fraction of values above c (TRUE = 1, FALSE = 0).
- `sum(x * p)` :: A weighted sum: $E(X)$ when `p` holds probabilities.
- `c(-1, 1) * ...` :: Computes the ± of an interval in one step.
- `data$column` :: Pulls one column out of a data frame.
- `hist(x, probability = TRUE)` + `curve(..., add = TRUE)` :: A histogram on the density scale with a model's curve on top.
idea: The four letters d / p / q / r work the same for every distribution (`binom`, `norm`, `t`, …). d = exact probability or height, p = cumulative probability, q = the reverse of p, r = random draws.

=== wrap-up ===

## Every formula used

:::formula Normal
- $Z = \dfrac{X - \mu}{\sigma}$, so $P(X < a) = P\!\left(Z < \dfrac{a - \mu}{\sigma}\right)$ (#1)
- Percentile: $x = \mu + z\,\sigma$; the 95th percentile uses $z = 1.64$ (#3a)
- Sum of $n$ independent $N(\mu, \sigma^2)$: $N(n\mu,\; n\sigma^2)$, so the SD is $\sqrt n\,\sigma$, **not** $n\sigma$ (#3b)
:::

:::formula Binomial
- $P(Y = k) = \binom{n}{k}p^k(1-p)^{n-k}$; $E(Y) = np$; $\text{var}(Y) = np(1-p)$ (#2, #4a)
- At least one: $1 - (1-p)^n$ (#2a)
- $P(Y \ge k) = 1 - P(Y \le k - 1)$ (#2b, #4b)
:::

:::formula Confidence interval for a proportion
$\hat p \pm 2\sqrt{\dfrac{\hat p(1-\hat p)}{n}}$ (or 1.96 instead of 2) (#4c)
:::

## Learning summary

- **Answers:** the N(151, 8²) model puts about 0.4% below 130 and 0.9% above 170 (#1); 0.502, 0.345, n = 16 (#2); 433 g for a day and 2887 g for a week (#3); 45 expected, $P(Y \ge 56) \approx 0.013$, CI (0.520, 0.724), so p ≠ 0.5 (#4).
- A model can be **wrong but useful**: GRE scores can't be exactly Normal, but N(151, 8²) is a good approximation because it puts very little probability on impossible scores.
- "Probability of running out ≤ 5%" means stock the **95th percentile**.
- For a sum of independent days, **variances add**. High and low days partly cancel, so a week needs less buffer than 7 × one day's buffer.
- Problem 4 previews **inference**: "how surprising is 56 if p = 0.5?" is a p-value, and "what p values fit the data?" is a confidence interval. Both say p = 0.5 doesn't fit.

## What to take away from the R output

:::r Reading the R
- **d / p / q / r** works for every distribution: `dbinom` = exact probability, `pnorm` = area to the left, `qnorm` = value for a given area, `rnorm` = random draws.
- `hist(..., probability = TRUE)` + `curve(dnorm(...), add = TRUE)` is a **visual model check**: does the curve trace the bars?
- `mean(sims < 130)` estimates a probability by simulation. It should be close to the exact `pnorm(130, 151, 8)` ≈ 0.004, and changes slightly every run.
- `which(... >= 0.75)[1]` searches all n at once and returns the first one that works.
- `c(-1, 1) *` gives both ends of an interval in one line.
:::

## Common mistakes

:::tip Watch for these
- Off-by-one: $P(Y \ge 6)$ is `1 - pbinom(5, ...)`, not `1 - pbinom(6, ...)`.
- `qnorm(0.05, ...)` instead of `qnorm(0.95, ...)`. That's the amount you'd run out of 95% of the time.
- Weekly SD $= 7 \times 20$. Correct: $\sqrt 7 \times 20 \approx 52.9$.
- Using $p = 0.5$ inside the CI's SE. The CI uses $\hat p$; only the test assumes p = 0.5.
- Comparing a count histogram to a density curve (forgetting `probability = TRUE`).
- Concluding *why* the sex ratio changed. The data show p ≠ 0.5, not the cause.
:::
