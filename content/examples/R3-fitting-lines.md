---
id: R3
key: fitting-lines
title: Fitting lines
lecture: L06
topics: read.table, head, names, $, plot, lm, coefficients, abline
summary: The first regression in R. Load the economic-voting data, make a scatter plot of income growth vs. incumbent vote share, fit the least squares line with lm(), and draw it on the plot.
takeaways:
- `df$column` pulls one column out of a data frame.
- `plot(x = ..., y = ...)`: predictor on x, response on y. `xlab`/`ylab` label the axes.
- `lm(y ~ x, data = df)` fits the least squares line. The formula is **response ~ predictor**.
- Save the fit (`bestfit <- lm(...)`) and use `bestfit$coefficients` → (intercept, slope).
- `abline(a = intercept, b = slope)` or just `abline(bestfit$coefficients)` adds the line to the current plot.
- Voting data: $\widehat{\text{vote}} = 46.25 + 3.06\cdot\text{growth}$.
---

## Load and look at the data

### box: Read the data file
items: 2-8
what: Load the economic-voting data into a data frame called `voting_data` and see what's in it.
explain:
- `read.table(file, header = TRUE)` reads a whitespace-separated text file; `header = TRUE` means the first row holds the column names. For a .csv file use `read.csv()` instead.
- The path `~/Documents/...` is the instructor's computer. Change it to wherever **your** copy of `hibbs.dat` is, or use `file.choose()` to pick it.
- `head(df)` shows the first 6 rows; `names(df)` lists the column names.
- We only need `growth` (predictor) and `vote` (response).

### box: Pull out one column with $
items: 12-13
what: Get the values of the `growth` column.
explain:
- `dataframe$column` returns that column as a vector: 16 elections' income growth (%).

## Scatter plot

### box: Plot growth vs. vote share
items: 16-17
key: true
what: Scatter plot with growth on the x-axis (predictor) and incumbent vote share on the y-axis (response).
explain:
- `plot(x = ..., y = ...)` makes a scatter plot. Always put the **predictor on x** and the **response on y**.
- `xlab`, `ylab` set axis labels; `pch = 16` makes solid dots.
- The relationship looks roughly linear and positive.

## Fit the least squares line

### box: lm(response ~ predictor)
items: 23-28
key: true
what: Fit the best (least squares) line through the data.
explain:
- `lm()` fits linear models. The formula `vote ~ growth` reads "vote modeled by growth": **response on the left, predictor on the right** (general form `y ~ x`).
- `data = voting_data` tells R where to find the columns, so you can write `vote` instead of `voting_data$vote`.
- The output's **Coefficients** are the intercept $\hat\beta_0 = 46.248$ and the slope $\hat\beta_1 = 3.061$.
- Fitted line: $\widehat{\text{vote}} = 46.248 + 3.061\cdot\text{growth}$. Elections with 1 percentage point higher income growth have incumbent vote shares about 3.1 points higher, on average.

### box: Save the model and get its coefficients
items: 32-39
key: true
what: Store the fit as an object so you can reuse it.
explain:
- `bestfit <- lm(...)` saves the model. Typing `bestfit` prints it again.
- `bestfit$coefficients` is a named vector: element 1 is the intercept, element 2 is the slope. `bestfit$coefficients[2]` gets just the slope.

## Draw the line

### box: abline with the numbers typed in
items: 43-44
what: Redraw the scatter plot and add the fitted line by specifying its intercept and slope.
explain:
- `abline(a = intercept, b = slope)` draws a straight line on the **current** plot, so run `plot()` first.

### box: abline straight from the model
items: 47-48
key: true
what: Same picture, but let R take the intercept and slope from `bestfit`.
explain:
- `abline(bestfit$coefficients)` avoids copy-paste errors. (`abline(bestfit)` also works.)
- HW 3 #5 and HW 4 #1(a)–(b) follow exactly this recipe: `plot`, `lm`, `$coefficients`, `abline`.
