Fill in the **[brackets]** with the context: the units (fish, storms, plants), the variable names, the numbers and their units. Every interpretation should mention **what** was measured, **on whom**, and **in what units**.

## Regression line

:::template Slope (observational data)
"For [units] whose [x] differs by 1 [x-unit], we predict their [y] to differ by [$\hat\beta_1$] [y-unit], on average."

*Example:* "For hurricanes whose central pressures differ by 1 mb, we predict their max wind speeds to differ by 0.91 knots on average, with the lower-pressure storm faster."

Never write "increasing x causes y to increase" for observational data. Use "differ by."
:::

:::template Slope (randomized experiment)
"Increasing [x] by 1 [x-unit] causes [y] to increase by [$\hat\beta_1$] [y-unit], on average."

Only when x was **randomly assigned** (e.g. nitrogen doses in HW 5).
:::

:::template Intercept
"For [units] with [x] = 0, the predicted average [y] is [$\hat\beta_0$] [y-unit]."

Then say whether that's meaningful: "This isn't meaningful, since [x = 0 is impossible / far outside the observed range of x]."
:::

:::template Predicted value
"For [units] with [x] = [value], the model predicts an average [y] of [$\hat y$] [y-unit]."

If the value is outside the observed range of x, add: "This is extrapolation and may not be reliable."
:::

:::template Residual
"[This unit]'s [y] was [|residual|] [y-unit] [above / below] what the model predicts for its [x]."

Residual = observed − predicted $= y_i - \hat y_i$; positive means above the line.
:::

## Intervals

:::template Confidence interval for a mean or proportion
"We are [95]% confident that the true [average / proportion of] [y] among [population] is between [L] and [U] [units]."

Never "95% probability," and never "95% of [individuals] fall in this range."
:::

:::template Confidence interval for the slope
"We are [95]% confident that [units] whose [x] differs by 1 [x-unit] differ in average [y] by between [L] and [U] [y-unit]."

If 0 is not in the interval, there's evidence of a linear relationship at the matching α.
:::

:::template Confidence interval for the mean response (at x*)
"We are [95]% confident that the true **average** [y] among all [units] with [x] = [x*] is between [L] and [U] [y-unit]."
:::

:::template Prediction interval (one new observation at x*)
"We are [95]% confident that [this specific / a new] [unit] with [x] = [x*] will have [y] between [L] and [U] [y-unit]."

Always wider than the CI at the same x*.
:::

:::template Comparing interval widths
- **Higher confidence level** → wider: "To be more confident, the interval has to cover a wider range."
- **PI vs CI** → PI wider: "It accounts for individual variation around the average, not just uncertainty in the average."
- **Far from $\bar x$** → wider: "We're least certain about the line far from the center of the data."
:::

## Hypothesis tests

:::template Hypotheses
"$H_0$: [parameter] = [value] ([no effect / no change / no linear relationship]). $H_A$: [parameter] [$\ne$ / $>$ / $<$] [value]."

Always about **population** parameters ($p$, $\mu$, $\beta_1$), never $\hat p$, $\bar x$ or $\hat\beta_1$. The direction comes from the research question.
:::

:::template p-value meaning
"If [$H_0$ in words] were true, there would be a [p × 100]% chance of seeing [a sample result / an estimated slope] at least as extreme as ours."

**Not** "the probability that $H_0$ is true."
:::

:::template Conclusion: reject H₀
"Since the p-value ([p]) is less than α = [0.05], we reject $H_0$. There is evidence that [$H_A$ in context, e.g. there is a positive linear association between nitrogen dose and plant biomass]."
:::

:::template Conclusion: fail to reject H₀
"Since the p-value ([p]) is greater than α = [0.05], we fail to reject $H_0$. There is not enough evidence that [$H_A$ in context]."

Never "accept $H_0$" or "prove there's no effect."
:::

## Model quality

:::template R²
"[R² × 100]% of the variation in [y] is explained by its linear relationship with [x]."

A low R² means a weak linear relationship **or** a non-linear one. Check the plot.
:::

:::template Correlation r
"There is a [strong / moderate / weak] [positive / negative] linear association between [x] and [y] (r = [value])."
:::

:::template Residual standard error σ̂
"The observed [y] values typically fall about [$\hat\sigma$] [y-unit] above or below the values predicted by the line."
:::

:::template Describing a scatter plot
"The association between [x] and [y] is [positive / negative], [roughly linear / curved], and [strong / moderate / weak], [with / without] unusual points [describe them]."

Always cover **direction, form, strength, unusual points**.
:::

:::template Diagnosing a residual plot
- **Curve / U-shape:** "The residuals show a systematic [U-shaped] pattern, so the linearity assumption appears violated. Estimates, inference and predictions are not reliable; try transforming x and/or y."
- **Fan shape:** "The spread of the residuals increases with x, so the constant-variance assumption appears violated. The estimates and predictions are still valid, but confidence intervals and hypothesis tests are not."
- **Random scatter:** "The residuals are scattered evenly around 0 with similar spread at all x, so there's no evidence of violated linearity or constant variance."
:::

## Transformed models

:::template log(y) model
"For [units] whose [x] differs by 1 [x-unit], we predict [y] to be [$e^{\hat\beta_1}$] times as large, on average (about [($e^{\hat\beta_1} - 1$) × 100]% [higher / lower])."
:::

:::template log–log model
"For [units] whose [x] is [k] times as large, we predict [y] to be [$k^{\hat\beta_1}$] times as large, on average. Roughly, a 1% difference in [x] goes with a [$\hat\beta_1$]% difference in [y]."
:::

## Probability

:::template Expected value and SD of a random variable
"On average, [X] is [E(X)] [units], and it typically varies from that by about [SD] [units]."
:::

:::template z-score
"[Value] is [z] standard deviations [above / below] the mean."
:::
