---
id: L13
date: 2026-10-28
title: Multiple linear regression
pdf: notes/2026-10-28-multiple-regression.pdf
slides: notes/2026-10-28-multiple-regression-slides.pdf
part: Part II
topics: multiple predictors, population model, least squares, R-squared, holding other predictors fixed, coefficients change with the model, confounding, polynomial terms, I(), lm with +, predict
summary: Regression with more than one predictor. The model, estimation and R² work the same way as before; what changes is how you read a slope. Each coefficient compares observations that differ by one unit in that predictor but are equal on all the others, so a predictor's coefficient can shrink, vanish or flip sign when other predictors are added. Examples: NYC restaurant prices, shark attacks and ice cream, house prices and bedrooms, and a tide curve fit with time².
takeaways:
- Model: $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_p x_p + \varepsilon$, with $E(\varepsilon) = 0$, so $E(Y \mid x_1, \dots, x_p) = \beta_0 + \beta_1 x_1 + \cdots + \beta_p x_p$.
- Estimation is still **least squares**: choose the $\hat\beta$'s that minimize $\sum (y_i - \hat y_i)^2$. $R^2 = 1 - \sum(y_i - \hat y_i)^2 / \sum(y_i - \bar y)^2$ still means the % of variation in y explained.
- **The new part:** $\hat\beta_k$ is the average difference in y between observations with a **one-unit difference in $x_k$ and the same values of all the other predictors** ("holding the others constant").
- A predictor's coefficient **depends on what else is in the model**. Food alone: $2.94; food with service: $1.50. Bedrooms alone: +30; bedrooms with square footage: −5.
- In R: `lm(y ~ x1 + x2, data = d)`; `lm(y ~ ., data = d)` uses every other column. For a squared term, wrap it in `I()`: `lm(depth ~ time + I(time^2))`.
- Each row of `summary()` tests $H_0: \beta_k = 0$ **for that coefficient, given the others in the model**.
---

## Why more than one predictor?

So far: **simple** linear regression, one predictor, $y = \beta_0 + \beta_1 x + \varepsilon$. In practice we often have additional variables we can use to predict y.

**Example (restaurants):** 168 Italian restaurants in NYC (2001).
- y = dinner price (\$19 to \$65)
- $x_1$ = food quality score (0–30)
- $x_2$ = service quality score (0–30)

Food and service scores are **positively correlated** (not surprising).

We could fit two separate simple regressions:

| Model | Fitted line |
|---|---|
| Food only | $\widehat{\text{price}} = -17.83 + 2.94\cdot\text{food}$ |
| Service only | $\widehat{\text{price}} = -11.98 + 2.82\cdot\text{service}$ |

That isn't satisfactory:
- For any restaurant we'd get **two different predictions**, which isn't helpful.
- Each model **ignores** the information in the other predictor, so we don't want to just pick one.

**Better approach:** one combined model in which each predictor has its own slope.

$$\text{price} = \beta_0 + \beta_1\,\text{food} + \beta_2\,\text{service} + \varepsilon$$

:::formula Multiple linear regression model
$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_p x_p + \varepsilon, \qquad E(\varepsilon) = 0$$
$$E(Y \mid X_1 = x_1, \dots, X_p = x_p) = \beta_0 + \beta_1 x_1 + \cdots + \beta_p x_p$$
$x_k$ is the k-th predictor. Each data point is $(x_{i1}, x_{i2}, \dots, x_{ip}, y_i)$: every observation has a value for every predictor.
:::

## What stays the same

- We still assume a **true linear relationship in the population** and use the data to estimate its coefficients.
- Each observation still has a random error $\varepsilon$ with mean 0.
- Coefficients are estimated by **least squares**.
- $R^2$ means the same thing.

:::formula Least squares and R² (multiple regression)
$$\hat\beta_0, \hat\beta_1, \dots, \hat\beta_p \text{ minimize } \sum_{i=1}^n \big(y_i - (\hat\beta_0 + \hat\beta_1 x_{i1} + \cdots + \hat\beta_p x_{ip})\big)^2$$
$$R^2 = 1 - \frac{\sum (y_i - \hat y_i)^2}{\sum (y_i - \bar y)^2} = \text{\% of variation in } y \text{ explained by the model}$$
:::

We can't draw the fitted "line" in a helpful way anymore (with two predictors it's a plane), but the idea is the same: the fit that is closest to the data, where closest means smallest sum of squared residuals.

## What's different: interpreting the slopes

Fitted model: $\widehat{\text{price}} = -21.16 + 1.50\cdot\text{food} + 1.70\cdot\text{service}$.

:::template Slope in multiple regression
"Among [units] with the same [other predictors], those whose [$x_k$] differs by 1 [unit] differ in average [y] by [$\hat\beta_k$] [units]."
:::

:::example Restaurants
- $\hat\beta_1 = 1.50$: restaurants with a **1-point difference in food score and the same service score** have dinner prices that differ by **$1.50** on average.
- $\hat\beta_2 = 1.70$: restaurants with **equal food quality** but a 1-point difference in service quality have prices that differ by **$1.70** on average.
- Both scores are on the same 0–30 scale, so it's fair to say service is associated with a bigger price difference than food, once both are in the model.
:::

:::def Coefficient in a multiple regression
$\beta_k$ = the average difference in y between observations with a **one-unit difference in $x_k$** but **equal values of all the other predictors**. Often phrased "with all other predictors held constant."
:::

Depending on context it may not make sense for two observations to differ in one predictor and match on the rest. Don't worry about that for now.

## Coefficients change with the model

Adding predictors can change the estimated relationship between a given predictor and the response. This isn't a quirk of estimation: new information changes the question being asked.

| Model | Food coefficient |
|---|---|
| Food only | **2.94** |
| Food + service | **1.50** |

With food alone, food gets almost twice the weight, because it is also standing in for service (the two are correlated). Once service is in the model, food only gets credit for what it adds beyond service.

**In general, $\hat\beta_k$ depends on what else is in the model.**

:::example Shark attacks and ice cream
- y = number of shark attacks at a beach community over time; $x_1$ = ice cream sales.
- Alone: $\hat\beta_1 > 0$, a positive association.
- Add $x_2$ = temperature: $\hat\beta_1 \approx 0$ and $\hat\beta_2 > 0$. The link between attacks and ice cream was mostly explained by temperature (hot days bring both).
:::

:::example House prices and bedrooms
- y = house price ($1000s), $x_1$ = number of bedrooms. Alone: $\hat y = 220 + 30x_1$, so more bedrooms go with more expensive houses.
- Add $x_2$ = square footage: $\hat y = 10 - 5x_1 + 0.175x_2$. Now the bedroom coefficient is **negative**: **among houses of the same size**, more bedrooms go with a lower price. Six tiny bedrooms are less desirable than three or four larger ones.
:::

:::tip Connection to what you know
This is confounding and omitted variable bias in action. A simple regression's slope can absorb the effect of a left-out variable that's related to both x and y. Adding that variable can shrink the slope (ice cream), cut it roughly in half (food) or flip its sign (bedrooms, and Beds in HW 6).
:::

## In R

:::r Fitting and predicting
- `lm(Price ~ Food + Service, data = restaurants)`: list predictors separated by `+`.
- `lm(Price ~ ., data = restaurants)`: `.` means every column except the response. Same model here.
- `summary(fit)$coefficients`: one row per coefficient. Each p-value tests $H_0: \beta_k = 0$ vs. $H_A: \beta_k \ne 0$ **individually, with the other predictors in the model**.
- `predict(fit, newdata = data.frame(Food = 28, Service = 28))`: supply a value for every predictor.
:::

| Predict for food = 28, service = 28 | $\hat y$ |
|---|---|
| Combined model | **$68.43** |
| Food only | $64.46 |
| Service only | $66.94 |

The combined model predicts a slightly higher price for a restaurant with excellent food **and** service than either single-predictor model.

## Polynomial terms: capturing a curve

**Tide example:** tide depth vs. time of day is clearly **non-linear** (it rises and falls). Add $\text{time}^2$ as a second predictor:

$$\text{depth} = \beta_0 + \beta_1\,\text{time} + \beta_2\,\text{time}^2 + \varepsilon$$

:::r Squared terms need I()
`lm(depth ~ time + I(time^2), data = tides)`

Exponents mean something else inside a model formula, so wrap the squared term in `I()` ("isolate") to get the actual square.
:::

Fitted: $\widehat{\text{depth}} = -0.42 + 3.05\,\text{time} - 0.254\,\text{time}^2$, with $R^2 = 0.97$: a far better fit than a straight line. The model is still **linear in the coefficients**, which is why least squares and `lm()` still work.
