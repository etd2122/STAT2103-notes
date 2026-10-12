---
id: L03
date: 2026-09-21
title: Sampling distributions and limit theorems
pdf: notes/2026-09-21-sampling-distributions.pdf
part: Part I
examples: R2
topics: probability vs statistics, Law of Large Numbers, sample proportion, sample mean, sampling distribution, Central Limit Theorem
summary: The turn from probability to statistics. Instead of predicting data from a known model, we use data to learn about an unknown population. The sample mean is itself a random variable; the Law of Large Numbers says it gets close to μ, and the CLT says it's approximately Normal with variance σ²/n.
takeaways:
- Probability: model → what data will I see? Statistics: data → what's the population model? Everything after this lecture is the second direction.
- The sample average is not equal to the population average, but it's close, and how close depends on $n$.
- **LLN:** $\bar X_n \to \mu$ as $n \to \infty$.
- $\bar X_n$ is a random variable: a new sample gives a new value. Its distribution is the **sampling distribution**.
- $E(\bar X_n) = \mu$ and $\text{var}(\bar X_n) = \sigma^2/n$, so $\text{sd}(\bar X_n) = \sigma/\sqrt n$.
- If $X$ is Normal, $\bar X_n$ is exactly Normal. If not, the **CLT** says $\bar X_n \approx N(\mu, \sigma^2/n)$ for large $n$.
- Sample proportion $\hat p = Y/n$ with $E(\hat p) = p$. Bigger $n$ makes a $\hat p$ far from $p$ much less likely.
- In R, use the SD of $\bar X$: `pnorm(115, mean = 120, sd = 10/sqrt(5))`.
---

## Recap

- **Bernoulli:** $X\in\{0,1\}$, $P(X=1)=p$, $E(X)=p$, $\text{sd}(X)=\sqrt{p(1-p)}$.
- **Binomial:** $X_1,\dots,X_n \;\overset{\text{iid}}{\sim}\;\text{Bern}(p)$, $Y=\sum X_i \sim \text{Binom}(n,p)$, $E(Y)=np$, $\text{var}(Y)=np(1-p)$, $\text{sd}(Y)=\sqrt{np(1-p)}$.
- **Normal:** continuous, $X \in (-\infty, \infty)$, $E(X)=\mu$, $\text{var}(X)=\sigma^2$. $P(a<X<b)$ = area under the pdf. Linear transformations of a normal are normal; sums of independent normals are normal (means and variances both add).

## Two directions of reasoning

So far: **start** with a probability model, and reason about what data we're likely to see.

> 15% of people are left-handed, so # LH out of 10 $\sim$ Binom(10, 0.15). What is $P(\ge 2 \text{ LH in a sample of 10})$?

Often we want the **opposite** direction: **start** with observed data, and learn about the population probability model.

> We surveyed 10 people and 1 was left-handed. What % of Americans are left-handed?

To answer this rigorously, frame it as a question about a probability model. If the true proportion is $p$, then # LH in a random sample of 10 $\sim$ Binom(10, $p$). We don't know $p$; we observed $Y = 1$. **Which values of $p$ are plausible?**

To answer that, we need some key **statistical properties of sample data**.

## The Law of Large Numbers

If we observe random samples of some quantity, the sample average generally isn't *equal* to the population average, but it will be close. How close depends on how much data we collect, $n$.

:::example Blood pressure
US adult blood pressure $X \sim N(120, 10^2)$.
- One random person could easily be above 130.
- The average of 5 random people above 130? Possible, but it requires picking 5 people who mostly have high BP by chance.
- The average of 1000 random people above 130? Very unlikely. That would be a huge coincidence.
:::

:::def Law of Large Numbers (LLN)
If $X \sim p(x)$ with $E(X) = \mu$, then as the sample size grows, the sample average approaches the population average:
$$\bar X_n = \frac{X_1+X_2+\dots+X_n}{n} \;\to\; \mu \quad\text{as } n \to \infty$$
:::

## Sample proportions

If 15% of US adults are left-handed, then in a random sample of $n$, $Y$ = # LH $\sim \text{Binom}(n, 0.15)$.

- Expected number: $E(Y) = np = 0.15n$, so we expect 15% of the sample to be LH.
- Define the **sample proportion** $\hat p = Y/n$. Then $E(\hat p) = \dfrac{0.15n}{n} = 0.15$.

| | $n = 10$ | $n = 100$ |
|---|---|---|
| $P(\hat p = 0)$ | $P(Y=0) \approx 0.20$ | $\approx$ 1 in 10 million |
| $P(\hat p \ge 0.3)$ | $P(Y\ge3) \approx 0.18$ | $P(Y \ge 30) \approx$ 1 in 10,000 |

With 10 people, getting 0 or 3 left-handers wouldn't be shocking. With 100 people it would be very surprising. **A larger sample makes it less likely that the sample proportion is far from the population proportion.**

## The sample mean is a random variable

Just like $X$ is a random variable with a distribution, $\bar X_n$ is also a random variable with its **own distribution** (the **sampling distribution**). Every time we collect a new random sample, the sample average comes out slightly different.

:::example Average BP of 5 people
$X_1,\dots,X_5 \;\overset{\text{iid}}{\sim}\; N(120, 10^2)$. The sum of independent normals is normal:
$$X_1+\dots+X_5 \sim N(120+\dots+120,\; 10^2+\dots+10^2) = N(600,\; 5\cdot10^2)$$
$\bar X$ is that sum divided by 5, and dividing by a constant keeps it normal:
$$E(\bar X) = \tfrac15 E(X_1+\dots+X_5) = \tfrac15(5\cdot120) = 120$$
$$\text{var}(\bar X) = \tfrac{1}{5^2}\,\text{var}(X_1+\dots+X_5) = \tfrac{1}{25}(5\cdot10^2) = \tfrac{10^2}{5}$$
So $\bar X_5 \sim N\!\left(120, \tfrac{10^2}{5}\right)$.
:::

:::formula Mean and variance of the sample mean
For the average of $n$ iid observations with $E(X) = \mu$, $\text{var}(X) = \sigma^2$:
$$E(\bar X_n) = \mu, \qquad \text{var}(\bar X_n) = \frac{\sigma^2}{n}, \qquad \text{sd}(\bar X_n) = \frac{\sigma}{\sqrt n}$$
Same center as the population, but **smaller variance**, shrinking as $n$ grows.
:::

With that distribution we can compute probabilities about the sample mean:

:::r Questions about $\bar X_5$
- $P(\bar X_5 < 115)$: `pnorm(115, mean = 120, sd = 10/sqrt(5))`
- 95th percentile of the 5-person average (the value it falls below 95% of the time): `qnorm(0.95, mean = 120, sd = 10/sqrt(5))`

The `sd` argument is $\sigma/\sqrt n$, **not** $\sigma$.
:::

## The Central Limit Theorem

We got the Normal distribution of $\bar X$ because $X$ itself was Normal. What if $X$ is **not** Normal? For large enough samples, the sample mean is still **approximately** Normal, with the same expected value and variance.

:::def Central Limit Theorem (CLT)
If $X \sim p(x)$ (not necessarily normal) with $E(X) = \mu$ and $\text{var}(X) = \sigma^2$, then for **large $n$**
$$\bar X_n \;\approx\; N\!\left(\mu,\; \frac{\sigma^2}{n}\right)$$
:::

See the LLN & CLT R example for simulations of both theorems.
