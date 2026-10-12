---
id: L05
date: 2026-09-28
title: Hypothesis tests
pdf: notes/2026-09-28-hypothesis-tests.pdf
part: Part I
topics: null hypothesis, alternative hypothesis, one-sided, two-sided, test statistic, p-value, rejection threshold, t test, fail to reject
summary: A second way to learn from data. State a specific claim (H₀), ask how unusual the observed data would be if H₀ were true (the p-value), and reject H₀ when that probability is small. Covers two-sided and one-sided tests, and the t version when σ is estimated.
takeaways:
- Steps: (1) state $H_0$ and $H_A$, (2) observe data, (3) compute how many SDs the estimate is from the value under $H_0$, (4) find the p-value, (5) compare to a cutoff chosen **in advance**.
- Test statistic = $\dfrac{\text{observed} - \text{value under } H_0}{\text{SD of the estimate under } H_0}$.
- **p-value** = probability of data at least this unusual if $H_0$ is true. Small p-value → data don't agree with $H_0$ → reject.
- Two-sided ($H_A: p \ne 0.6$): p-value $= 2\times$ one tail, e.g. `2*pnorm(-1.86)`. One-sided ($H_A: \mu > 350$): one tail only, e.g. `1 - pnorm(2.8)`.
- $\sigma$ unknown → estimate with $S_X$ and use the t distribution with $n-1$ df: `1 - pt(2.5, df = 4)`.
- No universal cutoff (10%, 5%, 1% are common). Pick it **before** the test.
- Large p-value → **fail to reject** $H_0$. Never "accept" it: $H_0$ could be true, but so could nearby values.
- The Normal calculation for $\bar X$ needs $X$ Normal, or a large $n$ for the CLT.
---

## Recap: confidence intervals

We use data to estimate an unknown quantity of interest; a CI gives a plausible range for it. Sample means and proportions are approximately Normal, so $\bar X$ is within ±2 SD of $\mu$ 95% of the time, which makes $\mu \in \bar x \pm 2\,\text{SD}$ plausible ("95% confident"). Other levels: check percentiles of $N(0,1)$. If we estimate $\sigma^2$ with $S_X^2$, use `qt(0.975, df = n-1)` instead of the Normal.

Today: **hypothesis tests**, another tool for using observed data to learn about an unknown quantity of interest.

## Example: seat belts

A 2005 study found 60% of drivers in MS wear seat belts. Let $p$ = % who wear seat belts in 2025 (unknown). We could give a CI for $p$, but suppose we specifically want to check **whether it's still 60%**. That's the basis for a hypothesis test.

We observe 30 random drivers and 23 wear seat belts: $\hat p = 23/30 \approx 0.77$. Is the data compatible with $p = 0.6$, and can we **quantify** that compatibility?

If $p = 0.6$, then for random samples of 30 drivers,
$$\hat p \approx N\!\left(0.6,\; \frac{0.6(0.4)}{30}\right), \qquad \text{sd} = \sqrt{\frac{0.6(0.4)}{30}} \approx 0.09.$$

Is it unusual to see $\hat p = 0.77$, at least 17 percentage points from the expected 60%? How many SDs away is it?
$$\frac{0.77 - 0.6}{0.09} \approx 1.86$$

The probability of a Normal being at least 1.86 SDs from its mean in **either** direction:
$$P(|Z| > 1.86) = 2 \times \texttt{pnorm(-1.86, 0, 1)} \approx 2 \times 0.03 \approx 0.06$$
(Get the left-tail area with the cumulative distribution function and double it, since the Normal is symmetric.)

If 60% of all MS drivers wore seat belts, getting a sample like ours would happen only about 6% of the time. The data aren't very compatible with $p = 0.6$, so we don't think it's very plausible.

## The general format

:::def Hypothesis test
1. **State the null hypothesis** $H_0$ (e.g. $H_0: p = 0.6$) and the **alternative** $H_A$.
2. **Observe data** (e.g. $\hat p = 0.77$).
3. Ask how different the data are from what we'd expect if $H_0$ were true.
4. **p-value:** the probability of seeing data at least this "unusual" if $H_0$ is true. It quantifies how well the data agree with $H_0$.
5. **Decision:** if the p-value is small, the data don't agree with $H_0$, and we **reject** $H_0$.
:::

:::formula Test statistic
$$z = \frac{\text{observed estimate} - \text{value under } H_0}{\text{SD of the estimate under } H_0}$$
For a proportion: $z = \dfrac{\hat p - p_0}{\sqrt{p_0(1-p_0)/n}}$. For a mean with known $\sigma$: $z = \dfrac{\bar x - \mu_0}{\sigma/\sqrt n}$.
:::

**When is a p-value "small enough"?** There's no universal rule; 10%, 5%, or 1% are common cutoffs. There's always some chance you just got a weird sample. It's up to you, but **decide before doing the test**.

## One-sided vs. two-sided alternatives

:::example Toaster oven
I think my oven runs hotter than the manufacturer says. Oven temp fluctuates: $X \sim N(\mu, 20^2)$ (SD = 20°F). The "bake" setting claims $\mu = 350$°F; I think $\mu > 350$.

$$H_0: \mu = 350, \qquad H_A: \mu > 350$$

Measure at 5 random times: $X_1,\dots,X_5 \;\overset{\text{iid}}{\sim}\; N(\mu, 20^2)$. Under $H_0$, $\bar X \sim N\!\left(350, \tfrac{20^2}{5}\right)$, so 1 SD $= 20/\sqrt5 \approx 8.9$.

Observed $\bar x = 375$, which is
$$\frac{375 - 350}{20/\sqrt5} \approx 2.8 \text{ SDs above the expected value.}$$

p-value $= P(N(0,1) > 2.8) = $ `1 - pnorm(2.8, mean = 0, sd = 1)` ≈ 0.003.

If the oven really were calibrated to 350°, we'd be very unlikely to see a sample mean like ours. **Reject $H_0$; conclude $\mu > 350$.**
:::

- **Two-sided** $H_A$ (seat belts: $H_A: p \ne 0.6$): open to $p > 0.6$ or $p < 0.6$. Count **both** tails.
- **One-sided** $H_A$ (oven: $H_A: \mu > 350$): specifically asking about one direction. Count only that tail.

In the seat-belt example we didn't state the alternative explicitly, but it was implicitly $p \ne 0.6$.

## Unknown variance: the t test

What if $X \sim N(\mu, \sigma^2)$ with $\sigma^2$ **unknown**? To say how many SDs $\bar x$ is from 350, we have to estimate 1 SD from the data using $S_X^2$.

:::example Oven with estimated variance
Suppose $S_X^2 = 500$. Under $H_0$, $\bar X_5 \approx N\!\left(350, \tfrac{500}{5}\right)$: variance 100, SD = 10.
$$\frac{375 - 350}{10} = 2.5 \text{ SDs}$$
Because we estimated $\sigma^2$ from the data, use the **t distribution with $n - 1 = 4$ df** instead of the Normal:

p-value = `1 - pt(2.5, df = 4)` ≈ 0.033, around 3%.
:::

:::r Test p-values in R
| Situation | p-value |
|---|---|
| Two-sided, Normal | `2 * pnorm(-abs(z))` |
| Upper one-sided, Normal | `1 - pnorm(z)` |
| Lower one-sided, Normal | `pnorm(z)` |
| Two-sided, t | `2 * pt(-abs(t), df = n - 1)` |
| Upper one-sided, t | `1 - pt(t, df = n - 1)` |
:::

## When is the Normal calculation valid?

The oven calculations relied on $\bar X$ being Normal, which we knew because the individual measurements $X$ were Normal. In general, if we don't know that $X$ is Normal, $\bar X_n$ is still approximately Normal by the CLT **if the sample size is large**. With only 5 data points and a non-normal $X$, that might not be a good approximation.

## What a large p-value means

Small p-value → reject $H_0$. A **large** p-value says it would be reasonable to see data like ours if $H_0$ were true. So we don't reject $H_0$, but we **don't "accept" it either**.

:::example Seat belts, $\hat p = 0.63$
With $H_0: p = 0.6$, a sample proportion of 63% is quite possible if the true value is 60%, so we wouldn't reject. But that doesn't mean we think it's **exactly** 60%; 61% or 62% are also plausible. We just think $p = 0.6$ *could* be true.
:::

We phrase this conclusion as **"fail to reject $H_0$."**

:::tip Homework link
HW 3 #3 (bottles) is a one-sided test for a proportion, $H_A: p < 0.08$, so use the lower tail `pnorm(z)`. HW 3 #4 (uranium) is two-sided with known $\sigma = 3$.
:::
