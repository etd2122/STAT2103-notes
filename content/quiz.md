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
