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
idea: This problem previews hypothesis testing and confidence intervals. First ask "if p were really 0.5, how surprising is 56 of 90?", then build the range of p values the data supports.
walk:
- (a) If p = 0.5, the expected count is np = 45. You saw 56, which is 11 more.
- (b) How unusual is 56 or more if p = 0.5? That's P(Y ≥ 56) = 1 − P(Y ≤ 55). A small number means 56 would be surprising.
- (c) Now flip it: use $\hat p = 56/90$ and the ±2 SE recipe to get a range of plausible p values.
- (d) Two angles, one answer: is 0.5 inside your interval? Is (b) small? If 0.5 is outside and (b) is tiny, the data don't support p = 0.5.
pitfall:
- Using p = 0.5 in the SE for the confidence interval. The CI uses $\hat p$, because you don't know p.
- Concluding that warmer oceans caused the change. The data can show p ≠ 0.5, but not why.
