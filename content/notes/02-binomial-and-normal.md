---
id: L02
date: 2026-09-16
title: Binomial and Normal distributions
pdf: notes/2026-09-16-binomial-and-normal.pdf
part: Part I
examples: R1
topics: variance rules, Bernoulli, binomial, iid, sample mean, sample variance, Normal distribution, 68-95 rule, dbinom, pbinom, qbinom, dnorm, pnorm, qnorm, rnorm
summary: Rules for expected value and variance under linear changes and sums, then the two distributions used everywhere after: the Binomial (counting successes) and the Normal (the bell curve), with the R functions for each.
takeaways:
- $E(aX+b) = aE(X)+b$ and $\text{var}(aX+b) = a^2\text{var}(X)$. Adding a constant never changes variance, and $\text{var}(b) = 0$.
- Variances of **independent** RVs add; standard deviations never add.
- Bernoulli($p$): $E = p$, $\text{var} = p(1-p)$.
- Binomial($n,p$) = sum of $n$ iid Bernoulli($p$): $E(Y) = np$, $\text{var}(Y) = np(1-p)$, $P(Y=k) = \binom{n}{k}p^k(1-p)^{n-k}$.
- In R: `d…` = exact probability or density, `p…` = $P(X \le a)$, `q…` = percentile, `r…` = random draws. Upper tail: `1 - pnorm(a, mean, sd)`.
- Normal: within 1 SD ≈ 68%, within 2 SD ≈ 95%.
- If $X \sim N(\mu,\sigma^2)$ then $aX+b \sim N(a\mu+b,\, a^2\sigma^2)$. Sum of independent normals is normal: $X+Y \sim N(\mu_X+\mu_Y,\, \sigma_X^2+\sigma_Y^2)$.
- $E(X)$ and $\text{var}(X)$ belong to the **distribution** (fixed). $\bar X$ and $S_X^2$ belong to a **sample** (change every time you sample).
---

## Recap: rules for expected value

From last time: probability, random variables, distributions, $E(X)$ and $\text{var}(X)$, joint distributions $p(x,y)$, conditional probability $P(X=x\mid Y=y)$, $\text{cov}$ and $\text{cor}$, and independence $X \perp Y$.

:::formula Expected value rules
$$E(aX) = aE(X), \qquad E(X+b) = E(X)+b, \qquad E(X+Y) = E(X)+E(Y) \;\text{(always)}$$
:::

## Rules for variance

:::formula Variance rules
- **Multiply by a constant:** the variance gets multiplied by that constant **squared**. $\text{var}(aX) = a^2\,\text{var}(X)$. A negative $a$ still gives a positive multiplier, so variance stays positive.
- **Add a constant:** shifts the distribution left or right but doesn't change its spread. $\text{var}(X+b) = \text{var}(X)$.
- **A constant doesn't vary:** $\text{var}(b) = 0$.
- **Sum of independent RVs:** $\text{var}(X+Y) = \text{var}(X)+\text{var}(Y)$. The SDs never add.
- **Sum of correlated RVs:** $\text{var}(X+Y) = \text{var}(X)+\text{var}(Y)+2\rho_{XY}\sigma_X\sigma_Y$.
:::

SAT example again: positively correlated sections ⇒ total scores more spread out; negatively correlated ⇒ less spread out (above average on one tends to be offset by below average on the other).

## The Bernoulli distribution

:::def Bernoulli($p$)
A binary RV, $X \in \{0, 1\}$, that equals 1 (the "success") with fixed probability $p$:
$$P(X=1) = p, \qquad P(X=0) = 1-p$$
Example: one coin flip, $p = P(\text{heads})$; a fair coin has $p = \tfrac12$.
:::

It's a **family** of distributions, one for each value of $p$: Bern(0.1), Bern(0.2), and so on.

:::formula Bernoulli mean and variance
$$E(X) = 0\cdot(1-p) + 1\cdot p = p$$
$$\text{var}(X) = (1-p)(0-p)^2 + p(1-p)^2 = p(1-p), \qquad \text{sd}(X) = \sqrt{p(1-p)}$$
:::

## The Binomial distribution

The binomial comes from repeating **independent** Bernoulli trials that all have the **same** success probability. Flip a coin 5 times:

$$X_1, \dots, X_5 \;\overset{\text{iid}}{\sim}\; \text{Bern}(\tfrac12)$$

**iid** = independent and identically distributed. The total number of heads $Y = \sum_{i=1}^5 X_i$ is binomial: $Y \sim \text{Binomial}(n=5,\, p=\tfrac12)$.

Binomial is also a family, specified by $n$ (number of trials) and $p$ (success probability on each trial).

### Mean and variance (from the sum rules)

$$E(Y) = E(X_1)+\dots+E(X_5) = p+\dots+p = 5p = 5\cdot\tfrac12 = 2.5$$
$$\text{var}(Y) = \text{var}(X_1)+\dots+\text{var}(X_5) = 5p(1-p) = 5\cdot\tfrac12\cdot\tfrac12 = 1.25$$

The variances add because the flips are independent.

:::formula Binomial($n, p$)
$$E(Y) = np, \qquad \text{var}(Y) = np(1-p)$$
:::

### The probability of each outcome

Finding $P(Y = y)$ is a counting problem. Take one specific sequence with 3 heads then 2 tails, $(1,1,1,0,0)$. The flips are independent, so multiply:
$$p\cdot p\cdot p\cdot(1-p)\cdot(1-p) = p^3(1-p)^2 = (\tfrac12)^3(\tfrac12)^2 = \tfrac{1}{32}$$

Every sequence with 3 H and 2 T has this same probability (reordering doesn't change it). So
$$P(Y=3) = (\#\text{ sequences with 3 heads}) \times p^3(1-p)^2 = \binom{5}{3}p^3(1-p)^2, \qquad \binom{5}{3} = \frac{5!}{3!\,(5-3)!}$$

:::formula Binomial pmf
$$P(Y = k) = \binom{n}{k}\,p^k\,(1-p)^{n-k}$$
:::

:::example Left-handed people (R notebook)
15% of adults are left-handed. Survey 10 people, $X_i = 1$ if left-handed. $Y = \sum_{i=1}^{10} X_i \sim \text{Binom}(10, 0.15)$.

- Exactly one left-handed: $P(Y=1) = \binom{10}{1}0.15^1(0.85)^9$ → `dbinom(1, 10, 0.15)`
- At most two: $P(Y\le2) = P(Y=0)+P(Y=1)+P(Y=2)$ → `dbinom(0,10,0.15) + dbinom(1,10,0.15) + dbinom(2,10,0.15)` = `pbinom(2, 10, 0.15)` (the **cumulative distribution function**)
- 95th percentile: the smallest $k$ with $P(Y \le k) \ge 0.95$ → `qbinom(0.95, 10, 0.15)`
:::

## Distribution vs. sample

$E(X)$ and $\text{var}(X)$ are properties of a **probability distribution**, which is theoretical. If we observe values sampled from that distribution, the sample has its own **sample mean** and **sample variance**:

:::formula Sample statistics
$$\bar X_n = \frac1n\sum_{i=1}^n X_i, \qquad S_X^2 = \frac{1}{n-1}\sum_{i=1}^n (X_i - \bar X_n)^2, \qquad S_X = \sqrt{S_X^2}$$
:::

Flip a fair coin 5 times and record $Y_1$ = # heads; repeat 9 more times for $Y_1,\dots,Y_{10}$. The distribution has $E = 2.5$ and $\text{var} = 1.25$. The 10 sampled values have their own mean and variance, which you calculate. Sample 10 new values and you'd get a *new* mean and variance, but the expected value and variance of the underlying distribution stay the same.

Visually: the distribution is a bar graph of **probabilities**; the sample is a **histogram** whose bar heights are how often each value occurred.

## The Normal distribution

:::def Normal (Gaussian), $N(\mu, \sigma^2)$
A distribution for **continuous** RVs. Its pdf is symmetric and bell-shaped. It's a family specified by its expected value $\mu$ and its variance $\sigma^2$.
:::

Example: $X$ = adult blood pressure, $X \sim N(120, 15^2)$, so $\sigma^2 = 15^2$ and $\sigma = 15$.

Because it's continuous, $P(X = 120) = 0$, but we can talk about intervals: $P(120 \le X < 135) = 0.34$. That's the area under the pdf between 120 and 135, which you look up in a table or on a computer, not by hand.

:::formula The 68–95 rule
- $P(\text{within 1 SD of } \mu) \approx 68\%$
- $P(\text{within 2 SD of } \mu) \approx 95\%$ (the more useful one)
:::

### Special properties of the Normal

1. **Linear transformations stay normal:**
$$X \sim N(\mu, \sigma^2) \;\Rightarrow\; aX+b \sim N(a\mu+b,\; a^2\sigma^2)$$
This is *not* generally true for other families. The mean rule $E(aZ+b) = aE(Z)+b$ holds for every RV, but the result needn't be in the same family. Counterexample: if $Y \sim \text{Binom}(n,p)$ then $W = 2Y$ only takes even values, so $W$ can't be binomial.

2. **Sums of independent normals are normal:**
$$X \sim N(\mu_X,\sigma_X^2),\; Y \sim N(\mu_Y,\sigma_Y^2),\; X\perp Y \;\Rightarrow\; X+Y \sim N(\mu_X+\mu_Y,\; \sigma_X^2+\sigma_Y^2)$$

### The Normal in R

:::r Normal distribution functions
| Want | R |
|---|---|
| pdf (to graph the curve) | `dnorm(x, mean, sd)` |
| $P(X \le a)$ (cumulative) | `pnorm(a, mean, sd)` |
| $P(X > a)$ | `1 - pnorm(a, mean, sd)` |
| $P(a < X \le b)$ | `pnorm(b, mean, sd) - pnorm(a, mean, sd)` |
| 95th percentile: smallest $b$ with $P(X\le b) \ge 0.95$ | `qnorm(0.95, mean, sd)` |
| $n$ random draws | `rnorm(n, mean, sd)` |

R uses the **SD**, not the variance. For $N(120, 15^2)$ write `sd = 15`.
:::

For a binomial you could find a percentile by adding up cumulative probabilities value by value. For a continuous variable you can't, so you use the quantile function `qnorm`.

:::tip Homework link
HW 2 #3 (birdseed) is a `qnorm` question. For the 7-day version, use the sum-of-independent-normals rule: mean $7\cdot400$, variance $7\cdot20^2$.
:::
