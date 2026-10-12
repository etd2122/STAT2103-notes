---
id: R1
key: binom-normal
title: Binomial and Normal distributions in R
lecture: L02
topics: dbinom, pbinom, qbinom, sample, rbinom, mean, sd, barplot, hist, dnorm, pnorm, qnorm, rnorm, curve
summary: The four R functions every distribution has (d, p, q, r), first for the Binomial (left-handed people) and then for the Normal (blood pressure). Also shows the difference between a probability distribution and a sample drawn from it.
takeaways:
- `d…` gives $P(X = x)$ for a discrete RV (or the density height for a continuous one). `p…` gives $P(X \le x)$. `q…` gives the percentile. `r…` draws random samples.
- Binomial arguments: `size` = $n$ trials, `prob` = $p$. Normal arguments: `mean` and `sd` (the **SD**, not the variance).
- Right tail: `1 - pnorm(...)`. Between two values: `pnorm(b, ...) - pnorm(a, ...)`.
- Sample variance in R is `sd(x)^2` (or `var(x)`), and it uses $n - 1$.
- A sample's mean, variance and histogram change every time you draw; the distribution's $E$ and var don't. Bigger samples look more like the true distribution.
---

## Binomial distribution

### box: Probability of exactly one left-handed person
items: 4-5
key: true
what: $Y$ = # left-handed people in a random sample of 10, where $P(\text{left-handed}) = 0.15$, so $Y \sim \text{Binom}(10, 0.15)$. Find $P(Y = 1)$.
explain:
- `dbinom(x, size, prob)` gives the exact probability $P(Y = x)$ for a binomial.
- `size` is $n$ (number of trials) and `prob` is $p$ (success probability on each trial).
- It computes $\binom{10}{1}(0.15)^1(0.85)^9 \approx 0.347$ for you.

### box: At most two left-handed: add them up, or use pbinom
items: 8-12
key: true
what: Find $P(Y \le 2) = P(Y=0) + P(Y=1) + P(Y=2)$.
explain:
- Adding three `dbinom` calls works because 0, 1, 2 are separate outcomes.
- `pbinom(q, size, prob)` is the **cumulative distribution function**: it returns $P(Y \le q)$ in one step.
- Both give 0.82, so there's an 82% chance at most 2 of the 10 are left-handed.

### box: 95th percentile by checking cumulative probabilities
items: 15-18
what: Find the smallest $k$ with $P(Y \le k) \ge 0.95$ by trying values.
explain:
- $P(Y \le 2) = 0.82$ is not enough, so 2 can't be the 95th percentile.
- $P(Y \le 3) = 0.95003 \ge 0.95$, so the answer is 3.
- This trial-and-error approach only works because a binomial has a short list of possible values.

### box: 95th percentile with qbinom
items: 21-22
key: true
what: Get the same percentile directly with the quantile function.
explain:
- `qbinom(p, size, prob)` returns the smallest $k$ such that $P(Y \le k) \ge p$.
- `q…` is the inverse of `p…`: `pbinom` turns a value into a probability; `qbinom` turns a probability into a value.

## Sampling from the binomial distribution

### box: Simulate 5 coin flips with sample()
items: 27-34
what: Simulate flipping a fair coin 5 times and count the heads.
explain:
- `sample(values, size, replace = TRUE, prob)` draws `size` items from `values` with the given probabilities. `replace = TRUE` lets the same value come up again (needed for repeated flips).
- Coding heads/tails as 1/0 means `sum()` counts the heads.
- The sum of 5 fair flips is one draw from Binomial($n = 5$, $p = 0.5$). Your outputs will differ each run because it's random.

### box: Draw directly from the binomial with rbinom
items: 38-40
what: Get one draw from Binom(5, 0.5) in a single call.
explain:
- `rbinom(n, size, prob)`: careful, here **`n` is the number of samples you want**, while `size` is the binomial's number of trials.
- `rbinom(n = 1, size = 5, prob = 0.5)` = "flip a coin 5 times, count heads, do it once."

### box: Repeat the experiment 10 times; sample mean and variance
items: 43-49
key: true
what: Record # heads in 5 flips, ten times over, then compute the sample mean and sample variance.
explain:
- The distribution has $E(Y) = np = 2.5$ and $\text{var}(Y) = np(1-p) = 1.25$.
- `mean(y_values)` is the sample mean $\bar y$; `sd(y_values)^2` is the sample variance $S^2$ (divides by $n - 1$).
- The sample values (2 and 0.89 here) are close to, but not equal to, 2.5 and 1.25.

### box: A new sample gives new statistics
items: 51-54
what: Draw 10 fresh values and recompute.
explain:
- The new sample has a different mean (2.1) and variance (0.77).
- The **distribution's** expected value and variance never change; the **sample's** properties change every time you draw a new random sample.

### box: Bar graph of the true distribution
items: 59-62
what: Plot $P(Y = y)$ for $y = 0, \dots, 5$ when $Y \sim \text{Binom}(5, 0.5)$.
explain:
- `dbinom(x = 0:5, ...)` evaluates the pmf at every value from 0 to 5 at once and returns a vector.
- `barplot(heights, names.arg = labels)` draws one bar per value. This is the theoretical distribution.

### box: Histogram of the sample
items: 64-69
what: Plot how often each value occurred in the 10 sampled values, as counts and as proportions.
explain:
- `hist(x, breaks = ...)` makes a histogram. `breaks` sets the bucket edges; without it R picks them automatically.
- `probability = TRUE` puts relative frequency (proportion) on the y-axis instead of counts, so it's comparable to the bar graph of probabilities.
- With only 10 draws, the histogram doesn't match the true bar graph very well.

## Normal distribution

### box: Draw the Normal pdf
items: 73-74
what: Blood pressure $X \sim N(120, 15^2)$. Plot its density curve.
explain:
- `dnorm(x, mean, sd)` is the height of the pdf at `x`. It is **not** a probability, since $P(X = x) = 0$ for a continuous RV.
- `curve(expression in x, from, to)` plots a function of `x` over a range.
- Give R the **standard deviation** (`sd = 15`), not the variance $15^2$.

### box: P(X < 115) and P(X > 115)
items: 76-82
key: true
what: Probability a random person's BP is below 115, then above 115.
explain:
- `pnorm(q, mean, sd)` gives the area under the curve to the **left** of `q`, i.e. $P(X \le q)$.
- For the right tail, subtract from 1: `1 - pnorm(...)`.
- $0.369 + 0.631 = 1$.

### box: P(120 < X < 130)
items: 84-88
key: true
what: Probability BP is between 120 and 130.
explain:
- $P(120 < X < 130) = P(X < 130) - P(X < 120)$: the blue area minus the orange area in the plot.
- `pnorm(130, ...) - pnorm(120, ...)` = 0.248.
- The shading code (`polygon`) is just for the picture; you don't need it to get the number.

### box: 95th percentile: why trial and error doesn't work
items: 91-99
key: true
what: Find the smallest $b$ with $P(X < b) \ge 0.95$.
explain:
- Trying values gets close (130 → 0.75, 140 → 0.91, 145 → 0.952) but BP is continuous, so you can't check every value.
- `qnorm(p, mean, sd)` returns the exact percentile: 144.67.
- Same as using $\mu + 1.645\sigma = 120 + 1.645(15)$.

### box: Sample 10 blood pressures
items: 102-111
what: Draw 10 values from $N(120, 15^2)$, summarize them, and plot a histogram.
explain:
- `rnorm(n, mean, sd)` draws `n` random values.
- The sample mean (125.8) and SD (10.2) are near 120 and 15 but not equal.
- With only 10 points the histogram is chunky and doesn't look like a bell curve.

### box: Sample 100 and overlay the true pdf
items: 114-119
what: Draw 100 values, plot the histogram, and add the true density curve on top.
explain:
- `set.seed(3218)` fixes the random number generator so the "random" draws come out the same every run (reproducible).
- With 100 samples the histogram starts to look like the bell curve.
- `curve(..., add = TRUE)` draws on top of the existing plot instead of making a new one. Use `probability = TRUE` in `hist` so the scales match.
- HW 2 #1(a) asks for exactly this: a histogram of real scores with a Normal pdf on top.
