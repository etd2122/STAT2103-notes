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
idea: The variance of a sum isn't just the sum of variances. The extra piece, 2ρσσ, captures whether the two parts move together. Knowing var(M + V) lets you work backwards to the correlation.
walk:
- Write down $\text{var}(M+V) = \text{var}(M) + \text{var}(V) + 2\rho\sigma_M\sigma_V$ and plug in everything you know.
- The only unknown is ρ, so solve for it. Since $15^2 = 225$ is bigger than $10^2 + 8^2 = 164$, ρ must be positive: good math students tend to be good verbal students too.
- For the differences: $\text{var}(M-V) = \text{var}(M) + \text{var}(V) - 2\rho\sigma_M\sigma_V$. A positive ρ now *shrinks* the variance.
- Intuition: if the two scores rise and fall together, their difference stays fairly stable, so the SD of the differences is smaller than you'd expect for independent scores.
pitfall:
- Adding standard deviations: SDs never add, variances do (plus the covariance term).
- Forgetting the sign flips for a difference: + for M + V, − for M − V.
