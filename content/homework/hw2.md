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
