---
id: L01
date: 2026-09-14
title: Probability fundamentals
pdf: notes/2026-09-14-probability-fundamentals.pdf
part: Part I
topics: random variables, pmf, pdf, expected value, variance, joint distributions, conditional probability, independence, covariance, correlation
summary: The vocabulary for everything else in the course. Random variables, their distributions, and the numbers that summarize them (mean, variance), then how two variables relate (joint, conditional, independence, covariance, correlation).
takeaways:
- $E(Y) = \sum_y y\,P(Y=y)$ is a probability-weighted average. Think of it as the balancing point of the distribution.
- $\text{var}(X) = E[(X-E(X))^2]$. The SD is $\sqrt{\text{var}}$ and is in the variable's own units; variance is in units squared.
- For a continuous RV, $P(Z = a) = 0$. Probabilities are areas under the pdf between two values.
- Conditional probability: $P(X=x \mid Y=y) = \dfrac{P(X=x, Y=y)}{P(Y=y)}$. Restrict to the column, then rescale so it adds to 1.
- Independent means $P(X \mid Y) = P(X)$, which is equivalent to $P(X=x, Y=y) = P(X=x)P(Y=y)$ for every pair.
- Independent ⇒ $\text{cov}(X,Y) = 0$. Dependence is association, not causation.
- $\rho_{XY} = \dfrac{\text{cov}(X,Y)}{\sigma_X\sigma_Y}$ is always between −1 and 1.
- $E(X+Y) = E(X)+E(Y)$ always. $\text{var}(X+Y) = \text{var}(X)+\text{var}(Y)+2\rho_{XY}\sigma_X\sigma_Y$, which only reduces to the plain sum when they are uncorrelated.
---

## Random events and probability

A **random event** is one whose outcome can't be predicted with certainty, but whose *possible* outcomes we do know. Each outcome has a **probability**, which quantifies how likely it is relative to the others.

The usual way to think about a probability is as a **long-run frequency**: if the random event were repeated many, many times, it's the fraction of times that outcome would come up. $P(\text{heads}) = 0.5$ means that if we flipped the coin many times, it would land heads half the time.

:::def Two conventions
1. Probabilities are between 0 and 1: $0 \le P(A) \le 1$. They can be written as a decimal, fraction, or percentage.
   - $P(A) = 0$ means $A$ will **not** happen. $P(A) = 1$ means it definitely will.
2. The probabilities of all the different outcomes **add up to 1**.
   - $P(\text{rain}) + P(\text{no rain}) = 1$, so $P(\text{rain}) = 70\%$ ⇒ $P(\text{no rain}) = 30\%$.
:::

## Random variables

The result of a random event is a **random variable (RV)**. RVs come in a few kinds:

| Kind | Example RV | Possible values |
|---|---|---|
| Two outcomes | weather tomorrow; side of a flipped coin | rain / no rain; heads / tails |
| Categorical | color of an M&M drawn from a bag | blue, green, red |
| Discrete (numeric) | number of red M&Ms when you draw 3 | 0, 1, 2, 3 |
| Continuous (numeric) | a patient's systolic blood pressure | anything in (70, 200) |

**Discrete** RVs have outcomes you can list (usually integers). **Continuous** RVs can take *any* value in an interval.

:::def Distribution
The **distribution** of a random variable is the set of all its possible values together with their probabilities. If $X$ is the result of a coin flip:

| $x$ | heads | tails |
|---|---|---|
| $P(x)$ | 0.5 | 0.5 |
:::

### Discrete: the probability mass function (pmf)

Let $Y$ = number of tails in 2 flips of a fair coin. Its pmf is

| $y$ | 0 | 1 | 2 |
|---|---|---|---|
| $P(Y=y)$ | 1/4 | 1/2 | 1/4 |

We can draw this as a bar graph with a bar of height $P(Y=y)$ at each value.

### Continuous: the probability density function (pdf)

For a continuous RV like blood pressure, there is **no probability of observing an exact value** like 110. The variable can take any value in an interval and the total probability must be 1, so

$$P(Z = a) = 0, \qquad P(a < Z < b) > 0 \;\; (a \ne b).$$

Instead of bars, the distribution is drawn as a curve (the **pdf**), and the probability of $Z$ falling between two values is the **area under the curve** between them: $P(110 < Z < 120)$ = shaded area from 110 to 120.

## Expected value

The **expected value** is a weighted average of the possible outcomes, weighted by how likely each one is. It tells us what a "typical" value of the variable is.

:::formula Expected value (discrete)
$$E(Y) = \sum_{\text{all } y} y \cdot P(Y=y)$$
:::

:::example Two coin flips
$Y$ = # tails, $Y \in \{0,1,2\}$:
$$E(Y) = 0\cdot\tfrac14 + 1\cdot\tfrac12 + 2\cdot\tfrac14 = 1$$
:::

- This only makes sense for RVs with **numerical** values, not categorical ones.
- For a continuous RV it's the same idea (a probability-weighted average) but you can't add up the sum directly anymore (it becomes an integral).
- Think of $E(Y)$ as the **balancing point** of the distribution: cut the pdf out of a piece of wood and put a fulcrum under it. For a skewed distribution the balancing point is pulled toward the long tail.

## Variance and standard deviation

Two variables can have the same range of values but be more spread out or more concentrated (e.g. # kittens in a litter is spread over 1–7; # mutations in a DNA section is concentrated at 2). **Variance** measures how spread out the values tend to be.

:::formula Variance
$$\text{var}(X) = \sigma_X^2 = E\big[(X - E(X))^2\big] = \sum_x (x - E(X))^2\,P(X=x)$$
It's the expected value of the **squared distance from the mean**.
:::

**Why does this measure spread?** If the likely values of $X$ are all close to $E(X)$, then $(x - E(X))^2$ is small exactly where $P(X=x)$ is big, so the weighted sum is small.

**Why square?** So that deviations above and below the mean are all positive and don't cancel out. Absolute value would also work; squaring isn't fundamentally special, it's just mathematically convenient later on.

:::formula Standard deviation
$$\sigma_X = \text{sd}(X) = \sqrt{\text{var}(X)}$$
Same information as the variance, but in the **same units as the RV**. Variance of # kittens is in kittens²; SD is in kittens.
:::

:::example Two coin flips
$E(Y) = 1$, so
$$\text{var}(Y) = (0-1)^2\cdot\tfrac14 + (1-1)^2\cdot\tfrac12 + (2-1)^2\cdot\tfrac14 = \tfrac14 + 0 + \tfrac14 = \tfrac12$$
:::

## Joint distributions

Sometimes we study more than one RV at once. Your cat is having a kitten: $X$ = fur color, $Y$ = sex.

Separately: $P(M) = P(F) = 0.5$, and $P(\text{orange}) = 5/8$, $P(\text{black}) = 1/8$, $P(\text{multi}) = 2/8$.

But each **pair** $(x, y)$ has its own probability. The set of all pairs and their probabilities is the **joint distribution**:

| | M | F |
|---|---|---|
| orange | 3/8 | 2/8 |
| black | 1/8 | 0 |
| multi | 0 | 2/8 |

All the cells add up to 1. The individual distributions of $X$ and $Y$ are **not** enough to fill in this table (unless $X$ and $Y$ are independent).

Adding across a row gives back the individual probability: orange row $= 3/8 + 2/8 = 5/8 = P(\text{orange})$.

## Conditional probability

*What is the probability the kitten is orange, given that it's a boy?* Look only at the M column, then rescale so that column adds to 1:

:::formula Conditional probability
$$P(X = x \mid Y = y) = \frac{P(X = x,\, Y = y)}{P(Y = y)}$$
:::

:::example Orange given male
$$P(\text{orange} \mid M) = \frac{3/8}{3/8 + 1/8} = \frac34$$
The denominator $P(M)$ is the sum of the M column. Notice $P(\text{orange}) = 5/8 \ne 3/4 = P(\text{orange}\mid M)$: the chance of orange depends on sex.
:::

## Independence

:::def Dependent vs. independent
- **Dependent:** the distribution of one RV changes depending on the value of the other, $P(X \mid Y) \ne P(X)$.
- **Independent:** $P(X \mid Y) = P(X)$. Equivalently, the joint probability **factors**:
$$P(X = x, Y = y) = P(X = x)\,P(Y = y) \quad \text{for every pair}.$$
:::

Kittens: $P(\text{orange}, M) = 3/8$, but $P(\text{orange})P(M) = \tfrac58 \cdot \tfrac12 = \tfrac{5}{16}$. They don't match, so color and sex are **dependent** here.

The same idea applies to numeric RVs. With $X$ = blood pressure and $Y$ = resting heart rate: if they're independent, someone with a low RHR and someone with a high RHR are equally likely to have high blood pressure.

> Dependence is **not** causation. Saying $X$ and $Y$ are dependent only claims an association.

## Covariance and correlation

An association has a **direction** (positive: high BP tends to go with high RHR; negative: high BP with low RHR) and a **strength**.

:::formula Covariance
$$\text{cov}(X,Y) = E\big[(X - E(X))(Y - E(Y))\big] = \sum_{\text{all }(x,y)} (x - E(X))(y - E(Y))\,P(X=x, Y=y)$$
:::

**Why it works:** with a positive association, $X$ and $Y$ tend to be large together (both deviations $> 0$) or small together (both $< 0$). Either way the product is positive, and those pairs have high joint probability, so the sum is mostly big positive numbers. With a weak association the positive and negative products roughly cancel and the covariance is near 0.

- If $X$ and $Y$ are **independent**, $\text{cov}(X,Y) = 0$ exactly.

:::formula Covariance: five ways to compute it
1. **Definition:** $\text{cov}(X,Y) = E\big[(X - E(X))(Y - E(Y))\big]$
   *Use with a joint table:* multiply the two deviations in each cell by that cell's probability, then add.
2. **Shortcut:** $\text{cov}(X,Y) = E(XY) - E(X)\,E(Y)$, where $E(XY) = \sum x\,y\,P(X=x, Y=y)$.
   *Usually the fastest by hand.*
3. **Linear rule:** $\text{cov}(aX + b,\; cY + d) = ac\,\text{cov}(X,Y)$, so $\text{cov}(X,\, aX + b) = a\,\text{var}(X)$.
   *Use when Y is a linear function of X,* like $Y = 2X - 1$ (HW 1 #1c). Added constants don't matter.
4. **From correlation:** $\text{cov}(X,Y) = \rho_{XY}\,\sigma_X\,\sigma_Y$.
   *Use when you're given ρ and the SDs.*
5. **From a variance of a sum:** $\text{cov}(X,Y) = \dfrac{\text{var}(X+Y) - \text{var}(X) - \text{var}(Y)}{2}$.
   *Use when you're given var(X + Y),* like the GRE problem (HW 1 #5a).

Shortcut 2 is the covariance version of $\text{var}(X) = E(X^2) - (E(X))^2$. In fact $\text{cov}(X, X) = \text{var}(X)$.
:::

:::example Same answer three ways (HW 1 #1c)
$P(X = x) = \frac{x+2}{15}$ for $x = 0, 1, 2, 4$, with $E(X) = 7/3$ and $\text{var}(X) = 20/9$. Let $Y = 2X - 1$, so $E(Y) = 11/3$.
- **Linear rule (3):** $\text{cov}(X, 2X - 1) = 2\,\text{var}(X) = 2 \cdot \frac{20}{9} = \frac{40}{9}$.
- **Shortcut (2):** $E(XY) = E(2X^2 - X) = 2\cdot\frac{115}{15} - \frac{35}{15} = 13$, so $\text{cov} = 13 - \frac73\cdot\frac{11}{3} = \frac{117 - 77}{9} = \frac{40}{9}$.
- **Definition (1):** $Y - E(Y) = 2(X - E(X))$, so $E[(X - E(X)) \cdot 2(X - E(X))] = 2\,\text{var}(X) = \frac{40}{9}$.
:::

:::formula Correlation
$$\rho_{XY} = \text{cor}(X,Y) = \frac{\text{cov}(X,Y)}{\sigma_X\,\sigma_Y}, \qquad -1 \le \rho_{XY} \le 1$$
Correlation is covariance rescaled to the range $[-1, 1]$.
:::

## Sums of random variables

:::formula Expected value of a sum (always true)
$$E(X + Y) = E(X) + E(Y)$$
regardless of whether $X$ and $Y$ are dependent or independent.
:::

SAT example: $E(\text{math}) = 500$ and $E(\text{reading}) = 500$ ⇒ $E(\text{total}) = 1000$.

This is **not** always true for variances.

:::formula Variance of a sum
$$\text{var}(X + Y) = \text{var}(X) + \text{var}(Y) + 2\rho_{XY}\,\sigma_X\,\sigma_Y$$
If $X$ and $Y$ are independent ($\rho = 0$), this reduces to $\text{var}(X)+\text{var}(Y)$. With $\text{var}=100^2$ each: $\text{var}(X+Y) = 100^2 + 100^2$.
:::

- **Positively correlated** sections ⇒ totals are **more spread out**. Someone above average on math is likely above average on reading too, pushing the total further from 1000.
- **Negatively correlated** sections ⇒ totals are **less spread out**. Being above average on one tends to be cancelled by being below average on the other.

:::tip Homework link
HW 1 #5(a) gives $\text{var}(M)$, $\text{var}(V)$ and $\text{var}(M+V)$ and asks for the correlation: rearrange the variance-of-a-sum formula to solve for $\rho$.
:::
