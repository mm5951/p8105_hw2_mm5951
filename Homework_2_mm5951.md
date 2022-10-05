Homework 2
================
mm5951
2022-10-05

## Problem 1

Solutions provided in the p8105 course page.

## Problem 2

First, I import the Mr. Trash Wheel dataset using `read_excel` function
(note the library `readxl` has been previously installed, not shown).

Piped into the same code chunk, I proceed to read and clean the
Mr. Trash Wheel sheet:

-   specify the “Mr. Trash Wheel” sheet
-   omit non-data entries (by selecting range “A2:N549”)
-   omit rows that do not include dumpster-specific data
-   round the number of sports balls to the nearest integer using
    `mutate`
-   convert the result to an integer variable using the `transform` and
    `as.integer`function

``` r
Mr_trash_df = read_excel("./data/Trash-Wheel-Collection-Data.xlsx",
    sheet = "Mr. Trash Wheel",
    range = "A2:N549",) %>% 
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

    ##  int [1:547] 7 5 6 6 7 5 3 6 6 7 ...

I use a similar process to import, clean, and organize the data for
Professor Trash Wheel (same steps and functions as described above).
Note the variable “year” is converted into a character using
`as.character` and “sports_balls” is newly created and transformed into
a integer variable in order to allow for merging in a later step.

``` r
Prof_trash_df = read_excel("./data/Trash-Wheel-Collection-Data.xlsx",
    sheet = "Professor Trash Wheel",
    range = "A2:M96",) %>%  
  janitor::clean_names() %>% 
  drop_na("dumpster") %>% 
  mutate(sports_balls = "NA", .after = "chip_bags") %>% 
  transform(year = as.character(year)) %>% 
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

The resulting merged dataset contains 641 observations, n=547 from Mr
Trash and n=94 from Professor trash.

In “Mr. Trash Wheel dataset”, the key variables are listed as: dumpster,
month, year, date, weight_tons, volume_cubic_yards, plastic_bottles,
polystyrene, cigarette_butts, glass_bottles, grocery_bags, chip_bags,
sports_balls, homes_powered. Mr. Trash Wheel data contains 547
observations of dumpsters, and collects data about 14 related variables.
Notably, some key results are:

-   Over the entire study period, Prof. Trash collected a total of
    190.12 tons of dumpster.
-   In 2020 alone, Mr. Trash collected a total of 856 sports balls.

## Problem 3

First, I import the **“pols-month.csv” dataset** (part of
“FiveThirtyEight data”) using the `read_csv` function. More
specifically, the following functions are used:

-   To clean names, the `janitor::clean_names()` function;
-   To break the date “mon” variable into individual year, month, and
    day, the `separate()` function;
-   To coerce into integer data types, the `as.integer()` function;
-   To replace month number with month name, as well as create a
    president variable taking values “gop” and “dem”, the `mutate()`
    function;
-   To remove the “prez_dem”, “prez_gop” and “day” variables, the
    `select()`function.
-   To arrange according to year and month, the `arrange()` function.

``` r
polsmonth_df = read_csv("./Data/pols-month.csv", show_col_types = FALSE) %>%
  janitor::clean_names() %>%
  separate(mon, into = c("year", "month", "day")) %>%
  arrange(year, as.integer(month)) %>%
  mutate(year = as.integer(year),
         month = month.name[as.integer(month)],
         president = if_else(prez_dem == 1, "dem", "gop")
         ) %>%
  select(-day, -prez_dem, -prez_gop)
```

Next, I proceed similarly as described above for the **“snp.csv”** and
**“unemployment.csv” datasets**.

``` r
snp_df = read_csv("./Data/snp.csv", show_col_types = FALSE) %>%
  janitor::clean_names() %>%
  separate(date, into = c("month", "day", "year")) %>%
  mutate(year = as.integer(year),
         month = as.integer(month),
         year = ifelse(year >= 23, year + 1900, year + 2000)
         ) %>%
  relocate(year) %>%
  arrange(year, month) %>%
  mutate(month = month.name[as.integer(month)]) %>%
  select(-day)
```

For the “unemployment.csv” dataset, some additional steps are taken:

-   Switch from “wide” to “long” format using `pivot_longer()`function;
-   Renaming some of the key variables so they have the same name and
    take the same values, using `mutate()` and `as.integer()`.

``` r
unemployment_df = read_csv("./Data/unemployment.csv", show_col_types = FALSE) %>%
  pivot_longer("Jan":"Dec",
        names_to = "month",
        values_to = "unemployment"
        ) %>%
  janitor::clean_names() %>%
  mutate( month = month.name[match(month, month.abb)],
          year = as.integer(year)
         )
```

Then I proceed to **join the datasets**, first by merging “snp_df” into
“polsmonth_df”, and then merging “unemployment_df” into the result. To
do so, I use the `full_join()` function.

``` r
joint_df = full_join(polsmonth_df, snp_df)
joint2_df = full_join(joint_df, unemployment_df)
```

Finally, I describe the contents of the overall “joint2_df” dataset, as
well as the dimension, range of years, and names of key variables of
each separate original ones.

-   The **“pols-month.csv” dataset** entails:
    -   The dataset has 822 observations and 9 variables (columns).
    -   The years range from 1947 to 2015.
    -   The key variables are listed as: year, month, gov_gop, sen_gop,
        rep_gop, gov_dem, sen_dem, rep_dem, president.
-   The **“snp.csv”** dataset entails:
    -   The dataset has 787 observations and 3 variables (columns).
    -   The years range from 1950 to 2015.
    -   The key variables are listed as: year, month, close.
-   The **“unemployment.csv”** dataset entails:
    -   The dataset has 816 observations and 3 variables (columns).
    -   The years range from 1948 to 2015.
    -   The key variables are listed as: year, month, unemployment.
-   The final **“joint2_df”** dataset, which is the result of a merging
    from the three described above, entails:
    -   The dataset has 828 observations and 11 variables (columns).
    -   The years range from 1947 to 2015
    -   The key variables are listed as: year, month, gov_gop, sen_gop,
        rep_gop, gov_dem, sen_dem, rep_dem, president, close,
        unemployment.
