---
id: L08
date: 2026-10-07
title: Linear regression assumptions
pdf: notes/2026-10-07-regression-assumptions.pdf
part: Part II
examples: R4, R5
topics: linearity, mean-zero errors, normal errors, independent errors, constant variance, sampling distribution of the slope, variance of the slope, residual standard error, t statistic, n-2 degrees of freedom
summary: The assumptions behind the regression model and what each one buys you. Linearity plus mean-zero errors make the estimates unbiased. Adding iid Normal errors with constant variance makes the slope estimator Normal with a known variance. Estimating σ² from the residuals turns that into a t statistic with n − 2 df, the basis for inference.
takeaways:
- Assumptions 1 and 2: **linearity** ($Y = \beta_0+\beta_1X+\varepsilon$) and **mean-zero errors** ($E(\varepsilon)=0$). Together they give unbiased $\hat\beta_0, \hat\beta_1$.
- Added assumptions: $\varepsilon_i \;\overset{\text{iid}}{\sim}\; N(0, \sigma^2)$, meaning Normal, independent, and the same variance. Consequence: $Y \mid X = x \sim N(\beta_0+\beta_1x,\; \sigma^2)$.
- $\hat\beta_0, \hat\beta_1$ are **random variables**: a new sample gives a new line.
- $\text{var}(\hat\beta_1) = \dfrac{\sigma^2}{\sum(x_i-\bar x)^2} = \dfrac{\sigma^2}{(n-1)S_x^2}$. It's smaller when $\sigma^2$ is small, $n$ is large, or the $x$ values are spread out.
- Under Normal errors, $\hat\beta_1 \sim N(\beta_1, \text{var}(\hat\beta_1))$, so $Z = (\hat\beta_1-\beta_1)/\sqrt{\text{var}(\hat\beta_1)} \sim N(0,1)$.
- $\sigma^2$ is unknown. Estimate it with $\hat\sigma^2 = \frac{1}{n-2}\sum \hat e_i^{\,2}$; $\hat\sigma$ is the **residual standard error**.
- Plugging in $\hat\sigma^2$: $t = \dfrac{\hat\beta_1-\beta_1}{\sqrt{\hat\sigma^2/((n-1)S_x^2)}} \sim t_{n-2}$.
- The residuals always sum to 0. Interpret the slope as a **difference**, not a change caused by $X$.
---

## Recap

We're using observed data to estimate the true, unknown population relationship between predictor $X$ and response $Y$.

- Be cautious about using the fitted line far outside the observed $x$ range (**extrapolation**). Infants heard 1,000–12,000 words/day, so predicting at $x = 0$ or $x = 50{,}000$ would be risky.
- Don't suggest a causal relationship. Think of the slope as a **difference**:

| | |
|---|---|
| **Not** | "change in $y$ due to a 1-unit change in $x$" |
| **Yes** | "difference in $y$ values for observations with a 1-unit difference in $x$" |

E.g. "On average, we expect students whose SAT scores differ by 100 pts to have GPAs that differ by 0.25 pts."

## The assumptions so far

:::def Assumptions 1 and 2
1. **Linearity:** the true relationship really is linear, $Y = \beta_0 + \beta_1 X + \varepsilon$.
2. **Mean-zero errors:** the random error terms are zero on average, $E(\varepsilon) = 0$.
:::

Consequence of 1 + 2: the least squares estimators are **unbiased**, $E(\hat\beta_1) = \beta_1$ and $E(\hat\beta_0) = \beta_0$.

It makes sense to talk about their expected value because **the estimators are random variables**. Fit a line to one sample and record the slope and intercept; collect a new random sample and you'd get a different slope and intercept. (The earlier simulation drew 20 data sets and fit 20 lines, giving 20 values of $\hat\beta_0, \hat\beta_1$.) It's the same as $\hat p$ and $\bar X$: a true population quantity, and an estimate that varies with the data we happen to observe.

Unbiased means we get the right values on average and aren't systematically skewed in one direction. Averaging the 20 simulated slopes should give something very close to the true slope.

## Additional assumptions about the errors

Next we explore more uses of regression, if we're willing to make **additional assumptions** about the error terms in $Y = \beta_0+\beta_1X+\varepsilon$:

:::def Error assumptions
- the $\varepsilon_i$ are **normally distributed**
- the $\varepsilon_i$ are **independent** of each other
- the $\varepsilon_i$ all have the **same variance** $\sigma^2$

Stated concisely:
$$\varepsilon_i \;\overset{\text{iid}}{\sim}\; N(0, \sigma^2)$$
:::

:::formula Consequence: $Y$ at a given $x$ is Normal
$$Y \mid X = x \;\sim\; N(\beta_0 + \beta_1 x,\; \sigma^2)$$
:::

:::example SAT and GPA
If the population line passes through $(1200, 3.4)$, students who scored 1200 average a GPA of 3.4. But many students with that score would have different GPAs, spread above and below 3.4 according to a Normal distribution:
$$Y \mid X = 1200 = 3.4 + \varepsilon_i \sim N(3.4, \sigma^2)$$
:::

Because we know how to generate random samples from a Normal distribution, we can write down a population model and **simulate** drawing sample data from it (see the *Simulating regression, part 2* R example).

## What the error variance does

When $\sigma^2$ is larger, the data points are more spread out around the line at every $x$, which makes it harder to estimate $\beta_0$ and $\beta_1$.

The same was true for sample means: if $\text{var}(X) = \sigma^2$ then $\text{var}(\bar X) = \sigma^2/n$. When the population was more spread out, so was the distribution of the estimator.

## Variance of the slope estimator

We know $\hat\beta_1$ is unbiased. How precise is it?

:::formula Variance of $\hat\beta_1$
$$\text{var}(\hat\beta_1) = \frac{\sigma^2}{\sum_{i=1}^n (x_i - \bar x)^2} = \frac{\sigma^2}{(n-1)\,S_x^2}$$
using $\sum (x_i-\bar x)^2 = (n-1)\cdot\frac{1}{n-1}\sum(x_i-\bar x)^2 = (n-1)S_x^2$.
:::

What this tells us:

| Larger… | Effect on $\text{var}(\hat\beta_1)$ | Why |
|---|---|---|
| $\sigma^2$ (error variance) | larger | points more spread out around the line |
| $n$ (sample size) | smaller | $n-1$ in the denominator; more data, more precision |
| $S_x^2$ (spread of the observed $x$ values) | smaller | a wide range of $x$ pins down the slope better |

This is consistent with sample means and proportions: as samples got larger, it became harder for the estimate to be far from the true value.

:::tip Homework link
HW 4 #2–4 ask which of two scatter plots gives a more precise slope. Use this table: less scatter around the line, more points, or a wider spread of $x$ values each make the slope more precise.
:::

## The sampling distribution of the slope

Knowing the expected value and variance isn't enough to find the probability of a particular slope estimate. But under Normal errors, the slope and intercept estimators are **also Normally distributed**:
$$\hat\beta_1 \sim N\big(\beta_1,\; \text{var}(\hat\beta_1)\big)$$
If we collected many data sets and fit a line to each, the slopes would look like samples from a Normal distribution.

Recall (from homework): $X \sim N(\mu, \sigma^2) \Rightarrow \dfrac{X-\mu}{\sigma} \sim N(0,1)$. Doing the same for the slope:

:::formula Standardized slope
$$Z = \frac{\hat\beta_1 - \beta_1}{\sqrt{\text{var}(\hat\beta_1)}} = \frac{\hat\beta_1 - \beta_1}{\sqrt{\sigma^2/\big((n-1)S_x^2\big)}} \sim N(0,1)$$
$Z$ is between −1 and 1 about 68% of the time, and between −2 and 2 about 95% of the time.
:::

But $Z$ involves $\sigma^2$, a feature of the **true** population model, which is unknown. So we estimate it from the data.

## Estimating $\sigma^2$: the residual standard error

| | Formula | Known? |
|---|---|---|
| Error term | $\varepsilon_i = y_i - (\beta_0 + \beta_1 x_i)$ | No (true line unknown) |
| Residual | $\hat e_i = y_i - (\hat\beta_0 + \hat\beta_1 x_i) = y_i - \hat y_i$ | Yes |

The residuals are estimates of the true error terms, so use their sample variance to approximate $\sigma^2$. For least squares, **the residuals always sum to zero**, $\sum \hat e_i = 0$ (not proved in class), so their mean is 0 too and:

:::formula Residual variance
$$\hat\sigma^2 = \frac{1}{n-2}\sum_{i=1}^n \hat e_i^{\,2}$$
$\hat\sigma = \sqrt{\hat\sigma^2}$ is called the **residual standard error** (or standard error of the residuals).
:::

We divide by $n-2$, not $n-1$ as for $S_x^2 = \frac{1}{n-1}\sum (x_i-\bar x)^2$. The reason comes later, with multiple predictors.

## The t statistic

Substituting $\hat\sigma^2$ for $\sigma^2$:
$$Z = \frac{\hat\beta_1 - \beta_1}{\sqrt{\sigma^2/((n-1)S_x^2)}} \;\longrightarrow\; t = \frac{\hat\beta_1 - \beta_1}{\sqrt{\hat\sigma^2/((n-1)S_x^2)}}$$

As with CIs and tests for an unknown mean $\mu$, using an **estimated** variance means we use the t distribution instead of the Normal:

:::formula Distribution of the slope's t statistic
$$Z \sim N(0,1), \qquad t = \frac{\hat\beta_1 - \beta_1}{\sqrt{\dfrac{\hat\sigma^2}{(n-1)S_x^2}}} \sim t_{n-2}$$
**$n - 2$ degrees of freedom.** This is the basis for the confidence intervals and tests in the next lecture.
:::
