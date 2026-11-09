---
id: L15
date: 2026-11-09
title: Adding predictors, adjusted R² and variable selection
pdf: notes/2026-11-09-adding-predictors.pdf
part: Part II
topics: multiple testing, why the overall F test, partial F test recap, RSS never increases, R² always increases, adjusted R², variable selection, all subsets, scatterplots, stepwise, fail to reject is not accept, AIC, BIC
summary: Why we test all the slopes at once with an F test instead of running a t test for each one (many 5% tests together make a false alarm much more likely than 5%). Then a key fact about nested models: adding a predictor can never make RSS go up, so R² can never go down, even when the new predictor is useless in the population. Adjusted R² fixes that by charging for each predictor, which makes it a tool for choosing predictors: try every subset, look at scatterplots, or go stepwise. Page 6 of the scan is crossed out and redone on the next page; one page is blank.
takeaways:
- **Many individual t tests ≠ one overall F test.** Each 5% test has a 5% chance of a false rejection, but the chance that **at least one** of several tests falsely rejects is **more than 5%**. The overall F test keeps the false-rejection rate at exactly 5%. You need to know **that** they differ; the explanation isn't required.
- Left-handed analogy: P(one person is left-handed) = 0.13, but P(at least 1 of 10 is) = $1 - 0.87^{10} \approx 0.75$.
- Partial F test: $f_{obs} = \dfrac{(\text{RSS}_{red} - \text{RSS}_{full})/(df_{red} - df_{full})}{\text{RSS}_{full}/df_{full}}$ with $df_{full} = n - p - 1$ and $df_{red} = n - (\#\text{ predictors in reduced}) - 1$. Large $f_{obs}$ → removing those predictors makes the model much worse → reject $H_0$. Run it with `anova(reduced, full)`.
- **$\text{RSS}_{red} \ge \text{RSS}_{full}$, always.** The bigger model can always copy the smaller one by setting the extra slope to 0, and least squares never picks something worse. So $f_{obs} \ge 0$.
- So **adding a predictor never lowers $R^2$**, even if its true $\beta_k = 0$: by chance its sample correlation with y isn't exactly 0. A higher $R^2$ doesn't mean a truly better model; the goal is the **population** relationship.
- **Adjusted $R^2$** accounts for the number of predictors and **can go down** when an irrelevant predictor is added. If it drops, that suggests the new predictor isn't useful.
- **Don't** pick predictors by keeping only the significant ones. Failing to reject $H_0: \beta_k = 0$ doesn't mean $\beta_k$ **is** 0.
- Variable selection options: (1) fit every subset ($2^p - 1$ models: 7 for food/service/decor), impractical for many predictors; (2) scatterplots of y vs each predictor; (3) **backward stepwise**: start full, remove the predictor whose removal raises adj $R^2$ the most, repeat until every removal lowers it. Other criteria exist (AIC, BIC).
---

## Why not just test each slope separately?

Last time we met a new test of the hypothesis that **all** the slopes are zero:

$$H_0: \beta_1 = \beta_2 = \cdots = \beta_p = 0$$

But we already knew how to test each coefficient on its own ($H_0: \beta_1 = 0$, $H_0: \beta_2 = 0$, …, $H_0: \beta_p = 0$), using the t test in each row of `summary()`. Why bother with a new test?

Much like fitting one multiple regression model is different from fitting several simple regressions, **performing a bunch of individual tests is not the same as performing the overall test.**

:::tip What you need for the exam
The professor said you only need to know **that** the individual tests and the overall test are different, not the explanation of why. The explanation is below because it makes the rest of the lecture easier.
:::

### The idea: every test can raise a false alarm

With a 5% rejection threshold ($\alpha = 0.05$), when $H_0$ is actually **true** we still (mistakenly) reject it 5% of the time. That's what $\alpha$ means.

Now suppose the truth is $\beta_1 = \beta_2 = \cdots = \beta_p = 0$ and we run a separate test for each slope:

- **Each** test $H_0: \beta_k = 0$ mistakenly rejects 5% of the time.
- But the probability that **at least one** of the tests mistakenly rejects is **greater than 5%**.

:::example Left-handed people
Say 13% of people are left-handed, and we sample 10 people.
- For **each** person, P(left-handed) = 0.13.
- But P(**at least one** of the 10 is left-handed) is not 13%, it's much bigger:
$$P(\ge 1 \text{ left-handed}) = 1 - P(0 \text{ left-handed}) = 1 - (0.87)^{10} \approx 0.75$$
Same logic for tests: each one has a small chance of a false alarm, but with many tests at least one false alarm becomes likely.
:::

### Ten predictors that are all useless

Suppose there are 10 predictors $x_1, \dots, x_{10}$ and in truth $\beta_1 = \cdots = \beta_{10} = 0$ (no linear association between the predictors and y). We test $H_0: \beta_1 = 0$, …, $H_0: \beta_{10} = 0$, each with a 5% chance of a mistake.

If we reject in **any** of those tests, we'd wrongly conclude there **is** a linear association between y and at least one predictor. The chance of at least one mistake overall is **more than 5%**.

:::tip How much more? (not in the notes)
If the 10 tests were independent, the chance of at least one false rejection would be $1 - 0.95^{10} \approx 0.40$, i.e. about 40% instead of 5%. The t tests in one model aren't exactly independent, so the real number differs, but the point stands: it can be a lot bigger than 5%.
:::

A **single combined test** of $H_0: \beta_1 = \cdots = \beta_{10} = 0$ with threshold 5% is designed to reject a true null hypothesis **exactly 5% of the time**. If $H_0$ is true, the F test mistakenly rejects 5% of the time.

**That's why** we use the F test for "is there any linear association?" rather than scanning the individual p-values in `summary()`.

## The partial F test, again

We can also test whether a **group** of predictors (or all of them) have coefficients of zero. The idea: if certain predictors don't give any additional information about y, then removing them shouldn't make the model predict y much worse.

**Example:** $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_3 + \varepsilon$

$H_0: \beta_2 = \beta_3 = 0$ means $x_2$ and $x_3$ provide no **extra** information about y once $x_1$ is in the model. If that's true, removing $x_2$ and $x_3$ shouldn't worsen predictions very much.

For the restaurant data (price on food, service and decor), the question was whether service and decor really help the model predict price. Compare two models:

| | Model |
|---|---|
| "Full" (all predictors) | $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_3 + \varepsilon$ |
| "Reduced" (drops the predictors in $H_0$) | $y = \beta_0 + \beta_1 x_1 + \varepsilon$ |

What we compare is the **sum of squared residuals**, $\text{RSS}_{red}$ vs $\text{RSS}_{full}$.

- If $H_0$ is **false** (service and decor do add information), dropping them gives worse predictions, so $\text{RSS}_{red} > \text{RSS}_{full}$ by a lot.
- If $H_0$ is **true**, $\text{RSS}_{red} \approx \text{RSS}_{full}$.

:::formula Partial F test statistic
$$f_{obs} = \frac{(\text{RSS}_{red} - \text{RSS}_{full})\,/\,(df_{red} - df_{full})}{\text{RSS}_{full}\,/\,df_{full}}$$
$$df_{full} = n - p - 1, \qquad df_{red} = n - (\#\text{ predictors in reduced model}) - 1$$
A **large** $f_{obs}$ means removing those predictors makes the model much worse, which is incompatible with $H_0$ (here $H_0: \beta_2 = \beta_3 = 0$), so we reject.
:::

You won't compute this by hand in practice: use `anova(reduced_model, full_model)` in R. The worked restaurant output (F = 47.9) is in [L14](#L14).

## Adding a predictor never makes RSS go up

Something we didn't say explicitly last time:

:::def RSS in nested models
$$\text{RSS}_{red} \ \ge\ \text{RSS}_{full}, \quad \text{always}$$
Said the other way around: when you **add** a predictor to a regression model, the sum of squared residuals goes **down or stays the same**. It can never go up.
:::

Including a new predictor never gives a model that fits the **observed data** worse. Why not?

**Step by step.** Suppose we have data $y, x_1, x_2$.

1. **Model A** (one predictor): $\hat y = \hat\beta_0 + \hat\beta_1 x_1$. Least squares picks $\hat\beta_0, \hat\beta_1$ to make
$$\text{RSS}_A = \sum_{i=1}^n \big(y_i - (\hat\beta_0 + \hat\beta_1 x_{i1})\big)^2$$
as small as possible.
2. **Model B** (both predictors): $\hat y = \hat\beta_0' + \hat\beta_1' x_1 + \hat\beta_2' x_2$. Least squares picks $\hat\beta_0', \hat\beta_1', \hat\beta_2'$ to make
$$\text{RSS}_B = \sum_{i=1}^n \big(y_i - (\hat\beta_0' + \hat\beta_1' x_{i1} + \hat\beta_2' x_{i2})\big)^2$$
as small as possible.
3. Model B is **allowed** to choose $\hat\beta_0' = \hat\beta_0$, $\hat\beta_1' = \hat\beta_1$ and $\hat\beta_2' = 0$. Then it's literally model A, and $\text{RSS}_B = \text{RSS}_A$.
4. If **different** values of $(\hat\beta_0', \hat\beta_1', \hat\beta_2')$ give a smaller $\text{RSS}_B$, least squares picks those instead. If not, it can still match $\text{RSS}_A$.
5. Since model A's coefficients are among model B's options, B never picks anything worse: $\text{RSS}_B \le \text{RSS}_A$.

:::tip Consequence for the F test
Because $\text{RSS}_{red} - \text{RSS}_{full} \ge 0$ (and the dfs are positive), $f_{obs} \ge 0$ always. The F test is one-sided: only **large** values count as evidence against $H_0$.
:::

## R² always goes up, even for useless predictors

In multiple regression we still compute

$$R^2 = 1 - \frac{\sum_{i=1}^n (y_i - \hat y_i)^2}{\sum_{i=1}^n (y_i - \bar y)^2}$$

and it still means the **% of variation in y explained by the model**.

Chain of reasoning:
- Add a predictor → the numerator $\sum (y_i - \hat y_i)^2$ (RSS) goes down or stays the same.
- The denominator $\sum (y_i - \bar y)^2$ doesn't depend on the model at all.
- So **$R^2$ goes up or stays the same.**

Since $R^2$ is meant to measure how well the model fits, it seems that including more predictors **always** makes the model better. Is that right?

### What if the true $\beta_k = 0$?

$R^2$ **also** goes up when we add a predictor whose coefficient in the **population** model is zero.

- For any finite sample, the **sample** correlation between $x_k$ and y won't be exactly 0, purely from random chance. (Just like a sample mean never exactly equals the population mean.)
- So in the sample there's some association between $x_k$ and y, and $R^2$ improves when we add $x_k$.
- **But that's misleading.** In the population, $x_k$ doesn't provide any extra information about y (in this linear model). Including it isn't truly better.

:::tip Remember the goal
Our goal is to estimate the **true population relationship**, not just the relationship in this one particular sample. A model that chases the noise in one sample isn't a better model.
:::

## Adjusted R²

To correct for the problem that adding predictors always makes $R^2$ go up, there's an **adjusted** version of $R^2$:

- It takes into account **how many predictors** are in the model, adjusting for the fact that $R^2$ would otherwise grow with more predictors just by chance.
- It **can go down** when an irrelevant predictor is added.
- That allows a **fair comparison** of "full" and "reduced" models.

If we add a predictor and adjusted $R^2$ **decreases**, that's an indication the new predictor isn't useful.

:::formula Adjusted R² (standard formula, not written in the notes)
$$R^2_{adj} = 1 - \frac{\text{RSS}/(n - p - 1)}{\sum (y_i - \bar y)^2/(n - 1)} = 1 - (1 - R^2)\,\frac{n - 1}{n - p - 1}$$
It's $R^2$ with each sum of squares divided by its degrees of freedom. Adding a predictor lowers RSS but also lowers $n - p - 1$; adjusted $R^2$ only rises if RSS drops by enough to pay for the lost df.
:::

:::example Checking it against the restaurant output (n = 168)
- Food + Service ($p = 2$): $R^2 = 0.4486$, so $R^2_{adj} = 1 - 0.5514 \times \tfrac{167}{165} = 0.4419$ ✓ (matches `Adjusted R-squared: 0.4419`).
- Food + Service + Decor ($p = 3$): $R^2 = 0.617$, so $R^2_{adj} = 1 - 0.383 \times \tfrac{167}{164} = 0.610$ ✓.

Adjusted $R^2$ went up a lot (0.44 → 0.61), so decor earns its place.
:::

:::r Where to find it
```
summary(full_model)                 # see "Adjusted R-squared:"
summary(full_model)$adj.r.squared   # just the number
```
:::

## Choosing which predictors to include

As the analyst, **you** choose which predictors go in the model. You don't need to use every variable you have access to. Adjusted $R^2$ is one tool for deciding.

### What not to do: drop the non-significant ones

It's tempting to fit a model with every predictor, then throw out the ones whose slopes aren't significantly different from 0 (i.e. where you fail to reject $H_0: \beta_k = 0$). This is generally **not** considered best practice.

:::tip Fail to reject ≠ accept
Failing to reject $H_0: \beta_k = 0$ doesn't mean we accept that $\beta_k$ definitely **is** zero. It might just mean we don't have enough data to detect it, or that another correlated predictor is carrying the same information (remember service in [L14](#L14)).
:::

### Option 1: fit every combination of predictors

With only a few predictors, fit a separate model for **every subset** and compare (e.g. by adjusted $R^2$).

Restaurant prices with food, service and decor:

| 1 predictor | 2 predictors | 3 predictors |
|---|---|---|
| food | food + service | food + service + decor |
| service | food + decor | |
| decor | service + decor | |

That's **7 models**. In general there are $2^p - 1$ non-empty subsets, so with a large number of predictors there are far too many combinations to check them all (20 predictors → over a million models).

### Option 2: scatterplots of y against each predictor

Look at a scatterplot of the response against each predictor individually. If the plot of $x_k$ vs y shows no obvious association, $x_k$ probably won't be helpful for predicting y in a multiple regression either. You could decide to exclude some predictors based on that informal check.

:::tip Caveat (not in the notes)
"Probably" is doing work here. A predictor can look weak on its own and still matter once other predictors are held fixed, and vice versa (service looked strong alone, but not with decor). Treat scatterplots as a first screen, not a verdict.
:::

### Option 3: stepwise selection (backward)

A fairly common approach. With $p$ predictors:

1. **Fit the full model** with all $p$ predictors.
2. **For each predictor**, remove it and fit the model with the other $p - 1$. Check whether removing it **increases** adjusted $R^2$ compared to the full model.
3. **Remove the predictor that gives the largest increase** in adjusted $R^2$ (if any). That's the new model. If no removal is an improvement, stop and use the full model.
4. **Repeat** with the new model: try removing each remaining predictor; if any removal increases adjusted $R^2$, remove the one with the largest increase.
5. **Stop** when removing any predictor only decreases adjusted $R^2$.

In each "step," one predictor is **permanently** removed.

:::tip Not practiced in class
We won't practice implementing stepwise selection; the professor finds the R and Python tools for it not very user-friendly. It's good to know it exists for future data analysis projects. (R's built-in `step()` does this, but it uses AIC rather than adjusted $R^2$.)
:::

### Other selection criteria

Adjusted $R^2$ isn't the only criterion for choosing predictors. Others you'll see are **AIC** and **BIC**.
