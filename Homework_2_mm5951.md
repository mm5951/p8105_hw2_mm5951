Homework 2
================
mm5951
2022-10-01

## Problem 2

First, I import the Mr. Trash Wheel dataset using `read_excel` function
(note the library `readxl` has been previously installed, not shown).

Piped into the same code chunk, I proceed to read and clean the
Mr. Trash Wheel sheet:

-   specify the “Mr. Trash Wheel” sheet
-   omit non-data entries (by selecting range “A2:N534”)
-   omit rows that do not include dumpster-specific data
-   round the number of sports balls to the nearest integer using
    `mutate`
-   convert the result to an integer variable using the
    `as.integer`function

``` r
Mr_trash_df = read_excel("./data/Trash-Wheel-Collection-Totals-7-2020-2.xlsx",
    sheet = "Mr. Trash Wheel",
    range = "A2:N534",) %>% 
  janitor::clean_names() %>% 
  drop_na("dumpster") %>% 
  mutate(sports_balls = round(sports_balls, 0)) %>% 
  transform(sports_balls = as.integer(sports_balls)) 
```

Finally, I use the `str()` function to compactly display the structure
of the Mr_trash_df dataframe and check the integer nature of the
“sports_balls” variable.

``` r
  str(Mr_trash_df$"sports_balls")
```

    ##  int [1:453] 7 5 6 6 7 5 3 6 6 7 ...

I use a similar process to import, clean, and organize the data for
Professor Trash Wheel (same steps and functions as described above).

``` r
Prof_trash_df = read_excel("./data/Trash-Wheel-Collection-Totals-7-2020-2.xlsx",
    sheet = "Professor Trash Wheel",
    range = "A2:N115",) %>%  
  janitor::clean_names() %>% 
  drop_na("dumpster") %>% 
  mutate(sports_balls = round(sports_balls, 0)) %>% 
  transform(sports_balls = as.integer(sports_balls))
```

Next, I and stack the two datasets (that is, combine one on top of the
other) using the `bind_rows` function. To do so, first I generate an
“origin” column, containing the prefix “M” for Mr Trash and “P” for the
Professor dataframes. In doing so, I use the function `mutate` to
generate a “M” or “P” containing columns, and then merge it using
`unite` with the corresponding “dumpster” number, creating an “Id”
column.

``` r
Mr_trash2_df = Mr_trash_df %>% 
  mutate(origin = "M", .before = "dumpster")  %>% 
  unite('Id', origin:dumpster, sep = "", remove = FALSE)

Prof_trash2_df = Prof_trash_df %>% 
  mutate(origin = "P", .before = "dumpster")  %>% 
  unite('Id', origin:dumpster, sep = "", remove = FALSE)

stacked_trash_df = bind_rows(Mr_trash2_df, Prof_trash2_df) %>% 
  janitor::clean_names()
```

The resulting merged dataset contains 524 observations, n=453 from Mr
Trash and n=71 from Professor trash.

In “Mr. Trash Wheel dataset”, the key variables are listed as: dumpster,
month, year, date, weight_tons, volume_cubic_yards, plastic_bottles,
polystyrene, cigarette_butts, glass_bottles, grocery_bags, chip_bags,
sports_balls, homes_powered. Mr. Trash Wheel data contains 453
observations of dumpsters, and collects data about 14 related variables.
Notably, some key results:

-   Over the entire study period, Mr. Trash collected a total of 1449.7
    tons of dumpster.
-   In 2020 alone, he collected a total of 856 sports balls.

## Problem 2

\*\* PENDING\*\*
