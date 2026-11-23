---
id: HW8
num: 8
title: Categorical predictors and interactions
pdf: assignments/hw8.pdf
lectures: L17, L18
data: poverty2.csv, rental.csv
topics: categorical predictor, region, indicator variables, baseline level, k − 1 indicators, interpreting indicator coefficients, changing the baseline, relevel, factor levels, t test for a slope, simple linear regression, binary predictor, interaction, floor*view, testing the interaction term, interaction between quantitative predictors, interaction with an indicator, prediction from a fitted equation
summary: Use a 5-level categorical predictor (region) next to a quantitative one, find the baseline, and see what happens to the coefficients when you change it (poverty2). Then three models for apartment rent: floor alone, ocean view alone, and floor × view to test whether the floor–rent relationship differs by view (rental). Last, read an equation with two interactions by hand: when the "bilingual" difference depends on GPA, and why a tiny coefficient doesn't mean a tiny effect. Note that poverty2.csv has **51 rows**, not the 50 the prompt says, and rental.csv has an unnamed row-number column (R calls it `X`) that you can ignore.
---

## Problem 1 · Poverty, teen births and region

### box: Problem 1(a) · Fit poverty on teenbirth and region
question: Fit a multiple linear regression to predict poverty using teenbirth and region. Report the estimated coefficients.
code:
```r
pov2 <- read.csv("poverty2.csv")
nrow(pov2)                    # check: 51 rows
table(pov2$region)            # how many communities per region
fit1 <- lm(poverty ~ teenbirth + region, data = pov2)
summary(fit1)
```
explain:
- $\widehat{\text{poverty}} = 4.039 + 0.2826\,\text{teenbirth} + 0.657\,x_{NE} + 2.015\,x_{SE} + 1.881\,x_{SW} - 0.152\,x_{W}$
- Each $x$ is an indicator (1 if the community is in that region, 0 if not). n = 51, residual SE = 1.287 on 45 df, $R^2 = 0.725$, adjusted $R^2 = 0.694$, overall F = 23.7 (p ≈ 1.4×10⁻¹¹).
- **Why 6 coefficients:** region has 5 levels, so R builds **k − 1 = 4** indicators (L17): intercept + teenbirth + 4 region rows.
- Region is stored as text, so `lm()` treats it as a factor automatically.
idea: One model, five parallel lines: every region shares the teenbirth slope, and each region gets its own intercept (L17–L18, "parallel lines").
walk:
- Run `table(pov2$region)` first so you know the levels and their sizes.
- In `summary()`, rows named `regionnortheast`, `regionsoutheast`, … are the indicators. The level **missing** from that list matters for (b).
pitfall:
- Expecting 5 region coefficients. One level has no indicator.
- Saying "50 communities": the file has 51. Report n = 51 or note the discrepancy.

### box: Problem 1(b) · Which region is the baseline?
question: Which geographic region is the "baseline" category for your model?
code:
```r
levels(factor(pov2$region))   # R's default order (alphabetical)
```
explain:
- **Midwest.**
- **Why:** the output has rows for northeast, southeast, southwest and west, but none for midwest. R orders text levels **alphabetically** (midwest, northeast, southeast, southwest, west) and uses the **first** one as the baseline (L17).
idea: All indicators = 0 describes exactly one group. That group is the baseline, and the intercept belongs to it.
walk:
- List the 5 regions, cross off the 4 that appear in the coefficient table, and the one left is the baseline.
pitfall:
- Picking the largest or "most typical" region. R doesn't choose by size or meaning, only by level order.

### box: Problem 1(c) · Interpret every coefficient
question: Describe the interpretation of each coefficient in the fitted model, including the intercept.
explain:
- **Intercept (4.04):** expected poverty rate for a **midwest** community with a teen birth rate of 0. Not meaningful on its own: teen birth rates in the data run from 4.6 to 22.8, so 0 is far outside the range.
- **teenbirth (0.283):** among communities in the **same region**, a difference of 1 birth per 1,000 females aged 15–19 is associated with a 0.28 percentage point higher poverty rate, on average.
- **Northeast (0.657):** among communities with the **same teen birth rate**, northeast communities have an expected poverty rate 0.66 points **higher** than midwest communities.
- **Southeast (2.015):** same teen birth rate → southeast is 2.02 points **higher** than the midwest, on average.
- **Southwest (1.881):** same teen birth rate → southwest is 1.88 points **higher** than the midwest, on average.
- **West (−0.152):** same teen birth rate → west is 0.15 points **lower** than the midwest, on average.
- Every region coefficient is a **difference from the midwest**, not that region's average poverty rate.
idea: Every slope in a multiple regression holds the other predictors fixed (L13); every indicator coefficient is a **difference from the baseline** (L17).
walk:
- Do the intercept, then teenbirth, then the four regions one at a time.
- Units: poverty is a **percentage**, so a difference of 2 is "2 percentage points," not "2%."
pitfall:
- Calling a region coefficient "the poverty rate in the southeast." It's the gap vs. the baseline.
- Dropping "with the same teen birth rate" / "in the same region."

### box: Problem 1(d) · Is teenbirth significant within a region?
key: true
question: For communities in the same geographic region, is there significant evidence that average poverty differs across communities with different teen birth rates? Justify briefly.
explain:
- **Yes.** $H_0: \beta_{\text{teenbirth}} = 0$ vs. $H_A: \beta_{\text{teenbirth}} \ne 0$: t = 4.42 on 45 df, **p ≈ 6.1×10⁻⁵ < 0.05**, so reject $H_0$.
- In context: among communities in the same geographic region, there is significant evidence that average poverty rates differ across communities with different teen birth rates (higher teen birth rates go with higher poverty).
- **Why this row:** "in the same region" means the teenbirth slope **with region held fixed**, which is exactly the teenbirth row of the model with both predictors.
idea: The t test on one coefficient asks whether that predictor adds information **given the others in the model** (L14).
walk:
- Find the teenbirth row → read p → reject or fail to reject → one sentence in context.
pitfall:
- Using the overall F test at the bottom of `summary()`. That tests all 5 slopes at once.
- Saying teen births **cause** poverty. Observational data.

### box: Problem 1(e) · Southeast vs. southwest, same teen birth rate
key: true
question: For communities with the same teen birth rate, what is the difference in expected poverty for the southeast vs. the southwest?
explain:
- **0.134 percentage points**: for communities with the same teen birth rate, the southeast's expected poverty rate is about 0.13 points **higher** than the southwest's.
- **Why:** southeast: $\hat\beta_0 + \hat\beta_1 t + 2.0152$; southwest: $\hat\beta_0 + \hat\beta_1 t + 1.8812$. Subtract and everything cancels except $2.0152 - 1.8812 = 0.134$.
- Check with `predict()` at teenbirth = 15: 10.293 − 10.159 = 0.134. Any teen birth rate gives the same gap (parallel lines).
idea: Parallel lines are the same distance apart at every teen birth rate, so the gap doesn't depend on which $t$ you pick.
walk:
- Pull the two Estimates from `summary(fit1)`, subtract, interpret.
- Optional check in R: `predict(fit1, data.frame(teenbirth = 15, region = c("southeast", "southwest")))`, then subtract the two predictions. Any teenbirth value gives the same difference.
pitfall:
- Reporting $\hat\beta_{SE}$ alone. That's southeast vs. the **baseline**.
- Subtracting in the wrong order. The question asks southeast **minus** southwest.

### box: Problem 1(f) · What changes with southwest as the baseline?
question: How would your answer to (e) change if you used "southwest" as the baseline region? (Re-fitting is optional.)
code:
```r
pov2$region_sw <- relevel(factor(pov2$region), ref = "southwest")
fit1_sw <- lm(poverty ~ teenbirth + region_sw, data = pov2)
summary(fit1_sw)
```
explain:
- **The answer wouldn't change: still 0.134.** It would just be easier to read: with southwest as the baseline, the southeast coefficient **is** the southeast − southwest difference (0.134, SE 0.685, p = 0.85).
- Refit: $\widehat{\text{poverty}} = 5.920 + 0.2826\,\text{teenbirth} - 1.881\,x_{MW} - 1.224\,x_{NE} + 0.134\,x_{SE} - 2.033\,x_{W}$.
- **What changed:** the intercept (now southwest's) and every region coefficient, since each now compares to the southwest. Midwest is −1.881, the old southwest coefficient with the sign flipped.
- **What stayed the same:** the teenbirth slope (0.2826, same t and p), fitted values, residual SE 1.287, $R^2$ 0.725, and the F test. It's the same five parallel lines, labeled differently (L17).
idea: The baseline is a labeling choice. The model describes the same five parallel lines however you label them.
walk:
- `relevel(..., ref = "southwest")` makes southwest the first level.
- Line up the two outputs row by row.
pitfall:
- Saying the southeast–southwest difference changes. The **question** gets a different-looking coefficient, but the **answer** is the same number.
- Thinking a region's p-value is a property of that region alone. It tests the gap **from the current baseline**, so it changes when the baseline changes.

## Problem 2 · Apartment rent, floor and ocean view

### box: Problem 2(a) · Model for "rent differs across floors"
question: To evaluate the claim that average monthly rent differs across floors, what model would you fit? Treat floor as quantitative, fit it and report the coefficients.
code:
```r
rental <- read.csv("rental.csv")    # first column "X" is just row numbers
str(rental)
fit_floor <- lm(rent ~ floor, data = rental)
summary(fit_floor)
```
explain:
- **Model:** simple linear regression $\text{rent} = \beta_0 + \beta_1\,\text{floor} + \varepsilon$, since the claim only involves rent and floor. "Differs across floors" ↔ $\beta_1 \ne 0$.
- **Fit:** $\widehat{\text{rent}} = 2132.72 + 9.21\,\text{floor}$ (n = 30, residual SE = \$198, $R^2 = 0.151$).
idea: "Treat floor as quantitative" means one slope for floor, not an indicator for each floor.
walk:
- Write the model in symbols before running it; the hypothesis for (b) comes straight from it.
pitfall:
- Wrapping floor in `factor()`. That would make 20+ indicators, which isn't what's asked.
- Including `X` (the row-number column) as a predictor by using `rent ~ .`.

### box: Problem 2(b) · Does rent differ across floors?
question: Based on (a), would you conclude average rent differs across floors? Explain briefly.
explain:
- **Yes, at the 5% level.** $H_0: \beta_1 = 0$ vs. $H_A: \beta_1 \ne 0$: t = 2.24 on 28 df, **p = 0.034 < 0.05**, so reject $H_0$. (Same p as the overall F test, F = 4.99, since it's SLR.)
- In context: there is significant evidence that average monthly rent differs across apartments on different floors. Apartments one floor apart differ in rent by about \$9.21 on average, higher floors costing more.
- The evidence is only moderate: floor alone explains 15% of the variation in rent, and the residual SE (\$198) is large. That's because the model ignores the ocean view, which matters a lot (see (c) and (e)).
idea: SLR t test for the slope (L09). Check the scatter plot too: `plot(rent ~ floor, data = rental)`.
walk:
- Plot → fit → floor row → p vs. 0.05 → sentence in context.
pitfall:
- "Rent increases as you go up a floor." It's a comparison between apartments on different floors, not one apartment moving.
- Forgetting that view is left out of this model. Keep that in mind for (e).

### box: Problem 2(c) · Model for "rent differs by ocean view"
question: To evaluate the claim that average rent differs between ocean-facing and non-ocean-facing apartments, what model would you fit? Fit it and report the coefficients.
code:
```r
fit_view <- lm(rent ~ view, data = rental)
summary(fit_view)
tapply(rental$rent, rental$view, mean)   # group averages, for checking
```
explain:
- **Model:** one binary predictor, $\text{rent} = \beta_0 + \beta_1\,\text{view} + \varepsilon$.
- **Fit:** $\widehat{\text{rent}} = 2224.95 + 359.71\,\text{view}$ (residual SE = \$131, $R^2 = 0.630$).
- $\hat\beta_0$ = \$2,224.95 = average rent for the 21 units **without** an ocean view; $\hat\beta_0 + \hat\beta_1$ = \$2,584.67 = average for the 9 ocean-view units; $\hat\beta_1$ = \$359.71 = the difference. The `tapply` means match exactly.
idea: With a single 0/1 predictor, regression just reproduces the two group means.
walk:
- view is already coded 0/1, so no `factor()` is needed.
pitfall:
- Interpreting $\hat\beta_1$ as "per unit of view." There's only one step, 0 → 1.

### box: Problem 2(d) · Does rent differ by ocean view?
question: Based on (c), would you conclude average rent differs between ocean-facing and other apartments? Explain.
explain:
- **Yes.** $H_0: \beta_1 = 0$ vs. $H_A: \beta_1 \ne 0$: t = 6.91 on 28 df, **p ≈ 1.6×10⁻⁷**, so reject $H_0$.
- In context: there is strong evidence that average monthly rent differs between ocean-facing and other apartments. Ocean-facing units rent for about \$360 more per month on average.
- Same result as `t.test(rent ~ view, var.equal = TRUE)`: t = −6.91 (the sign only reflects the group order), p ≈ 1.6×10⁻⁷.
idea: A t test on an indicator coefficient = comparing two group means.
walk:
- Note the group sizes (`table(rental$view)`): the groups are unequal, which is fine.
pitfall:
- Claiming the view **causes** higher rent. Observational: ocean-facing units might differ in other ways (size, floor, layout).

### box: Problem 2(e) · Does the floor–rent relationship differ by view?
key: true
question: Does the association between floor and average rent differ significantly for ocean-facing vs. other apartments? Fit an appropriate model.
code:
```r
fit_int <- lm(rent ~ floor * view, data = rental)
# same as: lm(rent ~ floor + view + floor:view, data = rental)
summary(fit_int)

# picture: two groups, two fitted lines
plot(rent ~ floor, data = rental, col = view + 1, pch = 19)
legend("topleft", c("no view", "ocean view"), col = 1:2, pch = 19)
```
explain:
- **No.** Model with interaction: $\widehat{\text{rent}} = 1973.33 + 11.17\,\text{floor} + 338.52\,\text{view} + 2.55\,\text{floor}\times\text{view}$.
- Two lines: no view → slope **\$11.17** per floor; ocean view → slope $11.17 + 2.55 =$ **\$13.72** per floor. $\hat\beta_3 = 2.55$ is the difference in slopes.
- Test $H_0: \beta_3 = 0$ vs. $H_A: \beta_3 \ne 0$ with the `floor:view` row: t = 0.76 on 26 df, **p = 0.455 > 0.05**, so fail to reject.
- In context: there is no significant evidence that the relationship between floor and average monthly rent differs for apartments facing the ocean vs. not. Parallel lines (`rent ~ floor + view`) describe the data adequately.
idea: Without the interaction term the lines are forced parallel; with it, each group gets its own slope, and the test asks whether that extra freedom is needed.
walk:
- Find the `floor:view` row only; the main-effect rows aren't the answer to this question.
- Look at the plot: do the two clouds look like they have similar slopes?
- Optional (L18): check residuals of `lm(rent ~ floor + view)` colored by view for opposite trends.
pitfall:
- Using the `floor` or `view` row. In the interaction model, $\beta_1$ is the floor slope **for view = 0 only**, and $\beta_2$ is the view gap **at floor 0**, which doesn't exist (floors run 6–33).
- If the interaction is not significant, don't say "the slopes are equal." Say there's no significant evidence they differ.
- Comparing this floor slope with the one from (a) without thinking about it. In `rent ~ floor + view` the floor slope is \$12.02 (SE 1.57, p ≈ 3×10⁻⁸), versus \$9.21 (SE 4.12, p = 0.034) in (a). Two reasons: (1) view explains most of the rent variation, so the residual SE drops from \$198 to \$75 and the floor slope is estimated far more precisely; (2) ocean-view units sit on slightly **lower** floors on average (19.9 vs. 22.5) but cost \$390 more, which flattens the floor–rent slope when view is left out.

## Problem 3 · Starting salary with two interactions (by hand)

The fitted model: $\hat y = 50 + 20X_1 + 0.07X_2 + 35X_3 + 0.01X_1X_2 - 10X_1X_3$, with $X_1$ = GPA, $X_2$ = IQ, $X_3$ = bilingual (1/0), $y$ = salary (\$1000s).

### box: Problem 3(a) · Which statement about bilingual households is correct?
key: true
question: For fixed IQ and GPA, do people from bilingual households earn more, less, more if GPA is high enough, or less if GPA is high enough? (Exactly one is correct.)
explain:
- **(iv) is correct:** bilingual-household graduates earn **less** on average, provided GPA is high enough.
- **Why:** at fixed IQ and GPA, $\hat y(X_3 = 1) - \hat y(X_3 = 0) = 35 - 10X_1$. IQ drops out because there's no $X_2X_3$ term.
- $35 - 10X_1 < 0$ when $X_1 > 3.5$. So for GPA **above 3.5**, the bilingual group's predicted salary is lower (e.g. GPA 4.0: $35 - 40 = -5$, i.e. \$5,000 less); below 3.5 it's higher (GPA 3.0: +\$5,000). GPAs above 3.5 are realistic, so (iv) holds.
- (i) and (ii) are wrong because the sign depends on GPA; (iii) has the direction backwards.
idea: With an interaction, there's no single "bilingual effect": it depends on the value of the variable it interacts with.
walk:
- Write $\hat y$ for $X_3 = 1$ and for $X_3 = 0$, subtract, simplify.
- Plug in a low GPA (e.g. 2.0) and a high GPA (e.g. 4.0) to see the sign at each end.
pitfall:
- Looking only at the $+35$ and choosing "MORE." That's the gap at GPA = 0.
- Mixing up "provided GPA is high enough" with "low enough." Check the direction with your two test values.

### box: Problem 3(b) · Predicted income: bilingual, IQ 112, GPA 3.9
question: What is the predicted income for a person from a bilingual household with IQ 112 and GPA 3.9?
code:
```r
X1 <- 3.9; X2 <- 112; X3 <- 1
50 + 20*X1 + 0.07*X2 + 35*X3 + 0.01*X1*X2 - 10*X1*X3
```
explain:
- **\$136,208** (ŷ = 136.208 thousand).
- Term by term: $50 + 20(3.9) + 0.07(112) + 35(1) + 0.01(3.9)(112) - 10(3.9)(1)$ $= 50 + 78 + 7.84 + 35 + 4.368 - 39 = 136.208$.
idea: Prediction is plug-and-compute; interactions are just more terms.
walk:
- Compute each term separately on paper, then add. Use the R line to check.
pitfall:
- Forgetting the interaction terms, or using $X_1 + X_2$ instead of $X_1 \times X_2$.
- Reporting the answer as dollars instead of thousands of dollars.

### box: Problem 3(c) · "Tiny coefficient, so little evidence of an interaction"?
key: true
question: Agree or disagree: "Because the coefficient for the GPA/IQ interaction term is very small, there is very little evidence that the relationship between IQ and income varies depending on GPA."
explain:
- **Disagree.**
- **Evidence ≠ size:** whether there's evidence of an interaction depends on the test of $H_0: \beta_{X_1X_2} = 0$, i.e. the estimate **relative to its standard error** (t and p-value). A small coefficient with a tiny SE can be highly significant. We aren't given the SE, so we can't judge the evidence from 0.01 alone.
- **Small number, real effect:** the IQ slope is $0.07 + 0.01X_1$: 0.09 at GPA 2.0, 0.10 at GPA 3.0, 0.11 at GPA 4.0. Relative to 0.07, that's a big change in the IQ–income relationship. The coefficient looks small only because $X_1X_2$ is large (3.9 × 112 ≈ 437 contributes \$4,368 in (b)).
idea: A coefficient's size depends on the units of its variable; significance depends on the size relative to its standard error. Neither one tells you the other.
walk:
- Write the IQ slope as a function of GPA (L18 rule).
- Ask: what would you need from the output to judge evidence? (the SE / t / p for that row).
pitfall:
- Treating "small coefficient" as "not significant" (or "large coefficient" as "significant").
- Forgetting the product term's scale: GPA × IQ is in the hundreds.
