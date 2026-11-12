---
id: EX1R
num: 1
label: My graded exam
title: Exam 1: my graded paper (45/50) and what I missed
pdf: assignments/exam1-graded.pdf
pdflabel: My graded Exam 1
pdfsub: photos of all 7 pages · 45/50
lectures: L01, L02, L03, L04, L05, L06, L07, L08, L09, L10, L11
data:
topics: residual vs error, normality assumption, CI width and distance from x̄, significance vs R², variance of a sum, one-sided proportion test, extrapolation, slope in SD units, heteroscedasticity
summary: The real Exam 1 (Fall 2026), **45/50**. Every question is here with what I answered and why the right answer is right. The four questions I lost points on are marked **Exam**; read those first. Corrections are checked against the official key on [EX1](#EX1).
---

=== big picture ===

## Where the 5 points went

| Question | Points lost | What went wrong |
| --- | --- | --- |
| §1 Q6 residual formula | 1 | Said TRUE, but the formula had **true** $\beta$s (no hats), so it's the **error**, not the residual |
| §1 Q9 normality via histogram of Y | 1 | The normality assumption is about the **errors**, not about Y itself |
| §2 Q15 which CI is wider | 2 | Picked "cannot be determined"; the CI at X = 40 is wider because 40 is farther from $\bar x = 27$ |
| §3 Q4(c) significant linear association? (2 pts) | 1 | Used $R^2$ to judge significance; significance comes from the **slope t-test / p-value** (p = 0.031) |

**The pattern:** none of these were hard calculations. Three of the four are *reading-precision* misses: a missing hat, which quantity an assumption is about, and "significant" vs "strong." The calculation questions (Q1, Q3, Q4a) were all full marks.

**Fixes for the final:**

- When a formula has $\beta$, ask: **hat or no hat?** Hat = estimated from data (residual, fitted value). No hat = population truth (error, true mean).
- Every assumption (normality, constant variance, independence) is about the **errors $\varepsilon$**. You check it with **residuals**, never with Y alone.
- "Is there significant evidence…?" → **always** a hypothesis test: state $H_0: \beta_1 = 0$, quote t and p, compare with $\alpha$. $R^2$ answers "how strong," not "is it real."
- Only pick "cannot be determined" if a quantity in the formula is actually unknown. For interval width, check what changes: confidence level, $n$, $s$, and $(x^* - \bar x)^2$.

=== problems ===

## Section 1 · True or false (8/10)

### box: 1 · Correlation of zero ✓
question: A correlation of zero between X and Y suggests there is no relationship between X and Y.
explain:
- **FALSE** (I said FALSE ✓). $r = 0$ only rules out a **linear** relationship. Y could be a perfect parabola in X and still have $r = 0$.

### box: 2 · Variance of a sum, positive correlation ✓
question: If X and Y are positively correlated, then $\text{var}(X+Y) > \text{var}(X) + \text{var}(Y)$.
explain:
- **TRUE** (✓). $\text{var}(X+Y) = \text{var}(X) + \text{var}(Y) + 2\,\text{cov}(X,Y)$, and positive correlation means $\text{cov} > 0$.

### box: 3 · Binomial probability ✓
question: If 90% of New Yorkers wear seat belts, P(8 of 10 sampled wear them) $= 0.9^8 \cdot 0.1^2$.
explain:
- **FALSE** (✓). Missing the count of arrangements: $P = \binom{10}{8}\,0.9^8\,0.1^2 = 45 \cdot 0.9^8 \cdot 0.1^2 \approx 0.194$.

### box: 4 · p-value when H₀ is true ✓
question: When testing a population mean, if $H_0$ is true the p-value may take any value from 0 to 1.
explain:
- **TRUE** (✓). Under $H_0$ the p-value is uniformly distributed on [0, 1]; that's why you reject a true null exactly $\alpha$ of the time.

### box: 5 · Lower confidence → narrower ✓
question: A lower confidence level gives a narrower interval, all else equal.
explain:
- **TRUE** (✓). Smaller critical value ($z^*$ or $t^*$) → smaller margin of error.

### box: 6 · Residual formula ✗
key: true
question: In SLR, the residual for observation $i$ is $y_i - (\beta_0 + \beta_1 x_i)$.
explain:
- **FALSE.** I said TRUE (−1).
- No hats: $y_i - (\beta_0 + \beta_1 x_i) = \varepsilon_i$, the **error**, which we never observe.
- The residual uses the **fitted** line: $e_i = y_i - (\hat\beta_0 + \hat\beta_1 x_i) = y_i - \hat y_i$.
idea: Error = distance from the **true** line (unknowable). Residual = distance from the **estimated** line (computable). Residuals are our stand-in for errors.
walk:
- My note "observed − predicted" was the right idea, but "predicted" means $\hat y_i$, which needs hats.
- Before answering any formula T/F, scan for hats first.
pitfall:
- Reading $\beta$ and $\hat\beta$ as the same thing. On T/F questions the missing hat **is** the trap.

### box: 7 · Association vs causation ✓
question: A positive linear association in observational data does not necessarily mean increasing X will increase Y.
explain:
- **TRUE** (✓). Observational data → possible confounders; only a randomized experiment supports a causal claim.

### box: 8 · Least squares minimizes SSE ✓
question: It is always the case that $\sum (y_i - \hat\beta_0 - \hat\beta_1 x_i)^2 \ge \sum (y_i - \beta_0 - \beta_1 x_i)^2$.
explain:
- **FALSE** (✓). Least squares picks $\hat\beta_0, \hat\beta_1$ to make the sum of squares as **small as possible** for this sample, so the fitted line's SSE is always $\le$ the SSE of any other line, including the true one.

### box: 9 · Checking normality with a histogram of Y ✗
key: true
question: A useful check of the normality assumption is a histogram of the response Y; if it holds, the histogram should look normal.
explain:
- **FALSE.** I said TRUE (−1).
- The assumption is $\varepsilon_i \sim N(0, \sigma^2)$: Y is normal **at each fixed x**, not overall.
- Y's overall histogram mixes many normals with **different means** ($\beta_0 + \beta_1 x$), so it can be skewed or bimodal even when every assumption holds.
- Correct check: histogram or **QQ plot of the residuals**.
idea: All four regression assumptions are statements about the **errors**. So every check uses **residuals**.
pitfall:
- Checking the distribution of Y (or X) instead of the residuals.

### box: 10 · Fitted value at x̄ ✓
question: The value predicted by the least squares line at $X = \bar x$ equals the sample mean of the observed Y values.
explain:
- **TRUE** (✓). The LS line always passes through $(\bar x, \bar y)$ because $\hat\beta_0 = \bar y - \hat\beta_1 \bar x$.

## Section 2 · Multiple choice (12/14)

### box: 11 · P(X = 4) for a continuous variable ✓
question: If X is continuous, P(X = 4) is: (a) height of the pdf at 4, (b) area left of 4, (c) area right of 4, (d) zero.
explain:
- **(d) zero** (✓). Probability is area, and a single point has no width.

### box: 12 · Interpreting a 95% CI ✓
question: A 95% CI for the mean rent is \$1850 to \$2300. Best interpretation?
explain:
- **(c) We are 95% confident the true average monthly rent is between \$1850 and \$2300** (✓).
- (a) is about individual apartments, not the mean. (b) treats $\mu$ as random; once computed, the interval either contains $\mu$ or it doesn't.

### box: 13 · What does NOT lower Var(β̂₁) ✓
question: Which does NOT tend to make the slope estimator have lower variance? (a) larger n, (b) larger vertical spread of Y around the line, (c) larger variation in X.
explain:
- **(b)** (✓). $\text{Var}(\hat\beta_1) = \dfrac{\sigma^2}{\sum (x_i - \bar x)^2}$. Bigger $\sigma^2$ (spread around the line) **raises** it; larger n and more spread in X raise the denominator and lower it.

### box: 14 · Slope in standard-deviation units ✓
question: X values that differ by 1 SD → predicted Y values differ by: (a) less than 1 SD, (b) exactly 1, (c) more than 1, (d) can't tell.
explain:
- **(a)** (✓). $\hat\beta_1 = r\,\dfrac{s_y}{s_x}$, so a 1-$s_x$ change moves $\hat y$ by $r\,s_y$. The points scatter around the line, so $|r| < 1$ → less than one SD ("regression to the mean").

### box: 15 · Which CI is wider: X = 40 or X = 25? ✗
key: true
question: Scatterplot with $\bar x = 27$, data roughly 15 to 38. Which is wider: (a) 95% CI for mean Y at X = 40, (b) 95% CI for mean Y at X = 25, (c) cannot be determined?
explain:
- **(a)** X = 40. I circled (c) (−2).
- $SE(\hat y^*) = s\sqrt{\dfrac{1}{n} + \dfrac{(x^* - \bar x)^2}{\sum (x_i - \bar x)^2}}$. Same data, same 95% level, so only $(x^* - \bar x)^2$ differs.
- $(40 - 27)^2 = 169$ vs $(25 - 27)^2 = 4$ → X = 40 has the bigger SE → wider interval.
idea: The confidence band is a bow tie: narrowest at $\bar x$, flaring out as you move away. Uncertainty in the slope gets magnified the farther you go from the center.
walk:
- I wrote "further away from mean" next to X = 40, which was the right reasoning, then circled (c).
- If the worry was that 40 is slightly outside the data (extrapolation): that affects whether the interval is **trustworthy**, not which one is **wider**. The width formula still applies.
pitfall:
- Choosing "cannot be determined" when every piece of the formula is fixed except one you can compare.
- Remember for Q16: a PI is always wider than the CI at the same x (it adds $\sigma^2$ for the individual's own scatter).

### box: 16 · 95% CI vs 99% PI at X = 30 ✓
question: Which is wider: 95% CI for mean Y at X = 30, or 99% PI for an individual Y at X = 30?
explain:
- **(b) the PI** (✓). A PI is wider than a CI at the same level, and 99% is a higher level on top of that.

### box: 17 · R² = 0.81 → possible r ✓
question: $R^2 = 0.81$ for the downward-sloping scatterplot. Possible r?
explain:
- **(c) −0.90 only** (✓). $|r| = \sqrt{0.81} = 0.90$; the sign matches the slope, which is clearly negative.

## Section 3 · Free response (25/26)

### box: Q1 · Cost of two cheese blocks (4/4) ✓
question: Blocks weigh mean 1 lb, SD 0.2 lb; two independent blocks at \$12/lb. Expected value and SD of total cost?
explain:
- $E(T) = 12(1) + 12(1) = \$24$.
- $\text{Var}(T) = 12^2(0.04) + 12^2(0.04) = 11.52$ (independent → variances add, constants come out **squared**).
- $SD(T) = \sqrt{11.52} \approx \$3.39$ ✓.
pitfall:
- Doing $\text{Var}(24C)$ for one block doubled: $24^2(0.04) = 23.04$, which is wrong. Two **independent** blocks ≠ one block times two.

### box: Q2 · Cheesecake at 600°F (4/4) ✓
question: Model fit to bakes at 300–350°F predicts < 1 minute at 600°F. Reasonable?
explain:
- **No: extrapolation** (✓). The data only cover 300–350°F; nothing tells us the relationship stays linear at 600°F (a linear fit eventually predicts impossible negative times).
- Random assignment makes a causal reading valid **within** the range; it doesn't extend the range.

### box: Q3 · One-sided test for a proportion (6/6) ✓
key: true
question: 2010: 20% of 40-year-olds never married. 2026 sample: 18 of 62. At $\alpha = 0.05$, does the current proportion exceed 20%?
explain:
- $H_0: p = 0.20$ vs $H_a: p > 0.20$ (one-sided, from "exceeds") ✓.
- $\hat p = 18/62 = 0.290$; $SE = \sqrt{\dfrac{p_0(1-p_0)}{n}} = \sqrt{\dfrac{0.2 \cdot 0.8}{62}} = 0.0508$ (uses $p_0$, not $\hat p$ ✓).
- $z = \dfrac{0.290 - 0.20}{0.0508} = 1.78 > 1.645$; p-value $\approx 0.038 < 0.05$.
- Reject $H_0$: significant evidence the proportion of 40-year-olds who have never married now exceeds 20% ✓.
walk:
- Full marks, but tighten the conditions line for the final. For a proportion, the check is $np_0 = 12.4 \ge 10$ and $n(1-p_0) = 49.6 \ge 10$, not "$n \ge 40$" (that's the rule of thumb for means).
- "We don't know $\sigma$" doesn't apply to proportions: under $H_0$ the SD is fixed by $p_0$. That's why it's a **z** test, not t.

### box: Q4(a) · Predicted BP at heart rate 80 ✓
question: lm(bloodpressure ~ heartrate): intercept 95.2, slope 0.25 (SE 0.11, t = 2.19, p = 0.031), $R^2 = 0.07$. Estimated average BP at 80 bpm?
explain:
- $\hat y = 95.2 + 0.25(80) = 115.2$ mmHg ✓.

### box: Q4(b) · Interpreting the slope 0.25 ✓
question: Interpret 0.25.
explain:
- People whose resting heart rates differ by 1 beat/min differ in systolic BP by 0.25 mmHg **on average** ✓.
- Rescaled version (my extra line): 10 bpm apart → 2.5 mmHg. I wrote 100 bpm → 25 mmHg, but a 100-bpm gap in **resting** heart rate is outside realistic data; 10 is the sensible scale.

### box: Q4(c) · Significant linear association? (lost 1)
key: true
question: Is there significant evidence of a linear association between heart rate and BP? Justify from the output.
explain:
- **Yes.** Test $H_0: \beta_1 = 0$ vs $H_a: \beta_1 \ne 0$. From the heartrate row: t = 2.19, p = 0.031 < 0.05 → reject $H_0$.
- Conclusion: significant evidence of a (positive) linear association between resting heart rate and systolic BP.
- $R^2 = 0.07$ says the association is **weak** (explains 7% of variation), but weak and significant can both be true.
- My answer used $R^2$, concluded "not strong evidence," and added that the relationship "may not be linear," which the output alone can't show.
idea: **Significance** = is the slope distinguishable from 0? (t, p-value). **Strength** = how tightly points hug the line ($R^2$, $r$). With a large n, a tiny $R^2$ can still be very significant.
walk:
- See "significant evidence" → write $H_0$, $H_a$.
- Find the **predictor's row** in the output (not the intercept row).
- Quote t and p, compare with $\alpha$, state the conclusion in context.
- Optionally add one line about $R^2$ as strength.
pitfall:
- Using $R^2$ to decide significance.
- Reading the intercept row's p-value (<2e-16) instead of the slope's.

### box: Q5(a) · Which assumption is violated? (2/2) ✓
question: Residual plot: residuals tightly around 0 at the edges, spread out much more for x roughly 2.5–4.5.
explain:
- **Non-constant variance** (heteroscedasticity) ✓: the vertical spread of residuals changes with x. The center stays near 0, so linearity looks fine.

### box: Q5(b) · Consequences (2/2) ✓
question: Consequences for coefficient estimation and for inference?
explain:
- **Estimates:** $\hat\beta_0, \hat\beta_1$ are still unbiased ✓.
- **Inference:** the usual SEs are wrong, so CIs and tests are unreliable ✓.
- One thing to tighten: "predictions will be good" is only true of the **point** predictions. **Prediction intervals** are wrong too: too narrow in the middle (where spread is large) and too wide at the edges.
