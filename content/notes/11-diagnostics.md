---
id: L11
date: 2026-10-19
title: Diagnostics and remedial measures
pdf: notes/2026-10-19-diagnostics.pdf
slides: notes/2026-10-19-diagnostics-slides.pdf
part: Part II
examples: R9
topics: model assumptions, linearity, constant variance, normality, independence, residual plots, Q-Q plot, lagged residuals, transformations, log, square root, interpreting transformed models
summary: What happens when the regression assumptions fail. For each of the four assumptions (linearity, constant variance, Normal errors, independent errors), the consequences, how to spot a violation in a plot, and what to do about it. Then how transforming x or y with logs or square roots changes what the slope means.
takeaways:
- Check assumptions with **plots**, mainly residuals vs. x. When the assumptions hold, residuals are scattered evenly above and below 0 with similar spread at every x, and show no pattern.
- **Linearity** is the big one. If the true relationship isn't a line, the estimates, inference **and** predictions are all unreliable. Detect it with a curved scatter plot or a curved pattern in the residuals. Remedy: transform x, y or both (log, √, square).
- **Constant variance** (residuals fan out): estimates and predictions are fine, but CIs and tests are wrong. Transforming y sometimes helps; if the relationship already looks linear, transforming can *create* non-linearity.
- **Normal errors** (check with a histogram or Q-Q plot of the residuals): estimates and predictions are fine. In large samples CIs and tests are about right, **except prediction intervals**, which are always off. In small samples, be skeptical of all inference.
- **Independent errors** (only for ordered data, like time): look at residuals vs. observation index and the lagged-residual plot. Runs of same-sign residuals or a diagonal lag plot mean correlation. Estimates and predictions are fine, inference isn't.
- Pattern to remember: **violations of the error assumptions (2–4) break inference but not the estimates. A linearity violation breaks everything.**
- After transforming, the slope describes the **transformed** variables. Logs keep a clean interpretation: in a log(y) model, a 1-unit difference in x multiplies predicted y by $e^{\hat\beta_1}$. In a log–log model, multiplying x by $k$ multiplies predicted y by $k^{\hat\beta_1}$.
---

## Recap: assessing model quality

Is the fitted model successful at predicting $y$ from $x$?

- **Residual standard error** $\hat\sigma = \sqrt{\hat\sigma^2}$: how far the observed $y_i$ tends to be from the fitted $\hat y_i$, on average.
- **$R^2$** = $(r_{xy})^2$ in simple regression, between 0 (no linear relationship) and 1 (perfect linear relationship). Also $R^2 = 1 - \dfrac{\sum (y_i - \hat y_i)^2}{\sum (y_i - \bar y)^2}$, the % of variation in $y$ explained by the model. Higher means more useful for predicting $y$.
- A **low $R^2$** can mean a weak linear relationship **or** a non-linear relationship (wrong model). $R^2$ and $r_{xy}$ only measure the strength of **linear** relationships.

That leads into the broader topic of **potential problems** with linear regression models.

## The plan: assumptions, consequences, detection, remedies

When we chose to fit a linear regression model, we made several key assumptions about the true population relationship between $x$ and $y$. For each one:

1. What are the **consequences** if it's violated?
2. How do we **detect** a violation?
3. What can we do to **remedy** it?

:::def The four assumptions
$$Y_i = \beta_0 + \beta_1 X_i + \varepsilon_i, \qquad \varepsilon_i \overset{\text{iid}}{\sim} N(0, \sigma^2)$$
1. **Linearity:** the true relationship is a straight line.
2. **Constant variance:** $\text{var}(\varepsilon_i) = \sigma^2$ for every error term.
3. **Normality:** the errors are Normally distributed.
4. **Independence:** the errors are independent of each other (no correlation).
:::

:::formula Summary table
| Violation | Estimates $\hat\beta_0, \hat\beta_1$ | Predictions | CIs and tests | How to detect | Remedies |
|---|---|---|---|---|---|
| 1. Non-linearity | **not valid** | can be poor | **not valid** | $x$–$y$ scatter plot; residuals vs. $x$ | transform $x$, $y$ or both |
| 2. Non-constant variance | valid | OK | **not valid** | $x$–$y$ scatter plot; residuals vs. $x$ (spread changes) | maybe transform $y$; or just don't do inference |
| 3. Non-normal errors | valid | OK (point predictions) | large $n$: close, **except prediction intervals**; small $n$: be skeptical | histogram of residuals; Q-Q plot | sometimes transform $y$; large $n$: ignore it, but skip prediction intervals |
| 4. Correlated errors | valid | OK | **not valid** | residuals vs. observation index; lagged residuals | a different kind of model (not covered yet) |
:::

## 1. Linearity

The first and most important assumption: the true population relationship is **linear**, $y = \beta_0 + \beta_1 x + \varepsilon$. If it isn't, fitting a linear model is generally not a good choice. Essentially, **all of our conclusions would be wrong**:

- the least squares estimates aren't valid, because there **are** no true $\beta_0, \beta_1$ to estimate;
- confidence intervals and hypothesis tests about the model aren't valid;
- depending on how far the truth is from a line, predictions can be **arbitrarily poor**.

**Detect it:** look at a scatter plot of $x$ and $y$, or a scatter plot of the **residuals** $\hat e_i = y_i - \hat y_i$ vs. $x$.

- **Good:** residuals scattered evenly above and below 0 at every $x$, with no obvious pattern. The errors are supposed to be random draws from the **same** distribution regardless of $x$.
- **Bad:** a systematic pattern. If the model consistently **under**estimates (or **over**estimates) $y$ for certain $x$ values, the line doesn't match the true form of the relationship. A typical sign is a U or upside-down U in the residuals.

**Remedy:** a **non-linear transformation** of $x$, $y$ or both. Fitting a linear model to the transformed variables can capture a non-linear relationship between the original $x$ and $y$.

:::def Popular transformations
- $\log(y)$ and/or $\log(x)$
- $\sqrt{x}$, $x^2$, $\sqrt{y}$, $y^2$

Which to try depends on the shape of the original scatter plot. Try one, re-plot, and check the residuals again.
:::

## 2. Constant variance

The errors are supposed to all come from a distribution with the **same variance**, $\text{var}(\varepsilon_i) = \sigma^2$. If they tend to be more spread out for larger $x$, for example, the assumption is violated.

**Consequences:**
- Confidence intervals and hypothesis tests are **incorrect**, because they rely on the single value $\sigma^2$.
- The slope and intercept estimates are **still valid**, and the model can still be used for predictions.

**Detect it:** the same plots as for linearity (the $x$–$y$ scatter plot and residuals vs. $x$). The warning sign is $y$ values, or residuals, **more spread out vertically for certain $x$ values** in a noticeable pattern.

- **Good:** residuals about the same size at all $x$.
- **Bad:** residuals larger in magnitude at certain $x$. The common case is a **fan shape** that widens as $x$ grows, but being more spread out at small or middle $x$ is also a violation.

**Remedies:**
- Transforming the **response** sometimes helps. But if the relationship already looks linear, transforming **can cause non-linearity problems**.
- If you only want to estimate the coefficients and make predictions, not do inference, you don't have to do anything about it.

## 3. Normality of the errors

The errors in the true relationship are assumed to be **Normally distributed**. Confidence intervals and tests rely on this, so when it fails they give incorrect results.

**Consequences:**
- In **large samples**, this usually has only a small effect: inference for $\beta_0$, $\beta_1$ and the mean response $\beta_0 + \beta_1 x$ is close to correct.
- The exception: **prediction intervals** for an individual $y$ at a given $x$ are incorrect **even for large samples**. A prediction interval is about one draw of $\varepsilon$, so its shape matters directly; averaging doesn't rescue it.
- The least squares estimates are still valid, and the model can be used for **point** predictions (just not prediction **intervals**).

**Detect it:**
- a **histogram of the residuals**, compared to a Normal curve;
- a **Q-Q plot** ("Q" for quantile), which compares the percentiles of the residuals to the percentiles of a Normal distribution. If normality holds, the points lie on a **diagonal line**; points bending away from it mean possible non-normality. (You don't need to know how to build one from scratch: `plot(model, which = 2)`.)

**Remedies:**
- Sometimes transforming $y$ helps.
- In **large samples**, it's usually fine to use the model as-is for everything **except prediction intervals**.
- In **small samples**, be skeptical of all confidence intervals and hypothesis tests.

## 4. Independence of the errors

The last core assumption: the errors are **independent** of each other (no correlation). This is relevant when the data points have **sequential structure**, e.g. measurements collected over time, in order. If the data points aren't ordered in a meaningful way, this isn't something we usually try to check.

**Consequences:** inference based on the model is not valid (CIs and tests give wrong results). The estimates are still valid, and the model can be used for predictions.

**Detect it:**
- **Residuals vs. observation index:** plot the residuals in order (1st data point, 2nd, …).
  - **Positive** correlation looks like **clusters** of positive residuals followed by clusters of negative ones.
  - **Negative** correlation looks like the signs **alternating** almost every time: positive, negative, positive, …
- **Lagged residuals:** a scatter plot of the points $(\hat e_i, \hat e_{i+1})$, each residual against the next one. **Good:** a round blob. **Bad:** a diagonal shape.

**Remedy:** if you only want to estimate the linear relationship and make predictions, you can choose to ignore it. For inference you'd need a different type of model that allows correlated errors, which we haven't covered yet.

## Interpreting transformed models

Transformations change the **interpretation** of the coefficients. In general, $\beta_0$ and $\beta_1$ describe the **transformed** variables, and that doesn't translate neatly back to the original scale.

:::example Square root of x
Fit $\hat y = \hat\beta_0 + \hat\beta_1\sqrt{x}$. Then $y$ values tend to differ by $\hat\beta_1$ for $\sqrt{x}$ values that differ by 1. That's true, but there's no convenient interpretation in terms of differences in $x$ itself.
:::

**Log transformations are special:** they **do** have an interpretation on the original scale of $x$ and $y$.

### log(y) as the response

$$\log \hat y = \hat\beta_0 + \hat\beta_1 x \quad\Longrightarrow\quad \hat y = e^{\hat\beta_0 + \hat\beta_1 x} = e^{\hat\beta_0} e^{\hat\beta_1 x}$$

Compare $x_1$ and $x_2 = x_1 + 1$:
$$\frac{\hat y_2}{\hat y_1} = \frac{e^{\hat\beta_0}e^{\hat\beta_1 x_1}e^{\hat\beta_1}}{e^{\hat\beta_0}e^{\hat\beta_1 x_1}} = e^{\hat\beta_1}$$

:::formula log(y) model
For a **one-unit difference in $x$**, predicted $y$ differs by a **multiplicative factor of $e^{\hat\beta_1}$**, on average.

E.g. $\hat\beta_1 = 0.1$ gives $e^{0.1} \approx 1.105$: about 10.5% higher $y$ per extra unit of $x$.
:::

### log(y) and log(x): the log–log model

$$\log \hat y_1 = \hat\beta_0 + \hat\beta_1 \log x_1, \qquad \log \hat y_2 = \hat\beta_0 + \hat\beta_1 \log x_2$$
$$\log \hat y_2 - \log \hat y_1 = \hat\beta_1(\log x_2 - \log x_1) \quad\Longrightarrow\quad \log\!\left(\frac{\hat y_2}{\hat y_1}\right) = \hat\beta_1 \log\!\left(\frac{x_2}{x_1}\right) = \log\!\left(\left(\frac{x_2}{x_1}\right)^{\hat\beta_1}\right)$$

Exponentiating both sides:

:::formula log–log model
$$\frac{\hat y_2}{\hat y_1} = \left(\frac{x_2}{x_1}\right)^{\hat\beta_1}$$
If $x$ is multiplied by $k$, predicted $y$ is multiplied by $k^{\hat\beta_1}$.
- $x$ twice as large → $\hat y$ is $2^{\hat\beta_1}$ times as large.
- $x$ five times as large → $\hat y$ is $5^{\hat\beta_1}$ times as large.
- Rule of thumb: a 1% difference in $x$ goes with about a $\hat\beta_1$% difference in $y$. In economics this is the **elasticity**.
:::

:::tip Check your handwritten notes
Pages 11–12 of the handwritten notes write the log–log result as $\frac{\hat y_2}{\hat y_1} = e^{\hat\beta_1}\cdot\frac{x_2}{x_1}$, giving "$2e^{\hat\beta_1}$" for doubling and "$5e^{\hat\beta_1}$" for a factor of 5. Exponentiating $\hat\beta_1\log(x_2/x_1)$ actually gives $(x_2/x_1)^{\hat\beta_1}$, so doubling $x$ multiplies $\hat y$ by $2^{\hat\beta_1}$, not $2e^{\hat\beta_1}$. Quick check: if $\hat\beta_1 = 1$, $y$ is proportional to $x$, and doubling $x$ should double $y$. $2^1 = 2$ ✓, but $2e^1 \approx 5.4$ ✗. Worth confirming with your instructor or the slides.
:::

## Worked examples (from the slides and R notebook)

| Example | What the plots show | Problem | What fixed it |
|---|---|---|---|
| 1 | curved scatter; residuals − + − across x | non-linearity | $\log(x)$ (√x wasn't enough) |
| 2 | curved, residuals fan out at large x | non-linearity **and** non-constant variance | $\sqrt{y}$ |
| 3 | strongly curved | non-linearity | $\log(x)$ **and** $\log(y)$ |
| 4 | linear, but spread grows with x | non-constant variance | no transformation; estimates OK, skip inference |
| 5 | looks fine vs. x, but runs of same-sign residuals in time order | correlated errors | none yet; estimates OK, inference not |
| 6 | linear, even spread, but residual histogram and Q-Q plot not Normal | non-normal errors | estimates OK; in practice inference ≈ OK except prediction intervals |

See the *Diagnostics and remedial measures* R example for the code and plots.
