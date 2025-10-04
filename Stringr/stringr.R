
# String Converting 

str_to_upper()
str_to_lower()
str_to_title()
str_to_sentence()

# Joining text
str_c() 
paste0()
str_flatten(letters[1:3], ", ")

str_glue("My name is {name}, not {{name}}.")

# String counting
str_count()
fruit <- c("apple", "banana", "pear", "pineapple")
str_count(fruit, "a")

# string detect
str_detect(string, pattern, negate = FALSE)

str_starts(string, pattern, negate = FALSE)

str_ends(string, pattern, negate = FALSE)
str_escape(string)
str_detect(c("a", "."), ".")
str_detect(c("a", "."), str_escape("."))
# String dupicating
str_dup(string, times)

# Comparison
str_equal(x, y, locale = "en", ignore_case = FALSE, ...)

# Extracting
str_extract(string, pattern, group = NULL)

str_extract_all(string, pattern, simplify = FALSE)
shopping_list <- c("apples x4", "bag of flour", "bag of sugar", "milk x2")
str_extract(shopping_list, "\\d")
 

# string features
x <- c("\u6c49\u5b57", "\U0001f60a")
str_view(x)
str_width(x)
str_length(x)
fruit <- c("apple", "banana", "pear", "pineapple")
# Matching and finding
str_like(fruit, "app")
str_like(fruit, "app%")
str_locate(fruit, "an")

# Str sorting
str_sort(x)
# Triming
str_split(string, pattern, n = Inf, simplify = FALSE)
str_trim(string, side = c("both", "left", "right"))

str_squish(string)
# Sub string
str_sub(string, start = 1L, end = -1L)
str_which(fruit, "e")
