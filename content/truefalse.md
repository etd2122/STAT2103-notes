Every true/false idea from the Exam 1 practice questions (marked **PE #**), plus the other ways the same idea could be worded. Press **Quiz me** to hide the answers, then tap a card to check it. Yellow cards came straight from the practice exam.

:::tip How to attack true/false
- **Absolute words** ("always," "never," "proves," "guarantees," "any") are usually the trap. Ask whether there's a single exception.
- **Population vs. sample:** hypotheses and "true" values use $\beta_1$, $\mu$, $p$. Estimates use $\hat\beta_1$, $\bar x$, $\hat p$.
- **Probability wording on a CI** ("95% probability μ is in…") is always false.
- **Association ≠ causation** unless x was randomly assigned.
- **"Fail to reject" ≠ "accept."**
:::

## Regression model and the fitted line

<ul class="tf">
<li class="pe"><b class="t">TRUE</b> <span>In SLR, the expected value of Y when X = x* is $\beta_0 + \beta_1 x^*$. <i>(PE #1)</i></span><em>The population line is the average of Y at each x; the errors average to 0.</em></li>
<li><b class="f">FALSE</b> <span>Every individual Y value equals $\beta_0 + \beta_1 x$.</span><em>Individuals scatter around the line by $\varepsilon$; only the average sits on it.</em></li>
<li class="pe"><b class="t">TRUE</b> <span>If the data are a random sample and the SLR model is true, $\hat\beta_1$ is unbiased for $\beta_1$. <i>(PE #3)</i></span><em>$E(\hat\beta_1) = \beta_1$: no systematic tendency to be too high or too low.</em></li>
<li><b class="f">FALSE</b> <span>Unbiased means $\hat\beta_1 = \beta_1$ in every sample.</span><em>Each sample's estimate is off; they're right <b>on average</b> over many samples.</em></li>
<li><b class="t">TRUE</b> <span>The least squares line always passes through $(\bar x, \bar y)$.</span><em>$\hat\beta_0 = \bar y - \hat\beta_1\bar x$, so $\hat y(\bar x) = \bar y$.</em></li>
<li class="pe"><b class="f">FALSE</b> <span>To check $E(\varepsilon) = 0$, compute the mean residual; if it's not near 0, the assumptions are violated. <i>(PE #6)</i></span><em>Least squares residuals (with an intercept) <b>always</b> average exactly 0, so this check can't detect anything.</em></li>
<li class="pe"><b class="f">FALSE</b> <span>Linear regression gives reliable predictions for x values beyond the observed range. <i>(PE #8)</i></span><em>That's extrapolation: no evidence the line continues outside the data.</em></li>
<li><b class="f">FALSE</b> <span>A steeper fitted slope means it is estimated more precisely.</span><em>Precision depends on $\text{var}(\hat\beta_1) = \sigma^2/[(n-1)S_x^2]$: less scatter, more points, more spread in x.</em></li>
<li><b class="f">FALSE</b> <span>Regressing X on Y gives slope $1/\hat\beta_1$.</span><em>The reversed slope is $r^2/\hat\beta_1$, smaller unless the points lie exactly on a line.</em></li>
<li><b class="f">FALSE</b> <span>The intercept is always meaningful.</span><em>Only if x = 0 is possible and inside the observed range.</em></li>
</ul>

## Correlation, R² and sums of squares

<ul class="tf">
<li class="pe"><b class="f">FALSE</b> <span>The correlation depends on which variable is labeled X and which is Y. <i>(PE #2)</i></span><em>$r_{xy} = r_{yx}$: the formula is symmetric. (The <b>slope</b> is not.)</em></li>
<li><b class="t">TRUE</b> <span>Changing units (inches to cm, °F to °C) doesn't change r.</span><em>Correlation has no units. A positive rescaling leaves it unchanged.</em></li>
<li class="pe"><b class="t">TRUE</b> <span>For any fitted SLR, $\sum (y_i - \hat y_i)^2 \le \sum (y_i - \bar y)^2$. <i>(PE #5)</i></span><em>The flat line $\hat y = \bar y$ is one possible line, and least squares picks the best one, so SSE ≤ SST and $0 \le R^2 \le 1$.</em></li>
<li><b class="t">TRUE</b> <span>In simple linear regression, $R^2 = r^2$.</span><em>Both measure the strength of the <b>linear</b> relationship.</em></li>
<li><b class="f">FALSE</b> <span>$R^2 \approx 0$ means X and Y are unrelated.</span><em>The relationship could be strong but curved (salmonella, HW 5).</em></li>
<li><b class="f">FALSE</b> <span>A significant slope or a high $R^2$ shows that X causes Y.</span><em>Observational data show association only. Causation needs random assignment.</em></li>
<li><b class="f">FALSE</b> <span>If $\text{cor}(X,Y) = 0$, X and Y are independent.</span><em>Independent ⇒ cov = 0, but not the reverse: a U-shape can have r = 0.</em></li>
<li><b class="t">TRUE</b> <span>If X and Y are independent, $\text{cov}(X,Y) = 0$.</span><em>That's why variances simply add for independent variables.</em></li>
</ul>

## Hypothesis tests and p-values

<ul class="tf">
<li class="pe"><b class="f">FALSE</b> <span>If a test fails to reject $H_0: \beta_1 = 0$, there is no relationship between X and Y. <i>(PE #4)</i></span><em>Fail to reject ≠ accept (the sample may be too small), and $\beta_1 = 0$ only rules out a <b>linear</b> relationship.</em></li>
<li><b class="f">FALSE</b> <span>The p-value is the probability that $H_0$ is true.</span><em>It's the probability of data at least this extreme <b>if</b> $H_0$ is true.</em></li>
<li><b class="f">FALSE</b> <span>A large p-value proves $H_0$.</span><em>It only means the data aren't strong enough to reject it.</em></li>
<li><b class="t">TRUE</b> <span>If you reject $H_0$ at α = 0.01, you also reject at α = 0.05.</span><em>p < 0.01 means p < 0.05. The reverse isn't guaranteed.</em></li>
<li><b class="t">TRUE</b> <span>If a 95% CI for $\beta_1$ excludes 0, a two-sided test of $\beta_1 = 0$ rejects at α = 0.05.</span><em>CIs and two-sided tests at matching levels agree.</em></li>
<li><b class="f">FALSE</b> <span>Hypotheses can be written in terms of $\hat p$, $\bar x$ or $\hat\beta_1$.</span><em>Always population parameters: $p$, $\mu$, $\beta_1$.</em></li>
<li><b class="f">FALSE</b> <span>R's <code>Pr(&gt;|t|)</code> is the p-value for a one-sided test.</span><em>It's two-sided. Halve it when the estimate points the way $H_A$ says.</em></li>
<li><b class="f">FALSE</b> <span>The p-value changes when you change α.</span><em>Only the cutoff changes. The p-value comes from the data.</em></li>
</ul>

## Confidence and prediction intervals

<ul class="tf">
<li class="pe"><b class="f">FALSE</b> <span>A 95% CI of 6.8 to 7.3 hours means there's a 95% probability the true mean is between 6.8 and 7.3. <i>(PE #7)</i></span><em>μ is fixed: it's in the interval or not. "95%" describes the procedure: 95% of intervals built this way capture μ.</em></li>
<li><b class="f">FALSE</b> <span>95% of individuals fall inside a 95% CI for the mean.</span><em>A CI is about the <b>mean</b>. Individuals need a prediction interval.</em></li>
<li class="pe"><b class="f">FALSE</b> <span>CIs for a proportion use the t distribution to account for not knowing the SD. <i>(PE #9)</i></span><em>Proportion intervals use z. t is for means when σ is estimated by s (and for regression coefficients).</em></li>
<li><b class="t">TRUE</b> <span>Use t instead of z for a mean when σ is unknown and estimated by s.</span><em>Extra uncertainty from estimating σ makes the interval wider. If σ is given, use z.</em></li>
<li><b class="t">TRUE</b> <span>Larger n → narrower CI; higher confidence → wider CI.</span><em>The SE shrinks like $1/\sqrt n$; more confidence needs a bigger multiplier.</em></li>
<li><b class="t">TRUE</b> <span>At the same x and confidence level, a PI is always wider than a CI for the mean response.</span><em>The PI adds individual scatter: $\sqrt{1 + \tfrac1n + \cdots}$ vs. $\sqrt{\tfrac1n + \cdots}$.</em></li>
<li><b class="f">FALSE</b> <span>A PI is always wider than a CI, at any x values.</span><em>At different x values it can't be determined (PE #17).</em></li>
<li><b class="f">FALSE</b> <span>With enough data, a PI shrinks to zero width.</span><em>Individual scatter σ never goes away; only the CI shrinks to 0.</em></li>
<li><b class="t">TRUE</b> <span>CIs and PIs from a regression are narrowest at $x = \bar x$.</span><em>The $(x^* - \bar x)^2$ term is 0 there.</em></li>
</ul>

## Sampling distributions: CLT and LLN

<ul class="tf">
<li class="pe"><b class="f">FALSE</b> <span>The CLT guarantees that in large samples, the sample <b>values</b> are approximately Normal. <i>(PE #10)</i></span><em>The CLT is about the sample <b>mean</b>. The data keep their own shape.</em></li>
<li><b class="t">TRUE</b> <span>For large n, $\bar X$ is approximately Normal whatever the population's shape.</span><em>That's what the CLT says (finite variance needed).</em></li>
<li><b class="t">TRUE</b> <span>$\text{sd}(\bar X) = \sigma/\sqrt n$.</span><em>Averages are less variable than individuals.</em></li>
<li><b class="f">FALSE</b> <span>The LLN says that after a run of heads, tails becomes more likely.</span><em>Trials are independent. The LLN is about long-run averages, not making up for past results.</em></li>
</ul>

## Variance rules

<ul class="tf">
<li><b class="t">TRUE</b> <span>For independent X and Y, $\text{var}(X - Y) = \text{var}(X) + \text{var}(Y)$.</span><em>Subtracting still adds uncertainty (PE #11: SD = √(16 + 9) = 5).</em></li>
<li><b class="f">FALSE</b> <span>$\text{sd}(X + Y) = \text{sd}(X) + \text{sd}(Y)$.</span><em>Variances add (for independent variables), SDs don't.</em></li>
<li><b class="f">FALSE</b> <span>$\text{var}(aX + b) = a\,\text{var}(X) + b$.</span><em>It's $a^2\,\text{var}(X)$: constants added don't change spread.</em></li>
<li><b class="f">FALSE</b> <span>Standardizing a variable makes it Normal.</span><em>It sets mean 0 and SD 1, but keeps the shape.</em></li>
</ul>

## Assumptions, diagnostics and outliers

<ul class="tf">
<li><b class="t">TRUE</b> <span>If the true relationship isn't linear, the estimates, predictions and inference are all unreliable.</span><em>Linearity is the one assumption whose violation breaks everything.</em></li>
<li><b class="t">TRUE</b> <span>With non-constant error variance, $\hat\beta_0$ and $\hat\beta_1$ are still unbiased, but CIs and tests aren't valid.</span><em>Error assumptions (variance, Normality, independence) break inference, not the estimates.</em></li>
<li><b class="f">FALSE</b> <span>A U-shaped residual plot shows non-constant variance.</span><em>A curve shows non-linearity. A fan (spread growing with x) shows non-constant variance (PE Section 3 #5).</em></li>
<li><b class="t">TRUE</b> <span>Normality of the errors is checked with a histogram or Q-Q plot of the residuals.</span><em>A residuals-vs-x plot can't show it.</em></li>
<li><b class="f">FALSE</b> <span>Transforming only x fixes non-constant variance.</span><em>Transform y ($\log y$, $\sqrt y$), which shrinks large values more.</em></li>
<li><b class="t">TRUE</b> <span>An outlier in y (with a typical x) mostly inflates $\hat\sigma$, giving wider CIs and larger p-values.</span><em>It barely moves the slope; a leverage point (unusual x) can move it a lot.</em></li>
<li><b class="f">FALSE</b> <span>You should always remove outliers before fitting.</span><em>Only if impossible or a clear recording error. Otherwise, fit with and without it and compare.</em></li>
</ul>
