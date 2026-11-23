---
id: L19
date: 2026-11-23
title: Logistic regression, part 1: odds, log odds and the logistic curve
pdf: notes/2026-11-23-logistic-regression.pdf
part: Part II
topics: logistic regression, binary response, 0 and 1 response, modeling a probability, P(Y = 1 | x), why not linear regression, probabilities outside 0 and 1, logit, log odds, odds, odds ratio, betting odds, 4-to-1, logistic function, S-shaped curve, sigmoid, beta1 not a slope, steepness, beta0 shifts the curve, 50/50 threshold, probability threshold, multiplicative change in odds, exp(beta1), doubling the odds, log(2)/beta1, multiple predictors, holding other predictors constant, voting and income, high school graduation, self-esteem
summary: Until now the response $Y$ was always a **number**. Logistic regression handles a **binary** response (fraud or not, Clinton or Bush). Instead of predicting 0 or 1, it estimates the **probability** $P(Y = 1 \mid x)$. A straight line can't do that: $0.65 - 0.003x$ predicts a **negative** probability at an income of \$225k. The fix is to model the **log odds** $\log\frac{p}{1-p}$, which can be any number, as a linear function of $x$. That's the same as $p = \frac{e^{\beta_0 + \beta_1 x}}{1 + e^{\beta_0 + \beta_1 x}}$, an S-shaped curve that always stays between 0 and 1. $\beta_1$ is no longer a slope on the probability scale: a 1-unit difference in $x$ **adds** $\beta_1$ to the log odds, which **multiplies** the odds by $e^{\beta_1}$. With several predictors, each $e^{\beta_k}$ is the multiplicative difference in odds holding the others constant.
takeaways:
- **Binary response:** $Y = 1$ ("success") or $Y = 0$. Logistic regression estimates $p = P(Y = 1 \mid x)$, not the 0/1 value itself.
- **Why not linear regression:** $\hat p = \hat\beta_0 + \hat\beta_1 x$ isn't constrained to $[0, 1]$, so it can predict negative probabilities or probabilities above 100%, even at realistic $x$ values.
- **Odds** $= \frac{p}{1-p}$: expected number of successes per one failure. $p = 0.5 \to$ odds 1; $p = 0.25 \to 1/3$; $p = 0.9 \to 9$ ("9 to 1"). Odds can be any value $\ge 0$.
- **Log odds** $= \log\frac{p}{1-p}$ (natural log): $p = 0.5 \to 0$; $p < 0.5 \to$ negative; $p > 0.5 \to$ positive. Unconstrained: anything from $-\infty$ to $\infty$.
- **The model:** $\log\frac{p}{1-p} = \beta_0 + \beta_1 x$, equivalently $p = \frac{e^{\beta_0 + \beta_1 x}}{1 + e^{\beta_0 + \beta_1 x}}$. Linear in the log odds, **nonlinear** (S-shaped) in $p$.
- **$\beta_1$:** sign = direction ($> 0$ curve rises, $< 0$ falls); larger $|\beta_1|$ = steeper curve. It is **not** a constant change in probability: the same $\Delta x$ changes $p$ most in the middle of the curve.
- **$\beta_0$:** shifts the curve left or right. It's **not** where the curve crosses the y-axis; $\frac{e^{\beta_0}}{1 + e^{\beta_0}}$ is the predicted probability at $x = 0$.
- **Probability threshold:** to find the $x$ with $\hat p = p^*$, set $\log\frac{p^*}{1-p^*} = \hat\beta_0 + \hat\beta_1 x$ and solve. For $p^* = 0.5$ the left side is 0, so $x = -\hat\beta_0/\hat\beta_1$.
- **Interpretation:** a 1-unit difference in $x$ ↔ log odds differ by $\hat\beta_1$ (additive) ↔ odds differ by a **factor** of $e^{\hat\beta_1}$ (multiplicative). For $\hat\beta_1 = 0.05$: $e^{0.05} \approx 1.051$, about 5.1% higher odds.
- **A difference of $d$** in $x$ multiplies the odds by $e^{\hat\beta_1 d}$. Odds double when $d = \log(2)/\hat\beta_1$.
- **Multiple predictors:** $e^{\hat\beta_k}$ = multiplicative difference in odds for a 1-unit difference in $x_k$, **with the other predictors held the same**.
---

:::tip What's in the file
- **Handwritten notes** (14 pages), part 1 of logistic regression. No R handout yet; the plots on this page are drawn from the formulas in the notes.
- Next lecture (part 2) will presumably cover fitting it in R. A preview of the R syntax is at the bottom, marked "not in the notes."
:::

## A new kind of response

For most of our discussion of linear regression we focused on **quantitative** variables. The response was some numerical quantity, and we modeled it as a linear function of some predictor(s).

| | response $Y$ | predictor $x$ |
|---|---|---|
| so far | quantitative | quantitative, then categorical ([L17](#L17), [L18](#L18)) |
| now | **binary** (two values) | quantitative or categorical |

Last week we used **categorical predictors**, but the response was still quantitative: test scores, days in hospital, calorie intake. Next we model and predict a response $Y$ that is **not numerical**.

**Logistic regression** is a method for modeling **binary** response variables: there are two possible values. Examples:
- Is this credit card transaction fraudulent? (based on amount, location, type of purchase, …)
- Does someone develop a disease?

### Running example: income and vote preference

Conservative parties have historically received more support among voters with higher income. Survey data from **1992**: people were polled on which presidential candidate they preferred in the upcoming election. Discard 3rd-party and no-preference answers, so there are only two options:

$$Y = \begin{cases} 1 & \text{prefer Democrat (Clinton)} \\ 0 & \text{prefer Republican (Bush)} \end{cases} \qquad x = \text{income}$$

**Goal:** predict $Y$ from $x$.

When we make a prediction for some income value $x^*$, what do we actually want to predict? In logistic regression, instead of directly predicting the binary response (0 or 1), we choose to model the **probability** that $Y = 1$.

:::def What logistic regression estimates
$$P(Y = 1 \mid x^*)$$
The method takes a value of $x$ (income) and tells us: based on that value, here is the probability that $Y = 1$. Example: income = 50,000 → $P(\text{prefer Dem}) = P(Y = 1 \mid x = 50)$ = ?
:::

## Why not linear regression?

Suppose we fit a typical linear regression to predict the **probability** someone prefers Clinton, from income ($x$ in \$1000s):

$$\widehat{P}(\text{prefer Dem}) = 0.65 - 0.003x$$

| income | $x$ | $\hat p$ |
|---|---|---|
| \$30,000 | 30 | $0.65 - 0.003(30) = 0.62$ (62%) |
| \$100,000 | 100 | $0.65 - 0.003(100) = 0.35$ (35%) |
| \$225,000 | 225 | $0.65 - 0.003(225) = -0.025$ (**−2.5%**) |

[![Straight line 0.65 − 0.003x falling from 0.65 at x = 0 to below zero; the point at x = 225 is in the shaded region below 0](img/notes/logistic-linear-problem.png)](img/notes/logistic-linear-problem.png)

For someone with that income, we estimate their probability of preferring the Democrat is **negative**. \$225,000 is a high income, but it isn't a wildly unreasonable extrapolation.

:::tip The issue
Probabilities **must** be between 0 and 1, but the linear function $\hat\beta_0 + \hat\beta_1 x$ doesn't have that constraint. A linear model for $\hat p$ can predict negative probabilities or probabilities > 100% **even for values of $x$ that are realistically possible to observe**, not just extreme values that would be extrapolation.
:::

**Want:** $\hat p$ = a function of $x$, **and** $0 \le \hat p \le 1$ guaranteed.

Instead, we need a function of $x$ that is constrained to only give output values between 0 and 1. To achieve this we use a **"logit" transformation**:

$$\hat p = f(\underbrace{\hat\beta_0 + \hat\beta_1 x}_{\text{linear}})$$

Start with a linear function of $x$, then **transform** it to get a quantity that's always between 0 and 1:

$$\hat p = \frac{\exp(\hat\beta_0 + \hat\beta_1 x)}{1 + \exp(\hat\beta_0 + \hat\beta_1 x)}$$

Mathematically, this is the same as using a linear function of $x$ to estimate something called the **"log odds."** So first: what are odds?

## Odds

:::def Odds
For a binary variable $Y$, with $p = P(Y = 1)$:
$$\text{odds} = \frac{p}{1-p} = \frac{P(Y = 1)}{P(Y = 0)}$$
This quantifies how likely the $Y = 1$ outcome is (e.g. a respondent preferring the Democrat) **relative to** the $Y = 0$ outcome: the relative likelihood of the "success" outcome.
:::

| $p$ | odds | meaning |
|---|---|---|
| 0.5 | $\frac{0.5}{0.5} = 1$ | equally likely to prefer the Democrat or the Republican |
| 0.25 | $\frac{0.25}{0.75} = \frac13$ | only a 25% chance of preferring the Democrat |
| 0.9 | $\frac{0.9}{0.1} = 9$ | "9 to 1" |

Unlike probabilities, odds can be **larger than 1**. Odds can take any **nonnegative** value.

**Betting.** If a horse has a 0.8 probability of winning a race, its odds of winning are $0.8/0.2 = 4$, also called "4 to 1" odds of winning. We expect that for every 4 races it wins, it loses 1.

:::def Reading odds
In general, the odds tell us the **expected number of "successes" ($Y = 1$) per one "failure" ($Y = 0$).**

If the odds of preferring the Democrat are 9 to 1 for people at a certain income level, we expect that at that income level there are 9 people who prefer the Democrat for every 1 person who prefers the Republican.
:::

:::tip Odds ≠ probability (not in the notes)
"Odds of 4" does **not** mean a 4% or 40% chance. Convert back with $p = \frac{\text{odds}}{1 + \text{odds}}$: odds 4 → $p = 4/5 = 0.8$; odds 1/3 → $p = (1/3)/(4/3) = 0.25$.
:::

## Log odds

:::def Log odds
$$\text{log odds} = \log\left(\frac{p}{1-p}\right) \qquad \text{(natural log, base } e\text{)}$$
:::

Since $\log(1) = 0$:
- $p = 0.5$ → odds = 1 → $\log\left(\frac{0.5}{1-0.5}\right) = \log(1) = 0$.
- $0 <$ odds $< 1$ ($p < 0.5$) → log odds **negative**.
- odds $> 1$ ($p > 0.5$) → log odds **positive**.

The log odds can take **any** positive or negative value: $-\infty <$ log odds $< \infty$. This quantity is **not constrained**. And in logistic regression, we assume the log odds are a **linear function of $x$**.

:::formula Logistic regression model ★
$$\log\left(\frac{p}{1-p}\right) = \beta_0 + \beta_1 x \qquad\Longleftrightarrow\qquad p = P(Y = 1 \mid x) = \frac{\exp(\beta_0 + \beta_1 x)}{1 + \exp(\beta_0 + \beta_1 x)}$$
Instead of modeling the probability itself as a linear function of $x$, we model the **log odds**, which aren't constrained in value, as a linear function of $x$. This is mathematically equivalent to writing $p$ itself as a **nonlinear** function of $x$, the **"logistic function."**
:::

:::example Why the two forms are the same (you are not responsible for this)
Write $z$ for $p$ and $x$ for the linear part. Claim: $\log\left(\frac{z}{1-z}\right) = x$ is the same as $z = \frac{\exp(x)}{1 + \exp(x)}$.

1. Exponentiate both sides: $\frac{z}{1-z} = \exp(x)$.
2. Take the reciprocal of both sides: $\frac{1-z}{z} = \exp(-x)$, i.e. $\frac1z - 1 = \exp(-x)$, so $1 + \exp(-x) = \frac1z$.
3. So $z = \frac{1}{1 + \exp(-x)}$.
4. Multiply by $\frac{\exp(x)}{\exp(x)}$: $z = \frac{\exp(x)}{\exp(x) + \exp(-x + x)} = \frac{\exp(x)}{\exp(x) + 1}$.
:::

## The logistic curve

What does the logistic function $\frac{\exp(z)}{1 + \exp(z)}$ look like? An **"S"-shaped curve** that flattens out at either end, and is between 0 and 1 everywhere, whatever value we plug in.

[![Black S-curve exp(z)/(1+exp(z)) rising from 0 to 1 and crossing 0.5 at z = 0; red mirror-image curve exp(−z)/(1+exp(−z)) falling from 1 to 0](img/notes/logistic-curve.png)](img/notes/logistic-curve.png)

- **Very large negative** $z$: $\frac{\exp(-100)}{1 + \exp(-100)} \approx \frac{0}{1 + 0} = 0$. The curve is close to **0**.
- **Very large positive** $z$: $\frac{\exp(100)}{1 + \exp(100)} \approx 1$. Close to **1**.
- At $z = 0$: $\frac{1}{1+1} = \frac12$.

If we flipped the sign and plotted $\frac{\exp(-z)}{\exp(-z) + 1}$, the curve would turn **the other way** (red curve).

## How $\beta_0$ and $\beta_1$ shape the curve

The model is $P(Y = 1 \mid x) = \frac{\exp(\beta_0 + \beta_1 x)}{1 + \exp(\beta_0 + \beta_1 x)}$. How do the coefficients control the shape?

:::def β₁ is not exactly a "slope"
The curve is **nonlinear**: for the same difference $\Delta x$ on the x-axis, the corresponding difference on the vertical axis is **not** the same everywhere. In particular, the $y$ values vary **more in the middle part** of the curve. The difference in $y$ for a 1-unit difference in $x$ is **not constant**.

But $\beta_1$ still controls how **steep** the curve is:
- **Large $|\beta_1|$** → steeper curve; small $|\beta_1|$ → flatter curve.
- $\beta_1 > 0$: the curve rises. $\beta_1 < 0$: the curve **flips the other way** (falls).
:::

:::def β₀ is not the "intercept"
The $\beta_0$ value is **not** the $y$ value where the curve crosses the y-axis. Visually, the $\beta_0$ term **shifts the curve left or right**. (This is a less important detail.)
:::

[![Left: curves with β₀ = 0 and β₁ = 3, 1, 0.4 get flatter as β₁ shrinks, all crossing 0.5 at x = 0; β₁ = −1 falls instead. Right: with β₁ = 1, β₀ = 2 shifts the curve left and β₀ = −2 shifts it right](img/notes/logistic-betas.png)](img/notes/logistic-betas.png)

:::tip Where the curve crosses the y-axis (not in the notes)
At $x = 0$ the height is $\frac{e^{\beta_0}}{1 + e^{\beta_0}}$, not $\beta_0$. And the curve passes $p = 0.5$ where $\beta_0 + \beta_1 x = 0$, i.e. at $x = -\beta_0/\beta_1$. With $\beta_1 > 0$, a **larger** $\beta_0$ moves that midpoint **left**.
:::

## Example: graduating high school

High school graduation probability as a function of parents' income.

$$Y = \begin{cases} 1 & \text{graduate HS} \\ 0 & \text{not} \end{cases} \qquad x = \text{parents' income (USD 1,000s)}$$

$$\log\left(\frac{\hat p}{1-\hat p}\right) = -1 + 0.05x \qquad\Longleftrightarrow\qquad \hat p = \frac{\exp(0.05x - 1)}{1 + \exp(0.05x - 1)}$$

[![S-curve of predicted graduation probability vs parents' income: 0.27 at x = 0, 0.50 at x = 20, 0.95 at about x = 79](img/notes/logistic-hs-grad.png)](img/notes/logistic-hs-grad.png)

### $\hat\beta_0 = -1$

If $x = 0$: $\hat p = \frac{\exp(-1)}{1 + \exp(-1)} \approx 0.27$. If parents' income = 0, we predict a **27%** probability of graduating HS.

### The 50/50 income

If we're using this model to predict whether or not a student will graduate, we might want to know what value of $x$ gives a 50/50 prediction.

A probability of 0.5 corresponds to odds of 1 and **log odds of zero**: $\hat p = 0.5 \to \log\left(\frac{0.5}{1-0.5}\right) = \log(1) = 0$. So, using the fitted model, solve for $x$:

$$0 = 0.05x - 1 \;\Rightarrow\; 0.05x = 1 \;\Rightarrow\; x = 20$$

For parents with income of \$20,000, we predict a 50/50 chance the child graduates high school.

### Any other probability level: the 95% threshold

What's the income threshold where we would predict **at least 95%** probability of graduating HS? Want $\hat p \ge 0.95$:

$$\log\left(\frac{0.95}{1-0.95}\right) = 0.05x - 1 \;\Rightarrow\; \underbrace{\log(19)}_{\approx\,3} = 0.05x - 1 \;\Rightarrow\; x \approx 80$$

For income \$80k and above, we predict at least a 95% probability of graduating high school.

:::tip Exact value (not in the notes)
$\log(19) = 2.944$, so $x = 3.944/0.05 = 78.9$. The notes round $\log(19)$ to 3 and get 80. If an exam gives you a calculator, use the exact value; if not, show the setup and the rounding.
:::

:::formula Threshold recipe
To find the $x$ where $\hat p = p^*$:
1. Convert the probability to log odds: $\log\frac{p^*}{1 - p^*}$.
2. Set it equal to $\hat\beta_0 + \hat\beta_1 x$ and solve: $x = \dfrac{\log\frac{p^*}{1-p^*} - \hat\beta_0}{\hat\beta_1}$.
3. For $p^* = 0.5$: $x = -\hat\beta_0/\hat\beta_1$.
:::

## Interpreting $\hat\beta_1$: from log odds to odds

$\hat\beta_1 = 0.05$. Because the log odds are modeled as a **linear** function of $x$, $\hat\beta_1$ is the expected difference in **log odds** for a one-unit difference in $x$:

> 1-unit difference in $x$ → expect a $\hat\beta_1$ (**additive**) difference in log odds.

Log odds aren't the most intuitive thing to think about, though. How can we express this differently?

Two families, family 1 with income $x_1$, family 2 with $x_2 = x_1 + 1$ (a 1-unit difference):

$$\log(\widehat{\text{odds}}_1) = 0.05x_1 - 1$$
$$\log(\widehat{\text{odds}}_2) = 0.05(x_1 + 1) - 1 = \underbrace{(0.05x_1 - 1)}_{\log(\widehat{\text{odds}}_1)} + \underbrace{0.05}_{\hat\beta_1}$$

So $\log(\widehat{\text{odds}}_2) = \log(\widehat{\text{odds}}_1) + 0.05$. The log odds are larger by 0.05 ($\hat\beta_1$) for the family with 1 more unit of income.

Exponentiate both sides (using $e^{a+b} = e^a e^b$):

$$\exp(\log(\widehat{\text{odds}}_2)) = \exp(\log(\widehat{\text{odds}}_1) + 0.05)$$
$$\widehat{\text{odds}}_2 = \exp(\log(\widehat{\text{odds}}_1))\exp(0.05) = \widehat{\text{odds}}_1 \times \exp(0.05)$$

So for kids whose family incomes differ by 1 unit (\$1000), we expect their **odds** of graduating to differ by a **multiplicative factor** of $\exp(\hat\beta_1)$: $\exp(0.05) \approx 1.051$, approximately a **5.1%** difference.

:::formula Interpreting β₁ in logistic regression
| difference in $x$ | log odds | odds |
|---|---|---|
| 1 unit (additive) | differ by $\hat\beta_1$ (additive) | multiplied by $e^{\hat\beta_1}$ |
| $d$ units | differ by $\hat\beta_1 d$ | multiplied by $e^{\hat\beta_1 d}$ |

$e^{\hat\beta_1} > 1$ → higher odds; $e^{\hat\beta_1} < 1$ → lower odds; $e^{\hat\beta_1} = 1$ ($\hat\beta_1 = 0$) → no difference. Percent difference in odds = $(e^{\hat\beta_1} - 1) \times 100\%$.
:::

:::tip Trap: odds, not probability (not in the notes)
"5.1% higher **odds**" is not "5.1% higher **probability**," and not "5.1 percentage points." The change in probability for one more \$1000 depends on where you start on the S-curve: from $x = 20$ ($\hat p = 0.5$) to 21 it's about +1.25 points, from $x = 100$ ($\hat p \approx 0.98$) to 101 it's about +0.1 points. The **odds** change by the same factor everywhere; the probability doesn't.
:::

### What difference in $x$ doubles the odds?

How large a difference in $x$ do we need for the predicted odds to differ by a factor of 2? Let $x_2 = x_1 + d$ and solve for $d$.

If $x$ differs by $d$, the log odds differ by $\hat\beta_1 d$:

$$\log(\widehat{\text{odds}}_2) = \hat\beta_0 + \hat\beta_1(x_1 + d) = (\hat\beta_0 + \hat\beta_1 x_1) + \hat\beta_1 d = \log(\widehat{\text{odds}}_1) + \hat\beta_1 d$$

Exponentiating both sides:

$$\widehat{\text{odds}}_2 = \exp(\log(\widehat{\text{odds}}_1))\exp(\hat\beta_1 d) = \widehat{\text{odds}}_1 \times \exp(\hat\beta_1 d)$$

When $x$ differs by $d$, the predicted odds differ by a **factor** of $\exp(\hat\beta_1 d)$.

We want to double the odds, so set that factor equal to 2:

$$2 = \exp(\hat\beta_1 d) \;\Rightarrow\; d = \frac{\log(2)}{\hat\beta_1} = \frac{\log 2}{0.05} \approx 13.9$$

For a family with \$13,900 more income, we predict their child's odds of graduating are **twice** as high (compared to families with \$13.9k less income).

:::tip Common mistake (not in the notes)
Doubling the odds does **not** need $2 \times$ the income or $2/\hat\beta_1$ more units. Odds multiply, so set $e^{\hat\beta_1 d} = 2$ and take logs. Tripling: $d = \log(3)/\hat\beta_1 = 22.0$. Halving: $d = \log(0.5)/\hat\beta_1 = -13.9$.
:::

## Multiple predictors

Just like linear regression, we can include multiple predictors in logistic regression models.

$$y = \begin{cases} 1 & \text{high self-esteem (self-reported)} \\ 0 & \text{if not} \end{cases} \qquad x_1 = \text{score on reading test}, \quad x_2 = \text{income (\$1000s)}$$

$$\hat p = \frac{\exp(-1 + 0.1x_1 + 0.05x_2)}{1 + \exp(-1 + 0.1x_1 + 0.05x_2)}$$

**$\hat\beta_0 = -1$:** expected probability of high esteem for 0 income and 0 reading score $= \frac{\exp(-1)}{1 + \exp(-1)} \approx 27\%$.

**$\hat\beta_1 = 0.1$:** among people with the **same income**, we estimate a person with 1 more point on the reading test has $\exp(0.1) \approx 1.11$, so about **11% higher odds** of high esteem.

**$\hat\beta_2 = 0.05$:** $\exp(0.05) \approx 1.051$. Among people with the **same reading score**, we expect people with \$1000 higher income to have **5.1% higher odds** of high esteem.

:::formula Coefficients with multiple predictors
The coefficient for each predictor describes the expected **multiplicative** difference in **odds** ($e^{\hat\beta_k}$) for a one-unit (**additive**) difference in that predictor, but the **same values for all the other predictors**.
:::

:::tip Rounding (not in the notes)
$e^{0.1} = 1.1052$, so "about 10.5% higher odds" is the more precise reading; the notes round to 1.11 / 11%. Either is fine if you show $e^{0.1}$.
:::

## R preview (not in the notes)

Part 1 had no R. When you fit this in R, it will look like the code below: `glm` instead of `lm`, with `family = binomial`. The functions `plogis` and `qlogis` do the logistic and log-odds conversions, so you can check every number on this page.

:::r Checking this lecture's numbers in R
```
qlogis(0.5)              # log odds of p = 0.5
# [1] 0
plogis(-1)               # P(Y = 1) when log odds = -1  (HS example, x = 0)
# [1] 0.2689414
(qlogis(0.95) + 1)/0.05  # income where p-hat = 0.95
# [1] 78.88878
exp(0.05)                # odds multiplier for +$1000
# [1] 1.051271
log(2)/0.05              # income difference that doubles the odds
# [1] 13.86294
exp(0.1)                 # reading score, self-esteem example
# [1] 1.105171
```
:::

`plogis(z)` is $\frac{e^z}{1 + e^z}$ (log odds → probability) and `qlogis(p)` is $\log\frac{p}{1-p}$ (probability → log odds).

:::r Fitting a logistic regression (syntax preview)
```
# y must be 0/1 (or a two-level factor)
fit <- glm(y ~ x, data = mydata, family = binomial)
summary(fit)          # Estimates are on the LOG ODDS scale
exp(coef(fit))        # odds multipliers, e^beta
predict(fit, newdata = data.frame(x = 50), type = "response")  # P(Y = 1 | x = 50)
```
:::

Without `type = "response"`, `predict()` returns the **log odds**, not the probability.

## Remember for the test

:::tip On the exam
1. **Say what's modeled:** $P(Y = 1 \mid x)$, through the log odds. Say which outcome is $Y = 1$.
2. **Why not linear:** a line can give $\hat p < 0$ or $> 1$ at realistic $x$.
3. **Convert fluently:** $p \to$ odds $= \frac{p}{1-p} \to$ log odds $= \log\frac{p}{1-p}$; back with $p = \frac{e^{\eta}}{1 + e^{\eta}}$ where $\eta = \hat\beta_0 + \hat\beta_1 x$.
4. **Interpret $\hat\beta_1$ as $e^{\hat\beta_1}$:** "a 1-unit difference in $x$ is associated with odds that are $e^{\hat\beta_1}$ times as large" (multiplicative), never "probability changes by $\hat\beta_1$."
5. **Thresholds:** set log odds of $p^*$ equal to the linear part and solve for $x$. 50/50 ↔ log odds 0.
6. **Odds factor $k$:** $d = \log(k)/\hat\beta_1$.
7. **Multiple predictors:** add "among [units] with the same [other predictors]."
:::
