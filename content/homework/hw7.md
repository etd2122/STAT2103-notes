---
id: HW7
num: 7
title: Partial F tests, collinearity and multiple testing
pdf: assignments/hw7.pdf
lectures: L14, L15, L16
data: poverty.csv, CosmeticsSales.csv, HW7Q3.csv
topics: multiple regression, residuals vs fitted, partial F test, nested models, non-nested models, adjusted R², AIC, BIC, collinearity, pairs, VIF, confidence interval for slope, multiple testing, overall F test
summary: Drop predictors with a partial F test (poverty), and see why a non-nested comparison needs adjusted R² or AIC instead. Watch collinearity blow up a slope's standard error and then disappear when one ad variable is dropped (cosmetics). Finally, one "significant" t test out of ten next to a non-significant overall F test (HW7Q3). Note that poverty.csv has **51 rows**, not the 50 the prompt says.
---

## Problem 1 · Poverty, overdose deaths, gun deaths and teen births

### box: Problem 1(a) · Fit the full model
question: Fit poverty on drugdeaths (X1), gundeaths (X2) and teenbirth (X3). Report the coefficients.
code:
```r
pov <- read.csv("poverty.csv")
nrow(pov)                      # 51, not 50
fit_full <- lm(poverty ~ drugdeaths + gundeaths + teenbirth,
               data = pov)
summary(fit_full)
```
explain:
- $\hat y = 2.222 + 0.0554X_1 - 0.0637X_2 + 0.4486X_3$
- t tests (each given the other two): drugdeaths p = 0.020, gundeaths p = 0.251, teenbirth p ≈ 4×10⁻⁸. $R^2 = 0.667$.
idea: Each slope compares communities that are alike on the other two predictors. Teen births carry most of the signal.
walk:
- Response first: `poverty ~ drugdeaths + gundeaths + teenbirth`.
- Read the Estimate column of `summary()`; you'll need the p-values later in (e).
pitfall:
- Reading a slope without "holding the other predictors fixed."

### box: Problem 1(b)–(c) · Residuals vs fitted values
question: Plot residuals (y-axis) against fitted values (x-axis). Any violations of the model assumptions?
code:
```r
plot(fitted(fit_full), resid(fit_full),
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, lty = 2, col = "red")
```
explain:
- Residuals sit in a band roughly −3 to +3 around 0 across fitted values 5–12.
- **No clear violation:** no curve (linearity OK) and no fan (constant variance OK). A small cluster of negative residuals around fitted 7.5–9.5 is too weak to call a pattern.
idea: In multiple regression you can't draw one scatter plot of y vs. all x's, so residuals vs. $\hat y$ is the one-picture check (L16).
walk:
- Look for **shape** (is the center bending?) then **spread** (does the scatter widen?).
- Say what you see in words, then name the assumption it tells you about.
pitfall:
- Plotting residuals against Y instead of $\hat Y$. Residuals are correlated with Y by construction, so that plot always shows a trend.

### box: Problem 1(d) · Hypotheses for dropping X1 and X2
question: Fit poverty ~ teenbirth. State the hypotheses for an F test comparing it to the model in (a).
code:
```r
fit_teen <- lm(poverty ~ teenbirth, data = pov)
summary(fit_teen)
```
explain:
- Reduced fit: $\widehat{\text{poverty}} = 3.352 + 0.396\,X_3$.
- $H_0: \beta_1 = \beta_2 = 0$ (drug and gun deaths add nothing once teen births are in the model).
- $H_A$: at least one of $\beta_1, \beta_2 \ne 0$.
idea: A partial F test asks whether the predictors you dropped were pulling their weight. $H_0$ sets exactly the dropped slopes to 0.
walk:
- The reduced model must be **nested** in the full one: its predictors are a subset. teenbirth ⊂ {drug, gun, teen} ✓.
- Only $\beta_1, \beta_2$ appear in $H_0$; $\beta_3$ stays free.
pitfall:
- Writing $H_A$ as "both ≠ 0." It's **at least one**.
- Putting $\beta_3$ or the intercept into $H_0$.

### box: Problem 1(e) · Run the partial F test
question: Do the test at the 5% level. Report the p-value and conclude in context.
code:
```r
anova(fit_teen, fit_full)    # reduced first, then full
```
explain:
- RSS drops from 102.06 to 90.22: F = 3.08 on (2, 47) df, **p = 0.055**.
- p > 0.05: **fail to reject** $H_0$. Once teen birth rates are in the model, drug overdose and firearm death rates together don't significantly improve predictions of a community's poverty rate.
idea: $f = \dfrac{(\text{RSS}_{red} - \text{RSS}_{full})/2}{\text{RSS}_{full}/47}$. A small RSS improvement relative to leftover noise means the extra predictors aren't worth it.
walk:
- `anova(reduced, full)`: read `F` and `Pr(>F)` on the second row.
- df: 2 slopes dropped; full model has 51 − 3 − 1 = 47 residual df.
- 0.055 is close to 0.05, but the rule is the rule: fail to reject.
pitfall:
- Thinking this contradicts drugdeaths' p = 0.020 in (a). The joint test spreads the evidence over two slopes, and gundeaths contributes almost nothing, which dilutes it.
- Saying "drug and gun deaths are unrelated to poverty." Failing to reject isn't proof of 0, and they're only "not useful **given** teen births."

### box: Problem 1(f) · Compare X1+X2 to teenbirth alone (not nested)
question: Fit poverty ~ drugdeaths + gundeaths and use an appropriate method to compare it with the teenbirth model. Which would you choose?
code:
```r
fit_x1x2 <- lm(poverty ~ drugdeaths + gundeaths, data = pov)
summary(fit_x1x2)
c(teen = summary(fit_teen)$adj.r.squared,
  x1x2 = summary(fit_x1x2)$adj.r.squared)
AIC(fit_teen, fit_x1x2)
BIC(fit_teen, fit_x1x2)
```
explain:
- Adjusted $R^2$: teenbirth **0.615** vs. X1+X2 **0.334**. Residual SE 1.44 vs. 1.90.
- AIC (R): ≈ 186.1 vs. 215.1; BIC ≈ 191.9 vs. 222.8. Lower is better.
- **Choose teenbirth alone:** better on every measure, with one predictor instead of two.
idea: Neither model's predictors are a subset of the other's, so they're **not nested** and the partial F test doesn't apply. Adjusted $R^2$ (L15) charges for each predictor, so it can compare any two models on the same y.
walk:
- Check nesting first: {teen} vs. {drug, gun} share nothing → no F test.
- Compare adjusted $R^2$ (higher is better), or AIC/BIC (lower is better).
pitfall:
- Running `anova(fit_teen, fit_x1x2)`. R will print a number, but it's meaningless for non-nested models.
- Comparing plain $R^2$ when models have different numbers of predictors.

## Problem 2 · Cosmetics sales and advertising

### box: Problem 2(a) · Scatter plots of each pair of predictors
question: Plot each pair of predictors. Are any pairs highly correlated?
code:
```r
cos <- read.csv("CosmeticsSales.csv")
preds <- cos[, c("displays", "localads", "nationalads")]
pairs(preds, pch = 19)
cor(preds)
```
explain:
- **displays vs. localads: r = 0.974**, an almost perfect straight line. Highly correlated.
- displays vs. nationalads r = 0.38; localads vs. nationalads r = 0.41: weak.
idea: Regions that spend more on in-store displays also spend more on local ads, almost in lockstep. The model will struggle to tell their effects apart.
walk:
- `pairs()` draws every pair at once; `cor()` puts numbers on what you see.
pitfall:
- Relying only on pairwise plots in general. With 3+ predictors, collinearity can hide in a combination (L16). That's why (b) asks for VIFs.

### box: Problem 2(b) · Full model and VIFs
question: Fit sales on all three predictors and report the VIFs. Is there collinearity?
code:
```r
library(car)
fit_b <- lm(sales ~ displays + localads + nationalads, data = cos)
summary(fit_b)
vif(fit_b)
```
explain:
- VIF: displays **20.1**, localads **20.7**, nationalads 1.22.
- **Yes, serious collinearity:** two VIFs are well above 10.
- Symptom: $R^2 = 0.74$ and the overall F p ≈ 8×10⁻¹², yet displays (p = 0.18) and localads (p = 0.42) are each **not** significant.
idea: VIF = how many times larger a slope's variance is because of the other predictors. 20 means the SE is about $\sqrt{20} \approx 4.5$ times bigger than it would otherwise be.
walk:
- `vif()` comes from the `car` package; install it once with `install.packages("car")`.
- Rule of thumb from L16: VIF > 5 or 10 is a warning sign.
pitfall:
- Concluding displays and local ads don't matter. They clearly do together; the model just can't split credit between them.

### box: Problem 2(c) · 95% CI for the displays slope (full model)
question: In model (b), find a 95% confidence interval for the displays slope.
code:
```r
confint(fit_b, "displays", level = 0.95)
```
explain:
- **(−0.468, 2.399)**, from estimate 0.966 with SE 0.709.
- It contains 0, so from this model we can't even say the effect is positive.
idea: Collinearity inflates the SE, and a big SE means a wide interval.
walk:
- `confint()` = estimate ± $t_{0.975,\,40}$ × SE, with df = 44 − 3 − 1 = 40.
pitfall:
- Interpreting without "holding local and national ads fixed."

### box: Problem 2(d) · Drop localads and recheck VIFs
question: Fit sales ~ displays + nationalads and report the VIFs. Any collinearity?
code:
```r
fit_d <- lm(sales ~ displays + nationalads, data = cos)
summary(fit_d)
vif(fit_d)
```
explain:
- VIF = **1.16** for both. **No collinearity problem.**
- Both slopes are now significant: displays p ≈ 3×10⁻¹¹, nationalads p = 0.040.
idea: Removing one of the two near-duplicate predictors is the L16 remedy.
walk:
- With exactly two predictors, both VIFs are always equal: $1/(1 - r^2)$ with $r = 0.376$.
pitfall:
- Saying collinearity "violated an assumption" in (b). It doesn't. Model (b) was valid, just much less useful.

### box: Problem 2(e) · 95% CI for displays again, and compare
question: In model (d), find the 95% CI for the displays slope. Compare with (c).
code:
```r
confint(fit_d, "displays", level = 0.95)
```
explain:
- **(1.179, 1.866)**, from estimate 1.522 with SE 0.170.
- About **4× narrower** than (−0.468, 2.399), and it **excludes 0**. The SE fell from 0.709 to 0.170.
- In context: holding national ad spending fixed, each extra \$1,000 on displays goes with 1.18 to 1.87 thousand more cases sold, on average.
idea: Same data and same variable, but a much more precise estimate once its near-twin is out of the model.
walk:
- The estimate also moved (0.97 → 1.52): displays now carries the credit it used to share with localads.
pitfall:
- Comparing only the centers. The point is the **width**.

### box: Problem 2(f) · Partial F test: (d) vs. (b)
question: F test comparing model (d) to model (b). Report the p-value and conclude in context.
code:
```r
anova(fit_d, fit_b)
```
explain:
- $H_0: \beta_{\text{localads}} = 0$ vs. $H_A: \beta_{\text{localads}} \ne 0$.
- F = 0.653 on (1, 40) df, **p = 0.424**. **Fail to reject.**
- Once display and national ad spending are known, local media spending adds no significant information about sales.
idea: The models are nested ({displays, national} ⊂ all three), so the partial F test applies.
walk:
- Dropping one predictor: this F equals the square of localads' t from (b) ($0.808^2 \approx 0.653$), same p.
pitfall:
- Saying local ads don't affect sales. They're just redundant **given** displays.

### box: Problem 2(g) · R² and adjusted R²
question: Compare $R^2$ and adjusted $R^2$ for models (b) and (d).
code:
```r
sb <- summary(fit_b); sd <- summary(fit_d)
c(R2_b = sb$r.squared,     R2_d = sd$r.squared)
c(adj_b = sb$adj.r.squared, adj_d = sd$adj.r.squared)
```
explain:
- $R^2$: (b) **0.7417**, (d) **0.7374**. Adjusted $R^2$: (b) **0.7223**, (d) **0.7246**.
- $R^2$ drops slightly when localads is removed (it always does). Adjusted $R^2$ **rises**, agreeing with (f): the smaller model is better.
idea: $R^2$ can never go down when you add a predictor (L15). Adjusted $R^2$ penalizes each one, so it can.
pitfall:
- Picking model (b) because its $R^2$ is higher.

## Problem 3 · Ten predictors, one "significant"

### box: Problem 3(a) · Individual t tests
question: Fit y on all ten predictors. Which individual $H_0: \beta_k = 0$ would you reject at 5%?
code:
```r
q3 <- read.csv("HW7Q3.csv")
fit_q3 <- lm(y ~ ., data = q3)     # "." = every other column
summary(fit_q3)
```
explain:
- Only **X4** (t = 2.88, p = 0.004). Every other p-value is above 0.18.
idea: Each t test asks whether $X_k$ helps given the other nine.
walk:
- Scan the `Pr(>|t|)` column, skipping the intercept row.
pitfall:
- Counting the intercept as a "predictor."

### box: Problem 3(b) · Overall F test
question: Test $H_0: \beta_1 = \cdots = \beta_{10} = 0$ vs. at least one $\ne 0$. Conclude.
code:
```r
fs <- summary(fit_q3)$fstatistic
pf(fs["value"], fs["numdf"], fs["dendf"], lower.tail = FALSE)
```
explain:
- F = 1.334 on (10, 189) df, **p = 0.215**. **Fail to reject.**
- No evidence that any of the ten predictors is linearly associated with y. ($R^2 = 0.066$.)
walk:
- It's the last line of `summary()`; the `pf()` line just pulls it out.
pitfall:
- Writing $H_A$ as "all ten ≠ 0."

### box: Problem 3(c) · Do (a) and (b) contradict each other?
question: Do the results in (a) and (b) contradict each other? Why or why not?
code:
```r
1 - 0.95^10    # P(at least one false rejection in 10 tests)
```
explain:
- **No.** They answer different questions with different error rates.
- **Multiple testing:** with 10 tests at 5%, even if every β is 0, P(at least one rejects) ≈ $1 - 0.95^{10}$ ≈ **0.40**. One "hit" out of ten is what noise often produces. The F test keeps the overall false-alarm rate at 5%.
- **Dilution:** if X4 has a small real effect, the F test spreads that one signal over 10 df and nine noise predictors drown it out.
idea: This is the left-handed example from L15: one person rarely is, but at least one in a group often is.
pitfall:
- Treating X4 as an established predictor based on one p = 0.004 among ten tests.

=== wrap-up ===

## Every formula used

:::formula Comparing models
- Partial F test (nested): $f = \dfrac{(\text{RSS}_{red} - \text{RSS}_{full})/(df_{red} - df_{full})}{\text{RSS}_{full}/df_{full}}$, run with `anova(reduced, full)` (#1e, #2f)
- Adjusted $R^2 = 1 - \dfrac{\text{RSS}/(n-p-1)}{\text{TSS}/(n-1)}$; works for non-nested models (#1f, #2g)
- Overall F: $H_0: \beta_1 = \cdots = \beta_p = 0$ vs. at least one $\ne 0$ (#3b)
- P(at least one false rejection in $m$ independent 5% tests) $= 1 - 0.95^m$ (#3c)
:::

:::formula Collinearity
- $\text{VIF}_k \ge 1$; above 5 or 10 is a warning sign. `car::vif(model)` (#2b, #2d)
- Two predictors: $\text{VIF} = 1/(1 - r^2)$ for both (#2d)
- CI for a slope: $\hat\beta_k \pm t_{0.975,\,n-p-1}\,\text{se}(\hat\beta_k)$, `confint()` (#2c, #2e)
:::

## Learning summary

- **Answers:** poverty = 2.222 + 0.0554·drug − 0.0637·gun + 0.4486·teen; residual plot fine; partial F p = 0.055 (fail to reject); teen-only adj R² 0.615 beats drug+gun 0.334. Cosmetics: r(displays, local) = 0.974; VIFs 20.1, 20.7, 1.22; CI (−0.47, 2.40) → (1.18, 1.87) after dropping localads (VIF 1.16); F p = 0.424; adj R² 0.722 → 0.725. HW7Q3: only X4 (p = 0.004); overall F p = 0.215.
- Partial F test only for **nested** models; otherwise use adjusted $R^2$ or AIC/BIC.
- Collinearity inflates SEs and hides real effects; dropping a near-duplicate predictor fixes it.
- One significant t test among many is weak evidence when the overall F test isn't significant.

## What to take away from the R output

:::r Reading the R
- `anova(reduced, full)`: second row has `F` and `Pr(>F)` for the partial F test.
- `car::vif(model)`: one number per predictor.
- `confint(model, "displays")`: CI for one slope.
- `summary(model)$adj.r.squared` and `AIC()` / `BIC()` compare non-nested models.
- `lm(y ~ ., data = d)` uses every other column as a predictor.
:::

## Common mistakes

:::tip Watch for these
- Running `anova()` on non-nested models.
- Choosing a model by plain $R^2$.
- Concluding a collinear predictor "doesn't matter" because its own t test isn't significant.
- Calling 0.055 significant at 5%.
- Trusting one significant t test out of ten without the overall F test.
:::
