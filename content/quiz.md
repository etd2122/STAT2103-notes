## Probability · L01–L02

### tf T
If X and Y are independent, then $\text{cov}(X, Y) = 0$.
why: Independence means knowing X tells you nothing about Y, so they can't move together. That's why variances simply add for independent variables.

### tf F ★
If $\text{cov}(X, Y) = 0$, then X and Y must be independent.
why: Zero covariance only rules out a **linear** relationship. Example: X is −1, 0 or 1 equally likely and $Y = X^2$. Y is completely determined by X, but $\text{cov}(X, Y) = 0$.

### tf F
A variance can be negative if X takes negative values.
why: Variance is an average of **squared** distances, so it's always ≥ 0. Negative values of X only affect the mean.

### tf T ★
For any random variable, $E(X^2) \ge (E(X))^2$.
why: $\text{var}(X) = E(X^2) - (E(X))^2 \ge 0$. Equality only when X is a constant.

### tf T
The correlation between X and $3X + 5$ is exactly 1.
why: $3X + 5$ is a perfect increasing straight-line function of X. Shifting and positive scaling don't change correlation.

### tf F
The correlation between X and $-2X$ is 0.
why: It's −1: a perfect **decreasing** linear relationship.

### tf T
$\text{cov}(X, 7) = 0$ for any random variable X.
why: A constant never varies, so it can't move together with anything.

### tf F
$P(A \mid B) = P(B \mid A)$ always.
why: $P(\text{rain} \mid \text{clouds})$ is not $P(\text{clouds} \mid \text{rain})$ (which is near 1). The denominators differ: $P(B)$ vs. $P(A)$.

### num
X is 1 or 3, each with probability 0.5. Find $E(X)$ and $\text{var}(X)$.
answer: $E(X) = 2$, $\text{var}(X) = 1$
why: $E(X) = 0.5(1) + 0.5(3) = 2$. Each value is 1 away from the mean, so $\text{var}(X) = 0.5(1^2) + 0.5(1^2) = 1$.

### num
$\text{var}(X) = 4$. What is $\text{sd}(3X - 7)$?
answer: 6
why: $\text{sd}(aX + b) = \lvert a\rvert\,\text{sd}(X) = 3 \times 2 = 6$. The −7 shifts but doesn't change spread.

### num
$E(X) = 2$ and $E(X^2) = 13$. What is $\text{sd}(X)$?
answer: 3
why: $\text{var}(X) = E(X^2) - (E(X))^2 = 13 - 4 = 9$, so $\text{sd} = 3$.

### num ★
$\text{var}(X) = 9$, $\text{var}(Y) = 16$, $\text{cor}(X, Y) = 0.5$. Find $\text{var}(X + Y)$ and $\text{var}(X - Y)$.
answer: 37 and 13
why: $\text{cov} = \rho\,\sigma_X\sigma_Y = 0.5(3)(4) = 6$. Sum: $9 + 16 + 2(6) = 37$. Difference: $9 + 16 - 2(6) = 13$.

### num
$\text{cov}(X, Y) = 6$, $\text{sd}(X) = 2$, $\text{sd}(Y) = 5$. Find the correlation.
answer: 0.6
why: $\rho = \text{cov}/(\sigma_X\sigma_Y) = 6/10 = 0.6$.

### num
$Y = 4X + 1$ and $\text{var}(X) = 2$. Find $\text{cov}(X, Y)$.
answer: 8
why: Linear rule: $\text{cov}(X, aX + b) = a\,\text{var}(X) = 4 \times 2 = 8$.

### tf T
A Binomial count needs a fixed number of independent trials with the same success probability.
why: Those are the Binomial conditions (plus each trial is success/failure).

### tf F
If $Y \sim \text{Bin}(10, 0.5)$, then $P(Y = 5) = 0.5$.
why: 5 is the most likely value, but $P(Y = 5) = \binom{10}{5}/2^{10} \approx 0.246$. The other values share the rest.

### tf F ★
For iid $X_1, X_2$, the variable $2X_1$ has the same variance as $X_1 + X_2$.
why: $\text{var}(2X_1) = 4\sigma^2$, but $\text{var}(X_1 + X_2) = 2\sigma^2$. Two independent draws partly cancel; one draw doubled doesn't.

### tf F
If $X \sim N(10, 4)$, then $3X \sim N(30, 12)$.
why: The mean triples, but the variance gets multiplied by $3^2 = 9$: $3X \sim N(30, 36)$.

### tf F
`dnorm(0)` gives $P(Z = 0)$.
why: `dnorm` is the **height** of the curve. For a continuous variable, $P(Z = 0) = 0$. Probabilities are areas: `pnorm`.

### tf T
About 95% of a Normal distribution lies within 2 SDs of its mean.
why: The 95% rule (exactly ±1.96 SD).

### num
$Y \sim \text{Bin}(20, 0.3)$. Find $E(Y)$ and $\text{sd}(Y)$.
answer: 6 and about 2.05
why: $E(Y) = np = 6$. $\text{var}(Y) = np(1-p) = 20(0.3)(0.7) = 4.2$, so $\text{sd} = \sqrt{4.2} \approx 2.05$.

### num
$X \sim N(100, 15^2)$. Roughly, what is $P(X > 130)$?
answer: about 0.025
why: $z = (130 - 100)/15 = 2$. About 95% is within ±2 SD, so about 2.5% is above. (Exact: 0.023.)

### num
$X \sim N(50, 10^2)$. Find the 90th percentile.
answer: about 62.8
why: Percentile $= \mu + z\sigma$ with $z_{0.90} = 1.28$: $50 + 1.28(10) = 62.8$.

### num ★
Daily use is $N(400, 20^2)$ grams, independent across days. Mean and SD of the total over 4 days?
answer: mean 1600, SD 40
why: Means add: $4 \times 400$. Variances add: $4 \times 400 = 1600$, so $\text{SD} = 40$ (**not** $4 \times 20 = 80$).

### num
Each try succeeds with probability 0.2, independently. P(at least one success in 3 tries)?
answer: 0.488
why: $1 - P(\text{none}) = 1 - 0.8^3 = 1 - 0.512 = 0.488$.

## Sampling distributions · L03

### tf T
$\text{sd}(\bar X) = \sigma/\sqrt n$.
why: Averages are less variable than single values, by a factor of $\sqrt n$.

### tf T
Quadrupling the sample size cuts the SD of $\bar X$ in half.
why: $\sigma/\sqrt{4n} = \tfrac12 \cdot \sigma/\sqrt n$.

### tf F
By the CLT, with a big enough sample the **histogram of the data** looks Normal.
why: The CLT is about the **sampling distribution of $\bar X$**. Skewed data stay skewed no matter how many you collect.

### tf T
If the population is Normal, $\bar X$ is exactly Normal for any n.
why: Sums of independent Normals are Normal. The CLT is only needed for non-Normal populations.

### tf F
$E(\bar X) = \mu$ only when the population is Normal.
why: $E(\bar X) = \mu$ always (for iid data). Normality only matters for the **shape** of $\bar X$'s distribution.

### tf F
The Law of Large Numbers says that after many heads, tails become more likely.
why: The trials are independent. The LLN says the long-run **average** settles near p because new data swamp old luck, not because the coin "makes up" for it.

### num
$\sigma = 12$ and $n = 36$. What is $\text{sd}(\bar X)$?
answer: 2
why: $12/\sqrt{36} = 12/6 = 2$.

### num ★
With n = 10, the SE of $\bar x$ is too big. What n makes it one third as big?
answer: 90
why: SE scales like $1/\sqrt n$. To divide it by 3, multiply n by $3^2 = 9$.

## Confidence intervals · L04

### tf T
From the same data, a 99% CI is wider than a 95% CI.
why: To be more confident, you need a bigger multiplier (2.58 vs. 1.96).

### tf F
Doubling the sample size cuts the CI width in half.
why: Width scales like $1/\sqrt n$. Doubling n divides it by $\sqrt 2 \approx 1.41$. You need **4×** the data to halve it.

### tf F
95% of sample means fall inside a 95% CI.
why: The CI is a range for **μ**. It says nothing about where other samples' means land.

### tf F
If 100 different samples each produce a 95% CI, exactly 95 of them contain μ.
why: About 95 on average. The actual count varies (it's Binomial(100, 0.95)).

### tf T ★
If a 95% CI for μ is (4, 8), a two-sided test of $H_0: \mu = 9$ at α = 0.05 rejects.
why: CIs and two-sided tests agree: the CI holds every value the test would **not** reject. 9 is outside, so it's rejected.

### tf T
A CI for a proportion uses $\hat p$ (not a hypothesized $p_0$) inside the SE.
why: No hypothesis is assumed, so you plug in your best estimate. Tests use $p_0$.

### tf F
For a mean with σ known, you should use t because the sample is small.
why: The t distribution covers the extra uncertainty from **estimating σ with s**. If σ is known, use z regardless of n (the pine tree problem).

### num
$\bar x = 50$, σ = 10 known, n = 25. 95% CI for μ?
answer: (46.08, 53.92)
why: SE $= 10/5 = 2$. $50 \pm 1.96(2) = 50 \pm 3.92$.

### num
$\hat p = 0.4$ from n = 100. Approximate 95% CI using ±2 SE.
answer: about (0.30, 0.50)
why: SE $= \sqrt{0.4 \cdot 0.6/100} = \sqrt{0.0024} \approx 0.049$. $0.4 \pm 0.098$.

### num
n = 9, $\bar x = 20$, s = 6, data Normal, σ unknown. 95% CI? (Use $t_8 = 2.31$.)
answer: (15.38, 24.62)
why: SE $= 6/\sqrt9 = 2$. $20 \pm 2.31(2) = 20 \pm 4.62$.

### mc b
Which change makes a 95% CI for μ **narrower**?
- a) Raise the confidence level to 99%
- b) Collect a larger sample
- c) Replace a known σ with the sample SD s
- d) Use a one-sided test instead
why: More data shrinks the SE. (a) widens it, (c) switches to a larger t multiplier, and (d) isn't a CI change.

## Hypothesis tests · L05

### tf F
A smaller p-value means a bigger effect.
why: p measures **evidence**, not size. A tiny effect can have a tiny p-value with a huge sample.

### tf F
A one-sided p-value is always half of the two-sided one.
why: Only when the data fall in the direction of $H_A$. Otherwise it's 1 minus that half (PE Q14).

### tf F
If p = 0.03, you reject at both α = 0.05 and α = 0.01.
why: 0.03 < 0.05, so reject at 0.05. But 0.03 > 0.01, so you fail to reject at 0.01.

### tf T
In a test for a proportion, the SE uses $p_0$, not $\hat p$.
why: The p-value is computed **assuming $H_0$ is true**, so you use its value.

### tf F
"Fail to reject $H_0$" means we've shown $H_0$ is true.
why: It only means the evidence isn't strong enough. Absence of evidence isn't evidence of absence.

### tf T ★
If the two-sided p-value is 0.08, a one-sided test in the direction the data fell rejects at α = 0.05.
why: One-sided p = 0.08/2 = 0.04 < 0.05. That's why the direction must be chosen **before** seeing the data.

### tf F
$H_0: \bar x = 50$ is a valid null hypothesis.
why: Hypotheses are about **population** parameters (μ), never sample statistics. You already know $\bar x$.

### num
$H_0: p = 0.5$, n = 100, $\hat p = 0.6$. Find the z statistic.
answer: z = 2
why: SE $= \sqrt{0.5 \cdot 0.5/100} = 0.05$. $z = (0.6 - 0.5)/0.05 = 2$.

### num
$H_0: \mu = 100$, σ = 15, n = 25, $\bar x = 106$. z? Reject at α = 0.05 (two-sided)?
answer: z = 2, reject
why: SE $= 15/5 = 3$, $z = 6/3 = 2$. |2| > 1.96, so p ≈ 0.046 < 0.05.

### num
z = 2.33 with $H_A: \mu > \mu_0$. What's the p-value?
answer: 0.01
why: Upper tail. From the table, $P(Z \le 2.33) = 0.99$, so $P(Z \ge 2.33) = 0.01$.

### mc c
A study reports p = 0.002. Which is correct?
- a) There's a 0.2% chance $H_0$ is true
- b) There's a 99.8% chance $H_A$ is true
- c) If $H_0$ were true, data this extreme would happen 0.2% of the time
- d) The effect is large
why: A p-value is a probability about the **data**, computed assuming $H_0$. It's never a probability that a hypothesis is true, and it says nothing about effect size.

## The regression line · L06–L07

### tf T
Least squares chooses the line that minimizes the sum of squared **vertical** distances.
why: Vertical, because we're predicting y; a miss is measured in y units.

### tf T
With an intercept in the model, the least squares residuals always add up to 0.
why: Built into the fit. That's why "check the mean residual" is useless (PE Q6).

### tf T
If r = 0, the least squares slope is 0.
why: $\hat\beta_1 = r\,s_y/s_x$.

### tf T
The slope and the correlation always have the same sign.
why: $\hat\beta_1 = r\,s_y/s_x$ and SDs are positive.

### tf T
Converting y from inches to centimeters changes the slope but not r.
why: The slope has units (y per x), so it rescales. r has no units.

### tf F
Swapping x and y leaves both r and the slope unchanged.
why: r is symmetric; the slope isn't. The reversed slope is $r^2/\hat\beta_1$ (PE Q15).

### tf F
A fitted slope of 2 means increasing x by 1 **causes** y to increase by 2.
why: Only if x was randomly assigned. For observational data say "units whose x differs by 1 differ in average y by 2."

### tf F
r = 0.9 means 90% of the variation in y is explained by x.
why: That's R², and $R^2 = r^2 = 0.81$.

### tf F ★
Adding a new data point exactly at $(\bar x, \bar y)$ changes the slope.
why: Its x deviation is 0, so it adds nothing to $\sum(x - \bar x)(y - \bar y)$ or $\sum(x - \bar x)^2$, and the means stay the same. The slope doesn't move.

### tf T ★
If every x value is doubled, the slope is cut in half.
why: Each unit of the new x is half a unit of the old one, so y changes half as much per unit. (r stays the same.)

### tf F
The intercept is the predicted y at the smallest observed x.
why: It's the predicted y at **x = 0**, which may be far outside the data (0 mb for hurricanes).

### num
$\bar x = 10$, $\bar y = 50$, $\hat\beta_1 = 3$. Find $\hat\beta_0$.
answer: 20
why: $\hat\beta_0 = \bar y - \hat\beta_1\bar x = 50 - 30 = 20$.

### num
r = 0.6, $s_x = 2$, $s_y = 10$. Find the slope.
answer: 3
why: $\hat\beta_1 = r\,s_y/s_x = 0.6 \times 10/2 = 3$.

### num
Fitted line $\hat y = 5 + 2x$. A point is (3, 14). Residual?
answer: +3
why: $\hat y = 5 + 6 = 11$. Residual = observed − predicted = 14 − 11 = 3. The point is above the line.

### num ★
r = −0.5. Someone is 2 SDs above average in x. How many SDs from average is their predicted y?
answer: 1 SD below
why: Each SD in x predicts r SDs in y: $2 \times (-0.5) = -1$. Regression to the mean: less extreme than 2.

### num
The fitted line is $\hat y = 20 + 4x$ and $\bar x = 5$. What is $\bar y$?
answer: 40
why: The line passes through $(\bar x, \bar y)$: $20 + 4(5) = 40$.

### num
y is income in dollars and x is years of education. Units of the slope? Of the intercept?
answer: dollars per year; dollars
why: Slope = y units per x unit. Intercept = y units.

### mc d
Which of these does **not** change the correlation?
- a) Swapping which variable is x and which is y
- b) Converting both variables to different units
- c) Adding 10 to every y value
- d) All of the above leave r unchanged
why: r is symmetric, unit-free, and unaffected by shifting.

## The model and slope inference · L08–L09

### tf T
In the SLR model, $Y \mid x \sim N(\beta_0 + \beta_1 x,\ \sigma^2)$.
why: Normal errors with mean 0 and constant variance σ², centered on the population line.

### tf F
The errors are assumed to be $N(0, 1)$.
why: $N(0, \sigma^2)$. σ² is unknown and estimated by $\hat\sigma^2 = \text{SSE}/(n-2)$.

### tf T
Spreading the x values out more gives a more precise slope estimate.
why: $\text{var}(\hat\beta_1) = \sigma^2/[(n-1)s_x^2]$: bigger $s_x$, smaller variance.

### tf F
A steeper fitted line means the slope is estimated more precisely.
why: Precision depends on σ, n and the spread of x, not on the slope's size.

### tf F ★
With only 2 data points you can estimate σ.
why: $\hat\sigma^2 = \text{SSE}/(n-2)$ and n − 2 = 0. Two points always sit exactly on a line, so there's no information about scatter.

### tf T
The slope test uses n − 2 degrees of freedom.
why: Two parameters ($\beta_0$, $\beta_1$) are estimated before you can estimate σ.

### tf F
R's `Pr(>|t|)` column gives a one-sided p-value.
why: It's two-sided (the |t| gives it away). Halve it for a one-sided test when t points the way $H_A$ says.

### tf F
If the 95% CI for $\beta_1$ contains 0, the true slope is 0.
why: 0 is just one **plausible** value. The data can't rule it out, but they can't confirm it either.

### tf F ★
A highly significant slope (p < 0.001) means x and y have a strong relationship.
why: With a big n, even a weak relationship (low R²) can be very significant. Significance ≠ strength.

### num
Estimate = 4.0 and Std. Error = 0.8 for the slope. t value?
answer: 5
why: t = Estimate / SE = 4.0/0.8 = 5.

### num
$\hat\beta_1 = 3$, $\text{se}(\hat\beta_1) = 1$, n = 12. 95% CI? (Use $t_{10} = 2.23$.)
answer: (0.77, 5.23)
why: df = 12 − 2 = 10. $3 \pm 2.23(1)$. 0 isn't inside, so the slope is significant at 0.05.

### num
$\hat\beta_1 = 19.0$, SE = 3.67, n = 80. 99% CI for the slope?
answer: about (9.5, 28.5)
why: df = 78 is beyond the t table, so use $z_{0.995} = 2.58$: $19 \pm 2.58(3.67) = 19 \pm 9.47$.

### num
SSE = 90 with n = 12. Find $\hat\sigma$.
answer: 3
why: $\hat\sigma = \sqrt{\text{SSE}/(n - 2)} = \sqrt{90/10} = 3$.

## Prediction and R² · L10

### tf T
At the same x and confidence level, the prediction interval is wider than the CI for the mean.
why: The PI adds individual scatter: $\sqrt{1 + \tfrac1n + \cdots}$ vs. $\sqrt{\tfrac1n + \cdots}$.

### tf T
CIs and PIs from a regression are narrowest at $x = \bar x$.
why: The $(x^* - \bar x)^2$ term is 0 there.

### tf F
With enough data, the 95% PI shrinks to zero width.
why: The CI does, but the PI's "1 +" term (individual scatter σ) never goes away.

### tf T
A 95% PI at x* should contain about 95% of new individual observations at that x*.
why: That's what it's built for. A CI for the mean would capture far fewer individuals.

### tf F
In simple regression with an intercept, R² can be negative.
why: SSE ≤ SST always (the flat line at ȳ is one option), so $0 \le R^2 \le 1$.

### tf F
R² = 0.8 means the model predicts 80% of the points correctly.
why: It means 80% of the **variation** in y is explained by the linear relationship with x.

### tf F
Adding 100 to every y value changes R².
why: Shifting y moves the line up but leaves every residual and deviation the same.

### tf F ★
If R² = 0, all the points lie on a horizontal line.
why: R² = 0 means the best line is flat (slope 0), not that the points are. They could be scattered, or form a U-shape.

### tf T
If r = 1, every residual is 0.
why: The points lie exactly on an increasing line, so the fitted line hits every one.

### num
SST = 200 and SSE = 50. Find R². If the slope is negative, what is r?
answer: R² = 0.75, r ≈ −0.87
why: $R^2 = 1 - 50/200 = 0.75$. $r = -\sqrt{0.75} \approx -0.866$; the sign comes from the slope.

### num
R² = 0.49 and the slope is negative. Find r.
answer: −0.7
why: $r = -\sqrt{0.49}$.

### mc c ★
You want a much narrower 95% **prediction** interval. Which would help most?
- a) Collect many more data points
- b) Predict at $x^* = \bar x$
- c) Find a predictor that leaves less scatter around the line (smaller σ)
- d) Lower the confidence level from 95% to 94%
why: The PI is dominated by σ. More data and predicting at $\bar x$ only shrink the small "$\tfrac1n + \cdots$" part; (d) barely changes the multiplier.

## Diagnostics and outliers · L11–L12

### tf T
A fan-shaped residual plot (spread grows with x) indicates non-constant variance.
why: The scatter around the line isn't the same at every x.

### tf F
A U-shaped residual plot indicates non-constant variance.
why: A curve means **non-linearity**. The spread can be equal everywhere and the shape still curved.

### tf F
If the errors aren't Normal, $\hat\beta_1$ is biased.
why: Unbiasedness doesn't need Normality. Non-Normal errors affect inference (especially PIs), not the estimates.

### tf T
With non-constant variance, $\hat\beta_0$, $\hat\beta_1$ and predictions are still fine, but CIs and tests are not.
why: Error-assumption violations break inference, not estimation.

### tf F
If linearity fails, the CI for the slope is still valid.
why: If the truth isn't a line, there's no true $\beta_1$ to capture. Everything breaks: estimates, predictions, inference.

### tf F
A Q-Q plot of the residuals checks linearity.
why: It checks **Normality**. Linearity and constant variance are checked with residuals vs. x.

### tf T
Correlated errors are mainly a concern for data collected in a time order.
why: Neighbouring observations in time tend to resemble each other. Check residuals vs. index or lagged residuals.

### tf F ★
A residual plot with random scatter proves the model is correct.
why: It shows no evidence of a problem. That's not proof (e.g., it can't check independence for unordered data).

### tf F
Transforming only x can fix non-constant variance.
why: The uneven spread is in y. Transforming y ($\log y$, $\sqrt y$) shrinks large values more and evens it out.

### tf T
An outlier in y (with a typical x) mostly inflates $\hat\sigma$, giving wider CIs and larger p-values.
why: It barely tilts the line but adds one huge squared residual to SSE.

### tf F
A leverage point (unusual x) always makes the fit worse.
why: If it lies on the true trend it **helps** (more spread in x). Off the trend, it yanks the slope.

### tf F
You should delete any outlier that makes the fit look worse.
why: Only delete impossible or clearly mis-recorded values. Otherwise fit with and without it and compare.

### num
In the model $\log(\hat y) = 2 + 0.1x$, how do predicted y values compare for x values 1 apart?
answer: about 10.5% higher
why: Ratio $= e^{0.1} \approx 1.105$. (Transformations are light on the exam.)

### num
Log–log model with slope 2. If x doubles, what happens to predicted y?
answer: it's 4 times as large
why: Ratio $= 2^{\hat\beta_1} = 2^2 = 4$.

### mc a
The residual plot shows a clear U-shape with even spread. Which assumption is violated?
- a) Linearity
- b) Constant variance
- c) Normality
- d) None
why: A systematic curve = the straight line is the wrong shape. Even spread means constant variance looks fine.

### mc b ★
An observational study finds a significant positive slope between coffee cups per day and lifespan. Best conclusion?
- a) Drinking more coffee causes people to live longer
- b) People who drink more coffee tend to live longer, on average
- c) There is no relationship, because it's observational
- d) The slope is meaningless without an experiment
why: Observational data support **association**, not causation. Confounders (income, health) could explain it, but the association itself is real.

## Practice exams · PE1, 1B, 1C

### tf T
In a simple linear regression model, the expected value of Y when X = x* is $\beta_0 + \beta_1 x^*$. *(PE1 #1)*
why: The population line is the average of Y at each x. Individual Y values scatter around it, but the errors average to 0.

### tf F
The correlation between two variables depends on which variable is labeled X and which is labeled Y. *(PE1 #2)*
why: $r_{xy} = r_{yx}$; the formula is symmetric. The regression **slope** is what changes when you swap roles.

### tf T
If the data are a random sample from a population where the SLR model is true, $\hat\beta_1$ is unbiased: no systematic tendency to be too high or too low. *(PE1 #3)*
why: That's the definition of unbiased: $E(\hat\beta_1) = \beta_1$. Any one sample is off, but on average it's right.

### tf F
If a test fails to reject $H_0: \beta_1 = 0$, you can conclude there is no relationship between X and Y. *(PE1 #4)*
why: Fail to reject ≠ accept (the sample may be too small), and $\beta_1 = 0$ only rules out a **linear** relationship. A strong curve is still possible.

### tf T
For any fitted SLR, $\sum (y_i - \hat y_i)^2 \le \sum (y_i - \bar y)^2$. *(PE1 #5)*
why: The flat line $\hat y = \bar y$ is one possible line, and its SSE is SST. Least squares picks the best line, so SSE ≤ SST and $0 \le R^2 \le 1$.

### tf F
To check $E(\varepsilon) = 0$, compute the mean of the residuals; if it isn't close to 0, the assumptions are violated. *(PE1 #6)*
why: Least squares residuals **always** average exactly 0 (with an intercept), so this check can never detect anything. Look for **patterns** in residual plots instead.

### tf F
A 95% CI for mean sleep is 6.8 to 7.3 hours, so there's a 95% probability the true mean is between 6.8 and 7.3. *(PE1 #7)*
why: μ is fixed: it's in the interval or it isn't. "95%" describes the procedure. Say "95% confident," never "95% probability."

### tf F
One advantage of linear regression is reliable predictions for Y at X values beyond the observed range. *(PE1 #8)*
why: That's extrapolation. There's no evidence the straight-line pattern continues outside the data.

### tf F
When estimating a proportion p, CI widths use the t distribution to account for not knowing the true SD. *(PE1 #9)*
why: Proportion CIs use **z**: $\hat p \pm z\sqrt{\hat p(1-\hat p)/n}$. t is for means when σ is estimated by s (and for regression coefficients).

### tf F
The CLT guarantees that in sufficiently large random samples, the sample **values** approximately follow a normal distribution. *(PE1 #10)*
why: The CLT is about the **sample mean** $\bar X$. The individual data keep their own shape, however many you collect.

### tf F
If X and Y are independent, then $\text{var}(X - Y) = \text{var}(X) - \text{var}(Y)$. *(1B #1)*
why: Variances **add** even for a difference: $\text{var}(X - Y) = \text{var}(X) + \text{var}(Y)$. Subtracting doesn't cancel randomness.

### tf T
For any simple linear regression fit by least squares, the fitted line passes through $(\bar x, \bar y)$. *(1B #2)*
why: $\hat\beta_0 = \bar y - \hat\beta_1\bar x$, so plugging in $\bar x$ gives $\bar y$.

### tf F
Using the same sample, a 99% CI for μ will be narrower than a 95% CI for μ. *(1B #3)*
why: More confidence needs a bigger multiplier (2.58 vs. 1.96), so the 99% interval is **wider**.

### tf F
If a simple linear regression of Y on X has $R^2 = 0$, then X and Y are unrelated. *(1B #4)*
why: $R^2 = 0$ only means no **linear** relationship. A strong curved relationship can still exist.

### tf T
Holding n and σ fixed, collecting data whose x values are more spread out decreases the standard error of $\hat\beta_1$. *(1B #5)*
why: $\text{se}(\hat\beta_1) = \hat\sigma/\sqrt{(n-1)s_x^2}$: a bigger spread in x means a bigger denominator and a smaller SE.

### tf T
The CLT says that for a large enough random sample, the sampling distribution of $\bar X$ is approximately normal, even if the population itself is skewed. *(1B #6)*
why: That's exactly the CLT. Notice it's about $\bar X$, not the data.

### tf F
If the residual plot shows a fan shape (spread increasing with x), then $\hat\beta_0$ and $\hat\beta_1$ are biased. *(1B #7)*
why: Non-constant variance leaves the estimates **unbiased** and predictions fine. It breaks **inference**: CIs, tests and PIs. Only a linearity violation breaks the estimates.

### tf F
As the sample size grows very large, the width of a 95% prediction interval for an individual Y at $X = x^*$ shrinks toward zero. *(1B #8)*
why: The PI has $\hat\sigma\sqrt{1 + \tfrac1n + \cdots}$. The "1" (individual scatter) never goes away, so the width approaches $\pm 1.96\sigma$. Only the CI shrinks to 0.

### tf T
If a two-sided test of $H_0: \beta_1 = 0$ rejects at α = 0.05, then the 95% CI for $\beta_1$ does not contain 0. *(1B #9)*
why: Two-sided tests and CIs at matching levels always agree: the CI contains exactly the values the test would **not** reject.

### tf F
Two regressions are fit to samples of the same size. The one with the smaller p-value for the slope must have the larger estimated slope. *(1B #10)*
why: The p-value depends on $t = \hat\beta_1/\text{se}(\hat\beta_1)$. A small slope with a tiny SE can have a smaller p-value than a large, noisy slope.

### tf T
If $\text{cor}(X, Y) = -1$ and both variables have positive variance, then $\text{var}(X + Y) < \text{var}(X) + \text{var}(Y)$. *(1C #1)*
why: $\text{var}(X+Y) = \sigma_X^2 + \sigma_Y^2 + 2\rho\sigma_X\sigma_Y$, and ρ = −1 makes the last term negative. The two partly cancel.

### tf F
If 10 is added to every x value, both the estimated slope and the estimated intercept change. *(1C #2)*
why: Shifting x leaves the deviations $x - \bar x$ unchanged, so the **slope stays the same**. Only the intercept changes, since $\bar x$ moved.

### tf F
In simple linear regression, a 95% CI for the mean response has the same width at every $x^*$. *(1C #3)*
why: The $(x^* - \bar x)^2$ term makes it narrowest at $\bar x$ and wider farther away.

### tf T
If $X \sim N(\mu, \sigma^2)$, then $P(X \le \mu + 1.64\sigma) \approx 0.95$. *(1C #4)*
why: Standardize: $P(Z \le 1.64) = 0.95$, the 0.95 column of the table. $\mu + z\sigma$ is the percentile formula.

### tf F
The residual standard error $\hat\sigma$ is computed by dividing SSE by $n - 1$ and taking the square root. *(1C #5)*
why: Divide by $n - 2$, because two parameters ($\beta_0$, $\beta_1$) were estimated: $\hat\sigma = \sqrt{\text{SSE}/(n-2)}$.

### tf T
If a 90% CI for $\beta_1$ is (0.2, 1.8), then a two-sided test of $H_0: \beta_1 = 0$ rejects at α = 0.10. *(1C #6)*
why: A 90% CI matches a two-sided test at α = 0.10. 0 is outside the interval, so reject.

### tf T
Removing an outlier with an unusual y value but a typical x value will usually change $\hat\sigma$ much more than $\hat\beta_1$. *(1C #7)*
why: A point near the middle of the x range barely tilts the line, but its huge squared residual dominates SSE, and so $\hat\sigma$.

### tf F
With σ known, doubling the sample size cuts the width of a 95% CI for μ in half. *(1C #8)*
why: Width ∝ $1/\sqrt n$. Doubling n divides it by $\sqrt 2 \approx 1.41$. You need **4×** the data to halve it.

### tf F
A test that rejects $H_0$ at α = 0.05 will also reject $H_0$ at α = 0.01. *(1C #9)*
why: It's the reverse. p = 0.03 rejects at 0.05 but not at the stricter 0.01. Rejecting at 0.01 implies rejecting at 0.05.

### tf F
In a simple linear regression with r = 0.6, 60% of the variation in y is explained by its linear relationship with x. *(1C #10)*
why: $R^2 = r^2 = 0.36$, so 36%.
