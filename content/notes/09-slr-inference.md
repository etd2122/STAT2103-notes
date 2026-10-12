---
id: L09
date: 2026-10-12
title: Inference for simple linear regression
pdf: notes/2026-10-12-slr-inference.pdf
part: Part II
examples: R6
topics: standard error of the slope, confidence interval for the slope, confidence interval for the intercept, t distribution with n-2 df, test of no linear relationship, p-value, critical value, one-sided test, confint
summary: Putting the pieces together. With iid Normal errors, the slope's t statistic follows a t distribution with n − 2 df. That gives confidence intervals (estimate ± t-percentile × SE) and hypothesis tests (especially H₀: β₁ = 0, no linear relationship), worked through on the language acquisition data.
takeaways:
- $\text{se}(\hat\beta_1) = \sqrt{\dfrac{\hat\sigma^2}{(n-1)S_x^2}}$, using $\hat\sigma^2 = \frac{1}{n-2}\sum \hat e_i^{\,2}$.
- **Any CI** = estimate ± [percentile of $t_{n-2}$] × se(estimator). 95% uses `qt(0.975, df = n-2)`; 90% uses `qt(0.95, df = n-2)`.
- Language data ($n = 30$): 95% CI for $\beta_1$ = $16.9 \pm 2.05\cdot2.8 \approx [11.2, 22.6]$; 90% CI ≈ $[12.15, 21.65]$. Higher confidence → wider interval.
- Intercept: same recipe, $\hat\beta_0 \pm t\cdot\text{se}(\hat\beta_0)$, also with $n-2$ df.
- $H_0: \beta_1 = 0$ means **no linear relationship**: knowing $X$ doesn't help predict $Y$.
- Test statistic $t = \dfrac{\hat\beta_1 - 0}{\text{se}(\hat\beta_1)}$. Two-sided p-value: `2 * pt(-abs(t), df = n-2)`. One-sided ($H_A: \beta_1 > 0$): `1 - pt(t, df = n-2)`.
- **Critical value** shortcut: reject at level $\alpha$ if $|t| >$ `qt(1 - α/2, df = n-2)` (2.05 for $\alpha = 0.05$, 2.76 for $\alpha = 0.01$ when df = 28).
- In R: `confint(model)`, `confint(model, level = 0.9)`, and `summary(model)` (the slope row's t value and Pr(>|t|)).
---

## Recap: consequences of Normal errors

Model: $Y = \beta_0 + \beta_1 X + \varepsilon$, with the added assumption $\varepsilon_1, \varepsilon_2, \dots \;\overset{\text{iid}}{\sim}\; N(0, \sigma^2)$ (independent, Normal, variance $\sigma^2$, mean 0 as before).

1. **$Y$ at each $x$ is Normal:** $Y \mid X = x \sim N(\beta_0 + \beta_1 x,\; \sigma^2)$. If we collected data at that $x$, the $y$ values would be centered at the point on the line and spread above and below it according to a Normal distribution.
2. **$\hat\beta_0$ and $\hat\beta_1$ are Normal:**
$$\hat\beta_1 \sim N\!\left(\beta_1,\; \frac{\sigma^2}{(n-1)S_x^2}\right), \qquad S_x^2 = \frac{\sum_{i=1}^n (x_i - \bar x)^2}{n-1}$$

Because $\hat\beta_1$ is Normal, $P(\hat\beta_1 \text{ within } \pm2\,\text{sd of } \beta_1) \approx 95\%$. (The z-score $\frac{\hat\beta_1-\beta_1}{\sqrt{\sigma^2/((n-1)S_x^2)}}$ follows $N(0,1)$.)

But that SD depends on $\sigma^2$, the variance of the error terms, which describes how spread out $y$ is at any $x$ in the true model. We don't know it, so we estimate it with the sample variance of the residuals:

| Error term | Residual |
|---|---|
| $\varepsilon_i = y_i - (\beta_0 + \beta_1 x_i)$ | $\hat e_i = y_i - (\hat\beta_0 + \hat\beta_1 x_i)$ |

As with inference for $\mu$ when $\sigma$ was unknown, estimating $\sigma^2$ means basing probability calculations on the **t distribution**. For a regression with one predictor, **df = $n - 2$**.

:::def Standard error of the slope
$$\text{se}(\hat\beta_1) = \sqrt{\frac{\hat\sigma^2}{(n-1)S_x^2}}$$
The SD of $\hat\beta_1$ with $\hat\sigma^2$ estimated from the data plugged in.
:::

## Confidence interval for the slope

:::example Language acquisition
$X$ = words spoken to the infant daily (1000s), $Y$ = vocabulary size at 24 months. 30 children; fitted line
$$\hat y = 158 + 16.9x, \qquad \hat\beta_1 = 16.9.$$
For children whose infant-directed speech differs by 1000 words, the infant hearing more words has a vocabulary 16.9 words larger, on average. But the true average difference isn't **exactly** 16.9; that's just the estimate from this sample of 30. A different 30 babies would give a slightly different slope. What's a plausible **range** for $\beta_1$?

We need $\hat\sigma^2$ and $S_x^2$ from the data (in practice R does this): $\hat\sigma^2 = 2004$, $S_x^2 = 8.84$.
:::

If we knew $\sigma^2$ we could go 2 SD either way from $\hat\beta_1$. Because the SD is estimated, ask instead: **how far from the mean must we go to capture 95% of a $t_{28}$ distribution?**

`qt(0.975, df = 28)` ≈ 2.05. (The t is symmetric, so the 2.5th percentile is −2.05.)

:::formula Confidence interval, any level
$$\text{estimate} \;\pm\; \big[\text{percentile of } t_{n-2}\big] \times \text{se(estimator)}$$
95% CI for $\beta_1$: $\big[\hat\beta_1 - 2.05\,\text{se}(\hat\beta_1),\; \hat\beta_1 + 2.05\,\text{se}(\hat\beta_1)\big]$ when df = 28.
:::

:::example 95% CI
$$16.9 \pm 2.05\sqrt{\frac{2004}{(30-1)(8.84)}} = 16.9 \pm 5.7 \;\Rightarrow\; [11.2,\; 22.6]$$
We are 95% confident that the true average difference in 24-month vocabulary, between babies hearing a difference of 1,000 infant-directed words daily, is between 11.2 and 22.6 words.
:::

:::example 90% CI
Need the 95th percentile: `qt(0.95, df = 28)` ≈ 1.7.
$$16.9 \pm 1.7\sqrt{\frac{2004}{(30-1)(8.84)}} = 16.9 \pm 4.75 \;\Rightarrow\; [12.15,\; 21.65]$$
:::

As with proportions and means, **a higher confidence level gives a wider interval**: to be 95% confident we need a larger range of values than to be only 90% confident.

## Confidence interval for the intercept

With iid Normal errors, the intercept estimator is also Normal:
$$\hat\beta_0 \sim N\!\left(\beta_0,\; \sigma^2\left(\frac1n + \frac{\bar x^2}{(n-1)S_x^2}\right)\right)$$
(You aren't required to know this variance expression.) It also depends on $\sigma^2$, so we use $\hat\sigma^2$ and the $t_{n-2}$ distribution:

:::formula CI for $\beta_0$
$$\hat\beta_0 \pm \big[\text{percentile of } t_{n-2}\big] \times \text{se}(\hat\beta_0), \qquad \text{se}(\hat\beta_0) = \sqrt{\hat\sigma^2\left(\frac1n + \frac{\bar x^2}{(n-1)S_x^2}\right)}$$
:::

Rather than computing these by hand, use `confint()` in R (see the *Inference for SLR* R example).

## Hypothesis tests about the slope

Since $\hat\beta_1 \sim N(\beta_1, \text{var}(\hat\beta_1))$, we can check whether $\hat\beta_1$ is too many SDs from a hypothesized value for that value to be plausible. Most often:
$$H_0: \beta_1 = 0 \quad\text{vs.}\quad H_A: \beta_1 \ne 0$$

:::def What $\beta_1 = 0$ means
No linear relationship between $X$ and $Y$: $Y = \beta_0 + \varepsilon$, so $Y \sim N(\beta_0, \sigma^2)$ for **any** $X$. Knowing $x_i$ doesn't help predict $y_i$ with a linear model.
:::

Even if the true slope is 0, the slope estimated from a random sample won't be exactly 0. A line with a nonzero slope might fit the particular sample slightly better just by chance. So how far from 0 is it likely to be?

:::example Testing the language data
$$t = \frac{16.9 - 0}{\sqrt{\dfrac{\hat\sigma^2}{(n-1)S_x^2}}} = \frac{16.9}{\sqrt{\dfrac{2004}{(30-1)(8.84)}}} \approx 6.04$$
The estimated slope is about 6.04 (estimated) SDs from 0. If $H_0$ were true, what's the probability of being at least that far from 0 under $t_{28}$? With $\alpha = 0.05$:

p-value = `2 * pt(-6.04, df = 28)` ≈ $1.64\times10^{-6}$ (lower tail doubled, since the two tails are symmetric).

That's tiny. p-value < $\alpha = 0.05$ → **reject $H_0$**: there **is** evidence of a nonzero linear relationship between $X$ and $Y$.
:::

### Critical values (no p-value needed)

From the CI we know $\hat\beta_1$ falls within 2.05 SDs of the true $\beta_1$ 95% of the time under $t_{28}$. So a result 6.04 SDs away must have probability less than 5%.

:::def Critical value
How many SDs from the hypothesized value $\hat\beta_1$ must be for us to reject $H_0$. For a two-sided test at level $\alpha$: `qt(1 - α/2, df = n - 2)`.
:::

| $\alpha$ | Percentile | Critical value (df = 28) | Reject $H_0$ if |
|---|---|---|---|
| 0.05 | 97.5th | `qt(0.975, 28)` ≈ 2.05 | $\left|\dfrac{\hat\beta_1 - \beta_1}{\text{se}(\hat\beta_1)}\right| > 2.05$ |
| 0.01 | 99.5th | `qt(0.995, 28)` ≈ 2.76 | $\left|\dfrac{\hat\beta_1 - \beta_1}{\text{se}(\hat\beta_1)}\right| > 2.76$ |

At $\alpha = 0.01$ there's a 99% chance of an estimate within ±2.76 SDs of the true value, so the chance of being at least 2.76 SD away is 1%.

### One-sided tests

Depending on the research question, a one-sided alternative may make sense, e.g. specifically a **positive** association:
$$H_0: \beta_1 = 0 \quad\text{vs.}\quad H_A: \beta_1 > 0$$
Since we observed $\hat\beta_1 = 16.9$, we want the probability of a value **at least that large**, i.e. at least 6.04 SDs above the hypothesized value:
$$P\!\left(\frac{\hat\beta_1 - \beta_1}{\text{se}(\hat\beta_1)} \ge 6.04\right) = \texttt{1 - pt(6.04, df = 28)}$$

:::r Inference in R
| Want | R |
|---|---|
| Fit the model | `model <- lm(y ~ x, data = df)` |
| 95% CIs for intercept and slope | `confint(model)` |
| 90% CIs | `confint(model, level = 0.9)` |
| t statistic and two-sided p-value for $H_0: \beta = 0$ | `summary(model)` → `t value`, `Pr(>|t|)` |
| Residual standard error $\hat\sigma$ | `summary(model)` → "Residual standard error" |
| t percentile by hand | `qt(0.975, df = n - 2)` |
:::
