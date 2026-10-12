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

### box: Problem 2 · Standardizing
question: If $E(X) = \mu$ and $\text{var}(X) = \sigma^2$, find $E\!\left(\frac{X-\mu}{\sigma}\right)$ and $\text{var}\!\left(\frac{X-\mu}{\sigma}\right)$.
explain:
- Write it as $aX + b$ with $a = 1/\sigma$, $b = -\mu/\sigma$.
- Use $E(aX + b) = aE(X) + b$ and $\text{var}(aX + b) = a^2\,\text{var}(X)$ (Sep 16 variance rules).
- This result comes back on Oct 7: standardizing the slope estimator gives a standard Normal.

### box: Problem 3 · Joint and conditional (USB)
question: $W$ = tries to plug in a USB, $P(W = 1, 2, 3) = 0.45, 0.50, 0.05$. $Y = 1$ if it works on the first try. (a) Joint table of $W$ and $Y$. (b) $P(W = 3 \mid Y = 0)$.
explain:
- $Y = 1$ exactly when $W = 1$, so most cells of the joint table are 0. Fill each cell with $P(W = w, Y = y)$; all cells sum to 1.
- (b) Conditional probability: $P(W=3 \mid Y=0) = \dfrac{P(W=3, Y=0)}{P(Y=0)}$. Restrict to the $Y = 0$ row and rescale.

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
