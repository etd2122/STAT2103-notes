"""Conceptual walkthroughs for each homework box, keyed by (homework file, box title prefix).
Run from repo root: python3 build/concepts.py  (inserts/refreshes idea/walk/pitfall blocks), then build.py."""
import re, os

C = {}

# ---------------------------------------------------------------- HW1
C["hw1.md"] = {
"Problem 1": dict(
 idea="A pmf is a complete list of outcomes and their chances. Every summary (mean, variance, covariance) is just a weighted average over that list, where the weights are the probabilities.",
 walk=["Check that the probabilities add to 1. If they don't, something is mis-copied.",
       "**E(X)**: multiply each value by its probability and add. Think of it as the balancing point of the bar chart.",
       "**var(X)**: for each value, measure how far it is from E(X), square it, weight by its probability, and add. It's the *average squared distance from the center*.",
       "**cov(X, Y)** with $Y = 2X - 1$: Y is just X stretched by 2 and shifted down by 1. Shifting doesn't change how X and Y move together; stretching by 2 doubles it. So cov(X, 2X − 1) = 2·cov(X, X) = 2·var(X)."],
 pitfall=["Squaring E(X) instead of averaging the squares: $E(X^2) \\ne (E(X))^2$.",
          "Forgetting the shortcut $\\text{var}(X) = E(X^2) - (E(X))^2$ exists. Either formula gives the same answer, so use one to check the other."]),
"Problem 2": dict(
 idea="Subtracting the mean re-centers a variable at 0; dividing by the SD rescales it so its spread is 1. That's what \"standardizing\" (a z-score) does, for any distribution.",
 walk=["Rewrite $\\frac{X - \\mu}{\\sigma}$ as $\\frac{1}{\\sigma}X - \\frac{\\mu}{\\sigma}$, which has the form $aX + b$.",
       "Mean: shifting and scaling move the mean the same way, $E(aX+b) = aE(X)+b$. Plug in and the μ's cancel.",
       "Variance: shifting does nothing to spread, and scaling by $a$ multiplies variance by $a^2$. Plug in and the σ²'s cancel.",
       "Interpretation: a z-score tells you *how many SDs above or below average* a value is."],
 pitfall=["Writing var(aX + b) = a·var(X). The constant gets **squared**.",
          "Thinking standardizing makes something Normal. It only fixes the center and spread, not the shape."]),
"Problem 3": dict(
 idea="A joint table lists every *combination* of two variables. Conditioning means \"zoom into one row or column, then rescale it so it adds to 1.\"",
 walk=["Notice Y is completely determined by W: Y = 1 exactly when W = 1. So many cells in the table must be 0, since impossible combinations get probability 0.",
       "Fill each cell with P(W = w AND Y = y), and check that all 6 cells sum to 1.",
       "For P(W = 3 | Y = 0): you already know the first try failed, so throw away the Y = 1 row.",
       "Within the Y = 0 row, the probabilities don't add to 1 anymore, so divide each by the row total P(Y = 0). That's the conditional probability."],
 pitfall=["Using P(W = 3) = 0.05 as the answer. That ignores the information that the first try failed.",
          "Dividing by the wrong total. Always divide by the probability of what you're *given*."]),
"Problem 4": dict(
 idea="Each route is a set of independent yes/no events (stop or not), so the number of stops is Binomial. The question is just which route has the smaller chance of \"too many\" stops.",
 walk=["Route A: n = 6 lights, p = 0.5. Late if stops > 3, i.e. 4, 5 or 6 stops.",
       "Route B: n = 2 lights, p = 0.5. Late if stops > 1, i.e. both lights.",
       "Compute each probability: either add up the binomial pmf for those values, or use 1 − P(Y ≤ cutoff).",
       "Intuition check: with more lights, the *fraction* of red lights tends to be closer to 50% (LLN), so it's harder to hit an extreme fraction like \"more than half.\""],
 pitfall=["Using \"≥ half\" instead of \"> half.\" 3 of 6 is exactly half, so it doesn't count as late.",
          "pbinom(3, ...) gives P(Y ≤ 3), so the late probability is 1 − pbinom(3, ...), not pbinom(4, ...)."]),
"Problem 5": dict(
 idea="The variance of a sum isn't just the sum of variances. The extra piece, 2ρσσ, captures whether the two parts move together. Knowing var(M + V) lets you work backwards to the correlation.",
 walk=["Write down $\\text{var}(M+V) = \\text{var}(M) + \\text{var}(V) + 2\\rho\\sigma_M\\sigma_V$ and plug in everything you know.",
       "The only unknown is ρ, so solve for it. Since $15^2 = 225$ is bigger than $10^2 + 8^2 = 164$, ρ must be positive: good math students tend to be good verbal students too.",
       "For the differences: $\\text{var}(M-V) = \\text{var}(M) + \\text{var}(V) - 2\\rho\\sigma_M\\sigma_V$. A positive ρ now *shrinks* the variance.",
       "Intuition: if the two scores rise and fall together, their difference stays fairly stable, so the SD of the differences is smaller than you'd expect for independent scores."],
 pitfall=["Adding standard deviations: SDs never add, variances do (plus the covariance term).",
          "Forgetting the sign flips for a difference: + for M + V, − for M − V."]),
}

# ---------------------------------------------------------------- HW2
C["hw2.md"] = {
"Problem 1": dict(
 idea="A model is a simplification. The question isn't whether GRE scores are *exactly* Normal (they can't be, since they're capped at 130–170), but whether Normal is a *good enough* approximation.",
 walk=["Overlaying the pdf on the histogram is a visual check: does the bell curve trace the bar heights? Use `probability = TRUE` so both are on the same scale.",
       "Simulating 3000 draws from N(151, 8²) shows what the model *predicts*: what fraction it would put below 130 or above 170.",
       "Compare: the real test makes those fractions exactly 0. If the model only puts a tiny sliver out there, the mismatch barely matters.",
       "Conclude: not literally Normal (impossible values exist under the model), but a reasonable approximation if the overlay fits and the tails are tiny."],
 pitfall=["Saying \"not Normal, so the model is useless.\" Almost no real data is exactly Normal.",
          "Comparing a count histogram to a density curve. Without `probability = TRUE` the curve looks flat."]),
"Problem 2": dict(
 idea="Every \"how many out of n\" question with a fixed success chance is a binomial. The trick is translating the words into the right inequality.",
 walk=["(a) \"At least one\" is easiest as 1 − P(none). P(none) is just $(1 - 0.16)^4$.",
       "(b) 20% of 30 is 6, so you want P(Y ≥ 6) = 1 − P(Y ≤ 5).",
       "(c) Think backwards: as n grows, P(at least 2) grows. Try n = 1, 2, 3, … until it first reaches 0.75. R can try all n at once.",
       "Sanity-check (c): the expected count is 0.16n, so you'd guess n needs to be big enough that 0.16n is comfortably above 2."],
 pitfall=["Off-by-one: P(Y ≥ 6) is 1 − pbinom(5), not 1 − pbinom(6).",
          "Treating \"at least 20%\" as exactly 20%."]),
"Problem 3": dict(
 idea="\"Probability of running out ≤ 5%\" means stocking enough to cover the consumption 95% of the time, which is the 95th percentile. For a week, add up 7 independent days, and the total is less variable *relative to its mean* than a single day.",
 walk=["Running out = consumption > amount stocked. You want P(consumption > amount) = 0.05, so the amount is the 95th percentile, `qnorm(0.95, ...)`.",
       "For 7 days, the total is a sum of 7 independent Normals, so it's Normal too.",
       "Its mean is 7 × 400. Its **variance** is 7 × 20² (variances add), so the SD is √7 × 20 ≈ 53, not 7 × 20 = 140.",
       "Notice the weekly buffer above the mean (about 1.645 × 53 ≈ 87 g) is much less than 7 × the daily buffer (7 × 33 ≈ 230 g). High and low days partly cancel."],
 pitfall=["Using SD = 7 × 20. That would assume every day is high or low together (perfect correlation).",
          "Using qnorm(0.05, ...): that's the amount you'd run *out* of 95% of the time."]),
"Problem 4": dict(
 idea="This problem previews hypothesis testing and confidence intervals. First ask \"if p were really 0.5, how surprising is 56 of 90?\", then build the range of p values the data supports.",
 walk=["(a) If p = 0.5, the expected count is np = 45. You saw 56, which is 11 more.",
       "(b) How unusual is 56 or more if p = 0.5? That's P(Y ≥ 56) = 1 − P(Y ≤ 55). A small number means 56 would be surprising.",
       "(c) Now flip it: use $\\hat p = 56/90$ and the ±2 SE recipe to get a range of plausible p values.",
       "(d) Two angles, one answer: is 0.5 inside your interval? Is (b) small? If 0.5 is outside and (b) is tiny, the data don't support p = 0.5."],
 pitfall=["Using p = 0.5 in the SE for the confidence interval. The CI uses $\\hat p$, because you don't know p.",
          "Concluding that warmer oceans caused the change. The data can show p ≠ 0.5, but not why."]),
}

# ---------------------------------------------------------------- HW3
C["hw3.md"] = {
"Problem 1": dict(
 idea="A confidence interval is estimate ± (how many SEs) × SE. With only 9 athletes and an estimated SD, you need the t distribution, which is wider than the Normal, to stay honest about the extra uncertainty.",
 walk=["Estimate: the sample mean, 188.",
       "SE: how much a mean of 9 bounces around, $s/\\sqrt n = 7.2/3 = 2.4$.",
       "Multiplier: 90% in the middle leaves 5% in each tail, so use the 95th percentile of t with n − 1 = 8 df.",
       "Interval = 188 ± multiplier × 2.4. Interpret it as a range for the **true average** heart rate of triathletes while swimming.",
       "(b) t, because σ is unknown and replaced by s. With n = 9 that substitution adds noticeable uncertainty."],
 pitfall=["Using `qt(0.90, ...)` for a 90% interval. You need 0.95, because the 10% is split into two tails.",
          "Saying \"90% of triathletes have heart rates in this interval.\" The CI is about the mean, not individuals."]),
"Problem 2": dict(
 idea="Linear transformations of a Normal stay Normal. Standardizing just picks the specific transformation that lands on mean 0, SD 1.",
 walk=["Family: Z is a linear function of a Normal, so Z is Normal.",
       "Parameters: from HW 1 #2, E(Z) = 0 and var(Z) = 1.",
       "So Z ~ N(0, 1), the standard Normal. That's why one table (or `pnorm` with defaults) works for every Normal."],
 pitfall=["Only giving the mean and variance. The question also asks for the **type** of distribution."]),
"Problem 3": dict(
 idea="A hypothesis test asks: \"if nothing changed, how weird is what we saw?\" Here, \"nothing changed\" means the breakage rate is still 8%, and we're only interested in evidence that it went **down**.",
 walk=["Set up: $H_0: p = 0.08$ (new packaging is no better) vs. $H_A: p < 0.08$. One-sided, because the manufacturer only cares about improvement.",
       "Observed: 16/300 ≈ 5.3%, lower than 8%. But is that lower than random chance would explain?",
       "Under $H_0$, $\\hat p$ has SD $\\sqrt{0.08 \\cdot 0.92/300}$. Count how many SDs below 0.08 your 5.3% is: that's z.",
       "The p-value is the area **below** z (lower tail): the chance of a result this low or lower if the packaging didn't help.",
       "Decide at 0.05, then translate: \"There is / isn't enough evidence that the new packaging reduces breakage.\""],
 pitfall=["Using $\\hat p$ in the SD. In a test you assume $H_0$, so use $p_0 = 0.08$.",
          "Doubling the p-value. This test is one-sided."]),
"Problem 4": dict(
 idea="Same logic as #3, but for a mean, two-sided (\"has it changed?\"), and with σ known, so use the Normal. It also shows that the same evidence can lead to different decisions at different α.",
 walk=["$H_0: \\mu = 20$, $H_A: \\mu \\ne 20$. \"Changed\" could mean up or down.",
       "SE of the mean = $3/\\sqrt{40}$. z = (18.9 − 20) / SE.",
       "Two-sided p-value: the area in *both* tails beyond |z|, i.e. 2 × the lower tail.",
       "Compare that **one** p-value to 0.05 and to 0.01. A stricter threshold (0.01) demands stronger evidence, so you may reject at one level but not the other."],
 pitfall=["Using t: σ = 3 is given as known, so use the Normal.",
          "Thinking the p-value changes with α. Only the cutoff changes."]),
"Problem 5": dict(
 idea="Your first regression: summarize how 0–60 time changes with weight using the line that minimizes squared vertical misses, then use the line to predict.",
 walk=["Plot first, always. Weight (the predictor) goes on x, acceleration time (the response) on y. Does it look roughly linear? Which direction?",
       "Fit with `lm(time ~ weight)`. The slope is the average change in time per extra pound; the intercept is where the line crosses weight = 0.",
       "Predict at 4315 lbs by plugging into $\\hat y = \\hat\\beta_0 + \\hat\\beta_1 x$. Check that 4315 is within your weight range, so you're not extrapolating."],
 pitfall=["Swapping x and y in `lm()`. The formula is `response ~ predictor`.",
          "Over-reading the intercept: a 0-lb car doesn't exist."]),
}

# ---------------------------------------------------------------- HW4
C["hw4.md"] = {
"Problem 1(a)": dict(
 idea="The least squares line is the single straight line that makes the total squared vertical distance from the points as small as possible. It's the best linear summary of how wind speed changes with pressure.",
 walk=["Decide roles: pressure is the predictor (x), wind speed the response (y).",
       "Fit the line with `lm()`. R finds $\\hat\\beta_0, \\hat\\beta_1$ using the formulas from Sep 30.",
       "Plot the data, then add the line. Check that it actually runs through the middle of the cloud of points."],
 pitfall=["Plotting the line before the scatter plot. `abline()` only draws on an existing plot."]),
"Problem 1(c)": dict(
 idea="The slope compares **groups of storms**: how much faster, on average, are storms with 1 mb lower pressure? The units tell you what the numbers mean.",
 walk=["Slope: about −0.9. Storms whose pressures differ by 1 mb have max winds that differ by about 0.9 knots on average, with the lower-pressure storm faster.",
       "Units: slope = response units per predictor unit = knots per mb. Intercept = response units = knots.",
       "Intercept = predicted wind at 0 mb. No hurricane is anywhere near 0 mb, so it's a mathematical anchor for the line, not a meaningful prediction."],
 pitfall=["Causal wording: \"lowering pressure increases wind speed.\" This is observational data, so say \"differ by.\"",
          "Forgetting the negative sign in the interpretation."]),
"Problem 1(e)": dict(
 idea="A regression line is only trustworthy where you have data. Inside the observed range you're interpolating; outside it you're guessing that the straight-line pattern continues.",
 walk=["Plug 945 into the line. 945 is inside the observed pressures (about 919–993), so it's a reasonable prediction.",
       "Plug 750 into the line. You'll get a number, but 750 is far below anything observed.",
       "Ask: is there any reason to believe the relationship is still a straight line out there? No data means no evidence. That's **extrapolation**."],
 pitfall=["Saying the 750 prediction is fine because R computed it. R will compute anything."]),
"Problem 1(g)": dict(
 idea="The least squares line always passes through the \"center of mass\" of the data, the point $(\\bar x, \\bar y)$. It's built into the intercept formula.",
 walk=["Compute $\\bar x$ (average pressure) and plug it into the line.",
       "Compare with $\\bar y$ (average wind speed). They match.",
       "Why: $\\hat\\beta_0 = \\bar y - \\hat\\beta_1\\bar x$, so $\\hat y(\\bar x) = \\bar y - \\hat\\beta_1\\bar x + \\hat\\beta_1\\bar x = \\bar y$."],
 pitfall=[]),
"Problem 1(h)": dict(
 idea="This is **regression to the mean**. A storm 1 SD more extreme in pressure is predicted to be less than 1 SD more extreme in wind, by a factor of |r|.",
 walk=["Change in prediction for a 1-SD change in x: $\\hat\\beta_1 s_x$.",
       "Because $\\hat\\beta_1 = r\\,s_y/s_x$, that equals $r\\,s_y$.",
       "Since |r| < 1, the predicted difference is smaller than $s_y$. The line \"pulls\" predictions toward the average.",
       "Only if the points fell perfectly on a line (|r| = 1) would a 1-SD change in x predict a full 1-SD change in y."],
 pitfall=["Dropping the sign. The difference is negative here, so lower pressure means faster wind."]),
"Problem 1(j)": dict(
 idea="A residual is how far reality landed from the line's prediction: observed − predicted. It measures one storm's \"surprise.\"",
 walk=["Predict Harvey's wind from its pressure (937 mb).",
       "Subtract the prediction from Harvey's actual 115 knots.",
       "Interpret the sign: positive means Harvey was stronger than a typical 937-mb storm; negative means weaker."],
 pitfall=["Computing predicted − observed. The convention is observed − predicted."]),
"Problems 2": dict(
 idea="How precisely you can pin down a slope depends on three things: how noisy the points are around the line, how many points you have, and how spread out the x values are. Think of balancing a ruler on points: a wide base and tight points make it steady.",
 walk=["Use $\\text{var}(\\hat\\beta_1) = \\dfrac{\\sigma^2}{(n-1)S_x^2}$. Smaller is more precise.",
       "Less vertical scatter around the line (small σ²) gives a more precise slope.",
       "More points (bigger n) gives a more precise slope.",
       "x values spread over a wider range (bigger $S_x^2$) give a more precise slope: a long lever is easier to tilt correctly than a short one.",
       "For each pair of plots, find which of these three differs and name it in your answer."],
 pitfall=["Judging by how steep the line looks. Steepness is the slope's value, not its precision."]),
}

# ---------------------------------------------------------------- HW5
C["hw5.md"] = {
"Problem 1(a)": dict(
 idea="Start every regression problem by looking. The scatter plot tells you whether a straight line is even a sensible summary before any numbers are computed.",
 walk=["Nitrogen (what the researchers controlled) goes on x; biomass (the outcome) goes on y.",
       "Fit the least squares line and add it to the plot.",
       "Describe four things: **direction** (up or down), **form** (straight or curved), **strength** (tight or scattered), and **unusual points**.",
       "Here: positive, roughly linear, moderate (r ≈ 0.65), with a few plants well above or below the line."],
 pitfall=["Giving only one feature (e.g. just \"moderate\"). Direction and form matter too.",
          "Putting a written answer inside an R chunk, which breaks rendering."]),
"Problem 1(c)": dict(
 idea="The test asks: if nitrogen truly had no linear effect (slope 0), how likely is a sample slope as large as ours? Because the researchers only care about nitrogen *helping*, the test is one-sided.",
 walk=["Hypotheses: $H_0: \\beta_1 = 0$ (no linear effect) vs. $H_A: \\beta_1 > 0$ (more nitrogen, more biomass). The direction comes from the research question, not the data.",
       "Measure the estimate in SE units: $t = \\hat\\beta_1/\\text{se}(\\hat\\beta_1) \\approx 0.389/0.093 \\approx 4.16$. The slope is about 4 SEs above 0.",
       "p-value: the area above 4.16 in a t distribution with n − 2 = 24 df, about 0.00018. R's `summary()` shows the two-sided value, so halve it or use `1 - pt()`.",
       "Decision: 0.00018 < 0.05, so reject $H_0$.",
       "Meaning: because doses were **randomly assigned**, this is an experiment, so you can say more nitrogen **causes** more growth, not just that they're associated."],
 pitfall=["Reporting `summary()`'s Pr(>|t|) for a one-sided test. That's two-sided.",
          "Interpreting p as \"the probability H₀ is true.\" It's the probability of data this extreme *if* H₀ were true."]),
"Problem 1(f)": dict(
 idea="The CI gives the range of slope values consistent with the data. It answers \"how big is the effect?\", which the p-value doesn't.",
 walk=["`confint(fit, level = 0.90)` returns estimate ± t-multiplier × SE for each coefficient. Use the nitrogen row.",
       "The interval is about 0.23 to 0.55 g per mg.",
       "Interpret in context: plants whose doses differ by 1 mg differ in average biomass by between 0.23 and 0.55 g.",
       "Connection: the interval doesn't include 0, which agrees with rejecting $H_0$."],
 pitfall=["Rounding 0.2288 down to 0.22. Round to 0.23.",
          "Interpreting it as a range for individual plants. It's about the average difference."]),
"Problem 2(a)": dict(
 idea="\"The average storm at 959 mb\" is one fixed, unknown number: the height of the true line at 959. The confidence interval brackets that number. The only uncertainty is that our line came from 62 storms, not every storm.",
 walk=["Point estimate: plug 959 into the fitted line, about 92.7 knots.",
       "The CI adds ± (t-multiplier × SE of the line's height at 959).",
       "95% vs 99%: same center, but to be more sure you must reach further, so the 99% interval is wider.",
       "Write the sentence: \"We are 95% confident the true **average** max wind speed of hurricanes at 959 mb is between __ and __ knots.\""],
 pitfall=["Leaving out the interpretation sentence.",
          "Thinking a higher confidence level moves the center. It only stretches the width."]),
"Problem 2(c)": dict(
 idea="Isaias is one specific storm. Even if we knew the true average perfectly, Isaias could be well above or below it. The prediction interval covers both kinds of uncertainty: where the line is, *plus* how much individual storms scatter.",
 walk=["Same point estimate as (a): 92.7 knots. Your best guess for one storm is still the average.",
       "Width: storm-to-storm scatter (residual SE ≈ 11 knots) dominates, giving roughly ±22 knots vs ±3 for the CI.",
       "Everyday analogy: you can estimate the average height of 20-year-olds to within a fraction of an inch, but the next person who walks in could be several inches off.",
       "Write: \"We are 95% confident that Hurricane Isaias's max wind speed is between __ and __ knots.\""],
 pitfall=["Using `interval = \"confidence\"` for a single storm.",
          "Expecting more data to shrink the PI to zero. Individual scatter never goes away."]),
"Problem 2(d)": dict(
 idea="Run the line backwards: instead of \"given pressure, predict wind,\" ask \"what pressure gives a prediction of 115?\" Then see how interval width depends on *where* you predict.",
 walk=["Solve $115 = \\hat\\beta_0 + \\hat\\beta_1 x$ for x: about 934 mb. The slope is negative, so a faster storm needs lower pressure.",
       "Build the 95% PI at 934 mb.",
       "Compare widths: intervals are narrowest at $\\bar x$ (≈ 961 mb) and widen as you move away, because a slightly-off slope matters more far from the center (think of a seesaw pivoting at $\\bar x$).",
       "959 is right next to $\\bar x$; 934 is about 27 mb away, so its interval is slightly wider. Only slightly, because individual scatter is the same everywhere and dominates the width."],
 pitfall=["Saying the interval is wider \"because 115 is a bigger number.\" Width depends on distance of x from $\\bar x$, not on the size of y.",
          "Long code lines running off the PDF page. Break them across lines."]),
"Problem 3(a)": dict(
 idea="This problem is designed to break the habit of trusting R² blindly. The pattern is strong but curved, so a straight line misses it entirely.",
 walk=["Plot first: an upside-down U. Density rises to a peak near 40°C, then falls.",
       "The fitted line is nearly flat (about 3.3), because the rising half and the falling half cancel out.",
       "Describe: a strong, **non-linear** association, with no single direction."],
 pitfall=["Calling the association \"weak\" because the line is flat. The *line* is weak; the relationship is strong."]),
"Problem 3(c)": dict(
 idea="R² measures how much better the **straight line** predicts than just guessing the average every time. A low R² can mean a weak relationship **or** the wrong shape of model. You need the plot to know which.",
 walk=["R² ≈ 0.0001: the line explains about 0.01% of the variation in density, basically nothing.",
       "(d) This **linear model** is not useful: it predicts about 3.3 at every temperature and misses by about 2.9 on average (the residual SE).",
       "(e) **Temperature** is very useful. Following the curve, density is about 1 at 10°C, about 8 at 40°C and about 1 at 65°C. A curved model would capture it.",
       "The lesson: R² and correlation only measure *linear* association. Always look at the scatter plot before concluding a variable doesn't matter."],
 pitfall=["Answering (d) and (e) the same way. One asks about the model, the other about the variable.",
          "Saying R² ≈ 0 means temperature and salmonella are unrelated."]),
}

def emit(d):
    out = [f"idea: {d['idea']}", "walk:"] + [f"- {w}" for w in d["walk"]]
    if d.get("pitfall"):
        out += ["pitfall:"] + [f"- {p}" for p in d["pitfall"]]
    return out

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
for fn, boxes in C.items():
    path = os.path.join(root, "content", "homework", fn)
    lines = open(path, encoding="utf-8").read().split("\n")
    # strip old concept blocks
    clean, skip = [], False
    for ln in lines:
        if re.match(r"^(idea|walk|pitfall):", ln): skip = True; continue
        if skip and ln.startswith("- "): continue
        skip = False; clean.append(ln)
    # insert after each matching box header block (before next ### box or EOF)
    out = []; i = 0; used = set()
    starts = [k for k, ln in enumerate(clean) if ln.startswith("### box:")]
    for idx, k in enumerate(starts):
        end = starts[idx + 1] if idx + 1 < len(starts) else len(clean)
        title = clean[k][len("### box:"):].strip()
        block = clean[k:end]
        while block and not block[-1].strip(): block.pop()
        key = next((t for t in boxes if title.startswith(t)), None)
        if key: block += emit(boxes[key]); used.add(key)
        out += block + [""]
    head = clean[:starts[0]]
    open(path, "w", encoding="utf-8").write("\n".join(head + out).rstrip() + "\n")
    missing = set(boxes) - used
    print(fn, "boxes:", len(starts), "with concepts:", len(used), "unmatched keys:", missing or "-")
