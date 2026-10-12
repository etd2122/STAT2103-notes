---
id: R2
key: lln-and-clt
title: Law of Large Numbers and Central Limit Theorem
lecture: L03
topics: set.seed, rnorm, for loop, rep, sampling distribution, hist, curve, dgamma, rgamma, skewed data
summary: Simulations that make the two big theorems visible. Repeatedly sample blood pressures and watch sample averages cluster tighter around 120 as n grows (LLN) and match N(120, 10²/n). Then do the same with skewed income data: individual incomes stay skewed, but the average of 50 incomes looks Normal (CLT).
takeaways:
- The simulation pattern: make an empty vector with `rep(0, reps)`, loop `for (i in 1:reps)`, and store `mean(rnorm(n, ...))` each time. The result is draws from the **sampling distribution** of $\bar X$.
- Larger $n$ → sample means pile up closer to $\mu$ (LLN). With $n = 1000$, BP averages rarely leave 118–122.
- $\bar X$ of Normal data is Normal with SD $\sigma/\sqrt n$. Check by overlaying `dnorm(x, 120, 10/sqrt(5))`.
- CLT: the **data** never become Normal by collecting more of it. The **average** becomes approximately Normal as $n$ grows, even from a skewed population.
- `set.seed()` makes random results reproducible.
---

## Law of Large Numbers

### box: One person vs. an average of five
items: 5-11
what: Population: systolic BP $\sim N(120, 10^2)$. Measure one random person, then the average of 5 random people.
explain:
- `set.seed(6292)` fixes the random number generator so running the chunk again gives the same "random" values. Use it whenever you need reproducible results.
- `rnorm(n = 5, mean = 120, sd = 10)` simulates measuring 5 people.
- `mean(x)` is the sample average, about 126 here. One sample's average doesn't have to equal 120.

### box: Another five people, another average
items: 14-17
what: Draw a new random sample of 5 and average it.
explain:
- No `set.seed` this time, so the values are new: average ≈ 123.
- $\bar X$ is a random variable. Each new sample gives a slightly different value.

### box: Repeat 200 times with a for loop
items: 20-24
key: true
what: Collect 200 different samples of 5 people, store each sample's average, and plot the 200 averages.
explain:
- `rep(0, n_repetitions)` makes a vector of 200 zeros to fill in.
- `for (i in 1:n_repetitions) { ... }` runs the body once for each `i`; `sample_means[i] <- mean(rnorm(...))` stores the i-th average.
- The histogram of `sample_means` is a picture of the **sampling distribution** of $\bar X_5$: centered at 120, spread roughly from 110 to 130.
- `xlim = c(105, 135)` fixes the x-axis so you can compare plots with different $n$.

### box: Samples of 20 people
items: 27-33
what: One sample of 20 people, its average, and then a second sample's average.
explain:
- `print(x)` shows all 20 simulated BPs; `mean(x)` collapses them to one number.
- Averages from samples of 20 (125.7, 121.2) also vary, but less than samples of 5 tend to.

### box: 200 averages of 20 people
items: 35-38
key: true
what: Repeat the 20-person sample 200 times and plot the averages on the same x-axis as before.
explain:
- Compared to $n = 5$, the averages cluster **more tightly around 120**, the population mean.
- That's the variance formula in action: $\text{sd}(\bar X) = 10/\sqrt{20} \approx 2.2$ vs. $10/\sqrt5 \approx 4.5$.

### box: 200 averages of 1000 people
items: 41-42
key: true
what: Same exercise with 1000-person samples.
explain:
- The averages are packed very close to 120; it's rare to see one below 118 or above 122 ($\text{sd} = 10/\sqrt{1000} \approx 0.32$).
- This is the **Law of Large Numbers**: as $n$ grows, $\bar X_n \to \mu$.
- (The code comment still says "20-person" but `n = 1000` is what's actually used.)

## Distribution of the sample average

### box: Simulated averages vs. the theoretical N(120, 10²/5)
items: 48-51
key: true
what: Generate 2000 five-person averages and overlay the Normal pdf with mean 120 and SD $10/\sqrt5$.
explain:
- Because BP is Normal, $\bar X_5 \sim N(120, 10^2/5)$ exactly. The curve matches the histogram.
- `probability = TRUE` scales the histogram to density so it's on the same scale as `dnorm`.
- `curve(dnorm(x, mean = 120, sd = 10/sqrt(5)), add = TRUE)`: the SD of a sample mean is $\sigma/\sqrt n$, not $\sigma$.

## Central Limit Theorem

### box: A skewed population: income
items: 55-56
what: Income has a long right tail. Model it with a distribution with mean 70 and SD 37.4 (thousands of dollars) and plot its pdf.
explain:
- `dgamma` is the density of a gamma distribution, a common skewed distribution. You don't need to know it; it's just a convenient non-Normal population.
- With `shape = 3.5` and `rate = 0.05`: mean = shape/rate = 70 and variance = shape/rate² = 1400, so SD ≈ 37.4.

### box: More data doesn't make the data Normal
items: 58-63
key: true
what: Histograms of 50, 200 and 1000 individual incomes.
explain:
- `rgamma(n, ...)` draws `n` random incomes.
- The histograms stay **skewed** no matter how many people you sample. They just look more like the population pdf.
- The CLT does **not** say individual observations become Normal with enough data.

### box: Average income of 3 people
items: 67-69
what: 1000 repetitions of "sample 3 people, average their incomes."
explain:
- The averages are still noticeably right-skewed. $n = 3$ isn't large enough for the CLT to kick in.

### box: Average income of 10 people
items: 72-74
what: Same with samples of 10.
explain:
- Less skewed, closer to a bell shape. `breaks = 15` uses more bins so the shape is easier to see.

### box: Average income of 50 people vs. the Normal
items: 76-78
key: true
what: Same with samples of 50, then overlay $N(70, 37.4^2/50)$.
explain:
- The histogram of averages now looks Normal even though incomes themselves are skewed. That's the **Central Limit Theorem**: $\bar X_n \approx N(\mu, \sigma^2/n)$ for large $n$.
- `sd = sqrt(20*70/50)` is $\sqrt{1400/50} = 37.4/\sqrt{50} \approx 5.3$.
- `legend("topright", ...)` adds a label; `bty = 'n'` removes the legend's box.
