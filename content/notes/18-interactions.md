---
id: L18
date: 2026-11-18
title: Categorical + quantitative predictors, and interactions
pdf: notes/2026-11-18-interactions.pdf
slides: notes/2026-11-18-interactions-R.pdf
part: Part II
topics: categorical and quantitative predictors, parallel lines, different intercepts, interaction, interaction term, product term, x1 times x2, main effects, interaction effect, different slopes, separate models per group, shared variance, constant variance, testing beta3 = 0, residuals by group, weight*neutered, colon notation, quantitative interactions, synergy, categorical interactions
summary: Put a 0/1 indicator next to a quantitative predictor and you get **two parallel lines**: the indicator shifts the intercept, but both groups share one slope. That's an assumption, not a fact. Adding the **interaction term** $x_1 x_2$ lets the slope differ too: for $x_2 = 0$ the line is $\beta_0 + \beta_1 x_1$, for $x_2 = 1$ it's $(\beta_0 + \beta_2) + (\beta_1 + \beta_3)x_1$, so $\beta_3$ is the **difference in slopes**. Testing $H_0: \beta_3 = 0$ asks whether the relationship differs between groups. The interaction model gives the same lines as fitting each group separately, but assumes **one shared error variance**, which gives better inference when that's true. Interactions also work between two quantitative predictors (factory example) and two categorical ones (vaccine × smoking).
takeaways:
- **Indicator + quantitative, no interaction:** $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2$. Two **parallel** lines: intercepts $\beta_0$ and $\beta_0 + \beta_2$, one shared slope $\beta_1$. $\beta_2$ = average difference in y between groups **at the same $x_1$**.
- Parallel lines are **forced by how the model is written**. If the relationship between $x_1$ and y differs by group, the predictors **interact**.
- **Interaction model:** $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_1 x_2 + \varepsilon$. The $x_1 x_2$ term literally multiplies the two predictors.
- With binary $x_2$: group 0 line $\beta_0 + \beta_1 x_1$; group 1 line $(\beta_0 + \beta_2) + (\beta_1 + \beta_3) x_1$. So $\beta_2$ = **difference in intercepts**, $\beta_3$ = **difference in slopes**.
- $\beta_3$ is the **interaction effect**; $\beta_1$ and $\beta_2$ are the **main effects**. In the interaction model, $\beta_1$ is the slope **for the $x_2 = 0$ group only**, not "the" slope.
- $H_0: \beta_3 = 0$ tests whether the slopes differ. Rejecting it means the relationship between $x_1$ and y **depends on** $x_2$. ($H_0: \beta_2 = 0$ tests the intercepts; less common.)
- **Same estimates as fitting a separate model to each group**, but **different inference**: the interaction model assumes **one** error variance $\sigma^2$ for both groups; separate models let each group have its own ($\sigma_0^2, \sigma_1^2$). If the variances look equal, prefer the interaction model (uses all the data to estimate $\sigma^2$).
- **General rule:** in $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_1 x_2$, the slope for $x_1$ is $\beta_1 + \beta_3 x_2$, and the slope for $x_2$ is $\beta_2 + \beta_3 x_1$. Works for quantitative × quantitative and categorical × categorical too.
- Residual plot colored by group: a pattern going **opposite ways** for the two groups is the sign of a missing interaction.
- R: `lm(cals ~ weight*neutered)` = `lm(cals ~ weight + neutered + weight:neutered)`. The `weight:neutered` row is the interaction.
---

:::tip What's in the files
- **Handwritten notes** (13 pages): the concepts, using rounded numbers (e.g. $\hat y = 58 + 24.5\,\text{wt} - 4\,\text{neut} - 3.5\,\text{wt}\cdot\text{neut}$).
- **Lecture slides** = the R handout: the cat example on the real data (n = 14), with the residual plots shown below.
- **Python notebook** ([open it](examples/interactions-python.html)): the same models in statsmodels, same estimates.
- The first three pages repeat the end of the Nov 16 scan ([L17](#L17)), where this example started.
:::

## Categorical and quantitative predictors together

What if we include a categorical predictor in a model that also has a **quantitative** predictor?

$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \varepsilon$$

- $x_1$ = continuous, numerical
- $x_2$ = binary, categorical (0 or 1)

Including the binary variable **again** gives us something like having two models, one for each level:

| $x_2 = 0$ | $x_2 = 1$ |
|---|---|
| $y = \beta_0 + \beta_1 x_1 + \varepsilon$ | $y = \beta_0 + \beta_1 x_1 + \beta_2 \cdot 1 + \varepsilon$ |

$\beta_0$ and $\beta_1$ are the same in both.

:::formula What the coefficients mean (no interaction)
- $E(Y \mid x_1 = 0, x_2 = 0) = \beta_0$: intercept is expected y when $x_1 = 0$ and $x_2 = 0$.
- $E(Y \mid x_1 = 0, x_2 = 1) = \beta_0 + \beta_2$: expected y when $x_1 = 0$ and $x_2 = 1$.
- $\beta_1$: expected difference in y for the **same $x_2$** but a 1-unit difference in $x_1$.
- $\beta_2$: expected difference in y between the two groups for the **same $x_1$**.
:::

### Example: cats' daily calories

Model a cat's daily calorie intake needs using bodyweight and whether the cat has been neutered.

- $y$ = daily calories
- $x_1$ = weight (lbs)
- $x_2 = 1$ if neutered, 0 if not

Fitted model (handwritten example): $\hat y_i = 75 + 22x_{i1} - 35x_{i2}$

1. **The intercept is not meaningful here**: no cat weighs 0 lbs.
   - $\hat\beta_0 = 75$: average calories for a **non-neutered** cat with weight 0.
   - $\hat\beta_0 + \hat\beta_2 = 75 - 35 = 40$: average calories for a **neutered** cat with weight 0.
2. $\hat\beta_1 = 22$: on average, cats with the **same neuter status** but a 1-lb difference in weight have daily calorie needs that differ by 22.
3. $\hat\beta_2 = -35$: on average, among cats with the **same weight**, neutered cats need 35 fewer calories per day.

Just like multiple regression with all quantitative predictors: each slope is the average difference in y associated with a one-unit difference in that predictor, **with all other predictors held constant**.

## The hidden assumption: parallel lines

In this example the model says that, on average, the difference in calorie needs associated with a 1-lb weight difference equals 22 ($\hat\beta_1$) for neutered cats **and** for non-neutered cats: both groups.

$$y = \beta_0 + \beta_1\,\text{weight} + \beta_2\,\text{neuter}$$

The calorie difference for a 1-lb weight difference is the **same for both groups**. In other words, the relationship between weight ($x$) and calories ($y$) is the same in both groups. If we plotted the fitted model it would look like **two lines with the same slope** ($\beta_1$):

- Intercept for non-neutered ($x_2 = 0$): $\hat\beta_0$ (75)
- Intercept for neutered ($x_2 = 1$): $\hat\beta_0 + \hat\beta_2$ (75 − 35); in this example $\hat\beta_2$ is negative, so the neutered line sits lower.
- Slope for both: $\hat\beta_1$.

Because of the way we wrote the model, the two estimated lines are **forced to be parallel**: there's one slope, $\hat\beta_1$, for bodyweight. Parallel lines, by construction.

**But that doesn't HAVE to be true for the actual data. It's an assumption** we made when writing the model that way. It's possible that the true relationship between bodyweight and calorie intake **is** different in the two groups.

:::def Interaction
If the relationship between one predictor ($x_1$) and the response ($y$) **differs depending on the value of another predictor** ($x_2$; neuter status in this example), we say the predictors **interact**.
:::

## The interaction model

We can fit a model that captures the interaction:

:::formula Interaction model
$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_1 x_2 + \varepsilon$$
($x_1$ = weight, $x_2$ = neuter.) The $x_1 x_2$ term literally **multiplies** the bodyweight value $x_1$ by $x_2$, the indicator for neuter status.
:::

What does writing the model this way achieve? Plug in each value of $x_2$:

**If $x_{i2} = 0$:** the $\beta_2$ and $\beta_3$ terms are multiplied by 0 and drop out.
$$y_i = \beta_0 + \beta_1 x_{i1} + \varepsilon$$

**If $x_{i2} = 1$:**
$$y_i = \beta_0 + \beta_1 x_{i1} + \beta_2 \cdot 1 + \beta_3 x_{i1} \cdot 1 + \varepsilon = \underbrace{(\beta_0 + \beta_2)}_{\text{intercept}} + \underbrace{(\beta_1 + \beta_3)}_{\text{slope}}\,x_{i1} + \varepsilon$$

So effectively:
- For **non-neutered** cats ($x_{i2} = 0$): a line with intercept $\beta_0$ and slope $\beta_1$.
- For **neutered** cats ($x_{i2} = 1$): a line with intercept $\beta_0 + \beta_2$ and slope $\beta_1 + \beta_3$.

Now the lines **don't have to be parallel**.

:::formula Interaction with a binary $x_2$: two lines
| | intercept | slope |
|---|---|---|
| $x_2 = 0$ | $\beta_0$ | $\beta_1$ |
| $x_2 = 1$ | $\beta_0 + \beta_2$ | $\beta_1 + \beta_3$ |
| difference (1 − 0) | $\beta_2$ | $\beta_3$ |
:::

### Interpreting each term

Fitted model (handwritten, rounded): $\hat y_i = 58 + 24.5x_{i1} - 4x_{i2} - 3.5x_{i1}x_{i2}$, i.e. $58 + 24.5\,\text{wt} - 4\,\text{neut} - 3.5\,\text{wt}\cdot\text{neut}$.

1. **$\hat\beta_0 = 58$:** average calories for non-neutered cats with weight 0.
2. **$\hat\beta_2 = -4$: difference in intercepts.** $58 - 4 = 54$ = average calories for neutered cats with weight 0. On average, among cats with weight 0, neutered cats need 4 fewer calories. Same interpretation as before: $\hat\beta_0$ is the intercept for the indicator = 0 category, $\hat\beta_0 + \hat\beta_2$ is the intercept for the $x_{i2} = 1$ group, and the difference between them is $\hat\beta_2$.
3. **$\hat\beta_1 = 24.5$: slope for the $x_2 = 0$ (non-neutered) group.** Among non-neutered cats, a 1-lb difference in bodyweight is associated with a 24.5 difference in calories, on average.
4. **$\hat\beta_1 + \hat\beta_3 = 24.5 - 3.5 = 21$: slope for the $x_2 = 1$ (neutered) group.** Among neutered cats, a 1-lb difference in weight is associated with a 21-calorie difference, on average.
5. **$\hat\beta_3 = -3.5$: difference in slopes for the 2 groups.** $\hat\beta_3 < 0$ means a 1-lb difference in weight is associated with a **smaller** average difference in calories for neutered cats than for non-neutered. If $\hat\beta_3$ had been positive, a 1-lb difference would go with a **larger** average difference for neutered cats.

:::def Main effects and interaction effect
- $\beta_3$, the coefficient for the **product** of the two predictors, is called the **interaction effect**.
- $\beta_1$ and $\beta_2$, the coefficients for each predictor on its own, are the **main effects**.
:::

:::tip Trap: β₁ is no longer "the" weight slope (not in the notes)
In the no-interaction model, $\hat\beta_1$ was the weight slope for **every** cat. In the interaction model it's the slope **only when $x_2 = 0$** (non-neutered). Likewise $\hat\beta_2$ is the neutered-vs-not gap **only at weight 0**, which here is pure extrapolation. At a typical weight of 8 lbs the gap is $\hat\beta_2 + \hat\beta_3(8) = -3.86 - 3.61(8) \approx -32.7$ calories (real-data numbers below). So "$\beta_2$ isn't significant" does **not** mean neutering doesn't matter.
:::

:::tip Keep the main effects in (not in the notes)
Standard practice: if $x_1 x_2$ is in the model, keep $x_1$ and $x_2$ too, even if their own p-values are large. Dropping $\beta_2$ would force both lines through the same intercept at weight 0, an odd constraint with no reason behind it. `weight*neutered` in R includes all three automatically.
:::

## Is this the same as fitting two separate models?

2 slopes, 2 intercepts, 2 groups… is this the same as fitting 2 separate models?

If we include an interaction term, we get a separate slope and intercept for each group. Compare to fitting a separate linear model to the subset of data belonging to each group:

- For non-neutered, fit $\hat y = \tilde\beta_0 + \tilde\beta_1 \,\text{weight}$
- For neutered, fit $\hat y = \tilde\beta_0 + \tilde\beta_1\,\text{weight}$ (on the other subset)

**The estimated coefficients (slope and intercept) will be the same** whether we fit separate models for each group or one overall model with an interaction term.

:::example Separate fits give the same lines
Fitting only the non-neutered cats' data: $\hat y = 58 + 24.5\,\text{weight}$.
Fitting only the neutered cats' data: $\hat y = 54 + 21\,\text{weight}$.
Same as the interaction model: $58 - 4 = 54$ and $24.5 - 3.5 = 21$.
:::

### What is NOT the same: inference

**Inference** is different for the interaction model vs. separate models. You aren't responsible for knowing **why** it's different, but the explanation involves the error terms.

:::formula Interaction model vs. separate models
| | errors | variance |
|---|---|---|
| **Interaction model** $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_1 x_2 + \varepsilon$ | $\varepsilon_i \sim N(0, \sigma^2)$ for **all** observations, from both groups | **one shared** variance $\sigma^2$ |
| **Separate models** | within each group's model, constant variance | **each group has its own**: $\sigma_0^2$, $\sigma_1^2$ |
:::

When we perform inference for linear regression, our confidence intervals and hypothesis tests rely on our estimate of $\sigma^2$ (how spread out the observed y values are around the true regression line), and we estimate it from the data (sample variance of the residuals). For example:

$$\hat\beta_1 \pm t^* \sqrt{\frac{\hat\sigma^2}{(n-1)S_x^2}} \qquad (t^* = \text{percentile of the } t \text{ distribution})$$

So inference depends on (the estimate of) $\sigma^2$.

- If the variance does **not** appear to be the same for both groups, that's a violation of the **constant variance** assumption, and the interaction model (which assumes constant variance) does **not** give valid inference.
- If the variances **are** equal, we prefer the interaction model, because it uses **all** the data to estimate $\sigma^2$ more precisely.

:::tip Rule of thumb
If $\sigma^2$ is the same for both groups → the interaction model is the better choice. If one group is clearly more spread out → separate models (or at least don't trust the interaction model's SEs).
:::

### Testing whether the groups differ

The interaction model also gives us an easy way to check whether the slopes and intercepts are **statistically significantly** different across the two groups.

:::formula Tests in the interaction model
$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_1 x_2 + \varepsilon$
- $H_0: \beta_3 = 0$ tests whether the **slopes** are different. $\beta_3$ is the difference in slopes. Rejecting means concluding the relationship between bodyweight and calorie intake **is** different depending on neuter status.
- $H_0: \beta_2 = 0$ tests whether the **intercepts** are different. Technically possible, but less common.
:::

If we fit a separate model to each group, we can observe that the estimated slopes are different, but it isn't clear whether the difference is **significant**. The interaction model answers that with one t test.

## In R: the cat data

The handout uses `food` with `cals` (required daily calorie intake), `weight` (bodyweight in lbs), and `neutered` (1 if neutered, 0 if not). 14 cats.

### Separate models for each group

:::r One model per group
```
model0 <- lm(cals ~ weight, data = food, subset = neutered == 0)   # NOT neutered
model1 <- lm(cals ~ weight, data = food, subset = neutered == 1)   # neutered

round(summary(model0)$coefficients, 2)
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept)    58.00       1.28   45.18        0
# weight         24.46       0.16  157.15        0

round(summary(model1)$coefficients, 2)
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept)    54.14       1.29   41.96        0
# weight         20.86       0.16  133.28        0
```
:::

`subset = neutered == 0` fits the model using only the rows where that condition is true. The estimated intercepts and slopes are different for each group.

### Single model, no interaction

:::r Parallel-lines model
```
model2 <- lm(cals ~ weight + neutered, data = food)
round(summary(model2)$coefficients, 2)
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept)    72.43       4.70   15.41        0
# weight         22.66       0.55   40.91        0
# neutered      -32.71       2.22  -14.77        0
```
:::

This model **forces** both groups to have the same slope. The separate models had slopes of about 24.5 and 21, versus 22.7 here: somewhere in between. Is that a meaningful difference?

[![Daily calories vs bodyweight: the not-neutered points (black) rise more steeply than the neutered points (red); both groups lie almost exactly on straight lines](img/notes/interactions-data.png)](img/notes/interactions-data.png)

Check the residuals from the no-interaction model, colored by group:

[![Residuals from the parallel-lines model vs bodyweight: not-neutered residuals rise from about −6 to +6 as weight increases, neutered residuals fall from about +6 to −5](img/notes/interactions-resid-additive.png)](img/notes/interactions-resid-additive.png)

**Reading it:**
1. Uncolored, the residuals already don't look randomly scattered.
2. Colored: the **not-neutered** residuals go from negative to positive as weight increases → the shared slope 22.66 is **too shallow** for them (their real slope is ~24.5).
3. The **neutered** residuals go from positive to negative → the shared slope is **too steep** for them (~21).
4. The model makes **systematic mistakes for both groups**: it isn't accurately describing the bodyweight–calorie relationship for either one. Two trends going **opposite ways** is the signature of a missing interaction.

### Interaction model

There are multiple ways to specify it. Interaction terms are written with a colon `:`.

:::r Interaction model
```
model3 <- lm(cals ~ weight + neutered + weight:neutered, data = food)
# or, more compactly:
model3 <- lm(cals ~ weight*neutered, data = food)
# "include weight and neutered as predictors, and also their interaction"

round(summary(model3)$coefficients, 2)
#                 Estimate Std. Error t value Pr(>|t|)
# (Intercept)        58.00       1.29   45.06     0.00
# weight             24.46       0.16  156.74     0.00
# neutered           -3.86       1.82   -2.12     0.06
# weight:neutered    -3.61       0.22  -16.34     0.00
```
:::

**Reading it, step by step:**
1. The interaction term is the **last line**, `weight:neutered`: $\hat\beta_3 = -3.61$.
2. $H_0: \beta_3 = 0$, t = −16.34, p ≈ 0 (two-sided). **Small p-value → the interaction is significant.** Conclude the slopes are different for the two groups: there is evidence that the relationship between bodyweight and calorie needs is different between neutered and un-neutered cats.
3. Rebuild the two lines:
   - Non-neutered: $58.00 + 24.46\,\text{weight}$, **exactly** `model0`.
   - Neutered: $(58.00 - 3.86) + (24.46 - 3.61)\,\text{weight} = 54.14 + 20.86\,\text{weight}$ (unrounded: $24.4643 - 3.6071 = 20.8572$), **exactly** `model1`.
4. Compare the SEs: intercept 1.29 here vs. 1.28 and 1.29 in the separate fits. Same estimates, slightly different SEs, because the interaction model pools both groups to estimate one $\sigma^2$. Here the two groups' spreads are similar, so the numbers barely move.
5. `neutered` (−3.86, p = 0.06) is the gap **at weight 0**. Not interesting by itself (see the trap above).

[![Residuals from the interaction model vs bodyweight, colored by group: points scattered between −1.2 and +1 with no trend for either group](img/notes/interactions-resid-interaction.png)](img/notes/interactions-resid-interaction.png)

There's no longer an obvious pattern in the residuals, and still none when they're colored by group. Good. (Notice the scale too: residuals within about ±1 calorie, versus ±6 before.)

:::tip Python: same model, two small differences
In the [Python notebook](examples/interactions-python.html), `sm.ols('cals ~ weight*neutered', data=food).fit()` gives the same coefficients (58.00, 24.46, −3.86, −3.61). Subsets are written `subset=food['neutered']==0`. The summary also prints a warning, "kurtosistest only valid for n>=20 … n=14": that's only about the normality checks at the bottom of the table (Omnibus, Skew, Kurtosis), not the coefficients. It also shows $R^2 = 1.000$ (rounded): with the interaction, the model explains essentially all the variation in this data.
:::

## Interactions between two quantitative predictors

The idea remains the same: the relationship between one predictor ($x_1$) and the response ($y$) is different **depending on the value of** another predictor ($x_2$). Now both are quantitative.

Rearrange the model to see the slope for $x_1$:

$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_1 x_2 + \varepsilon = \beta_0 + (\beta_1 + \beta_3 x_2)\,x_1 + \beta_2 x_2 + \varepsilon$$

:::formula Slope with an interaction
Effectively, the slope for $x_1$ is $\beta_1 + \beta_3 x_2$.
- When $x_2$ is binary there are 2 options: slope $= \beta_1$ or slope $= \beta_1 + \beta_3$.
- When $x_2$ can take any value (not just 0 or 1), then more generally, the **average difference in y associated with a one-unit difference in $x_1$ equals $\beta_1 + \beta_3 x_2$**.

By symmetry, the slope for $x_2$ is $\beta_2 + \beta_3 x_1$.
:::

:::example Factory output
Predict a factory's output from its number of production lines and number of employees.
- $y$ = units produced at the factory
- $x_1$ = # production lines
- $x_2$ = # employees

Fitted model: $\hat y = 1.2 + 3.4x_1 + 0.22x_2 + 1.4x_1 x_2 = 1.2 + (3.4 + 1.4x_2)\,x_1 + 0.22x_2$

**Production lines:** for factories with the same number of workers, and a number of production lines that differs by 1, we expect an average difference in units produced equal to $3.4 + 1.4 \times$ (number of workers). The productivity difference associated with one more line **depends on** the number of workers.

**Workers:** among factories with the same number of production lines, on average we expect factories with one more worker to produce $0.22 + 1.4 \times$ (number of lines) more units.

**Why it makes sense:** in general, we might expect that having more production lines would not be associated with a large difference in productivity unless there are **also** more employees to operate the extra lines.

In some contexts, an interaction between variables is referred to as **"synergy."**
:::

:::example Plug in numbers (not in the notes)
- A factory with 10 workers: one more production line ↔ $3.4 + 1.4(10) = 17.4$ more units on average.
- A factory with 2 workers: one more line ↔ $3.4 + 1.4(2) = 6.2$ more units.
Same model, very different "effect" of a line. That's why with an interaction you can't quote one number for "the effect of $x_1$": you have to say at which $x_2$.
:::

## Interactions between categorical variables

Suppose we're studying length of stay (# days) for hospitalized COVID patients, with 2 categorical predictors: whether the patient was vaccinated, and whether they smoke cigarettes.

- $y$ = # days in hospital
- $x_1 = 1$ if vaccinated, 0 if not
- $x_2 = 1$ if smoker, 0 if not

Fitted model:
$$\hat y = 4 - 2x_1 + 2x_2 + 1x_1 x_2 = 4 + (-2 + 1x_2)\,x_1 + 2x_2$$

**Non-smokers** ($x_2 = 0$): $\hat y = 4 - 2x_1$.
- Not vaccinated: 4 days. Vaccinated: 2 days. Difference = 2.
- Among non-smokers, on average, vaccinated patients had **2 fewer days** in the hospital.

**Smokers** ($x_2 = 1$): $\hat y = 4 + (-2 + 1)x_1 + 2 = 6 - x_1$.
- Not vaccinated: 6 days. Vaccinated: 5 days. Difference = 1.
- Among smokers, on average, vaccinated patients had **one less day** in the hospital.

| | not vaccinated | vaccinated | vax − not vax |
|---|---|---|---|
| non-smoker | 4 | 2 | −2 |
| smoker | 6 | 5 | −1 |

The difference in length of stay for vaccinated vs. unvaccinated patients was **smaller for smokers** than for nonsmokers. That's what $\hat\beta_3 = +1$ says: it shrinks the vaccine's −2 to −1 when $x_2 = 1$.

:::tip Careful with the conclusion
If this data came from a **proper experiment**, this might lead us to believe the vaccine was less effective for smokers. Based on the available information (we don't know how the data were collected), we would **not** be justified in concluding that. An observational association isn't a causal effect: smokers who got vaccinated might differ from those who didn't in other ways.
:::

:::tip With two binary predictors, the model is just four group means (not in the notes)
Four groups, four coefficients: $\hat\beta_0$ = (not vax, non-smoker), $\hat\beta_0 + \hat\beta_1$, $\hat\beta_0 + \hat\beta_2$, $\hat\beta_0 + \hat\beta_1 + \hat\beta_2 + \hat\beta_3$. Reading the table above: $\hat\beta_3 = (5 - 6) - (2 - 4) = -1 - (-2) = 1$, the "difference of differences."
:::

## Interpreting interactions: a checklist

:::tip On the exam
1. **Find the interaction row** (`x1:x2` in R). Test $H_0: \beta_3 = 0$ with its t and p (two-sided by default).
2. **Significant →** "the relationship between [x₁] and [y] differs depending on [x₂]." Never just "x₁ and x₂ are related to each other": an interaction is about **y's** relationship with one predictor changing, not about the predictors being correlated (that's collinearity, [L16](#L16)).
3. **Write out the slope for each group / value**: $\beta_1 + \beta_3 x_2$. Plug in $x_2 = 0$ and $x_2 = 1$ (or a few typical values).
4. **Main effects are conditional**: $\beta_1$ is the $x_1$ slope **when $x_2 = 0$**; $\beta_2$ is the $x_2$ effect **when $x_1 = 0$**.
5. **Check the residual plot colored by group**: opposite trends → a missing interaction.
6. **Interaction model vs. separate models**: same estimates, different inference (one shared $\sigma^2$ vs. one per group).
:::
