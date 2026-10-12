---
id: L06
date: 2026-09-30
title: Introduction to linear regression
pdf: notes/2026-09-30-linear-regression-intro.pdf
part: Part II
examples: R3
topics: predictor, response, least squares, sum of squared residuals, population model, error term, fitted value, residual, slope and intercept formulas, unbiased
summary: Regression describes how a response Y relates to a predictor X and lets us predict Y from X. The best line is the one that minimizes the sum of squared vertical distances (least squares). The true line Y = β₀ + β₁X + ε is unknown; the fitted line ŷ = β̂₀ + β̂₁x estimates it, and those estimates are unbiased.
takeaways:
- $X$ = predictor, $Y$ = response. Regression lets us **describe** a relationship and **make predictions**.
- Least squares: choose the line minimizing $\sum_{i=1}^n (y_i - (\beta_0 + \beta_1 x_i))^2$. Squaring stops positive and negative distances cancelling.
- Population model: $Y_i = \beta_0 + \beta_1 X_i + \varepsilon_i$ with $E(\varepsilon_i) = 0$, so $E(Y \mid X = x) = \beta_0 + \beta_1 x$.
- $\hat\beta_1 = \dfrac{\sum (x_i - \bar x)(y_i - \bar y)}{\sum (x_i - \bar x)^2}$ and $\hat\beta_0 = \bar y - \hat\beta_1 \bar x$.
- Fitted value $\hat y_i = \hat\beta_0 + \hat\beta_1 x_i$. Residual $\hat e_i = y_i - \hat y_i$ (distance to the **estimated** line, which we can compute). Error $\varepsilon_i$ (distance to the **true** line, unknown).
- Unbiased: $E(\hat\beta_0) = \beta_0$ and $E(\hat\beta_1) = \beta_1$. Any one sample's estimates are off, but they're right on average.
- In R: `lm(y ~ x, data = df)`; `model$coefficients` gives $\hat\beta_0, \hat\beta_1$.
---

## What regression is for

With regression models we can explore relationships between variables, or predict the value of one variable from another. Regression lets us

- **describe relationships**, and
- **make predictions**.

We focus on **linear** regression: representing the relationship between $X$ and $Y$ with a line $y = ax + b$ (slope $a$, intercept $b$).

If two quantities have a **perfectly** linear relationship (temperature in °C vs. °F; voltage and current across a resistor), every observation falls exactly on a line. But in most real settings the points aren't in a perfect line.

:::example Economic voting
When economic conditions are good, people tend to view the incumbent party more favorably, and it tends to get a bigger share of the vote.
- $X$ = **predictor**: economic growth
- $Y$ = **response**: incumbent party's vote share

The scatter plot looks roughly linear. If we wanted to draw a line through the points to describe the relationship, how would we pick it?
:::

## Defining the "best" line: least squares

We want a line that's "close" to the points. Some lines are clearly not close; for two reasonable-looking lines, how do we decide which is better? For linear regression we measure closeness with the **vertical distances** from the points to the line, $d_i$.

We want those distances to be small across the whole data set. But positive and negative distances would cancel each other out, so we **square** them and make the **sum of squared distances** as small as possible.

:::def Notation
Data: pairs $(x_1,y_1), (x_2,y_2), \dots, (x_n,y_n)$. If the line is $f(x) = ax+b$, the point on the line at $x = x_i$ is $(x_i,\, ax_i + b)$, and the vertical distance to the data point is $y_i - (ax_i+b)$.
:::

:::formula Least squares criterion
Choose the line that minimizes
$$\sum_{i=1}^n \big(y_i - (ax_i + b)\big)^2$$
This is the **line of best fit**, or **least squares regression line**.
:::

See the *Fitting lines* R example for this worked out on the voting data.

## The population model

The relationship between $X$ and $Y$ won't be perfectly linear for most problems we care about. Instead, we assume the **true** relationship is
$$Y = \beta_0 + \beta_1 X + \text{error}.$$
Data points don't fall exactly on the line; each one is away from it by some error term, and we treat those error terms as **random**:

:::formula Simple linear regression model
$$Y_i = \beta_0 + \beta_1 X_i + \varepsilon_i, \qquad E(\varepsilon_i) = 0 \text{ for all } i$$
The errors having expected value zero is an **assumption** of the model.
:::

:::example SAT score and first-year GPA
$X$ = SAT score, $Y$ = freshman GPA. Suppose the true relationship is
$$\text{GPA} = 1 + 0.002\cdot\text{SAT} + \varepsilon$$
A student who scored 1200: $Y_i = 1 + 0.002\cdot1200 + \varepsilon_i = 3.4 + \varepsilon_i$.

There's a whole **population distribution** of GPAs for students who scored 1200. Because $\varepsilon$ is random, their GPA is a random variable. Collect GPAs from several such students and they'd differ, but be close to 3.4 on average:
$$E(Y \mid X = 1200) = E(3.4 + \varepsilon) = 3.4 + E(\varepsilon) = 3.4$$
:::

:::formula Expected response
$$E(Y \mid X = x) = \beta_0 + \beta_1 x$$
The point on the true line is the "typical" value of $Y$ when $X = x$.
:::

## Estimating the line from data

In practice we **don't know** the true relationship. It's the same situation as not knowing the population % of seat-belt wearers: there's a true value, so we estimate it from data.

We collect a random sample of pairs $(x_1,y_1),\dots,(x_n,y_n)$, make a scatter plot, and fit a line. The fitted slope and intercept won't exactly equal the true values, just as $\hat p$ and $\bar x$ don't exactly equal $p$ and $\mu$.

:::def Estimated regression line, fitted values, residuals
- **Estimated line:** $\hat y = \hat\beta_0 + \hat\beta_1 x$
- **Fitted value** for data point $(x_i, y_i)$: $\hat y_i = \hat\beta_0 + \hat\beta_1 x_i$
- **Residual:** the vertical distance from the data point to the **estimated** line,
$$\hat e_i = y_i - \hat y_i = y_i - (\hat\beta_0 + \hat\beta_1 x_i)$$
:::

The residual is **not** the error term. The error is the distance to the **true, unknown** line: $\varepsilon_i = y_i - (\beta_0 + \beta_1 x_i)$. We can't compute $\varepsilon_i$ because $\beta_0, \beta_1$ are unknown; we can only compute the residual $\hat e_i$.

The residuals are exactly the vertical distances from the start of the lecture, so **least squares minimizes** $\sum_{i=1}^n \hat e_i^{\,2}$.

:::formula Least squares estimates
$$\hat\beta_1 = \frac{\sum_{i=1}^n (x_i - \bar x)(y_i - \bar y)}{\sum_{i=1}^n (x_i - \bar x)^2}, \qquad \hat\beta_0 = \bar y - \hat\beta_1\,\bar x$$
$\hat\beta_1$ estimates $\beta_1$; $\hat\beta_0$ estimates $\beta_0$. (We won't derive these, just use them.)
:::

## Unbiasedness

Recall $E(\hat p) = p$ and $E(\bar X) = E(X) = \mu$.

:::def Unbiased estimator
An estimator $\hat\theta$ is **unbiased** if its expected value equals the true quantity: $E(\hat\theta) = \theta$.
:::

The slope and intercept estimates are also unbiased:
$$E(\hat\beta_0) = \beta_0, \qquad E(\hat\beta_1) = \beta_1$$

For any one data set the estimates won't be exactly right, but they're correct **on average**. The method doesn't systematically guess too high ($E(\hat\beta_1) > \beta_1$) or too low.

:::example Why $\hat\beta_1$ is unbiased (sketch)
Treat the $x_i$ as fixed. Since $E(y_i) = \beta_0 + \beta_1 x_i$ and $E(\bar y) = \beta_0 + \beta_1\bar x$,
$$E(\hat\beta_1) = \frac{\sum (x_i-\bar x)\big(E(y_i) - E(\bar y)\big)}{\sum (x_i-\bar x)^2} = \frac{\sum (x_i-\bar x)\,\beta_1(x_i - \bar x)}{\sum (x_i-\bar x)^2} = \beta_1$$
:::

Next we'll want to know how **close** $\hat\beta_0$ and $\hat\beta_1$ tend to be to the truth, i.e. their variance. As with proportions and means, observing more data makes the estimates more precise.
