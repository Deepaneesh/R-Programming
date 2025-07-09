Recipes in Detail
================

# What is Recipes

REcipes is a package in R that provides a framework for creating and
managing data preprocessing workflows. It allows users to define a
sequence of data transformations, making it easier to prepare data for
modeling.

# Key Features of Recipes

- **Modular Design**: REcipes allows users to create modular data
  preprocessing steps, making it easy to manage complex workflows.
- **Reproducibility**: By defining a recipe, users can ensure that the
  same preprocessing steps are applied consistently across different
  datasets.
- **Integration with Modeling**: REcipes can be seamlessly integrated
  with modeling functions in R, allowing for a smooth transition from
  data preprocessing to model training. \# Example of Using REcipes

``` r
library(tidymodels)
```

    ## Warning: package 'tidymodels' was built under R version 4.4.3

    ## ── Attaching packages ────────────────────────────────────── tidymodels 1.3.0 ──

    ## ✔ broom        1.0.8     ✔ recipes      1.3.1
    ## ✔ dials        1.4.0     ✔ rsample      1.3.0
    ## ✔ dplyr        1.1.4     ✔ tibble       3.2.1
    ## ✔ ggplot2      3.5.2     ✔ tidyr        1.3.1
    ## ✔ infer        1.0.8     ✔ tune         1.3.0
    ## ✔ modeldata    1.4.0     ✔ workflows    1.2.0
    ## ✔ parsnip      1.3.2     ✔ workflowsets 1.1.1
    ## ✔ purrr        1.0.4     ✔ yardstick    1.3.2

    ## Warning: package 'broom' was built under R version 4.4.3

    ## Warning: package 'dials' was built under R version 4.4.3

    ## Warning: package 'scales' was built under R version 4.4.3

    ## Warning: package 'ggplot2' was built under R version 4.4.3

    ## Warning: package 'infer' was built under R version 4.4.3

    ## Warning: package 'parsnip' was built under R version 4.4.3

    ## Warning: package 'purrr' was built under R version 4.4.3

    ## Warning: package 'recipes' was built under R version 4.4.3

    ## Warning: package 'rsample' was built under R version 4.4.3

    ## Warning: package 'tune' was built under R version 4.4.3

    ## Warning: package 'workflows' was built under R version 4.4.3

    ## Warning: package 'workflowsets' was built under R version 4.4.3

    ## Warning: package 'yardstick' was built under R version 4.4.3

    ## ── Conflicts ───────────────────────────────────────── tidymodels_conflicts() ──
    ## ✖ purrr::discard() masks scales::discard()
    ## ✖ dplyr::filter()  masks stats::filter()
    ## ✖ dplyr::lag()     masks stats::lag()
    ## ✖ recipes::step()  masks stats::step()

``` r
# Load the iris dataset
data(iris)
# Define a recipe for preprocessing
recipe_iris <- recipe(Species ~ ., data = iris) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_factor_predictors())

recipe_iris
```

    ## 

    ## ── Recipe ──────────────────────────────────────────────────────────────────────

    ## 

    ## ── Inputs

    ## Number of variables by role

    ## outcome:   1
    ## predictor: 4

    ## 

    ## ── Operations

    ## • Centering and scaling for: all_numeric_predictors()

    ## • Dummy variables from: all_factor_predictors()

this shows the recipe object with the preprocessing steps defined. and
what are happening in the background.

# To View the transormed data

``` r
recipe_iris %>% 
  prep() %>% 
  juice() %>% head()
```

    ## # A tibble: 6 × 5
    ##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ##          <dbl>       <dbl>        <dbl>       <dbl> <fct>  
    ## 1       -0.898      1.02          -1.34       -1.31 setosa 
    ## 2       -1.14      -0.132         -1.34       -1.31 setosa 
    ## 3       -1.38       0.327         -1.39       -1.31 setosa 
    ## 4       -1.50       0.0979        -1.28       -1.31 setosa 
    ## 5       -1.02       1.25          -1.34       -1.31 setosa 
    ## 6       -0.535      1.93          -1.17       -1.05 setosa

this will show the first few rows of the transformed data after applying
the preprocessing steps defined in the recipe.

The functions available in REcipes are designed to be flexible and can
be combined in various ways to create complex preprocessing workflows.
Here are some common functions used in REcipes:

### 🔧 1. Basic Functions

| **Function** | **Description** |
|----|----|
| `recipes::recipe()` | Starts a new recipe. Define outcome and predictors. |
| `formula(<recipe>)` | Converts a prepared recipe back into a formula. |
| `print(<recipe>)` | Prints the structure and steps of the recipe. |
| `summary(<recipe>)` | Summarizes all steps in the recipe. |
| `prep()` | Trains (prepares) the recipe using the training data. |
| `bake()` | Applies the prepped recipe to new/test data. |
| `juice()` | Extracts preprocessed training data. *(Superseded — use `bake()` instead.)* |

### 📌 Commonly Used Variable Selection Helpers

You can use these inside step functions (e.g.,
`step_normalize(all_numeric_predictors())`) to apply transformations to
specific types of variables.

| **Helper** | **Meaning** |
|----|----|
| `all_predictors()` | Selects all predictor variables (independent variables). |
| `all_outcomes()` | Selects all outcome variables (dependent variables). |
| `all_numeric()` | Selects all numeric variables (predictors + outcomes). |
| `all_numeric_predictors()` | Selects numeric predictors only. |
| `all_nominal()` | Selects all categorical variables (factors/characters). |
| `all_nominal_predictors()` | Selects only nominal (categorical) predictors. |
| `all_factor()` / `all_factor_predictors()` | Selects factor variables (or just predictor ones). |
| `all_integer()` / `all_integer_predictors()` | Selects integer variables. |
| `all_logical()` | Selects logical (`TRUE`/`FALSE`) variables. |
| `all_date()` / `all_datetime()` | Selects date/datetime variables. |
| `has_role("role_name")` | Selects variables with a specific role, like `"id"`. |

You can also use **tidyselect helpers** like `starts_with()`,
`contains()`, `matches()`, etc.

### VARIABLE SELECTION HELPERS

| Function | Description |
|----|----|
| `all_predictors()` / `all_outcomes()` | Select predictors or outcomes |
| `has_role()` / `has_type()` | Select by role or type |
| `all_numeric()` / `all_nominal()` / `all_integer()` / `all_factor()` / `all_ordered()` / `all_logical()` / `all_string()` / `all_date()` / `all_datetime()` | Select by data type |
| `current_info()` | Get current variable metadata |

### ROLE MANAGEMENT

| Function                     | Description                     |
|------------------------------|---------------------------------|
| `add_role()`                 | Add a new role to a variable    |
| `update_role()`              | Update an existing role         |
| `remove_role()`              | Remove a role                   |
| `update_role_requirements()` | Set requirements based on roles |
| `get_case_weights()`         | Extract case weights if present |

### STEP FUNCTIONS

#### Imputation

| Function               | Description                                 |
|------------------------|---------------------------------------------|
| `step_naomit()`        | Remove rows with NA values                  |
| `step_impute_mean()`   | Impute numeric data using mean              |
| `step_impute_median()` | Impute numeric data using median            |
| `step_impute_mode()`   | Impute nominal data using most common value |
| `step_impute_knn()`    | KNN imputation                              |
| `step_impute_linear()` | Linear model imputation                     |
| `step_impute_bag()`    | Bagged tree imputation                      |
| `step_impute_lower()`  | Impute values below threshold               |
| `step_impute_roll()`   | Rolling statistic imputation                |
| `step_unknown()`       | Assign “unknown” to missing categories      |

### STEP FUNCTIONS

#### Transformations

| Function | Description |
|----|----|
| `step_BoxCox()` | Box-Cox transformation |
| `step_YeoJohnson()` | Yeo-Johnson transformation |
| `step_log()` / `step_logit()` / `step_invlogit()` / `step_inverse()` | Mathematical transforms |
| `step_sqrt()` / `step_relu()` / `step_hyperbolic()` | Root, ReLU, and hyperbolic transforms |
| `step_poly()` / `step_poly_bernstein()` | Polynomial basis |
| `step_ns()` / `step_bs()` / `step_spline_*()` | Spline basis functions |
| `step_mutate()` | Add custom features |
| `step_mutate_at()` | Mutate multiple columns *(superseded)* |
| `step_harmonic()` | Add harmonic terms |

### STEP FUNCTIONS

#### Discretization

| Function            | Description                       |
|---------------------|-----------------------------------|
| `step_discretize()` | Discretize numeric variables      |
| `step_cut()`        | Cut numeric variable into factors |

### STEP FUNCTIONS

#### Dummy Variables & Encodings

    iris$Species <- relevel(iris$Species, ref = "virginica")

To relevel the factor levels of the `Species` variable in the `iris`
dataset, you can use the `relevel()` function. This function allows you
to specify a reference level for the factor, which is useful for
modeling purposes.

| Function | Description |
|----|----|
| `step_dummy()` | One-hot encode categorical variables |
| `step_dummy_extract()` | Extract pattern from text |
| `step_dummy_multi_choice()` | Encode multiple predictors together |
| `step_bin2factor()` | Convert binary to factor |
| `step_factor2string()` / `step_string2factor()` | Convert between factor and string |
| `step_num2factor()` | Numeric to factor |
| `step_other()` | Collapse rare levels |
| `step_ordinalscore()` | Ordinal to numeric |
| `step_novel()` | Handle novel levels |
| `step_regex()` | Regex detection |
| `step_relevel()` | Reorder factor levels |
| `step_unorder()` | Unorder ordered factors |
| `step_indicate_na()` | Add missing indicators |

### STEP FUNCTIONS

#### Date & Time Features

| Function         | Description             |
|------------------|-------------------------|
| `step_date()`    | Extract date components |
| `step_time()`    | Extract time components |
| `step_holiday()` | Add holiday indicators  |

#### Interactions

| Function          | Description                  |
|-------------------|------------------------------|
| `step_interact()` | Create interaction variables |

### STEP FUNCTIONS

#### Normalization

| Function           | Description                   |
|--------------------|-------------------------------|
| `step_center()`    | Mean-center numeric variables |
| `step_scale()`     | Scale numeric variables       |
| `step_normalize()` | Center and scale              |
| `step_range()`     | Rescale to a range            |

#### Multivariate Transformations

| Function | Description |
|----|----|
| `step_pca()` | Principal Component Analysis |
| `step_ica()` | Independent Component Analysis |
| `step_pls()` | Partial Least Squares |
| `step_kpca()` / `step_kpca_rbf()` / `step_kpca_poly()` | Kernel PCA variants |
| `step_classdist()` / `step_classdist_shrunken()` | Class centroid distance |
| `step_depth()` | Statistical depth |
| `step_geodist()` | Geographic distance |
| `step_isomap()` | Isomap embedding |
| `step_spatialsign()` | Normalize direction (spatial sign) |
| `step_ratio()` | Create ratio features |
| `step_nnmf_sparse()` | Sparse non-negative matrix factorization |

#### Filters

| Function                | Description                         |
|-------------------------|-------------------------------------|
| `step_corr()`           | Remove highly correlated variables  |
| `step_zv()`             | Remove zero-variance variables      |
| `step_nzv()`            | Remove near-zero variance variables |
| `step_lincomb()`        | Remove linear combinations          |
| `step_filter_missing()` | Filter based on missing values      |
| `step_rm()`             | Remove variables                    |
| `step_select()`         | Select variables *(deprecated)*     |

#### Row Operations

| Function         | Description             |
|------------------|-------------------------|
| `step_arrange()` | Arrange rows            |
| `step_filter()`  | Filter rows             |
| `step_sample()`  | Randomly sample rows    |
| `step_slice()`   | Select rows by position |
| `step_naomit()`  | Remove rows with NA     |
| `step_lag()`     | Add lagged values       |
| `step_shuffle()` | Shuffle values          |

#### Others

| Function                             | Description              |
|--------------------------------------|--------------------------|
| `step_intercept()`                   | Add intercept column     |
| `step_profile()`                     | Create profiling dataset |
| `step_window()`                      | Moving window statistics |
| `step_rename()` / `step_rename_at()` | Rename columns           |

------------------------------------------------------------------------

### ✅ CHECK FUNCTIONS

| Function             | Description                      |
|----------------------|----------------------------------|
| `check_class()`      | Check variable class             |
| `check_missing()`    | Ensure no missing values         |
| `check_new_values()` | Prevent unseen values            |
| `check_cols()`       | Ensure expected columns          |
| `check_range()`      | Ensure numeric range consistency |

------------------------------------------------------------------------

### 🔧 DEVELOPER FUNCTIONS

| Function | Description |
|----|----|
| `add_step()` / `add_check()` | Add custom step or check |
| `detect_step()` | Check if a step exists |
| `fully_trained()` | Check if recipe is prepped |
| `.get_data_types()` | Get column types |
| `prepper()` | Recipe wrapper for resampling |
| `recipes_argument_select()` / `recipes_eval_select()` | Evaluate tidyselect syntax |
| `recipes_extension_check()` | Validate step/check extensions |
| `recipes_ptype()` / `recipes_ptype_validate()` | Type validation |
| `recipes_names_predictors()` / `recipes_names_outcomes()` | Role accessors |

------------------------------------------------------------------------

### 🧹 TIDY METHODS

| Function | Description |
|----|----|
| `tidy(<recipe>)`, `tidy(<step>)`, `tidy(<check>)` | Extract step/check details (like affected variables) |
