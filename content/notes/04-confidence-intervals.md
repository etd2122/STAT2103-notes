---
id: L04
date: 2026-09-23
title: Confidence intervals
pdf: notes/2026-09-23-confidence-intervals.pdf
part: Part I
topics: sample proportion, standard error, 95% confidence interval, interpretation, other confidence levels, CI for a mean, t distribution, degrees of freedom, qnorm, qt
summary: How precise is an estimate? The sample proportion and sample mean are approximately Normal, so they land within 2 SDs of the truth 95% of the time. Flip that around to get a range of plausible values for the unknown p or μ, and use the t distribution when the SD has to be estimated too.
takeaways:
- $\hat p = Y/n$ has $E(\hat p) = p$ and $\text{var}(\hat p) = p(1-p)/n$. By the CLT, $\hat p \approx N(p, p(1-p)/n)$.
- 95% CI for a proportion: $\hat p \pm 2\sqrt{\hat p(1-\hat p)/n}$ (plug in $\hat p$ because $p$ is unknown).
- 95% CI for a mean with known $\sigma$: $\bar x \pm 2\,\sigma/\sqrt n$ (more exactly 1.96).
- Other levels: use the matching Normal percentile. 90% → `qnorm(0.95)` ≈ 1.645; 80% → `qnorm(0.90)` ≈ 1.28; 95% → `qnorm(0.975)` ≈ 1.96.
- Unknown $\sigma$: estimate it with $S_X$ and use the **t distribution** with $n-1$ df. 95% CI: $\bar x \pm$ `qt(0.975, df = n-1)` $\cdot S_X/\sqrt n$.
- Interpretation: the true $p$ or $\mu$ is a fixed number, either in the interval or not. "95% confident" means that **before** collecting data, there was a 95% chance the procedure would produce an interval containing the truth. It does not mean a 95% probability for this particular interval.
- The t is wider than the Normal (extra uncertainty from estimating the variance). With large $n$ (large df) they're nearly the same.
---

## How close is the estimate?

Last time: use data to estimate a quantity of interest. To estimate the % of the population who are left-handed, use the proportion in a random sample, $\hat p = Y/n$, where $Y \sim \text{Binom}(n,p)$ and $E(\hat p) = p$.

For larger samples, $\hat p$ is more likely to be close to the true $p$. Now we want to **quantify** that closeness: how precise is $\hat p$ as an estimate of $p$?

## Variance of the sample proportion

:::formula Sample proportion
$$E(\hat p) = E\!\left(\frac Yn\right) = \frac{E(Y)}{n} = \frac{np}{n} = p$$
$$\text{var}(\hat p) = \text{var}\!\left(\frac Yn\right) = \frac{\text{var}(Y)}{n^2} = \frac{np(1-p)}{n^2} = \frac{p(1-p)}{n}$$
:::

The variance has $n$ in the denominator: **larger samples → lower variance**, which matches the simulations from before.

### Its distribution

Knowing the mean and variance of an RV doesn't by itself tell us the probability of each outcome. But the sample proportion is actually a type of **sample average**. Each sampled person has a binary response $X_i = 1$ if left-handed, 0 otherwise, so
$$Y = X_1 + \dots + X_n, \qquad \hat p = \frac{X_1+\dots+X_n}{n}.$$
That means the **CLT applies**:
$$\hat p \;\approx\; N\!\left(p,\; \frac{p(1-p)}{n}\right)$$

For a Normal RV, 95% of observations fall within 2 SDs of the mean. So for large enough samples,
$$P\!\left(p - 2\,\text{sd} < \hat p < p + 2\,\text{sd}\right) \approx 95\%.$$

:::example Sampling 40 people when $p = 0.15$
$Y \sim \text{Binom}(40, 0.15)$. The sample proportion will be within
$$0.15 \pm 2\sqrt{\frac{0.15(0.85)}{40}} \approx [0.037,\; 0.263]$$
95% of the time: between 3.7% and 26.3% of a sample of 40 should be left-handed.
:::

## Reasoning in the opposite direction: the confidence interval

Now suppose we **don't** know $p$. We sampled 40 people and 10 were left-handed, so $\hat p = 10/40 = 25\%$. That isn't necessarily the true percentage. A popular way to describe our guess is an **interval of plausible values**.

Logic: $\hat p$ is within ±2 SD of the true $p$ with 95% probability, so it's reasonable to guess the true $p$ is within ±2 SD of the $\hat p$ we observed.

One issue: $\text{var}(\hat p) = p(1-p)/n$ depends on $p$, which we don't know. Approximate it by plugging in the sample proportion: $\text{var}(\hat p) \approx \hat p(1-\hat p)/n$.

:::formula 95% confidence interval for a proportion
$$\hat p \pm 2\sqrt{\frac{\hat p(1-\hat p)}{n}}$$
:::

:::example 10 of 40 left-handed
$$0.25 \pm 2\sqrt{\frac{0.25(0.75)}{40}} \approx [0.11,\; 0.39]$$
We are 95% confident that between 11% and 39% of the overall population is left-handed.
:::

### What "95% confident" means

"95% confident" is **not** "95% probability."

- The true % of left-handed people is some **fixed number**. We don't know it, but it's either in $[11\%, 39\%]$ or it isn't.
- Probability means long-run frequency over many repetitions, and there's no long-run frequency of the true percentage being in this interval.
- What *is* true: **before** we collect any data, there's a 95% chance that the data we observe will produce a confidence interval that includes the true value.

## Other confidence levels

±2 SD gives a 95% interval because the Normal has 95% of its probability within 2 SD of its mean. For a different level, find how many SDs out you need to go to capture that much of a Normal distribution.

:::example 90% interval
If the central chunk is 90%, its endpoints are the 5th and 95th percentiles. `qnorm(0.95, mean = 0, sd = 1)` ≈ 1.645.
$$\hat p \pm 1.645\sqrt{\frac{\hat p(1-\hat p)}{n}} \;\Rightarrow\; 0.25 \pm 1.645\sqrt{\frac{0.25(0.75)}{40}} \approx [0.14,\; 0.36]$$
We're 90% confident that the overall percentage of left-handed people is between 14% and 36%. A lower confidence level gives a narrower interval.
:::

| Confidence | Central area endpoints | Multiplier |
|---|---|---|
| 80% | 10th, 90th percentile | `qnorm(0.90)` ≈ 1.28 |
| 90% | 5th, 95th | `qnorm(0.95)` ≈ 1.645 |
| 95% | 2.5th, 97.5th | `qnorm(0.975)` ≈ 1.96 (≈ 2) |

## Confidence intervals for means

:::example Blood pressure medication
$X$ = reduction in BP from a drug. It varies from person to person and follows some (arbitrary) distribution with **unknown** mean $\mu$ and **known** SD = 2, so $\text{var}(X) = 4$. (Knowing the SD isn't realistic; we fix that below.)

We give the drug to 50 random people: $\bar x_{50} = 8$ mmHg. What can we say about $\mu$?

By the CLT, $\bar X_{50} \approx N\!\left(\mu,\; \tfrac{2^2}{50}\right)$. So $\bar X_{50}$ is within $2\sqrt{2^2/50} \approx 0.57$ of $\mu$ 95% of the time.

**95% CI:** $\bar x \pm 0.57 = 8 \pm 0.57 \approx [7.4,\; 8.6]$.

**80% CI:** `qnorm(0.9)` ≈ 1.28, so $8 \pm 1.28\sqrt{2^2/50} \approx [7.6,\; 8.4]$.
:::

:::formula CI for a mean, $\sigma$ known
$$\bar x \pm z\cdot\frac{\sigma}{\sqrt n}, \qquad z = \text{qnorm}\!\left(1 - \tfrac{\alpha}{2}\right)$$
:::

## Unknown variance: the t distribution

In practice we usually **don't** know $\text{var}(X)$. We estimate it from the data with the sample variance
$$S_X^2 = \frac{1}{n-1}\sum_{i=1}^n (x_i - \bar x)^2, \qquad S_X = \sqrt{S_X^2}.$$

Having to **also** estimate the variance adds extra uncertainty, so the interval must be **wider** to keep a 95% chance of covering $\mu$.

How much wider? Instead of Normal percentiles, use percentiles of the **t distribution**.

:::def The t distribution
Another **family** of distributions. Its parameter is the **degrees of freedom (df)**. For a confidence interval for a mean, $\text{df} = n - 1$.
:::

:::example n = 50
df = 49. To capture 95%, use the 97.5th percentile: `qt(0.975, df = 49)` ≈ 2.01. That's barely different from the Normal quantile (technically ≈ 1.96, not exactly 2).
:::

:::formula CI for a mean, $\sigma$ unknown
$$\bar x \pm t_{n-1}\cdot\frac{S_X}{\sqrt n}, \qquad t_{n-1} = \text{qt}\!\left(1-\tfrac\alpha2,\; \text{df}=n-1\right)$$
:::

- The t looks very similar to the Normal when df is large.
- df is large when $n$ is large. With lots of data we can estimate the variance well, so it doesn't add much extra uncertainty.
- With **small** samples the difference matters. HW 3 #1 has $n = 9$, so df = 8.

:::tip Normal or t?
Use Normal percentiles when $\sigma$ is **known** (or for a proportion). Use t when you've **estimated** the SD from the sample.
:::
