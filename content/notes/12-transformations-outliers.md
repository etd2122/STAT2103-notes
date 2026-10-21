---
id: L12
date: 2026-10-21
title: Transformations and outliers
pdf: notes/2026-10-21-transformations-outliers.pdf
part: Part II
examples: R9
topics: assumption recap, residual plots, transformations, log(y) model, log-log model, multiplicative interpretation, outliers, leverage points, sensitivity analysis
summary: A recap of what each broken assumption costs you, then how to use transformations. You fit a regression to the transformed data, convert predictions back with e^(...), and read the log slopes as multiplicative differences. The last part covers outliers (unusual y) and leverage points (unusual x): what they do to the fit and what to do about them. Your instructor said transformations in depth won't be on the exam.
takeaways:
- **Exam scope:** transformations in depth are **not** on the exam. Know *why* you'd transform (to fix non-linearity or non-constant variance) and that you then fit a regular regression to the transformed data. You don't need to master the log interpretations.
- Recap: a **linearity** violation breaks everything (estimates, predictions, inference). Violations of the **error** assumptions (constant variance, Normality, independence) leave $\hat\beta_0, \hat\beta_1$ and predictions valid but break CIs, tests and PIs.
- Transforming x, y or both (log, √, x²) can fix linearity and non-constant variance, and sometimes Normality. For non-constant variance, transforming **only x** won't help. $\sqrt y$ and $\log y$ shrink big values more than small ones, which evens out the spread.
- To predict on the original scale, plug x into the fitted model, then **undo** the transformation: $\hat y = e^{\log \hat y}$.
- **y outlier** (unusual y, typical x): barely moves $\hat\beta_0, \hat\beta_1$, but inflates $\hat\sigma^2$. That widens CIs and pushes the t statistic toward 0, giving bigger p-values.
- **Leverage point** (unusual x): can pull the line toward itself, so it has a bigger effect on $\hat\beta_0, \hat\beta_1$. It helps if it sits near the true line and hurts if it doesn't.
- What to do: delete a point **only** if it's impossible or obviously a recording error. Otherwise, fit the model with and without it and compare.
---

:::tip Exam scope
Your instructor said **transformations in depth will not be on the exam**. The interpretation sections below (log-y and log–log slopes) are here for reference and for HW. Focus on the recap, *why* and *when* to transform, and the outlier/leverage section.
:::

## Recap: why assumptions matter

The simple linear regression model relies on a few key assumptions. If they don't hold for the data, the conclusions we draw **can** be wrong.

| Assumption | If violated |
|---|---|
| ① **Linearity:** $y = \beta_0 + \beta_1 x + \varepsilon$ in the population | **Everything** is wrong: the least squares estimates aren't valid, predictions can be very inaccurate, inference is incorrect. |
| ② Errors have **constant variance** $\sigma^2$ | $\hat\beta_0, \hat\beta_1$ still valid (and unbiased); the model can still predict $\hat y$; **inference is not valid** (tests, CIs, PIs). |
| ③ Errors are **Normally distributed** | Same as ②. |
| ④ Errors are **independent** of each other | Same as ②. |

### Checking assumptions: plots of the residuals

- **Scatter plot of $(x_i, \hat e_i)$** → non-linearity, non-constant error variance.
- **Histogram or Q-Q plot** of the residuals → non-Normality. A Q-Q plot compares the percentiles of the residuals to the percentiles of a Normal distribution.
- **Residuals vs. index $(i, \hat e_i)$**, or **lagged residuals $(\hat e_i, \hat e_{i+1})$** → correlated error terms.

## Transformations

A non-linear transformation of x, y or both may fix assumptions ① and ②, and maybe ③. "Fix the problem" means: if we **fit a new linear regression to the transformed data**, the model assumptions will be satisfied.

That's what makes transformations useful: we keep using all the linear regression tools we already know, just on a modified version of the data set.

:::def Popular transformations
- **Natural log** of x and/or y. In this class, "log" always means the natural log, $\ln$.
- $x^2$, $\sqrt x$, $\sqrt y$.
:::

### Non-constant variance: transform y, not x

If the y values are more spread out for some x values than others, transforming **only x** will not fix it. Transformations like $\sqrt y$ or $\log y$ shrink **large values more than small ones**.

:::example Why √y evens out the spread
- At $x = 1$, y ranges from 1 to 16, so $\sqrt y$ ranges from **1 to 4** (a width of 3).
- At $x = 10$, y ranges from 25 to 64, so $\sqrt y$ ranges from **5 to 8** (also a width of 3).

On the original scale the spread was 15 vs. 39. After $\sqrt y$, it's the same at both x values. $\log y$ has a similar effect.
:::

In general, we **try a few different transformations**, fit a new model to each, and **check the assumptions again**.

## The log(y) model

Start with $(x, y)$ data, replace each $y_i$ with $\log(y_i)$, then fit a linear model to x and $\log y$:

$$\log(\hat y_i) = \hat\beta_0 + \hat\beta_1 x_i$$

### Predicting on the original scale

Plug x into the fitted model to get $\log \hat y$, then exponentiate to get $\hat y$.

:::example Height and income (data from around 2000)
x = height (inches), y = income (\$). Fitted model: $\log(\hat y) = 0.06 \cdot \text{height} + 5.91$.

- Height 66: $\log(\hat y) = 0.06(66) + 5.91 = 9.87$. Log earnings of 9.87 isn't very useful on its own.
- Exponentiate: $\hat y = e^{9.87} \approx 19{,}000$, so predicted earnings are about **\$19k**.
:::

### Interpreting the slope

Read literally, $\hat\beta_1 = 0.06$ means "people whose heights differ by 1 inch differ by 0.06 in log income, on average." That's true but not very helpful, because we care about **income**, not log income.

Compare the predictions at $x_1$ and $x_1 + 1$:

$$\hat y_1 = e^{\hat\beta_0 + \hat\beta_1 x_1} = e^{\hat\beta_0}e^{\hat\beta_1 x_1} \qquad \hat y_2 = e^{\hat\beta_0 + \hat\beta_1 (x_1 + 1)} = e^{\hat\beta_0}e^{\hat\beta_1 x_1}e^{\hat\beta_1}$$

$$\frac{\hat y_2}{\hat y_1} = e^{\hat\beta_1} \quad\Longrightarrow\quad \hat y_2 = e^{\hat\beta_1}\,\hat y_1$$

:::formula log(y) model: slope interpretation
A one-unit (**additive**) difference in x goes with a **multiplicative** difference of $e^{\hat\beta_1}$ in predicted y.
:::

:::example Height and income, interpreted
$e^{0.06} \approx 1.06$. Among people whose heights differ by 1 inch, we estimate the taller person's income to be about **1.06 times** larger on average (about 6% higher).
:::

The test of $H_0: \beta_1 = 0$ now asks whether there's a **multiplicative** difference in y associated with an additive difference in x, **not** whether x and y have a linear relationship.

## The log–log model

Replace **both** variables with their natural logs:

$$\log \hat y_i = \hat\beta_0 + \hat\beta_1 \log x_i$$

:::example Tree diameter and wood volume
x = tree diameter (in.), y = wood volume (ft³); timber companies want to predict volume. Fitted model: $\log \hat y = -2.8 + 2.5 \log x$.

- Diameter 10: $\log \hat y = -2.8 + 2.5\log(10) \approx 3$, so $\hat y \approx e^3 \approx$ **20 ft³**.
:::

### Interpreting the slope

Literally: trees with a one-unit difference in log(diameter) have a 2.5-unit difference in log(volume), on average. Again, that's not so helpful. Compare two trees with diameters $x_1$ and $x_2$:

$$\log(\hat y_2) - \log(\hat y_1) = [\hat\beta_0 + \hat\beta_1\log x_2] - [\hat\beta_0 + \hat\beta_1\log x_1] = \hat\beta_1[\log x_2 - \log x_1]$$

Using the rules of logarithms, $\log\!\left(\dfrac{\hat y_2}{\hat y_1}\right) = \hat\beta_1 \log\!\left(\dfrac{x_2}{x_1}\right)$. Exponentiating both sides:

$$\frac{\hat y_2}{\hat y_1} = e^{\hat\beta_1 \log(x_2/x_1)} = \left[e^{\log(x_2/x_1)}\right]^{\hat\beta_1} = \left(\frac{x_2}{x_1}\right)^{\hat\beta_1}$$

:::formula log–log model: slope interpretation
$\hat\beta_1$ relates a **multiplicative** difference in x to a **multiplicative** difference in y: if x is $k$ times as large, predicted y is $k^{\hat\beta_1}$ times as large.
:::

:::example Trees, interpreted
- Diameters differ by a factor of 1.01 (1% larger): volumes differ by $1.01^{2.5} \approx 1.025$, so about **2.5% larger**.
- Diameters differ by a factor of 2: the larger tree's volume is $2^{2.5} \approx$ **5.7 times** larger, on average.
:::

### Other transformations

Log transformations are special. For other non-linear transformations ($\sqrt{\ }$, $x^2$, …) there generally **isn't** a convenient interpretation of the coefficients in terms of the original x and y.

## Outliers

Another common problem when fitting linear models. There are two cases: a point with a **y value** very far from the regression line, and a point with an **x value** very far from the rest of the data.

### Case 1: y outlier

A point with an unusual y value but an x value similar to the rest of the data shows up as one big residual.

- It **does not** usually have a large effect on $\hat\beta_0$ and $\hat\beta_1$.
- It **does** tend to increase the estimated error variance $\hat\sigma^2$ a meaningful amount. One point with a very large residual can change the residual standard error a lot.

Why that matters: $\hat\sigma^2$ is used for inference.

$$\text{se}(\hat\beta_1) = \sqrt{\frac{\hat\sigma^2}{(n-1)S_x^2}} \qquad T = \frac{\hat\beta_1}{\text{se}(\hat\beta_1)} \quad\text{for } H_0: \beta_1 = 0 \text{ vs. } H_A: \beta_1 \ne 0$$

- A bigger $\hat\sigma^2$ means **wider confidence intervals**.
- $\hat\sigma^2$ sits in the denominator of T, so a bigger $\hat\sigma^2$ pulls T **closer to 0**, which gives a **larger p-value**. It becomes harder to reject $H_0$, i.e. harder to detect whether the slope is truly non-zero.

### What to do about it

It depends.

- If the value is **impossible or obviously a recording mistake**, based on what you know about the variables, you can throw that point away.
- Usually you **won't know** whether it's a mistake, so you can't justify deleting it. Unusual values do happen, and if the model can make large mistakes, we want to know, not pretend it didn't happen.
- **Another approach:** fit two models, one to the full data and one with the outlier removed, and compare. That tells you how much impact the outlier has on the analysis.

### Case 2: x outlier ("leverage point")

A point with an x value far from the rest of the data is usually called a **leverage point**. It yanks the estimated regression line toward itself, like a lever, so it has a **bigger effect on $\hat\beta_0, \hat\beta_1$**.

The effect isn't straightforward. For a leverage point $(x^*, y^*)$:

- If it's **close to the true population line**, it *helps*: the estimates become more accurate.
- If it's **far from the population line**, it *hurts*: the estimated slope and intercept become less accurate.

In practice it's hard to know which scenario you're in, because we don't know the true population line.

What to do is the same as for y outliers. Throw it away only if the value is impossible or obviously wrong. Usually you can't justify removing it, so fit models to the full data and with the leverage point removed, and compare.

:::tip y outlier vs. leverage point
- **y outlier:** typical x, unusual y → big residual → $\hat\sigma^2$ ↑, CIs wider, p-values larger; slope and intercept barely change.
- **Leverage point:** unusual x → can pull the line → slope and intercept can change a lot.
:::
