---
id: L17
date: 2026-11-16
title: Categorical predictors and indicator variables
pdf: notes/2026-11-16-categorical-predictors.pdf
slides: notes/2026-11-16-categorical-predictors-R.pdf
part: Part II
topics: categorical predictors, qualitative variables, binary predictor, indicator variable, dummy variable, coding 0 and 1, k levels k-1 indicators, baseline level, reference level, interpreting indicator coefficients, numbering categories, evenly spaced, factor, levels, changing the baseline, multiple categorical predictors, Python C() Treatment
summary: Until now every predictor was a number. Here the predictor is a **category** (left/right-handed; urban/suburban/rural). A binary predictor becomes one **indicator** (0/1) variable, which effectively gives each group its own average. A predictor with **k** levels needs **k − 1** indicators; the level without one is the **baseline**, the intercept is the baseline's average, and each indicator's coefficient is that group's average **minus the baseline's**. Don't code categories as 1, 2, 3: that forces them into an order and evenly spaced averages. R and Python build the indicators for you; `factor(..., levels = )` picks the baseline. The last pages of the scan start the categorical + quantitative example, which L18 covers in full.
takeaways:
- **Indicator (dummy) variable:** $x_i = 1$ if observation $i$ is in a group, 0 if not. With one binary predictor, $\hat y = \hat\beta_0 + \hat\beta_1 x$ gives two averages: $\hat\beta_0$ for the $x = 0$ group and $\hat\beta_0 + \hat\beta_1$ for the $x = 1$ group.
- $\hat\beta_1$ = **difference in average y** between the $x = 1$ group and the $x = 0$ group. Not a "per unit" slope: there's only one possible step, from 0 to 1.
- Flipping the coding (which group is 1) gives the **same conclusions**; only the signs and the intercept change: $75 + 5x$ becomes $80 - 5x$.
- **k levels → k − 1 indicators.** The level with no indicator is the **baseline (reference) level**. You don't need a k-th indicator: all zeros already means "baseline."
- **Intercept = expected y for the baseline group** (here it's meaningful, because "all indicators = 0" is a real group). **Each indicator's coefficient = expected difference in y between that group and the baseline.**
- Difference between two non-baseline groups = difference of their coefficients (e.g. suburban − urban = $\hat\beta_2 - \hat\beta_1$).
- **Don't number categories** (urban = 1, suburban = 2, rural = 3) and use that as one predictor: it forces the categories into that order and makes adjacent groups differ by the same amount. Even for ordered categories (education level) you may not want equal spacing.
- Changing the baseline changes the coefficients and their meaning, **not the fit**: same $\hat y$ for each group, same $R^2$, same overall F test.
- In R: `lm(y ~ geog)` makes the indicators automatically (baseline = first level alphabetically). `factor(geog, levels = c("urban", ...))` makes the **first listed level** the baseline. Python: `C(geog, Treatment(reference="urban"))`.
- **Several categorical predictors:** each coefficient is the difference vs. its baseline **holding the other predictors constant** ("for students with the same handedness…"). The intercept is the group that's baseline on everything.
---

:::tip What's in the files
- **Handwritten notes** (12 pages): the concepts with made-up round numbers ($\hat y = 75 + 5x$, $\hat y = 77 - 3x_1 + 4x_2$).
- **Lecture slides** = the R handout: the same reading-score example run on real data (n = 100). Its numbers differ from the handwritten ones; both are typed up below.
- **Python notebook** ([open it](examples/categorical-predictors-python.html)): same data and same estimates, in statsmodels.
- Pages 10–12 of the scan begin "categorical + quantitative predictors" (the cat-calories example). That's typed up with the rest of it in [L18](#L18).
:::

## Why categorical predictors?

So far every variable in our regression models has been **quantitative**: numerical values like SAT score, rainfall volume, a food quality rating.

In practice that isn't the only type of data. We may also have **qualitative**, aka **categorical**, variables that we want to use as **predictors**: ethnicity, marital status, level of education, …

(We can also build models to predict a categorical **outcome**, but that's not the focus of this class. Here y stays quantitative.)

How do we put a category into $\hat y = \hat\beta_0 + \hat\beta_1 x$, which needs a number? Start with the simplest case.

## Binary predictor: one indicator variable

A **binary** variable only takes two values (left/right, yes/no). We create an **indicator variable** (aka **dummy variable**) that represents the two values as 0 and 1.

:::def Indicator (dummy) variable
$$x_i = \begin{cases} 1 & \text{if observation } i \text{ is in the group} \\ 0 & \text{if not} \end{cases}$$
:::

**Example.** Model students' scores on an 8th-grade reading comprehension exam using their **dominant hand** as the only predictor.

- $y$ = test score
- $x_i = 1$ if left-handed (LH), $0$ if right-handed (RH)
- Model: $Y_i = \beta_0 + \beta_1 x_i + \varepsilon_i$

### It's like having two models

Plug in the two possible values of $x$:

| Group | $x$ | Model |
|---|---|---|
| left-handed | 1 | $Y_i = \beta_0 + \beta_1 + \varepsilon_i$ |
| right-handed | 0 | $Y_j = \beta_0 + \varepsilon_j$ |

$\beta_0$ is the **same** in both, because it's still one overall model.

### Interpreting the coefficients

:::formula Binary predictor: what each coefficient means
$$E(Y \mid x = 0) = \beta_0 \qquad\qquad E(Y \mid x = 1) = \beta_0 + \beta_1$$
- $\beta_0$: average y for the $x = 0$ group (right-handed).
- $\beta_0 + \beta_1$: average y for the $x = 1$ group (left-handed).
- $\beta_1$: on average, the $x = 1$ group scores $\beta_1$ **more** than the $x = 0$ group (difference in group means).
:::

:::example Fitted model $\hat y = 75 + 5x$
1. Right-handed ($x = 0$): $\hat y = 75$. Expected score 75.
2. Left-handed ($x = 1$): $\hat y = 75 + 5 = 80$. Expected score 80.
3. $\hat\beta_1 = 5$: we expect LH students to score **5 points higher** than RH students, on average.
:::

:::tip Why "slope" doesn't quite fit here (not in the notes)
With a quantitative x, $\hat\beta_1$ is the difference for a 1-unit difference in x. With an indicator, the only possible 1-unit difference **is** switching groups, so $\hat\beta_1$ is simply "group 1 average minus group 0 average." In fact, with one binary predictor, $\hat\beta_0$ and $\hat\beta_0 + \hat\beta_1$ are exactly the two **sample means**, and the t test for $\beta_1$ is the pooled two-sample t test.
:::

### The coding is your choice; the conclusions aren't

If we had coded the indicator the other way ($x_i = 0$ if LH, $1$ if RH), we'd get the **same conclusions**, but the interpretation of the individual coefficients changes. (The notes assert this without proof.)

:::example Same data, flipped coding
Fitted model: $\hat y = 80 - 5x$
- $\hat\beta_0 = 80$: expected LH score (LH is now the 0 group).
- $\hat\beta_1 = -5$: expect RH to score **5 points lower** on average.

Expected scores are still LH = 80 and RH = 75.
:::

### In the R handout (real data)

:::r Binary predictor
```
model1 <- lm(y ~ hand, data = reading)
round(summary(model1)$coefficients, 2)
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept)    77.65       0.56  138.66     0.00
# hand            1.18       1.36    0.87     0.39
```
:::

`hand` is already stored as 0/1, so no special steps are needed.

**Reading it:**
1. Students with `hand = 0` average **77.65** points.
2. Students with `hand = 1` average about **1.18 points higher** ($77.65 + 1.18 = 78.83$).
3. p = 0.39 for $H_0: \beta_1 = 0$ (two-sided): **no evidence** that average scores differ by dominant hand. ($R^2 = 0.008$ in the Python output: hand explains almost none of the variation.)

The handout doesn't say which hand is coded 1. If it follows the handwritten notes (1 = left-handed), $\hat\beta_1$ is LH minus RH.

## More than 2 levels: k − 1 indicators

Now model the reading scores using what type of **geographic area** the student lives in: urban, suburban, or rural. With 3 possible values, a **single** 0/1 indicator can't represent them all.

Use **two** indicators:

$$x_{i1} = \begin{cases} 1 & \text{urban} \\ 0 & \text{not} \end{cases} \qquad x_{i2} = \begin{cases} 1 & \text{suburban} \\ 0 & \text{not} \end{cases}$$

We **don't need a third** indicator for rural: if $x_{i1} = 0$ and $x_{i2} = 0$, the student must be rural, because that's the only remaining option. It's the same reason we didn't need two separate indicators for left- and right-handed.

| Student is | $x_1$ (urban) | $x_2$ (suburban) |
|---|---|---|
| urban | 1 | 0 |
| suburban | 0 | 1 |
| rural | 0 | 0 |

:::formula Number of indicators
$$\#\text{ indicator variables} = \#\text{ categories} - 1 \qquad (k \text{ levels} \to k - 1 \text{ indicators})$$
The level that **doesn't get its own indicator** is the **baseline level** (also called the **reference level**). Here, rural.
:::

:::tip Why not k indicators? (not in the notes)
With an intercept, an indicator for every level would add up to 1 for every student: $x_{urban} + x_{suburban} + x_{rural} = 1$, the same column as the intercept. That's exact collinearity ([L16](#L16)): least squares has no unique answer and R would print `NA` for one of them.
:::

### Interpreting the coefficients

Fitted model (handwritten example): $\hat y_i = 77 - 3x_{i1} + 4x_{i2}$

Work through each group by plugging in its indicators:

1. **Rural** ($x_1 = 0$, $x_2 = 0$): $\hat y = 77$. The **intercept is meaningful** here: it's the expected score for the **baseline** level, rural students.
2. **Urban** ($x_1 = 1$, $x_2 = 0$): $\hat y = 77 - 3 = 74$. The prediction is $\hat\beta_0 + \hat\beta_1$.
   - $\hat\beta_1 = -3$: expect urban students to score **3 points lower than rural**, on average.
3. **Suburban** ($x_1 = 0$, $x_2 = 1$): $\hat y = 77 + 4 = 81$. The prediction is $\hat\beta_0 + \hat\beta_2$.
   - $\hat\beta_2 = 4$: expect suburban students to score **4 points more than rural**, on average.

:::formula Coefficients of a k-level categorical predictor
- $\hat\beta_0$ = expected y for the **baseline** group.
- $\hat\beta_j$ = expected **difference** in y for group j **compared to the baseline**: $E(Y \mid \text{group } j) - E(Y \mid \text{baseline})$.
- Group j's expected y = $\hat\beta_0 + \hat\beta_j$.
:::

:::tip Comparing two non-baseline groups (not in the notes)
Suburban vs. urban isn't a single coefficient. Subtract: $(\hat\beta_0 + \hat\beta_2) - (\hat\beta_0 + \hat\beta_1) = \hat\beta_2 - \hat\beta_1 = 4 - (-3) = 7$ points. To get its SE and p-value directly, refit with urban as the baseline (below).
:::

## Why not just number the categories?

Instead of multiple indicators, what if we assigned numbers?

$$x_i = \begin{cases} 1 & \text{urban} \\ 2 & \text{suburban} \\ 3 & \text{rural} \end{cases}$$

In many examples this doesn't make sense. **It forces the categories into a specific order, and the expected y values for each category to be evenly spaced.**

:::example Fitted model $\hat y = 73 + 2.4x$
$\hat\beta_1 = 2.4$ means "when region differs by 1, score differs by 2.4 on average." Plug in:

| Region | x | $\hat y$ |
|---|---|---|
| urban | 1 | 73 + 2.4 = 75.4 |
| suburban | 2 | 73 + 2.4(2) = 77.8 |
| rural | 3 | 73 + 2.4(3) = 80.2 |

Each step is exactly +2.4. Compare with the indicator model:

| | indicator model | numbered model |
|---|---|---|
| urban − rural | −3 | −4.8 |
| suburban − rural | +4 | **−2.4** |
:::

In the original model, suburban students had the **highest** estimated average. But because we put "suburban" in the **middle** of the ordering, the numbered model **can't** capture that: it predicts suburban lower than rural. The model forces the group averages into the order we gave, whether or not that makes sense.

**Don't model it this way.** There's no logical ordering of {urban, suburban, rural}.

### Even ordered categories have the spacing problem

Even if there **were** a natural ordering, we might not want to force the average difference in y to be the same for all adjacent categories.

:::example Income and education level
$y$ = income, predictor = education level. Coding it as high school = 1, some college = 2, bachelor's degree = 3, higher = 4 assumes the **same average change in income** for each step. Maybe the income difference between "high school" and "some college" is not the same as between "some college" and "bachelor's." Indicators let each level have its own average.
:::

## In R: factors and the baseline

### R builds the indicators for you

`geog` is stored as the literal words:

:::r Check the variable type
```
str(reading$geog)   # "structure" of the variable, i.e. type
#  chr [1:100] "urban" "rural" "rural" "suburban" "suburban" "suburban"
```
:::

:::r Fit with the 3-level predictor as-is
```
model2 <- lm(y ~ geog, data = reading)
round(summary(model2)$coefficients, 2)
#              Estimate Std. Error t value Pr(>|t|)
# (Intercept)     77.42       0.65  118.50        0
# geogsuburban     4.56       0.90    5.05        0
# geogurban       -3.91       0.94   -4.16        0
```
:::

**Reading it, step by step:**
1. There's an indicator row for **suburban** (`geogsuburban`, 4.56) and one for **urban** (`geogurban`, −3.91). **No row for rural**, so rural is the baseline.
2. Rural students average **77.42**.
3. Suburban students average **4.56 points higher** than rural (≈ 81.98); urban students average **3.91 points lower** than rural (≈ 73.51).
4. Both p-values are tiny (the unrounded ones are $2.1 \times 10^{-6}$ and $6.8 \times 10^{-5}$): strong evidence that suburban and urban averages each differ from rural. The "0" in the rounded table means "less than 0.005," not exactly 0.

:::tip How R picks the baseline (not in the notes)
R names each indicator **variable name + level** (`geog` + `suburban`). The baseline is the **first level alphabetically**: rural < suburban < urban, so rural. Python labels the same rows `geog[T.suburban]` and `geog[T.urban]` ("T" for treatment coding) and picks the same baseline.
:::

### Saying explicitly that it's categorical: factor()

Instead of relying on R to interpret the variable correctly, you can specify that it's categorical:

:::r factor()
```
model2_alt <- lm(y ~ factor(geog), data = reading)
```
:::

This says specifically "the geographic region variable is categorical." It matters most when a category is **stored as numbers** (e.g. region codes 1, 2, 3): without `factor()`, R would treat it as quantitative and fit the numbered model from the section above.

### Changing the baseline

What if we wanted **urban** to be the baseline? Make a factor and reorder its levels. **The first level in the list is the baseline.**

:::r Reorder the levels
```
geog_factor <- as.factor(reading$geog)
levels(geog_factor)
# [1] "rural"    "suburban" "urban"     # rural first → baseline

geog_factor <- factor(reading$geog, levels = c("urban", "suburban", "rural"))
# urban is now first → urban is the baseline

model3 <- lm(reading$y ~ geog_factor)
round(summary(model3)$coefficients, 2)
#                     Estimate Std. Error t value Pr(>|t|)
# (Intercept)            73.51       0.67  109.06        0
# geog_factorsuburban     8.47       0.92    9.21        0
# geog_factorrural        3.91       0.94    4.16        0
```
:::

There's no coefficient for "urban" now, because it's the baseline.

**Check that it's the same fit:**

| Group | baseline = rural | baseline = urban |
|---|---|---|
| rural | 77.42 | 73.51 + 3.91 = **77.42** |
| suburban | 77.42 + 4.56 = 81.98 | 73.51 + 8.47 = **81.98** |
| urban | 77.42 − 3.91 = 73.51 | **73.51** |

Same three group averages. The new coefficients are just differences from a different reference point: urban → rural flips sign (−3.91 becomes +3.91), and suburban vs. urban is $4.56 - (-3.91) = 8.47$. In the Python output both versions have $R^2 = 0.468$ and the same F statistic (42.74). **Changing the baseline changes what the coefficients mean, not the model's fit.**

:::tip Shortcut: relevel() (not in the notes)
`lm(y ~ relevel(factor(geog), ref = "urban"), data = reading)` does the same thing in one line. Python: `sm.ols('y ~ C(geog, Treatment(reference="urban"))', data=reading)`.
:::

:::tip Testing whether region matters at all (not in the notes)
Each t test compares **one** group to the baseline. To ask "do the three regions have different average scores at all?", test **both** indicators at once, $H_0: \beta_1 = \beta_2 = 0$. With region as the only predictor, that's the overall F test in `summary()` (Python shows F = 42.74, p = $4.9 \times 10^{-14}$). With other predictors in the model, use a partial F test ([L14](#L14)): `anova(lm(y ~ hand), lm(y ~ geog + hand))`. Dropping a categorical predictor means dropping **all** its indicators together.
:::

## Multiple categorical predictors

We can also build models with **multiple categorical predictors**. Model the 8th-grade test scores using geography type **and** dominant hand.

- $y$ = test score
- $x_1 = 1$ if urban, 0 if not
- $x_2 = 1$ if suburban, 0 if not
- $x_3 = 1$ if left-handed, 0 if not

Fitted model (handwritten example): $\hat y = 76 - 4\,\text{urban} + 4.5\,\text{suburban} + 4.7\,\text{left-handed}$

| Coefficient | Interpretation |
|---|---|
| $\hat\beta_0 = 76$ | expected score for **right-handed rural** students (baseline on both) |
| $\hat\beta_1 = -4$ | for students with the **same handedness**, on average urban students score 4 pts **lower** than rural |
| $\hat\beta_2 = 4.5$ | for students with the same handedness, on average suburban students score 4.5 pts **higher** than rural |
| $\hat\beta_3 = 4.7$ | for students from the **same type of region**, on average left-handed students score 4.7 pts **higher** than RH |

Same rule as multiple regression with quantitative predictors: each coefficient is a difference **with the other predictors held constant**.

:::example Predict for a left-handed suburban student
$\hat y = 76 - 4(0) + 4.5(1) + 4.7(1) = 85.2$
:::

:::tip What this model assumes (not in the notes)
The handedness gap is the **same 4.7 points in every region**, and the region gaps are the same for LH and RH students. Letting one predictor's effect depend on another is exactly what **interactions** add, next lecture ([L18](#L18)).
:::

### In the R handout (real data)

:::r Two categorical predictors
```
model4 <- lm(y ~ geog + hand, data = reading)
#              Estimate Std. Error t value Pr(>|t|)
# (Intercept)     77.10       0.67  114.91     0.00
# geogsuburban     4.64       0.90    5.18     0.00
# geogurban       -3.93       0.93   -4.23     0.00
# hand             1.75       0.99    1.76     0.08
```
:::

**Reading it:**
1. Intercept 77.10: expected score for a **rural** student with `hand = 0`.
2. Among students with the same handedness, suburban students average 4.64 points higher than rural, and urban students 3.93 points lower.
3. Among students from the same type of region, `hand = 1` students average 1.75 points higher.
4. For `hand`, p = 0.08: not significant at α = 0.05 (two-sided), though closer than before (p = 0.39 alone).

:::tip Why did hand's SE shrink? (not in the notes)
Alone, `hand` had SE 1.36; with `geog` added it's 0.99. Region explains a lot of the score variation ($R^2$ goes from 0.008 to 0.485), so the leftover noise $\hat\sigma$ is smaller, and every SE shrinks with it. Adding a strong predictor can make another predictor's estimate **more precise** (the opposite of the collinearity story in [L16](#L16), where the added predictor overlapped with the existing ones).
:::

## Python version: what's different

The [Python notebook](examples/categorical-predictors-python.html) uses statsmodels' formula interface and gets the **same estimates**.

| Task | R | Python (statsmodels) |
|---|---|---|
| fit | `lm(y ~ geog, data = reading)` | `sm.ols('y ~ geog', data=reading).fit()` |
| check type | `str(reading$geog)` → `chr` | `reading['geog'].dtype` → `dtype('O')` (O for "object," not zero) |
| indicator names | `geogsuburban` | `geog[T.suburban]` |
| change baseline | `factor(geog, levels = c("urban", ...))` | `C(geog, Treatment(reference="urban"))` |

Both create the indicators automatically, so you never build them by hand.
