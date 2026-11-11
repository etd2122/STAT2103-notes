---
id: L16
date: 2026-11-11
title: Checking assumptions in multiple regression, and collinearity
pdf: notes/2026-11-11-collinearity.pdf
slides: notes/2026-11-11-collinearity-R.pdf
part: Part II
topics: assumptions in MLR, residuals vs fitted, collinearity, perfect correlation, multiple best fits, NA coefficients, singularities, high correlation, unstable estimates, large standard errors, power, multicollinearity, linear combination, pairs, cor matrix, VIF, car vif, removing predictors, polynomial terms
summary: Two parts. First, the MLR assumptions are the same five as before, checked with a scatter plot for each predictor plus a residuals-vs-fitted plot. Second, a new problem that only exists with several predictors, **collinearity**. If one predictor is an exact linear combination of others, least squares has no unique answer and R shows `NA`. If it's only *close*, the model fits but the slopes get huge standard errors and jump around from sample to sample. Pairwise correlations can miss it when 3+ predictors are involved, so check the **VIF** (`car::vif`): above 5 or 10 is a warning sign. The R and Python handouts are worked through at the end, including two places where Python behaves differently from R.
takeaways:
- MLR assumptions are the same as SLR: **linearity**, and errors with mean 0, independent, constant variance, Normal. Normality is only needed for inference (CIs, tests); you never check mean 0.
- Check linearity with y vs **each** $x_k$ (or residuals vs each $x_k$). Also plot **residuals vs fitted values $\hat y$**: you want random scatter around 0. A pattern → try transforming the predictor(s) and/or y.
- **Collinearity:** one predictor is (close to) a linear combination of other predictors, e.g. arm length in cm and in m, or SAT math + reading + total.
- **Exact** collinearity (corr = ±1, or $x_3 = x_1 + x_2$): many different $(\hat\beta_j, \hat\beta_k)$ give the same $\hat y$ and the same minimum RSS, so least squares **can't** pick one. R prints `NA` and "(1 not defined because of singularities)".
- **Near** collinearity (corr ≈ ±1): least squares works, but the estimates have **large variance / standard errors**. They swing a lot between samples, t statistics shrink toward 0, p-values get large, and **power** to detect a real $\beta_k \neq 0$ drops.
- Detect it with `pairs()` and `cor()`, but with **3+ predictors** pairwise correlations can look moderate (≈ 0.7) even when collinearity is exact. Use the **VIF**: `library(car); vif(model)`.
- $\text{VIF}_k = \dfrac{\text{var}(\tilde\beta_k)\text{ in the MLR}}{\text{var}(\hat\beta_k)\text{ in the SLR on } x_k \text{ alone}}$ (idea only; you won't compute it). **VIF ≥ 1 always; > 5 or 10 suggests a problem.**
- Remedy: remove one of the collinear predictors. Near collinearity **doesn't violate** any assumption: the model is still valid, removing a predictor just makes it more useful.
- Collinearity is about **linear** association between predictors. $x$ and $x^2$ are fine (their correlation can be near 0). But don't add polynomial terms without a reason (subject knowledge or a curved diagnostic plot): more terms always fit the **sample** better.
---

:::tip Two slips in the scanned notes
1. **Page 3, models B and C.** With $x_2 = x_1/100$ (meters), the fitted line is $\hat y = \hat\beta_0 + x_1\big(\hat\beta_1 + \tfrac{\hat\beta_2}{100}\big)$, so we need $\hat\beta_1 + \hat\beta_2/100 = 5$ (exactly what the box on page 4 says). That makes model B $\hat y = 37 + 0x_1 + \mathbf{500}\,x_2$ and model C $\hat y = 37 + 2.5x_1 + \mathbf{250}\,x_2$. The notes write 0.05 and 0.025, which would be right if $x_2$ were $100x_1$. Quick check for B: arm = 25 cm = 0.25 m, so $37 + 500(0.25) = 162 = 37 + 5(25)$ ✓. The point of the example is unchanged.
2. **Page 5** says the single-arm line was $\hat y = 14.8 + 5\cdot$arm length, then writes $37 + 5x_L$ right below. Same example, so read it as 37; the intercept doesn't matter for the argument.
:::

## Checking assumptions in multiple regression

Last time was about comparing models and choosing predictors. In multiple regression it's **still important to check** whether the model assumptions look satisfied in the data. They're the same as in simple regression:

:::def MLR assumptions
1. **Linearity** of the true relationship between y and the predictors.

The error terms are:

2. **mean zero** (we don't need to check this one),
3. **independent**,
4. **constant variance**,
5. **Normally distributed**.
:::

Same as before: Normality is **only required for inference** (confidence intervals, hypothesis tests). The least squares estimates of the coefficients are valid without assumptions 3, 4 and 5.

### Plots to make

1. **y vs each predictor $x_k$** (or **residuals vs each $x_k$**). One plot per predictor. A nonlinear pattern in any of them is a violation; consider a **nonlinear transformation of that predictor**. Non-constant variance can also show up here.
2. **Residuals $\hat e_i$ vs fitted values $\hat y_i$.** This one is new for MLR (in SLR, $\hat y$ is just a rescaled x, so it was the same as residuals vs x).
   - **Good:** residuals scattered evenly above and below 0, no obvious pattern.
   - **Bad:** a pattern, which can mean non-linearity and/or non-constant variance. Try transforming the predictors and/or **y**.

:::r Residuals vs fitted
```
model <- lm(y ~ x1 + x2 + x3)
plot(model$fitted.values, model$residuals)
abline(h = 0)
# or: plot(model, which = 1)
```
:::

:::tip Why fitted values? (not in the notes)
With several predictors there's no single x axis. $\hat y$ combines all of them into one number, so a plot against $\hat y$ shows problems with the model as a whole in one picture, the same way residuals vs x did in [L11](#L11).
:::

## A new problem: collinearity

Now that there are several predictors, there's one **new potential problem**.

:::def Collinearity
One of the predictors is equal to a **linear combination** of some of the other predictors. Conceptually, it's an issue when **two or more predictors are closely related** to each other.
:::

If two predictors are highly correlated with each other, it can cause problems. Start with the extreme case: two predictors that are **perfectly** correlated.

## Perfectly correlated predictors: no unique best fit

**Setup.** Model a person's height from forearm length.

- $y$ = height (cm), $x_1$ = forearm length (cm).
- Simple regression gives the best-fitting line $\hat y = 37 + 5x_1$.

Now add a second predictor: the **same** forearm length measured in **meters**, $x_2 = x_1/100$. If you know the arm length in cm, you know it in meters exactly, so $\text{corr}(x_1, x_2) = 1$.

Fit the model with both:

$$\hat y = \hat\beta_0 + \hat\beta_1 x_1 + \hat\beta_2 x_2 = \hat\beta_0 + \hat\beta_1 x_1 + \hat\beta_2 \frac{x_1}{100} = \hat\beta_0 + x_1\Big(\hat\beta_1 + \frac{\hat\beta_2}{100}\Big)$$

**Step by step.**

1. Everything depends only on the combination $\hat\beta_1 + \hat\beta_2/100$. Any choice where that equals 5 gives the original line.
2. So these are all effectively the **same** model (coefficients corrected, see the tip at the top):

| Model | $\hat y$ | $\hat\beta_1 + \hat\beta_2/100$ |
|---|---|---|
| A | $37 + 5x_1 + 0x_2$ | 5 |
| B | $37 + 0x_1 + 500x_2$ | 5 |
| C | $37 + 2.5x_1 + 250x_2$ | 5 |

3. Same $\hat y$ for every arm length → same residuals $y_i - \hat y_i$ → same $\sum (y_i - \hat y_i)^2$.
4. So if A minimizes the RSS, B and C also hit the minimum. And so does **any** pair with $\hat\beta_1 + \hat\beta_2/100 = 5$ (infinitely many).

:::formula Perfect correlation breaks least squares
If $\text{corr}(x_j, x_k) = \pm 1$, there is **more than one** set of "best" coefficients giving the minimum RSS, so **least squares can't choose** $\hat\beta_j, \hat\beta_k$.
:::

:::tip What R does about it
R notices and drops the redundant predictor: its row shows `NA`, with the message `Coefficients: (1 not defined because of singularities)`. See the arm example in the R handout below.
:::

## Highly (but not perfectly) correlated predictors

In practice it's very unlikely that observed predictors have a correlation of **exactly** ±1.

| $\text{corr}(x_j, x_k)$ | Least squares? |
|---|---|
| exactly ±1 | **can't** use it |
| close to ±1 | **can** use it, but may have problems |

**Example.** Measure each person's **left** forearm $x_L$ and **right** forearm $x_R$ and use both to predict height. They're not identical, but $\text{corr}(x_L, x_R) = 0.99$.

$$\hat y = \tilde\beta_0 + \tilde\beta_1 x_L + \tilde\beta_2 x_R$$

(The tildes just mark coefficients from the two-predictor model, to tell them apart from the one-predictor $\hat\beta$'s.)

1. With one arm the best fit was $\hat y = 37 + 5x_L$.
2. Since $x_L \approx x_R$, **any** model with $\tilde\beta_1 + \tilde\beta_2 \approx 5$ makes almost the same predictions: $(5, 0)$, $(2.5, 2.5)$, $(0, 5)$ all give very similar $\sum(y_i - \hat y_i)^2$.
3. Because the correlation isn't exactly ±1, there **is** one unique best pair for the observed data.
4. **But which pair wins depends mostly on randomness in the sample.** The RSS is nearly flat along the whole line $\tilde\beta_1 + \tilde\beta_2 = 5$, so tiny noise decides.

:::example Same population, three samples
- Sample 1: "best" fit $\tilde\beta_1 = 4,\ \tilde\beta_2 = 1$
- Sample 2: $\tilde\beta_1 = 8.1,\ \tilde\beta_2 = -3$
- Sample 3: $\tilde\beta_1 = 2.7,\ \tilde\beta_2 = 2.3$

Each pair still adds up to about 5, so the **predictions** are stable, but the **individual slopes** are all over the place. Small changes in the data → big changes in the estimated coefficients.
:::

### Consequences: big standard errors, low power

When predictors are highly correlated it's hard to untangle what relationship **each individual** predictor has with y. The estimates have more uncertainty, i.e. **greater variability**.

:::formula Large correlation → large standard errors
$$\text{large } \text{corr}(x_j, x_k) \ \Rightarrow\ \text{large variance and SE for } \hat\beta_j,\ \hat\beta_k$$
To test $H_0: \beta_k = 0$: $\quad t = \dfrac{\hat\beta_k}{\text{SE}(\hat\beta_k)}$

Large SE → $t$ close to 0 → large p-value → **not significant**.
:::

So if the true slope is nonzero ($\beta_k \ne 0$, so we **want** to reject), highly correlated predictors make us **less likely to reject** $H_0: \beta_k = 0$.

:::def Power
The probability of **correctly** rejecting the null hypothesis when it's false. Collinearity lowers the power of the t tests for the slopes involved.
:::

**Remedy:** remove one of the correlated predictors.

**Detecting it with two predictors at a time:**
- **Scatter plots of each pair of predictors** (`pairs()` in R),
- **Sample correlation for each pair** (`cor()` in R).

## Multicollinearity: three or more predictors

Collinearity can involve more than 2 predictors; then it's often called **multicollinearity**. The problem arises when one predictor is a linear combination of others, like

$$x_k = 5x_j + 2x_m$$

:::example Predicting GPA from SAT scores
$y$ = GPA, $x_1$ = SAT math, $x_2$ = SAT reading, $x_3$ = SAT total.

Since $x_3 = x_1 + x_2$ exactly, we **can't** fit this model by least squares: the best coefficients aren't unique. Having a redundant variable gives many sets of coefficients with the same minimum RSS, because they make **exactly the same predictions** $\hat y$. (Try it: $\hat\beta_1 x_1 + \hat\beta_2 x_2 + \hat\beta_3 (x_1 + x_2)$ only depends on $\hat\beta_1 + \hat\beta_3$ and $\hat\beta_2 + \hat\beta_3$.)
:::

With more than 2 predictors it's **harder to detect**:

| | Result |
|---|---|
| Exact multicollinearity | can't fit the model |
| Almost exact | can fit the model, but coefficients have **high variance**, and it's harder to spot |

When the relationship involves 3+ predictors, the correlation between **any pair** might not be close to ±1. If $x_3 = x_1 + x_2$, $\text{corr}(x_1, x_3)$ and $\text{corr}(x_2, x_3)$ **won't always** be close to ±1. (In the R handout they're only about 0.7, and the collinearity is exact.)

**So checking pairwise correlations isn't enough.** Check the **variance inflation factor** instead.

## Variance inflation factor (VIF)

If $x_k$ is closely related to several other predictors, we can't estimate $\beta_k$ very precisely: high variance. The useful question:

> How much higher is the variance of the estimate of $\beta_k$ in the multiple regression, compared to a simple regression using only $x_k$?

Two models:

$$\text{SLR: } \hat y = \hat\beta_0 + \hat\beta_k x_k \qquad\qquad \text{MLR: } \hat y = \tilde\beta_0 + \tilde\beta_1 x_1 + \cdots + \tilde\beta_k x_k + \cdots$$

:::formula Variance inflation factor (the idea)
$$\text{VIF}_k = \frac{\text{var}(\tilde\beta_k)}{\text{var}(\hat\beta_k)} \qquad \text{(MLR variance over SLR variance)}$$
- **VIF ≥ 1 always.**
- Much bigger than 1 means multicollinearity involving $x_k$: adding the other predictors made $\beta_k$ harder to pin down.
- No exact cutoff, but **VIF > 5 or 10** suggests a problem.
:::

:::tip What you need for the exam
You're **not** required to know the VIF formula and won't calculate it from scratch. Know what it measures, that it's ≥ 1, the 5–10 rule of thumb, and how to get it in R.
:::

:::tip The usual formula (not in the notes, not required)
Regress $x_k$ on all the **other** predictors and call that $R^2_k$. Then $\text{VIF}_k = \dfrac{1}{1 - R^2_k}$. If the others explain $x_k$ well ($R^2_k \to 1$), the VIF blows up. VIF = 10 means $R^2_k = 0.9$. Also, $\sqrt{\text{VIF}_k}$ is roughly how many times bigger the SE is: VIF = 100 → SE about 10× bigger.
:::

**Remedy:** you can remove predictors from the model. But if collinearity **isn't exact**, the model is **still valid**: one predictor isn't exactly a linear combination of the others, so no assumption is violated, and you can still fit the model and do inference. You may just choose to remove predictors to make the model **more useful**. Which predictors to include is ultimately the analyst's choice.

## Nonlinear relationships between predictors are fine

This whole discussion is specific to **linear** associations between predictors. Two predictors with a strong **nonlinear** association are **not** a problem in this regard.

:::example Tide depth vs time of day
$y$ = tide depth, $x_1$ = time of day, and the model
$$\hat y = \hat\beta_0 + \hat\beta_1 x_1 + \hat\beta_2 x_1^2$$
$x_1$ and $x_1^2$ have a perfect nonlinear relationship, but their **correlation** (which only measures linear association) can be small, depending on the range of $x_1$:
- $x$ spread evenly around 0 (the U is symmetric): corr ≈ 0
- $x$ only positive: corr ≈ 0.5 or higher
- $x$ only negative: corr ≈ −0.5 or lower
:::

So polynomial terms ($x^2, x^3, x^4, \dots$) **don't necessarily** create collinearity problems.

:::tip Centering trick (not in the notes)
If $x$ is all positive (like time 6 to 18), $x$ and $x^2$ can be very highly correlated. Using $(x - \bar x)$ and $(x - \bar x)^2$ makes the U symmetric around 0 and brings the correlation close to 0, without changing the fitted curve.
:::

**But** adding them has the same issue as adding any predictor: a more complicated, flexible model **always** fits the **sample** data better ([L15](#L15): RSS never goes up), whether or not it matches the **true population** relationship better. That can be misleading.

So we typically add polynomial terms only when:
- subject-matter knowledge says there **should** be a polynomial relationship, or
- diagnostic plots show a specific nonlinear pattern.

Not arbitrarily, "just to see what happens."

## R handout: what the output looks like

The R handout (linked above as "Lecture slides") runs every case. The data aren't posted, so the outputs are copied here to read.

### Two perfectly correlated predictors

`arm_cm` and `arm_meters` are the same forearm in two units: `cor(arm_cm, arm_meters)` is `1`, and their scatter plot is an exact straight line.

:::r Fit with both
```
lm(height ~ arm_cm + arm_meters)

Coefficients: (1 not defined because of singularities)
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  42.2634     6.5731    6.43 1.65e-08 ***
arm_cm        4.8465     0.2619   18.51  < 2e-16 ***
arm_meters        NA         NA      NA       NA
```
:::

**Reading it:** R fits the first predictor, finds the second adds nothing new (it's an exact multiple), and sets it to `NA`. The `arm_cm` row is just the simple regression. **"not defined because of singularities" = exact collinearity.**

### Exact multicollinearity: x3 = (x1 + x2)/2

Three predictors, $n = 50$. Look at them first:

[![Pairs plot of x1, x2, x3: x3 rises with both x1 and x2 but with a lot of scatter; x1 and x2 look unrelated](img/notes/collinearity-pairs.png)](img/notes/collinearity-pairs.png)

:::r Pairs and correlations
```
pairs(x)        # x = data frame of the predictors only
cor(x)
#             x1          x2        x3
# x1  1.00000000 -0.06548474 0.6913664
# x2 -0.06548474  1.00000000 0.6756796
# x3  0.69136641  0.67567957 1.0000000
```
:::

$x_3$ is moderately correlated with $x_1$ and $x_2$ (≈ 0.7), but the points aren't close to a line. Nothing here looks alarming. Then fit:

:::r Fit all three
```
lm(y ~ ., data = dat)       # "." = every other column as a predictor

Coefficients: (1 not defined because of singularities)
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  4.02679    0.41126   9.791 6.29e-13 ***
x1          -1.30465    0.09547 -13.666  < 2e-16 ***
x2          -1.03527    0.09741 -10.628 4.32e-14 ***
x3                NA         NA      NA       NA
```
:::

`NA` for $x_3$, because $x_3$ is **exactly** the average of $x_1$ and $x_2$ (simulated data):

[![x3 against (x1+x2)/2: every point falls exactly on a straight line](img/notes/collinearity-exact.png)](img/notes/collinearity-exact.png)

`cor(x3, (x1+x2)/2)` is exactly `1`. **The pairs plot couldn't show this**, because the relationship is among **three** variables at once.

### Approximate multicollinearity

Same $x_1$, $x_2$, $y$, but now $x_3$ is only **close** to the average: `cor(x3, (x1+x2)/2)` = 0.9964.

[![x3 against (x1+x2)/2 in the new data: points hug a straight line with small wiggles](img/notes/collinearity-approx.png)](img/notes/collinearity-approx.png)

:::r Fit all three: it works, but look at the SEs
```
est_model <- lm(y ~ x1 + x2 + x3)

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   4.0438     0.4174   9.689  1.1e-12 ***
x1           -0.9787     0.8479  -1.154    0.254
x2           -0.7142     0.8355  -0.855    0.397
x3           -0.6488     1.6767  -0.387    0.701
```
:::

**Reading it, step by step:**
1. All coefficients are estimated now (no `NA`): least squares works when it's not exact.
2. **None of the slopes is significant** (p = 0.25, 0.40, 0.70). Yet in the exact-data fit, $x_1$ and $x_2$ had p < $10^{-13}$.
3. Why? The SE for $x_1$ went from **0.095 to 0.848**, about 9× bigger. Bigger SE → t near 0 → big p-value. That's the "low power" problem from the notes, in real output.
4. This does **not** mean the predictors are useless. It means the model can't tell **which** of $x_1, x_2, x_3$ deserves the credit.

:::r Check the VIFs
```
library(car)        # install.packages("car") once
vif(est_model)
#       x1        x2        x3
# 77.79328  72.54703 139.62431
```
:::

All far above 10 → serious multicollinearity. (Check against the SE jump: $\sqrt{77.8} \approx 8.8$, and $0.848 / 0.095 \approx 8.9$ ✓.)

:::r Remove x3 and compare
```
new_model <- lm(y ~ x1 + x2)
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept)  4.02679    0.41126   9.791 6.29e-13 ***
# x1          -1.30465    0.09547 -13.666  < 2e-16 ***
# x2          -1.03527    0.09741 -10.628 4.32e-14 ***

sum(est_model$residuals^2)              # 18.88558
sum(new_model$residuals^2)              # 18.94706
summary(est_model)$adj.r.squared        # 0.8482773
summary(new_model)$adj.r.squared        # 0.8510221
vif(new_model)                          # x1 1.004307   x2 1.004307
```
:::

| | with $x_3$ | without $x_3$ |
|---|---|---|
| RSS | 18.886 | 18.947 (tiny increase; removing a predictor can't lower RSS, [L15](#L15)) |
| Adjusted $R^2$ | 0.8483 | **0.8510** (went up) |
| VIFs | 78, 73, 140 | 1.004, 1.004 |
| Significant slopes | none | both |

Dropping $x_3$ lost almost no fit, raised adjusted $R^2$, and made both slopes precise and significant. **That's the remedy working.**

## Python notebook: same data, two differences to know

The class also posted a Python version ([open the notebook](examples/collinearity-python.html)). Same data and conclusions, but statsmodels behaves differently from R in two ways that are easy to misread.

:::tip 1. Python doesn't print NA for exact collinearity
On the exact data, `sm.ols('y ~ x1 + x2 + x3', data=dat).fit().summary()` **returns numbers for all three slopes**, all "significant":

```
            coef   std err        t   P>|t|
Intercept  4.0268    0.411    9.791   0.000
x1        -0.9147    0.080  -11.412   0.000
x2        -0.6453    0.082   -7.899   0.000
x3        -0.7800    0.047  -16.621   0.000
```

It just picks one of the infinitely many solutions. The only warnings: note [2] at the bottom ("The smallest eigenvalue is 2.89e-28 … strong multicollinearity problems or … the design matrix is singular"), `Cond. No. 2.01e+15`, and `Df Model: 2` even though there are 3 predictors. **Read the notes at the bottom of the output.**

Proof it's the same line as R's: substitute $x_3 = (x_1 + x_2)/2$. The $x_1$ slope becomes $-0.9147 + (-0.78)/2 = -1.3047$ and the $x_2$ slope $-0.6453 - 0.39 = -1.0353$, exactly R's numbers.
:::

:::tip 2. Python's VIF numbers don't match R's
statsmodels' `variance_inflation_factor` gives **77.6, 1511.7, 1631.1** for the approximate data; R's `car::vif` gives **77.8, 72.5, 139.6**. The difference: statsmodels' function **doesn't add an intercept** unless you include a constant column, so it measures something slightly different. $x_1$ (mean near 0) barely changes, but $x_2$ and $x_3$ (means around 2–4) blow up. Both say "big problem," and the course uses R, so **quote R's `vif()` values**. (The fix in Python is to add an intercept column first with `statsmodels.api.add_constant(X)`.)
:::
