---
id: PE1
num: 1
title: Exam 1 practice questions
pdf: assignments/exam1-practice.pdf
solutions: assignments/exam1-practice-solutions.pdf
lectures: L01, L02, L03, L04, L05, L06, L07, L08, L09, L10, L11
data:
topics: true/false, variance rules, hypotheses, p-values, one- vs two-sided, regression slope, CI vs PI, interval width, linear transformation, causation, z vs t interval, reading lm output, R-squared, residual plots
summary: Worked answer key for the Exam 1 practice questions, checked against the instructor's official solutions (linked below). Each answer comes with the reasoning and the trap the question is testing. Try each question on paper first, then check here.
---

## Section 1 · True or false

### box: 1 · E(Y) at X = x*
key: true
question: In simple linear regression, the expected value of Y when X = x* is $\beta_0 + \beta_1 x^*$.
explain:
- **TRUE.** The population line *is* the average of Y at each x: $E(Y \mid X = x^*) = \beta_0 + \beta_1 x^*$.
idea: The regression line describes **averages**. Individual Y values scatter around it; the line is where they're centered.
walk:
- The model is $Y = \beta_0 + \beta_1 X + \varepsilon$ with $E(\varepsilon) = 0$.
- Take expectations at $X = x^*$: the error averages out, leaving $\beta_0 + \beta_1 x^*$.

### box: 2 · Does correlation care which variable is X?
question: The correlation between two variables depends on which is labeled X and which is labeled Y.
explain:
- **FALSE.** $r_{xy} = r_{yx}$; the formula is symmetric in x and y.
idea: Correlation measures how two variables move **together**, which is a two-way relationship. The **slope** is what changes when you swap roles (see Q15).
walk:
- $r = \frac{\sum (x_i-\bar x)(y_i-\bar y)}{\sqrt{\sum (x_i-\bar x)^2\sum (y_i-\bar y)^2}}$. Swapping x and y gives the identical expression.
pitfall:
- Mixing up correlation (symmetric) with the regression slope (not symmetric).

### box: 3 · Is the slope estimator unbiased?
question: If the data are a random sample from a population where the SLR model is true, $\hat\beta_1$ is unbiased: no systematic tendency to be too high or too low.
explain:
- **TRUE.** That's exactly what unbiased means: $E(\hat\beta_1) = \beta_1$.
idea: Any one sample's slope is off, but across many samples the estimates average out to the truth (Sep 30, Oct 7).

### box: 4 · Failing to reject β₁ = 0
key: true
question: If a test fails to reject $H_0: \beta_1 = 0$, you can conclude there is no relationship between X and Y.
explain:
- **FALSE.** Two reasons:
- "Fail to reject" ≠ "accept." The data just aren't strong enough to rule out 0 (maybe the sample is small).
- Even a true slope of 0 only means no **linear** relationship. X and Y could have a strong curved relationship (salmonella, HW 5).
pitfall:
- Treating a large p-value as proof of the null.

### box: 5 · SSE vs SST
question: For any fitted SLR, $\sum (y_i - \hat y_i)^2 \le \sum (y_i - \bar y)^2$.
explain:
- **TRUE.** This is why $R^2 = 1 - \text{SSE}/\text{SST}$ is never negative.
idea: The flat line $\hat y = \bar y$ (slope 0) is one of the lines least squares could pick, and its squared error is exactly SST. Least squares picks the line with the **smallest** squared error, so it can only do as well or better.

### box: 6 · Checking E(ε) = 0 with the mean residual
question: To check that the errors have mean zero, compute the mean of the residuals; if it isn't close to 0, the assumptions are violated.
explain:
- **FALSE.** With least squares (with an intercept), the residuals **always** sum to exactly 0, so their mean is 0 no matter what. This check can never detect anything.
idea: Assumption problems show up as **patterns** in residual plots (Oct 19), not in the average residual.

### box: 7 · "95% probability" for a CI
key: true
question: A 95% CI for mean sleep is 6.8 to 7.3 hours, so there's a 95% probability the true mean is between 6.8 and 7.3.
explain:
- **FALSE.** The true mean is a fixed number: it's either in [6.8, 7.3] or not. "95%" describes the **procedure**: before collecting data, there was a 95% chance of producing an interval that captures μ.
pitfall:
- This exact wording shows up on exams constantly. "95% confident," never "95% probability."

### box: 8 · Predicting beyond the data
question: One advantage of linear regression is reliable predictions for Y at X values beyond the observed range.
explain:
- **FALSE.** That's **extrapolation**. There's no evidence the straight-line pattern continues outside the data.

### box: 9 · t for proportions?
question: For a proportion p, CI widths use the t distribution to account for not knowing the true SD.
explain:
- **FALSE.** Proportion intervals use the **Normal**, $\hat p \pm z\sqrt{\hat p(1-\hat p)/n}$. The t distribution is for **means** when σ is estimated by s (and for regression coefficients).

### box: 10 · What the CLT says
key: true
question: The CLT guarantees that in large samples, the sample **values** are approximately Normal.
explain:
- **FALSE.** The CLT is about the **sample mean**, not the individual values. Incomes stay skewed no matter how many you collect; their *average* becomes approximately Normal (LLN & CLT R example).

## Section 2 · Multiple choice

### box: 11 · SD of X − Y
key: true
question: var(X) = 16, var(Y) = 9. What's the SD of X − Y? (a) 7 (b) 5 (c) 6.5 (d) 25 (e) cannot be determined.
explain:
- **(b) 5** (official key).
- For independent X and Y, variances **add**, even for a difference: $\text{var}(X - Y) = 16 + 9 = 25$, so $\text{sd} = \sqrt{25} = 5$.
- The key assumes X and Y are independent. In general $\text{var}(X - Y) = \text{var}(X) + \text{var}(Y) - 2\,\text{cov}(X, Y)$, so strictly you'd need the covariance. On the exam, treat X and Y as independent unless told otherwise.
idea: Subtracting a random variable still **adds** uncertainty. The minus sign gets squared away: $\text{var}(-Y) = (-1)^2\text{var}(Y)$.
pitfall:
- (a) 7 comes from subtracting SDs (4 − 3). Variances add; SDs never add or subtract.
- (d) 25 is the variance, not the SD.

### box: 12 · Hypotheses for dissatisfied customers
question: The ISP says 30% are dissatisfied; we think it's higher. In a sample of 200, 40% are dissatisfied. Hypotheses?
explain:
- **(d) $H_0: p = 0.3$, $H_A: p > 0.3$.**
- Hypotheses are about the **population** parameter $p$, never $\hat p$ (which rules out b and c).
- The null is the **claim being tested** (30%), not the value we observed (40%), which rules out (a).
- "Higher" makes it one-sided, $>$.

### box: 13 · Interpreting p = 0.03
key: true
question: Best interpretation of a p-value of 0.03?
explain:
- **(b)** There's a 3% chance of observing data this extreme or more extreme **if the null hypothesis is true**.
- (a), (c) and (d) all treat the p-value as a probability about the hypotheses. It isn't; it's a probability about the **data**, computed assuming $H_0$.

### box: 14 · Two-sided p = 0.44 → one-sided?
key: true
question: A two-sided test gives p = 0.44. Possible one-sided p-values for the same data?
explain:
- **(d) 0.22 and 0.78.**
- Two-sided p = 2 × (one tail), so the tail beyond the observed statistic is 0.22.
- If the one-sided alternative points the **same** direction as the data, p = 0.22.
- If it points the **opposite** direction, p is the other side: 1 − 0.22 = 0.78.
idea: A one-sided p-value is the area in the direction of $H_A$. Whether that's the small tail or the big remainder depends on which way the data actually fell.

### box: 15 · Swapping X and Y in the regression
key: true
question: Fitting Y on X gives slope $\hat\beta_1$. Fitting X on Y, the new slope is: (a) $= 1/\hat\beta_1$ (b) $< 1/\hat\beta_1$ (c) $> 1/\hat\beta_1$ (d) can't tell.
explain:
- **(b) less than $1/\hat\beta_1$.**
- $\hat\beta_1 = r\,s_y/s_x$, and the reversed slope is $r\,s_x/s_y$.
- Multiply them: $(r\,s_y/s_x)(r\,s_x/s_y) = r^2$, so the reversed slope $= r^2 / \hat\beta_1$.
- The scatter plot is positive but not a perfect line, so $0 < r^2 < 1$ and the reversed slope is **less than** $1/\hat\beta_1$.
idea: Regressing X on Y minimizes **horizontal** misses instead of vertical ones, so it's a different line, not the same line flipped. They'd only agree if all the points sat exactly on a line ($r^2 = 1$).

### box: 16 · CI vs PI at the same x
question: Which is wider: 99% CI for the average Y at X = 5, or 99% PI for an individual Y at X = 5?
explain:
- **(b) the prediction interval.** At the same x and the same confidence level, the PI is always wider: it adds the individual scatter σ² on top of the uncertainty about the line.
- Compare Q17: once the x values differ too, you can no longer say which is wider.

### box: 17 · CI at X = 11 vs PI at X = 6
key: true
question: Which is wider: 95% CI for the average Y at X = 11, or 95% PI for an individual Y at X = 6? (The data run from x ≈ 4 to 8, with x̄ = 6.)
explain:
- **(c) cannot be determined** (official key).
- The two intervals change in **different** ways, so neither one is automatically wider. Compare the parts under the square root (σ̂ and the multiplier are the same):
- CI at 11: $\sqrt{\tfrac1n + \tfrac{(11-6)^2}{\sum(x_i-\bar x)^2}}$. It's for an average, which makes it narrower, but 11 is far from $\bar x = 6$, which makes it wider.
- PI at 6: $\sqrt{1 + \tfrac1n}$. It's at the center, which makes it narrower, but it's for an individual, which makes it wider.
- Which wins depends on $\sum(x_i - \bar x)^2$, i.e. the exact x values, which you can't get precisely from the plot.
idea: In Q16 everything else was equal (same x, same level), so the PI had to be wider. Here two things differ at once and pull in opposite directions. When that happens, you can't call it without numbers.
pitfall:
- Answering (b) because "a PI is always wider." That's only true at the **same** x and the same confidence level.
- Answering (a) because x = 11 is extrapolation. Extrapolation widens the CI, but not necessarily past a PI.

## Section 3 · Free response

### box: 1 · Electricity cost (linear transformation)
key: true
question: Cost = 0.12·usage + 15. Usage has mean 1000 kWh and SD 50. Mean and SD of cost?
explain:
- **Mean:** $E(\text{Cost}) = 0.12(1000) + 15 = \$135$.
- **SD:** $\text{sd}(\text{Cost}) = 0.12 \times 50 = \$6$.
idea: Rules for $aX + b$: the mean shifts and scales, $aE(X) + b$; the SD only scales, $|a|\,\text{sd}(X)$, because adding a constant doesn't change spread.
pitfall:
- Adding the 15 to the SD.
- Squaring 0.12 for the SD. That's for the variance: $\text{var} = 0.12^2 \times 50^2 = 36$, and $\sqrt{36} = 6$.

### box: 2 · Dog weight and adoption (causation)
key: true
question: Heavier dogs take longer to be adopted (significant positive slope). The director concludes they should help dogs lose weight. Reasonable?
explain:
- **No.** This is an **observational** study, so a significant slope shows association, **not causation**.
- **Confounding:** weight goes with breed, size, age and energy level. Adopters likely prefer small breeds, not "lighter versions" of large dogs. A 70-lb Lab that slims to 60 lb is still a big dog.
- **Groups vs individuals:** the slope compares *different* dogs. A trend where smaller dogs get adopted faster doesn't mean that making any one dog lose weight would shorten **its** adoption time.
- **Context:** a large dog isn't necessarily overweight. Weight loss could hurt its health, which would probably make adoption *harder*.
- To claim weight loss shortens adoption time, you'd need a **randomized experiment** that changes weight while holding everything else equal.
pitfall:
- Arguing about R². A high R² still wouldn't make the relationship causal; the problem is the study design, not the strength of the fit.

### box: 3 · Pine tree heights: z or t?
key: true
question: Heights are Normal with SD 20 ft. A sample of 10 trees has mean 110 and sample SD 14. 90% CI for the true mean height?
explain:
- The population SD (σ = 20) is **given**, so use the **Normal** (z), not t with s = 14.
- 90% → $z = 1.64$ (from the table, the 0.95 column).
- $110 \pm 1.64 \cdot \frac{20}{\sqrt{10}} = 110 \pm 1.64(6.32) = 110 \pm 10.4$ → **about (99.6, 120.4) feet.**
- "We are 90% confident the true average height of mature pine trees is between 99.6 and 120.4 feet."
pitfall:
- Using s = 14 and t₉ = 1.83 (giving 110 ± 8.1). That's the right method only when σ is **unknown**. The extra sample SD is the distractor.

### box: 4(a)–(b) · Zinc from lead: prediction and residual
question: $\widehat{\text{zinc}} = 16.3 + 19.0\cdot\text{lead}$, from 80 fish. (a) Predict at lead = 0.8. (b) Residual for a fish with lead 2, zinc 52.
explain:
- (a) $16.3 + 19.0(0.8) = 16.3 + 15.2 =$ **31.5 ppm**.
- (b) Predicted: $16.3 + 19.0(2) = 54.3$. Residual = observed − predicted $= 52 - 54.3 =$ **−2.3 ppm**. The fish has slightly less zinc than the line predicts.

### box: 4(c) · 99% CI for the slope
key: true
question: 99% CI for the population slope, and its interpretation.
explain:
- Estimate ± t × SE with df = n − 2 = 78.
- The table stops at 10 df. With 78 df, t ≈ Normal, so use $z_{0.995} = 2.58$. (Exact `qt(0.995, 78)` = 2.64.)
- $19.0 \pm 2.58(3.67) = 19.0 \pm 9.5$ → **about (9.5, 28.5) ppm per ppm.**
- "We are 99% confident that fish whose lead concentrations differ by 1 ppm differ in average zinc concentration by between 9.5 and 28.5 ppm."
pitfall:
- Using df = 79 or 80. Simple regression loses 2 df.
- Saying "increasing lead increases zinc." That's causal wording for observational data.

### box: 4(d) · Interpreting R² = 0.82
question: Interpret $R^2 = 0.82$.
explain:
- **82% of the variation in zinc concentration among these fish is explained by the linear relationship with lead concentration.** The remaining 18% is variation the model doesn't capture.
pitfall:
- Leaving out the number. Say "82% of the variation…", not just "R² is the variation…".

### box: 5 · Reading residual plots
key: true
question: (a)/(b) Plot 1 is U-shaped. Which assumptions are violated, and what are the consequences? (c)/(d) Plot 2 shows random scatter. Same questions.
explain:
- **Plot 1 → linearity is violated** (official key: linearity only). The residuals are positive at both ends and negative in the middle: a curve the line can't follow. The vertical spread is about the same all the way across, so constant variance is **not** flagged.
- **Consequences:** the estimated coefficients aren't meaningful (there's no true straight line to estimate), CIs and tests are invalid, and predictions can be poor. Remedy: transform x and/or y.
- **Plot 2 → no apparent violations.** Points are scattered evenly around 0 with similar spread at every x, and there's no pattern.
- **Consequences:** none. The estimates are valid and the usual CIs and tests can be used. (Normality would need a histogram or Q-Q plot to check, and independence only matters for ordered data; this plot can't show either.)
pitfall:
- Calling a curve "non-constant variance." A U-shape changes where the residuals are **centered**; a fan changes how **spread out** they are.
idea: Read residual plots for two things. **Shape** (any curve means linearity fails) and **spread** (a fan means non-constant variance). Pure random noise is what you want.
