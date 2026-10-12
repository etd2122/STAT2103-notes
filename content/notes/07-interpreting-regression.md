---
id: L07
date: 2026-10-05
title: Interpreting linear regression
pdf: notes/2026-10-05-interpreting-regression.pdf
part: Part II
examples: R4
topics: interpreting the slope, interpreting the intercept, prediction, causation, observational study, controlled experiment, extrapolation, sample correlation, slope = r·sy/sx
summary: How to read a fitted line in context. A plugged-in x gives the typical y. The slope compares groups whose x differs, and the intercept is the typical y at x = 0 (often meaningless). Never phrase it as causal from observational data, and don't extrapolate outside the observed x range. The slope also equals r·s_y/s_x.
takeaways:
- $\hat y$ at a given $x$ = the predicted **average / typical** $Y$ for that $x$.
- **Slope:** "For units whose $X$ differs by 1 (or by 100, or 1000), we predict their $Y$ to differ by $\hat\beta_1$ (×100, ×1000) **on average**." Units = units of $Y$ per unit of $X$.
- **Intercept:** typical $Y$ when $X = 0$. Only meaningful if $X = 0$ is possible and within the data (SAT = 0 is not).
- **Don't** say "increasing $X$ increases $Y$" or "$Y$ increases due to $X$". That implies causation. Observational data can't rule out other explanations (confounders); you need a **controlled experiment**.
- **Extrapolation** (predicting at $x$ outside the observed range) is risky because the linear pattern may not continue.
- $\hat\beta_1 = r_{xy}\,\dfrac{s_y}{s_x}$. A 1-SD difference in $x$ predicts an $r_{xy}$-SD difference in $y$.
- The line always passes through $(\bar x, \bar y)$.
---

## Recap

Linear regression is a tool for exploring the relationship between two variables: a **predictor** $X$ and a **response** $Y$. We assume some true linear relationship in the population, which we don't know, and estimate it from data $(x_1,y_1),\dots,(x_n,y_n)$ by finding the line "closest" to the points: the one minimizing $\sum_{i=1}^n (y_i - \hat y_i)^2$.

- Estimated line: $\hat y = \hat\beta_0 + \hat\beta_1 x$ (intercept $\hat\beta_0$, slope $\hat\beta_1$). The point on the line for $x_i$ is $(x_i, \hat y_i)$.
- Population model: $Y = \beta_0 + \beta_1 X + \varepsilon$ with $E(\varepsilon) = 0$, so $E(Y \mid X = x) = \beta_0 + \beta_1 x$.
- So our prediction $\hat y_i$ is our estimate of the **average** or "typical" value of the response for that value of $x$.

## Example: SAT and GPA

Population: $\text{GPA} = \beta_0 + \beta_1\cdot\text{SAT} + \varepsilon$. From a random sample we estimate $\hat\beta_0 = 0.6$, $\hat\beta_1 = 0.0025$.

:::example Plugging in a value
$X = 1000$: $\;0.6 + 0.0025\cdot1000 = 3.1$. According to the model, **on average** we expect people who get 1000 on the SAT to have a first-year GPA of 3.1.
:::

:::example The intercept
Technically the intercept is the typical value of $y$ when $x = 0$: students who scored 0 on the SAT have GPAs of 0.6 on average. That **isn't meaningful**, because the minimum possible SAT score is 400. Depending on context, the intercept may or may not have a useful interpretation.
:::

:::example The slope
$\hat\beta_1 = 0.0025$. For students whose SAT scores differ by 100 points, on average we expect their GPAs to differ by 0.25 points.

There are many ways to phrase this, e.g. "For students whose SAT scores differ by 100 points, we predict their GPAs differ by 0.25 points." Nothing is special about 100; it just makes the numbers a convenient scale.
:::

:::def Don't imply causation
Avoid phrasing like:
- "Increasing SAT score by 100 pts tends to increase GPA by 0.25 pts"
- "A 100 pt increase in SAT score is associated with an 0.25 pt increase in GPA"
- "0.0025 is the increase in GPA due to a 1 pt increase in SAT score"

**Correlation ≠ causation.** SAT scores don't cause GPA; they're associated because both try to measure something about academic performance.
:::

## Example: language acquisition

It won't always be this obvious, and it can be tempting to conclude a causal relationship.

$X$ = # infant-directed words spoken per day (in 1000s), $Y$ = vocabulary size at 24 months. Researchers record audio in 30 households; values range from 1,000 to 12,000 words a day. The fitted line is
$$\hat y = 150 + 17.5x.$$

:::example Interpreting it
- **Prediction:** for infants who hear 8,000 words daily, a typical vocabulary at 24 months would be $150 + 17.5\cdot8 = 290$ words. *(The handwritten notes say 310 here, but $150 + 140 = 290$.)*
- **Intercept:** we'd expect infants who hear **zero** words a day to have a vocabulary of 150 words at 24 months. (But see extrapolation below.)
:::

### Extrapolation

Mathematically you **could** plug in any $x$ and get a $\hat y$. That doesn't mean you **should**. The observed $x$ values ranged from 1k to 12k words/day. 0 or 50k words/day are very different situations, and there's no reason to think the linear relationship extends to **all** values of $x$.

:::def Extrapolation
Making predictions at $x$ values **outside the observed range**. It's often unwise and can lead to flawed conclusions. (In the SAT example this was obvious because scores are constrained to 400–1600.)
:::

### The slope, and why causation is tempting here

$\hat\beta_1 = 17.5$. Unlike SAT/GPA, it seems intuitively plausible that the number of words spoken to an infant directly affects their vocabulary.

| | Phrasing |
|---|---|
| **Don't say** | "We estimate that speaking an extra 1000 words to an infant increases vocabulary size by 17.5 words." (implies speaking the words **causes** the growth) |
| **OK** | "On average, babies know 17.5 more words at age 2 compared to other babies who have 1000 fewer words spoken to them daily." |
| **OK** | "Babies whose infant-directed speech differs by 1000 words tend to have vocabulary sizes that differ by 17.5 words." |

**Why we can't claim causation:** the data came from an **observational study**, so we can't rule out other reasons for the association. For example, maybe language skills are mostly genetic: parents with weaker language skills talk to their babies less, *and* their babies have smaller vocabularies because of the shared genetics. Genetics would then drive both the parent's word count and the infant's vocab size, and having the parent speak 1000 more words a day wouldn't add 17.5 words.

To make a causal conclusion you'd need a **controlled experiment**: families whose **only** difference is the number of infant-directed words, with all other characteristics the same. Then a difference in vocabulary could be attributed to the difference in words.

## The slope in terms of correlation

Mathematically, rearranging the formula for $\hat\beta_1$ gives
$$\hat\beta_1 = \frac{\sum (x_i-\bar x)(y_i-\bar y)}{\sum (x_i-\bar x)^2} = r_{xy}\cdot\frac{s_y}{s_x}$$
where $s_x = \sqrt{S_x^2}$ and $s_y = \sqrt{S_y^2}$ are the sample standard deviations and $r_{xy}$ is the **sample correlation**, the data counterpart of $\text{cor}(X,Y)$:

:::formula Sample correlation
$$r_{xy} = \frac{\sum_{i=1}^n (x_i-\bar x)(y_i-\bar y)}{\sqrt{\sum_{i=1}^n (x_i-\bar x)^2}\,\sqrt{\sum_{i=1}^n (y_i-\bar y)^2}}$$
:::

**Intuition:**
- **Strong positive correlation:** $X$ and $Y$ tend to be big at the same time. If $x_i$ is one SD above $\bar x$, we'd guess $y_i$ is about one SD above $\bar y$.
- **Weak positive correlation:** $X$ and $Y$ are sometimes big together, but not always. If $x_i$ is one SD above $\bar x$, we'd guess $y_i$ is above $\bar y$, but by **less** than one SD.

:::formula What a 1-SD change in $x$ predicts
If $x$ increases by one SD ($\Delta x = s_x$), the prediction changes by
$$\hat\beta_1\cdot s_x = r_{xy}\frac{s_y}{s_x}\cdot s_x = r_{xy}\,s_y$$
- Perfect correlation, $r_{xy} = 1$: $\hat y$ goes up by exactly one SD of $y$.
- $r_{xy} = 0.25$: $\hat y$ goes up by $0.25\,s_y$.
:::

:::tip Homework link
HW 4 #1(h)–(i) is this idea exactly: the change in $\hat y$ for a 1-$s_x$ difference is $r_{xy}s_y$, which is smaller than $s_y$ unless $|r| = 1$. HW 4 #1(f) is an extrapolation question, and #1(g) uses the fact that the line passes through $(\bar x, \bar y)$.
:::
