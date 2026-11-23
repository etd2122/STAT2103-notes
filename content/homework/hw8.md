---
id: HW8
num: 8
title: Categorical predictors and interactions
pdf: assignments/hw8.pdf
lectures: L17, L18
data: poverty2.csv, rental.csv
topics: categorical predictor, region, indicator variables, baseline level, k − 1 indicators, interpreting indicator coefficients, changing the baseline, relevel, factor levels, t test for a slope, simple linear regression, binary predictor, interaction, floor*view, testing the interaction term, interaction between quantitative predictors, interaction with an indicator, prediction from a fitted equation
summary: Use a 5-level categorical predictor (region) next to a quantitative one, find the baseline, and see what happens to the coefficients when you change it (poverty2). Then three models for apartment rent: floor alone, ocean view alone, and floor × view to test whether the floor–rent relationship differs by view (rental). Last, read an equation with two interactions by hand: when the "bilingual" difference depends on GPA, and why a tiny coefficient doesn't mean a tiny effect. This guide gives concept checks and starter code, **not answers**. Note that poverty2.csv has **51 rows**, not the 50 the prompt says, and rental.csv has an unnamed row-number column (R calls it `X`) that you can ignore.
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
- **Concept check:** region has 5 levels, so R builds **k − 1 = 4** indicator variables for you (L17). Count the rows in the coefficient table: intercept + teenbirth + 4 region rows = 6.
- **Report:** write the fitted equation with every Estimate, e.g. $\widehat{\text{poverty}} = \hat\beta_0 + \hat\beta_1\,\text{teenbirth} + \hat\beta_2 x_{NE} + \dots$, naming each indicator.
- Region is stored as text, so `lm()` treats it as a factor automatically. No `factor()` needed unless you want to choose the baseline.
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
- **Concept check:** the baseline is the level with **no indicator row** in the output. By default R orders text levels **alphabetically** and uses the **first** one as the baseline (L17).
- Confirm by comparing `levels()` with the region rows in `summary(fit1)`.
idea: All indicators = 0 describes exactly one group. That group is the baseline, and the intercept belongs to it.
walk:
- List the 5 regions, cross off the 4 that appear in the coefficient table, and the one left is the baseline.
pitfall:
- Picking the largest or "most typical" region. R doesn't choose by size or meaning, only by level order.

### box: Problem 1(c) · Interpret every coefficient
question: Describe the interpretation of each coefficient in the fitted model, including the intercept.
explain:
- **Intercept:** expected poverty for a **baseline-region** community with teenbirth = 0. Say whether teenbirth = 0 is realistic for these data (check `range(pov2$teenbirth)`).
- **teenbirth slope:** expected difference in poverty for a 1-unit (1 birth per 1,000 females 15–19) difference in teen birth rate, **among communities in the same region**.
- **Each region coefficient:** expected difference in poverty between **that region and the baseline**, **among communities with the same teen birth rate**. Not that region's average.
- Use the indicator template on the Templates page: "On average, [region j] communities have poverty [$|\hat\beta_j|$] percentage points [higher / lower] than [baseline] communities with the same teen birth rate."
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
- **Concept check:** "in the same region" = the teenbirth slope **holding region fixed**, i.e. the teenbirth row of `summary(fit1)`.
- **Test:** $H_0: \beta_{\text{teenbirth}} = 0$ vs. $H_A: \beta_{\text{teenbirth}} \ne 0$ (two-sided; that's what R reports). Use the t value and `Pr(>|t|)` from that row, df = n − 6.
- **Conclusion format:** compare p to α = 0.05, then state it in context ("among communities in the same region, …").
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
- **Concept check:** neither region is the baseline. Each coefficient is a difference **from the baseline**, so the southeast − southwest gap is $\hat\beta_{SE} - \hat\beta_{SW}$: the baseline and the teenbirth term cancel.
- Write both expected values first: $\hat\beta_0 + \hat\beta_1 t + \hat\beta_{SE}$ and $\hat\beta_0 + \hat\beta_1 t + \hat\beta_{SW}$, then subtract.
- State the sign clearly: which region is higher, and by how many percentage points.
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
- **Concept check (L17):** changing the baseline changes **which comparisons the coefficients describe** (and their signs and values), but **not** the fitted model: same group lines, same $\hat y$, same teenbirth slope, same $R^2$.
- With southwest as baseline, the southeast row **is** the southeast − southwest difference directly. Compare it with your (e) number.
- Also compare: which rows changed and which stayed the same (teenbirth row, residual SE, $R^2$, F test)?
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
- **Concept check:** the claim involves only rent and floor, so the model is the **simple linear regression** $\text{rent} = \beta_0 + \beta_1\,\text{floor} + \varepsilon$ (L06, L09). "Differs across floors" ↔ $\beta_1 \ne 0$.
- Report $\hat\beta_0$ and $\hat\beta_1$ with units (dollars; dollars per floor).
idea: "Treat floor as quantitative" means one slope for floor, not an indicator for each floor.
walk:
- Write the model in symbols before running it; the hypothesis for (b) comes straight from it.
pitfall:
- Wrapping floor in `factor()`. That would make 20+ indicators, which isn't what's asked.
- Including `X` (the row-number column) as a predictor by using `rent ~ .`.

### box: Problem 2(b) · Does rent differ across floors?
question: Based on (a), would you conclude average rent differs across floors? Explain briefly.
explain:
- **Concept check:** $H_0: \beta_1 = 0$ vs. $H_A: \beta_1 \ne 0$. Use the floor row's t and p (df = 30 − 2 = 28). In SLR this p-value matches the overall F test.
- Conclude at α = 0.05 in context: "In the population of apartments in this building, …"
- Interpret the slope in words if it's significant: expected rent difference for apartments **one floor apart**.
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
- **Concept check:** one binary predictor (an indicator, L17): $\text{rent} = \beta_0 + \beta_1\,\text{view} + \varepsilon$.
- $\hat\beta_0$ = average rent for **no view** (view = 0); $\hat\beta_0 + \hat\beta_1$ = average for **ocean view**; $\hat\beta_1$ = the **difference** in averages.
- Check: the `tapply` group means should equal $\hat\beta_0$ and $\hat\beta_0 + \hat\beta_1$ exactly.
idea: With a single 0/1 predictor, regression just reproduces the two group means.
walk:
- view is already coded 0/1, so no `factor()` is needed.
pitfall:
- Interpreting $\hat\beta_1$ as "per unit of view." There's only one step, 0 → 1.

### box: Problem 2(d) · Does rent differ by ocean view?
question: Based on (c), would you conclude average rent differs between ocean-facing and other apartments? Explain.
explain:
- **Concept check:** $H_0: \beta_1 = 0$ (same average rent) vs. $H_A: \beta_1 \ne 0$. Read the view row's t and p.
- This is the same as a two-sample t test **assuming equal variances**. Optional check: `t.test(rent ~ view, data = rental, var.equal = TRUE)` gives the same t (up to sign) and p.
- Conclude in context with the direction and size of the difference.
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
- **Concept check:** "association between floor and rent differs by view" = an **interaction** (L18). Model: $\text{rent} = \beta_0 + \beta_1\,\text{floor} + \beta_2\,\text{view} + \beta_3\,\text{floor}\times\text{view} + \varepsilon$.
- **Two lines:** no view → slope $\beta_1$; ocean view → slope $\beta_1 + \beta_3$. So $\beta_3$ = difference in slopes.
- **Test:** $H_0: \beta_3 = 0$ vs. $H_A: \beta_3 \ne 0$, using the `floor:view` row (df = 30 − 4 = 26). Conclude with the interaction template: "…evidence that the relationship between floor and rent differs depending on view" (or no significant evidence).
idea: Without the interaction term the lines are forced parallel; with it, each group gets its own slope, and the test asks whether that extra freedom is needed.
walk:
- Find the `floor:view` row only; the main-effect rows aren't the answer to this question.
- Look at the plot: do the two clouds look like they have similar slopes?
- Optional (L18): check residuals of `lm(rent ~ floor + view)` colored by view for opposite trends.
pitfall:
- Using the `floor` or `view` row. In the interaction model, $\beta_1$ is the floor slope **for view = 0 only**, and $\beta_2$ is the view gap **at floor 0**, which doesn't exist (floors run 6–33).
- If the interaction is not significant, don't say "the slopes are equal." Say there's no significant evidence they differ.
- Comparing this floor slope with the one from (a). Model (a) ignores view entirely; once view is in the model, the floor coefficient can look quite different. Think about why (do ocean-view units sit on similar floors to the others? `tapply(rental$floor, rental$view, mean)`).

## Problem 3 · Starting salary with two interactions (by hand)

The fitted model: $\hat y = 50 + 20X_1 + 0.07X_2 + 35X_3 + 0.01X_1X_2 - 10X_1X_3$, with $X_1$ = GPA, $X_2$ = IQ, $X_3$ = bilingual (1/0), $y$ = salary (\$1000s).

### box: Problem 3(a) · Which statement about bilingual households is correct?
key: true
question: For fixed IQ and GPA, do people from bilingual households earn more, less, more if GPA is high enough, or less if GPA is high enough? (Exactly one is correct.)
explain:
- **Concept check:** collect every term that contains $X_3$. The bilingual vs. not difference at fixed IQ and GPA is $\hat y(X_3 = 1) - \hat y(X_3 = 0)$ = the **coefficient on $X_3$ as a function of GPA**: $35 - 10X_1$ (L18 general rule: slope for $x$ = its main effect + interaction coefficient × the other variable).
- IQ doesn't appear in that difference: there's no $X_2X_3$ term.
- Decide where $35 - 10X_1$ is positive vs. negative: solve $35 - 10X_1 = 0$, then ask whether GPAs above that value are possible (GPA ≤ 4.0).
- Pick the statement that matches; the "why" is the sign change.
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
- **Concept check:** plug into **all six** terms, including both products: $X_1X_2 = 3.9 \times 112$ and $X_1X_3 = 3.9 \times 1$.
- Units: y is in **thousands** of dollars, so report e.g. "\$___,000" in words.
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
- **Concept check 1: evidence ≠ size.** Evidence for $\beta_{X_1X_2} \ne 0$ comes from the **t statistic / p-value** = estimate ÷ **standard error**. We aren't given the SE, so the estimate alone can't tell you about evidence.
- **Concept check 2: scale.** The coefficient multiplies $X_1X_2$, and IQ is around 100. Work out what 0.01 means in practice: the IQ slope is $0.07 + 0.01X_1$, so compare the IQ slope at GPA 2.0 and at GPA 4.0. Is the change small relative to 0.07?
- State agree/disagree in one line, then give the reason.
idea: A coefficient's size depends on the units of its variable; significance depends on the size relative to its standard error. Neither one tells you the other.
walk:
- Write the IQ slope as a function of GPA (L18 rule).
- Ask: what would you need from the output to judge evidence? (the SE / t / p for that row).
pitfall:
- Treating "small coefficient" as "not significant" (or "large coefficient" as "significant").
- Forgetting the product term's scale: GPA × IQ is in the hundreds.
