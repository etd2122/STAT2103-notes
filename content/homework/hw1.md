---
id: HW1
num: 1
title: Probability review
pdf: assignments/hw1.pdf
lectures: L01, L02
data: scores.csv
topics: expected value, variance, covariance, standardizing, joint distribution, conditional probability, binomial, correlation, histogram
summary: Expected value, variance and covariance from a pmf; what standardizing does; a joint and conditional distribution; a binomial comparison; and correlation from the variance of a sum, then the same idea with real GRE data.
---

### box: Problem 1 · E, var and cov from a pmf
question: $P(X = x) = \frac{x+2}{15}$ for $x = 0, 1, 2, 4$. Find (a) $E(X)$, (b) $\text{var}(X)$, (c) $\text{cov}(X, Y)$ for $Y = 2X - 1$.
code:
```r
x <- c(0, 1, 2, 4)
p <- (x + 2) / 15
sum(p)                      # check: should be 1
EX   <- sum(x * p)          # E(X) = sum of x * P(X = x)
VarX <- sum((x - EX)^2 * p) # var(X) = E[(X - E(X))^2]
```
explain:
- (a) and (b) are the definitions from Sep 14: $E(X) = \sum x\,P(X=x)$ and $\text{var}(X) = \sum (x - E(X))^2 P(X=x)$.
- (c) $Y - E(Y) = 2(X - E(X))$, so $\text{cov}(X, 2X - 1) = 2\,\text{var}(X)$. The "−1" shifts but doesn't change spread.
rknow:
- `x <- c(0, 1, 2, 4)` :: `c()` combines numbers into a **vector**: the list of possible values of X. `<-` stores it under the name `x`.
- `p <- (x + 2) / 15` :: R does the math to **every** element at once (vectorized), so `p` = 2/15, 3/15, 4/15, 6/15. That's the pmf written as a list.
- `sum(p)` :: Adds the probabilities. Prints **1**. If not, the pmf is wrong.
- `sum(x * p)` :: `x * p` multiplies element by element (0·2/15, 1·3/15, …), then `sum` adds them. That's exactly $E(X) = \sum x\,P(X=x)$. Prints **2.333** (= 35/15 = 7/3).
- `sum((x - EX)^2 * p)` :: Distance from the mean, squared, weighted by probability, added up: the definition of variance. Prints **2.222** (= 20/9).
- cov(X, 2X − 1) :: No code needed: $2\,\text{var}(X) = 40/9 \approx 4.44$.
paper: make a table with columns $x$, $p$, $x\cdot p$, $(x - E(X))^2 p$ and add each column. That's all the code is doing.
idea: A pmf is a complete list of outcomes and their chances. Every summary (mean, variance, covariance) is just a weighted average over that list, where the weights are the probabilities.
walk:
- Check that the probabilities add to 1. If they don't, something is mis-copied.
- **E(X)**: multiply each value by its probability and add. Think of it as the balancing point of the bar chart.
- **var(X)**: for each value, measure how far it is from E(X), square it, weight by its probability, and add. It's the *average squared distance from the center*.
- **cov(X, Y)** with $Y = 2X - 1$: Y is just X stretched by 2 and shifted down by 1. Shifting doesn't change how X and Y move together; stretching by 2 doubles it. So cov(X, 2X − 1) = 2·cov(X, X) = 2·var(X).
pitfall:
- Squaring E(X) instead of averaging the squares: $E(X^2) \ne (E(X))^2$.
- Forgetting the shortcut $\text{var}(X) = E(X^2) - (E(X))^2$ exists. Either formula gives the same answer, so use one to check the other.

### box: Problem 2 · Standardizing
question: If $E(X) = \mu$ and $\text{var}(X) = \sigma^2$, find $E\!\left(\frac{X-\mu}{\sigma}\right)$ and $\text{var}\!\left(\frac{X-\mu}{\sigma}\right)$.
explain:
- Write it as $aX + b$ with $a = 1/\sigma$, $b = -\mu/\sigma$.
- Use $E(aX + b) = aE(X) + b$ and $\text{var}(aX + b) = a^2\,\text{var}(X)$ (Sep 16 variance rules).
- This result comes back on Oct 7: standardizing the slope estimator gives a standard Normal.
idea: Subtracting the mean re-centers a variable at 0; dividing by the SD rescales it so its spread is 1. That's what "standardizing" (a z-score) does, for any distribution.
walk:
- Rewrite $\frac{X - \mu}{\sigma}$ as $\frac{1}{\sigma}X - \frac{\mu}{\sigma}$, which has the form $aX + b$.
- Mean: shifting and scaling move the mean the same way, $E(aX+b) = aE(X)+b$. Plug in and the μ's cancel.
- Variance: shifting does nothing to spread, and scaling by $a$ multiplies variance by $a^2$. Plug in and the σ²'s cancel.
- Interpretation: a z-score tells you *how many SDs above or below average* a value is.
pitfall:
- Writing var(aX + b) = a·var(X). The constant gets **squared**.
- Thinking standardizing makes something Normal. It only fixes the center and spread, not the shape.

### box: Problem 3 · Joint and conditional (USB)
question: $W$ = tries to plug in a USB, $P(W = 1, 2, 3) = 0.45, 0.50, 0.05$. $Y = 1$ if it works on the first try. (a) Joint table of $W$ and $Y$. (b) $P(W = 3 \mid Y = 0)$.
explain:
- $Y = 1$ exactly when $W = 1$, so most cells of the joint table are 0. Fill each cell with $P(W = w, Y = y)$; all cells sum to 1.
- (b) Conditional probability: $P(W=3 \mid Y=0) = \dfrac{P(W=3, Y=0)}{P(Y=0)}$. Restrict to the $Y = 0$ row and rescale.
idea: A joint table lists every *combination* of two variables. Conditioning means "zoom into one row or column, then rescale it so it adds to 1."
walk:
- Notice Y is completely determined by W: Y = 1 exactly when W = 1. So many cells in the table must be 0, since impossible combinations get probability 0.
- Fill each cell with P(W = w AND Y = y), and check that all 6 cells sum to 1.
- For P(W = 3 | Y = 0): you already know the first try failed, so throw away the Y = 1 row.
- Within the Y = 0 row, the probabilities don't add to 1 anymore, so divide each by the row total P(Y = 0). That's the conditional probability.
pitfall:
- Using P(W = 3) = 0.05 as the answer. That ignores the information that the first try failed.
- Dividing by the wrong total. Always divide by the probability of what you're *given*.

### box: Problem 4 · Which route?
question: 6 stoplights or 2 stoplights, each stop with $p = 0.5$, independent. Late if you stop at more than half the lights on your route. Which route?
code:
```r
1 - pbinom(3, size = 6, prob = 0.5)   # P(more than 3 of 6)
1 - pbinom(1, size = 2, prob = 0.5)   # P(more than 1 of 2)
```
explain:
- # stops on a route is Binomial($n$ = # lights, $p = 0.5$).
- "More than half" of 6 is $\ge 4$, i.e. $P(Y > 3) = 1 - P(Y \le 3)$. For 2 lights it's $P(Y = 2)$.
- Choose the route with the smaller probability of being late.
rknow:
- `pbinom(3, size = 6, prob = 0.5)` :: **p** = cumulative probability, $P(Y \le 3)$ for $Y \sim \text{Bin}(6, 0.5)$. The first number is the cutoff, `size` is n, `prob` is p.
- `1 - pbinom(3, ...)` :: Flips "≤ 3" into "> 3" (4, 5 or 6 stops). Prints **0.344** (= 22/64).
- `1 - pbinom(1, size = 2, prob = 0.5)` :: $P(Y > 1) = P(Y = 2)$ on the 2-light route. Prints **0.25**.
- Conclusion :: 0.25 < 0.344, so take the **2-light route**.
- `dbinom` vs `pbinom` :: `dbinom(k, n, p)` = $P(Y = k)$ exactly; `pbinom(k, n, p)` = $P(Y \le k)$. "More than k" is always `1 - pbinom(k, ...)`.
paper: $P(Y = k) = \binom{n}{k}p^k(1-p)^{n-k}$. Route A: $(\binom64 + \binom65 + \binom66)/2^6 = (15+6+1)/64 = 22/64$. Route B: $0.5^2 = 0.25$.
idea: Each route is a set of independent yes/no events (stop or not), so the number of stops is Binomial. The question is just which route has the smaller chance of "too many" stops.
walk:
- Route A: n = 6 lights, p = 0.5. Late if stops > 3, i.e. 4, 5 or 6 stops.
- Route B: n = 2 lights, p = 0.5. Late if stops > 1, i.e. both lights.
- Compute each probability: either add up the binomial pmf for those values, or use 1 − P(Y ≤ cutoff).
- Intuition check: with more lights, the *fraction* of red lights tends to be closer to 50% (LLN), so it's harder to hit an extreme fraction like "more than half."
pitfall:
- Using "≥ half" instead of "> half." 3 of 6 is exactly half, so it doesn't count as late.
- pbinom(3, ...) gives P(Y ≤ 3), so the late probability is 1 − pbinom(3, ...), not pbinom(4, ...).

### box: Problem 5 · Correlation of GRE sections, then real data
question: $E(M) = 158$, $\text{var}(M) = 10^2$; $E(V) = 151$, $\text{var}(V) = 8^2$; $\text{var}(M + V) = 15^2$. (a) Find $\text{cor}(M, V)$. (b) With scores.csv: histogram of $d_i = M_i - V_i$, its sample mean and SD, compared to the SDs of $M$ and $V$.
code:
```r
scores <- read.csv("scores.csv")
names(scores)                    # check the column names first
d <- scores$math - scores$verbal # use the actual column names
hist(d, xlab = "math - verbal")
mean(d)
sd(d)
```
explain:
- (a) Rearrange $\text{var}(M+V) = \text{var}(M) + \text{var}(V) + 2\rho\,\sigma_M\sigma_V$ and solve for $\rho$.
- (b) $\text{var}(M - V) = \text{var}(M) + \text{var}(V) - 2\rho\sigma_M\sigma_V$. With positive correlation, differences are **less** spread out than you'd get if the sections were independent.
rknow:
- `read.csv("scores.csv")` :: Loads the data file as a **data frame** (a table: rows = students, columns = variables). The file has to be in your working directory.
- `names(scores)` :: Lists the column names, so you know what to type after `$`.
- `scores$math` :: `$` pulls out **one column** as a vector.
- `scores$math - scores$verbal` :: Subtracts student by student, giving one difference $d_i$ per student.
- `hist(d)` :: Histogram of the differences: shows the shape, center and spread.
- `mean(d)`, `sd(d)` :: Sample mean and sample SD (`sd` divides by n − 1).
- Part (a) result :: $225 = 100 + 64 + 2\rho(10)(8)$, so $\rho = 61/160 \approx$ **0.38**.
- What to compare :: The theory says $\text{var}(M - V) = 164 - 2(0.38)(80) = 103$, so SD ≈ **10.1**. That's about the same as SD(M) = 10, and well below $\sqrt{164} \approx 12.8$, which is what you'd get if the sections were independent. Your `sd(d)` should be in that neighborhood.
paper: you won't be asked to load data, but you can be asked to use $\text{var}(X \pm Y) = \text{var}(X) + \text{var}(Y) \pm 2\rho\,\sigma_X\sigma_Y$ and to solve for ρ.
idea: The variance of a sum isn't just the sum of variances. The extra piece, 2ρσσ, captures whether the two parts move together. Knowing var(M + V) lets you work backwards to the correlation.
walk:
- Write down $\text{var}(M+V) = \text{var}(M) + \text{var}(V) + 2\rho\sigma_M\sigma_V$ and plug in everything you know.
- The only unknown is ρ, so solve for it. Since $15^2 = 225$ is bigger than $10^2 + 8^2 = 164$, ρ must be positive: good math students tend to be good verbal students too.
- For the differences: $\text{var}(M-V) = \text{var}(M) + \text{var}(V) - 2\rho\sigma_M\sigma_V$. A positive ρ now *shrinks* the variance.
- Intuition: if the two scores rise and fall together, their difference stays fairly stable, so the SD of the differences is smaller than you'd expect for independent scores.
pitfall:
- Adding standard deviations: SDs never add, variances do (plus the covariance term).
- Forgetting the sign flips for a difference: + for M + V, − for M − V.

=== wrap-up ===

## Every formula used

:::formula One random variable
- $E(X) = \sum x\,P(X = x)$ (#1a)
- $\text{var}(X) = \sum (x - E(X))^2 P(X = x)$
- Shortcut: $\text{var}(X) = E(X^2) - (E(X))^2$, and $\text{sd}(X) = \sqrt{\text{var}(X)}$ (#1b)
- $E(aX + b) = aE(X) + b$ and $\text{var}(aX + b) = a^2\,\text{var}(X)$ (#1c, #2)
- Standardizing: $Z = \dfrac{X - \mu}{\sigma}$ has $E(Z) = 0$ and $\text{var}(Z) = 1$ (#2)
:::

:::formula Two random variables
- $\text{cov}(X,Y) = E[(X - E(X))(Y - E(Y))]$
- Shortcut: $\text{cov}(X,Y) = E(XY) - E(X)E(Y)$
- Linear rule: $\text{cov}(X, aX + b) = a\,\text{var}(X)$ (#1c)
- Joint table: cell $= P(W = w, Y = y)$; all cells add to 1 (#3a)
- Conditional: $P(A \mid B) = \dfrac{P(A \text{ and } B)}{P(B)}$ (#3b)
- $\rho = \dfrac{\text{cov}(X,Y)}{\sigma_X\sigma_Y}$ and $\text{var}(X \pm Y) = \sigma_X^2 + \sigma_Y^2 \pm 2\rho\,\sigma_X\sigma_Y$ (#5)
:::

:::formula Binomial and data
- $P(Y = k) = \binom{n}{k}p^k(1-p)^{n-k}$; $P(Y > k) = 1 - P(Y \le k)$ (#4)
- Sample mean $\bar d = \frac1n\sum d_i$; sample SD $s = \sqrt{\frac{1}{n-1}\sum (d_i - \bar d)^2}$ (#5b)
:::

## Learning summary

- **Answers:** $E(X) = 7/3$, $\text{var}(X) = 20/9$, $\text{cov}(X, 2X - 1) = 40/9$; standardized Z has mean 0 and variance 1; $P(W = 3 \mid Y = 0) = 0.05/0.55 \approx 0.091$; the 2-light route (0.25 vs. 0.344 chance of being late); $\rho \approx 0.38$ between GRE sections.
- Every summary of a distribution (mean, variance, covariance) is a **probability-weighted average** over the outcomes.
- **Shifting** a variable moves its mean but not its spread. **Scaling** by $a$ multiplies the SD by $\lvert a\rvert$ and the variance by $a^2$. That's why standardizing always gives mean 0 and SD 1.
- **Conditioning** = zooming in on what you know happened, then rescaling so it adds to 1.
- Count of successes in n independent yes/no trials → **Binomial**.
- Variances of sums need the **covariance term**. Positive correlation makes sums more variable and differences less variable.

## What to take away from the R output

:::r Reading the R
- R works on **whole vectors at once**: `x * p` multiplies element by element, so `sum(x * p)` *is* the formula for $E(X)$.
- `sum(p)` returning 1 is a built-in check that the pmf is valid.
- `pbinom(k, n, p)` is always **≤ k**. Any "more than" or "at least" question needs `1 -` in front.
- `data$column` pulls out one variable; subtracting two columns gives one difference **per row** (per student).
- `sd()` is the **sample** SD (divides by n − 1). Compare it to the theory: the SD of $M - V$ should be near $\sqrt{164 - 2(0.38)(80)} \approx 10.1$, smaller than $\sqrt{164} \approx 12.8$ for independent sections.
:::

## Common mistakes

:::tip Watch for these
- $E(X^2) \ne (E(X))^2$. Square first, then average.
- $\text{var}(aX + b) = a^2\,\text{var}(X)$, **not** $a\,\text{var}(X)$; the $+b$ disappears.
- Thinking standardizing makes a variable Normal. It fixes the center and spread, not the shape.
- Using $P(W = 3) = 0.05$ instead of the conditional $P(W = 3 \mid Y = 0)$. Divide by the probability of what you're **given**.
- "More than half" of 6 is 4 or more. 3 of 6 is exactly half and doesn't count.
- Adding SDs instead of variances, or forgetting that the covariance sign flips for $M - V$.
:::
