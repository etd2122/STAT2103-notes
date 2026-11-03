---
id: L14
date: 2026-11-04
title: Inference for multiple regression
pdf: notes/2026-11-04-multiple-regression-inference.pdf
pdflabel: Lecture slides
part: Part II
topics: overall F test, at least one predictor, reading summary output, F-statistic, t test given other predictors, nested models, full vs reduced model, anova, partial F test, RSS
summary: Testing several coefficients at once. The overall F test (bottom line of summary()) asks whether any predictor has a linear relationship with y. A partial F test, run with anova(reduced, full), asks whether a group of extra predictors adds information beyond the ones already in the model. Typed from the slides; handwritten notes not uploaded yet.
takeaways:
- **Overall F test:** $H_0: \beta_1 = \beta_2 = \cdots = \beta_p = 0$ vs. $H_A$: **at least one** $\beta_j \ne 0$. It's the last line of `summary()`: `F-statistic: … on p and n−p−1 DF, p-value: …`.
- Rejecting says **at least one** predictor is linearly related to y. It doesn't say which one(s); look at the individual t tests for that.
- Each t test in `summary()` asks whether that predictor adds anything **given all the others**. Service is significant with food alone (p ≈ 0.0001), but not once decor is added (p = 0.73).
- **Partial F test** for a subset: compare a reduced model (without those predictors) to the full model with `anova(reduced, full)`. $F = \dfrac{(\text{RSS}_{red} - \text{RSS}_{full})/(df_{red} - df_{full})}{\text{RSS}_{full}/df_{full}}$.
- Small p-value: the extra predictors explain significantly more variation; at least one of them adds information in a model that already has the others.
---

:::tip Note
Typed from the Nov 4 slides. Upload the handwritten notes when you have them and I'll merge them in.
:::

## Checking for any linear relationship: the overall F test

Restaurant data again: price on food quality ($x_1$) and service quality ($x_2$).

`combined_model <- lm(Price ~ Food + Service, data = restaurants)`

**Goal:** test whether **any** of the predictors has a linear relationship with price.

:::formula Overall F test
$$H_0: \beta_1 = \beta_2 = \cdots = \beta_p = 0 \qquad H_A: \text{at least one } \beta_j \ne 0$$
$$F = \frac{\text{SSR}/p}{\text{SSE}/(n - p - 1)}, \qquad \text{df} = (p,\ n - p - 1)$$
The intercept is not part of $H_0$. A large F means the predictors explain much more variation than chance would.
:::

### Reading the output

```
Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) -21.1586     5.6651  -3.735 0.000258 ***
Food          1.4954     0.4462   3.351 0.000997 ***
Service       1.7041     0.4185   4.072 7.22e-05 ***

Residual standard error: 6.942 on 165 degrees of freedom
Multiple R-squared:  0.4486,  Adjusted R-squared:  0.4419
F-statistic: 67.12 on 2 and 165 DF,  p-value: < 2.2e-16
```

- **Bottom line:** test statistic $f_{obs} = 67.12$ with 2 and 165 df ($p = 2$ predictors, $n - p - 1 = 168 - 3 = 165$).
- "p-value < 2.2e-16" means $p < 2.2 \times 10^{-16}$, essentially 0.
- Residual SE (σ̂ = 6.94) has the same df as the F denominator: n − p − 1.

**Conclusion:** reject $H_0$. Leaving out food and service leaves significantly more unexplained variation in price, so **at least one** of food quality and service quality has a linear relationship with price. The test **doesn't say which one** (or both).

:::template Overall F test conclusion
"Since the p-value ([p]) is less than [0.05], we reject $H_0: \beta_1 = \cdots = \beta_p = 0$. At least one of [predictors] has a linear relationship with [y]; the model is useful."
:::

## Adding a predictor: t tests depend on the model

Add decor quality (0–30) as a third predictor:

```
            Estimate Std. Error t value Pr(>|t|)
(Intercept) -24.6409     4.7536  -5.184 6.33e-07 ***
Food          1.5556     0.3731   4.170 4.93e-05 ***
Service       0.1350     0.3957   0.341    0.733
Decor         1.8473     0.2176   8.491 1.17e-14 ***

Residual standard error: 5.803 on 164 degrees of freedom
Multiple R-squared:  0.617,  Adjusted R-squared:  0.61
F-statistic: 88.06 on 3 and 164 DF,  p-value: < 2.2e-16
```

- **Service** dropped from 1.70 (p ≈ 0.0001) to **0.135 (p = 0.73)**. Among restaurants with the same food **and decor** scores, service isn't significantly associated with price. Service and decor are related, and decor carries the information service was standing in for.
- $R^2$ rose from 0.449 to 0.617.

:::tip Individual t tests
Each row's t test asks: does this predictor add information **given all the other predictors in this model**? Change the model and the answer can change.
:::

## Testing a subset of predictors: the partial F test

In the expanded model, we might ask whether service and decor **together** add anything beyond food:

$$H_0: \beta_2 = \beta_3 = 0 \qquad H_A: \text{at least one of } \beta_2, \beta_3 \ne 0$$

That's a comparison of two **nested** models:

| | Model |
|---|---|
| Full | $\text{price} = \beta_0 + \beta_1\,\text{food} + \beta_2\,\text{service} + \beta_3\,\text{decor} + \varepsilon$ |
| Reduced | $\text{price} = \beta_0 + \beta_1\,\text{food} + \varepsilon$ |

Is the reduced model significantly worse than the full one?

:::r Compare models with anova()
```
reduced_model <- lm(Price ~ Food, data = restaurants)
full_model    <- lm(Price ~ Food + Service + Decor, data = restaurants)
anova(reduced_model, full_model)
```
:::

```
Model 1: Price ~ Food
Model 2: Price ~ Food + Service + Decor
  Res.Df    RSS Df Sum of Sq      F    Pr(>F)
1    166 8751.2
2    164 5523.6  2    3227.6 47.915 < 2.2e-16 ***
```

:::formula Partial F test (nested models)
$$F = \frac{(\text{RSS}_{red} - \text{RSS}_{full})\,/\,(df_{red} - df_{full})}{\text{RSS}_{full}\,/\,df_{full}}$$
RSS = residual sum of squares (SSE); df = residual degrees of freedom (`Res.Df`). The numerator is the extra variation explained per added predictor; the denominator is the full model's leftover variation per df.
:::

**Check by hand:**
- Numerator: $(8751.2 - 5523.6)/(166 - 164)$ = 3227.6/2 = 1613.8
- Denominator: $5523.6/164 = 33.68$
- $F = 1613.8/33.68 \approx 47.9$ ✓

**Conclusion:** the p-value is extremely close to 0. Reject $H_0: \beta_2 = \beta_3 = 0$: **at least one of service and decor provides additional information** about price, in a linear model that already uses food quality.

:::tip Three tests, three questions
- **t test (one row):** does $x_k$ add anything, given all the others?
- **Overall F (bottom of `summary()`):** does any predictor help at all?
- **Partial F (`anova(reduced, full)`):** does this group of predictors add anything beyond the reduced model?

The overall F test is the partial F test with the reduced model being "intercept only."
:::
