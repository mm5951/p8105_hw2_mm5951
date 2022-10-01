## Problem 1
We use the `readr` package to import the dataset, the `janitor::clean_name`function to clean it.
Next, create a separate dataset for the requested variables. Note some include quotation marks (if non-logical or numerical DOUBLE CHECK ARGUMENT).

I'M STUCK ON RECODING

```{r, include = FALSE}
subway_df = read_csv("./data/NYC_Transit_Subway_Entrance_And_Exit_Data.csv") %>% 
  janitor::clean_names() %>% 

subway2_df = select(subway_df, Line:"Entry", "Vending", ADA) 

subway3_df = subway2_df %>% pull("Entry") %>% recode("YES" = TRUE, "NO" = FALSE)

subway3_df = mutate(subway2_df,"Entry", "YES" = TRUE, "NO" = FALSE)
```