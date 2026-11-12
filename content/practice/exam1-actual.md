---
id: EX1
num: 1
title: Exam 1 with official solutions
label: Exam
pdflabel: Exam 1 with solutions
pdf: assignments/exam1-solutions.pdf
lectures: L01, L02, L03, L04, L05, L06, L07, L08, L09, L10, L11
data:
topics: true/false, correlation vs relationship, var(X+Y), binomial coefficient, p-value under H0, CI width, residual vs error, causation, least squares minimizes RSS, Normality check, line through the means, P(X = a) for continuous, CI interpretation, var of slope, regression to the mean, CI width vs distance from x̄, CI vs PI, R² to r, linear combinations, extrapolation, one-proportion z test, prediction, slope interpretation, significance vs R², non-constant variance
summary: The real Exam 1 (50 points, 75 minutes) with the instructor's answer key, typed up with the reasoning and the trap behind each question. Answers come from the official solutions (linked below); the "why" and "trap" notes are added. For the graded paper with the four missed questions explained, see [EX1R](#EX1R). Several questions repeat ideas from the practice exam almost word for word, and those ideas will come back on the final.
---

## Section 1 · True or false (1 point each)

### box: 1 · Correlation 0 means no relationship?
key: true
question: A correlation of zero between X and Y suggests there is no relationship between X and Y.
explain:
- **FALSE.** Correlation only measures **linear** association. A perfect U-shape can have r = 0.
idea: r = 0 rules out a straight-line trend, nothing more. Same idea as PE1 #4 (fail to reject β₁ = 0 ≠ no relationship) and the $x$ vs $x^2$ example in [L16](#L16).
pitfall:
- Reading "no **linear** relationship" as "no relationship."

### box: 2 · var(X + Y) with positive correlation
question: If X and Y are positively correlated, then var(X + Y) > var(X) + var(Y).
explain:
- **TRUE.** $\text{var}(X+Y) = \text{var}(X) + \text{var}(Y) + 2\,\text{cov}(X, Y)$, and positive correlation means cov > 0.
pitfall:
- Using the independent-variables rule (no covariance term) when the variables are correlated.

### box: 3 · 8 of 10 drivers wear seat belts
key: true
question: If 90% of New Yorkers wear seat belts, P(8 of 10 sampled drivers do) = $0.9^8 \cdot 0.1^2$.
explain:
- **FALSE.** That's the probability of **one particular order** (e.g. the first 8 yes, last 2 no). Binomial: $P(Y = 8) = \binom{10}{8} 0.9^8\, 0.1^2 = 45 \times 0.9^8 \times 0.1^2 \approx 0.194$.
pitfall:
- Forgetting the $\binom{n}{k}$ count of orderings. In R: `dbinom(8, 10, 0.9)`.

### box: 4 · p-value when H₀ is true
question: Testing a population mean μ, if H₀ is true, the p-value may take any value from 0 to 1.
explain:
- **TRUE.** The p-value depends on the random sample. Even when H₀ is true, an unlucky sample can give a small p-value (that's the 5% false-rejection rate), and a typical one gives a large p-value.
idea: If H₀ is true, p-values are spread evenly between 0 and 1, which is exactly why P(p < 0.05) = 0.05.

### box: 5 · Lower confidence level, narrower CI?
question: A lower confidence level gives a narrower interval, all else equal.
explain:
- **TRUE.** Lower confidence → smaller critical value (e.g. 1.64 for 90% vs 1.96 for 95%) → smaller margin of error.

### box: 6 · Residual uses β or β̂?
key: true
question: In SLR, the residual for observation i is $y_i - (\beta_0 + \beta_1 x_i)$.
explain:
- **FALSE.** That's the **error** $\varepsilon_i$, which uses the unknown true line. The **residual** uses the fitted line: $\hat e_i = y_i - (\hat\beta_0 + \hat\beta_1 x_i)$.
pitfall:
- Missing the hats. On this exam, hats were the whole question (see #8 too).

### box: 7 · Association in observational data
question: A positive linear association between X and Y in observational data doesn't necessarily mean that increasing X will increase Y.
explain:
- **TRUE.** Association ≠ causation; confounders can drive both. Same idea as the practice exam's dog-weight question.

### box: 8 · Least squares vs the true line
key: true
question: For SLR, it's always true that $\sum (y_i - (\hat\beta_0 + \hat\beta_1 x_i))^2 \ge \sum (y_i - (\beta_0 + \beta_1 x_i))^2$.
explain:
- **FALSE.** It's the other way around. Least squares picks the line with the **smallest** sum of squared residuals for this sample, and the true line is just one of the lines it could have picked. So the fitted line's sum is **≤** the true line's.
idea: Same argument as [L15](#L15) (adding a predictor can't raise RSS): least squares never picks something worse than an option it had.
pitfall:
- Thinking the true line must fit the data best. It fits the **population** best; in one sample, least squares always does at least as well.

### box: 9 · Checking Normality with a histogram of Y
question: To check the Normality assumption, use a histogram of the response Y; it should look Normal.
explain:
- **FALSE.** The assumption is about the **errors**, so look at a histogram (or Q-Q plot) of the **residuals**. Y itself has different means at different x, so its histogram can be skewed or bimodal even when the model is perfect.

### box: 10 · Predicted y at x = x̄
question: The least squares prediction at $X = \bar x$ equals $\bar y$.
explain:
- **TRUE.** $\hat\beta_0 = \bar y - \hat\beta_1 \bar x$, so $\hat y(\bar x) = \bar y - \hat\beta_1\bar x + \hat\beta_1 \bar x = \bar y$. The line always passes through $(\bar x, \bar y)$.

## Section 2 · Multiple choice (2 points each)

### box: 11 · P(X = 4) for a continuous X
question: X is continuous. P(X = 4) is (a) the height of the pdf at 4, (b) area left of 4, (c) area right of 4, (d) equal to zero.
explain:
- **(d) 0.** For a continuous variable, probability is **area** under the density, and a single point has zero width.
pitfall:
- (a): the density's height is not a probability (it can even exceed 1).

### box: 12 · Interpreting a 95% CI for rent
key: true
question: 95% CI for mean one-bedroom rent in Chicago: \$1850 to \$2300. Best interpretation?
explain:
- **(c) We are 95% confident the true average monthly rent is between \$1850 and \$2300.**
- (a) is about **individual** apartments, not the mean. (b) says "95% probability," but μ is fixed. Same trap as PE1 #7.

### box: 13 · What does NOT lower var(β̂₁)?
key: true
question: Which does NOT tend to make the slope estimator have lower variance? (a) larger n, (b) larger vertical spread around the line, (c) larger variation in observed X, (d) none.
explain:
- **(b).** $\text{var}(\hat\beta_1) = \dfrac{\sigma^2}{\sum (x_i - \bar x)^2}$. More vertical spread = bigger $\sigma^2$ = **higher** variance.
- (a) and (c) both make $\sum (x_i - \bar x)^2$ bigger, which **lowers** the variance.
idea: Collinearity in [L16](#L16) is a multiple-regression version of the same idea: anything that makes the slope harder to pin down raises its variance.

### box: 14 · Predicted change for a 1-SD change in x
key: true
question: For X values 1 SD apart, predicted Y values differ by (a) less than 1 SD, (b) exactly 1 SD, (c) more than 1 SD, (d) can't tell. (Positive trend with scatter.)
explain:
- **(a) less than one SD.** The slope in SD units is $r$: $\hat\beta_1 = r\,\dfrac{s_y}{s_x}$, so 1 SD in x → $r$ SDs in predicted y.
- The points aren't exactly on a line, so $|r| < 1$.
idea: Regression to the mean. Predictions are always pulled toward $\bar y$ unless the fit is perfect.

### box: 15 · CI at X = 40 vs X = 25
question: Same data, $\bar x = 27$. Wider: 95% CI for mean Y at X = 40, or at X = 25?
explain:
- **(a) X = 40.** The CI's SE grows with $(x^* - \bar x)^2$. 40 is 13 away from 27; 25 is only 2 away.

### box: 16 · 95% CI vs 99% PI at X = 30
question: Wider: 95% CI for mean Y at X = 30, or 99% PI for an individual Y at X = 30?
explain:
- **(b) the 99% PI.** Same x, and both differences push the same way: a PI adds the scatter of individuals ($\hat\sigma^2$ term), and 99% uses a bigger critical value than 95%.
pitfall:
- Overthinking it like PE1 #17. There the two intervals were at **different** x values and could go either way; here everything points to the PI.

### box: 17 · From R² = 0.81 to r
key: true
question: R² = 0.81 for the plotted data (clear downward trend). Possible values of r?
explain:
- **(c) −0.90 only.** In SLR, $R^2 = r^2$, so $r = \pm 0.9$. The scatter plot slopes **down**, so r is negative.
pitfall:
- (b) ignores the plot. (a) is $0.81^2$: squaring instead of taking the square root.

## Section 3 · Free response

### box: 1 · Cheese cost (4 points)
key: true
question: Blocks have mean 1 lb, SD 0.2 lb. Two independent blocks at \$12/lb. Expected value and SD of the total cost?
explain:
- **Mean:** $E(12X_1 + 12X_2) = 12(1) + 12(1) =$ **\$24**.
- **Variance:** independent, so variances add: $12^2(0.2^2) + 12^2(0.2^2) = 5.76 + 5.76 = 11.52$.
- **SD:** $\sqrt{11.52} \approx$ **\$3.39**.
pitfall:
- Adding SDs: $12(0.2) + 12(0.2) = 4.80$. SDs don't add; variances do.
- Treating it as $24X_1$ (one block counted twice): that gives SD $24(0.2) = 4.80$. Two **independent** blocks partly cancel each other's randomness, so the SD is smaller.

### box: 2 · Cheesecake at 600°F (4 points)
question: Data cover 300–350°F, times 75–90 minutes. The model predicts under 1 minute at 600°F. Reasonable?
explain:
- **No.** 600°F is far **outside the observed range** of temperatures (extrapolation). There's no reason to assume the linear relationship continues out there.
pitfall:
- Arguing about cooking ("it would burn"). The question asks for a **statistical** reason: extrapolation.

### box: 3 · Never-married 40-year-olds (6 points)
key: true
question: In 2010, 20% had never married. 2026 sample: 18 of 62. At α = 0.05, has the proportion gone above 20%?
explain:
- **Hypotheses:** $H_0: p = 0.2$ vs $H_A: p > 0.2$ (one-sided: the question says "exceeds").
- $\hat p = 18/62 = 0.290$.
- $z = \dfrac{0.290 - 0.2}{\sqrt{0.2 \times 0.8 / 62}} = \dfrac{0.090}{0.0508} \approx 1.78$ (the key rounds to 1.8).
- One-sided 5% cutoff is **1.64**. 1.78 > 1.64 → **reject $H_0$**. (p-value ≈ 0.038.)
- **Conclusion in context:** there's significant evidence that the current proportion of 40-year-olds who have never been married is greater than 20%.
pitfall:
- Using $\hat p$ in the SE. For the **test**, use $p_0 = 0.2$ (the CI uses $\hat p$).
- Using 1.96: that's the two-sided cutoff. With 1.96 you'd wrongly fail to reject.

### box: 4(a) · Predicted blood pressure at 80 bpm (3 points)
question: $\widehat{\text{bp}} = 95.2 + 0.25\cdot\text{heartrate}$. Estimated average BP at 80 bpm?
explain:
- $95.2 + 0.25(80) = 95.2 + 20 =$ **115.2 mmHg**.

### box: 4(b) · Interpreting the slope 0.25 (3 points)
key: true
question: Interpret 0.25.
explain:
- **Good:** "For people whose resting heart rates **differ by** 1 bpm, we expect their blood pressures to **differ by** 0.25 mmHg on average."
- Also fine: "a 1 bpm difference in heart rate is associated with a 0.25 mmHg difference in **average** blood pressure."
- **Not-so-good (loses points):** "when heart rate **increases** by 1 bpm, blood pressure **increases** by 0.25." That implies changing one person's heart rate changes their BP (causal, observational data).
idea: Compare two **groups** of people, don't change one person. Use "differ by", not "increase". This is the same fix as the HW4 1(c) feedback ("For storms whose central pressure **differs** by 1 millibar…").

### box: 4(c) · Significant association? (2 points)
question: Is there significant evidence of a linear association? Justify from the output.
explain:
- **Yes.** The heartrate row tests $H_0: \beta_1 = 0$ vs $H_A: \beta_1 \neq 0$; p = 0.031 < 0.05, so reject.
- (Also accepted: the estimate is more than 2 SEs from 0, t = 2.19.)
- **The R² = 0.07 is a trap.** A small R² means the association is **weak**, not that it doesn't exist. "Is there an association?" and "Is it large?" are different questions.
pitfall:
- Answering "no" because R² is small.
- Reading the intercept row's p-value instead of the heartrate row.

### box: 5 · Fanning residual plot (4 points)
key: true
question: Residuals spread out more as x grows. (a) Which assumptions are violated? (b) Consequences for estimation and inference?
explain:
- **(a) Non-constant variance** of the errors. No other violation shows in this plot: the residuals stay centered at 0, so no curve.
- **(b) The estimated coefficients are still valid (unbiased).** **Inference (CIs and tests) is NOT valid**, because the SEs assume one common σ.
idea: Fan = spread problem → inference breaks. Curve = shape problem → everything breaks. The practice exam asked about the curve; this exam asked about the fan.
pitfall:
- Saying the estimates are biased, or that "all assumptions are violated."
