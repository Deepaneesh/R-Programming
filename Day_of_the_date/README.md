# Day Finder in R Using Odd Days Calculation

This project provides an R script to determine the day of the week for any given date. The calculation is based on the **odd days** method, which involves breaking the process into **century odd days**, **yearly odd days**, and **monthly odd days**. This approach is a classic technique often used to manually compute the day of the week.

------------------------------------------------------------------------

## Key Concepts

### Odd Days Explanation:

1.  **Century Odd Days**:
    -   Every 100 years contribute 5 odd days.
    -   Example:
        -   1600, 2000 → 0 odd days (leap centuries).
        -   1700, 2100 → 5 odd days.
        -   1800, 2200 → 3 odd days.
        -   1900, 2300 → 1 odd day.
2.  **Yearly Odd Days**:
    -   Each year adds either 1 or 2 odd days:
        -   **Leap Year**: Contributes 2 odd days.
        -   **Non-Leap Year**: Contributes 1 odd day.
    -   Leap year formula:
        -   A year is a leap year if it is divisible by 4 but not divisible by 100, unless it is also divisible by 400.
3.  **Monthly Odd Days**:
    -   Each month has a fixed number of odd days:
        -   January: 3
        -   February: 0 (1 in leap years)
        -   March: 3
        -   April: 2
        -   May: 3
        -   June: 2
        -   July: 3
        -   August: 3
        -   September: 2
        -   October: 3
        -   November: 2
        -   December: 3
4.  **Date Odd Days**:
    -   The day of the month contributes directly as odd days.

### Summing Up:

-   Add the odd days from centuries, years, months, and the date.
-   Take modulo 7 of the total to get the day of the week:
    -   `0: Sunday`
    -   `1: Monday`
    -   `2: Tuesday`
    -   `3: Wednesday`
    -   `4: Thursday`
    -   `5: Friday`
    -   `6: Saturday`

------------------------------------------------------------------------

## Features of the Script

-   **Input Handling**:
    -   Used `scan()` and `readline()` functions to take user inputs for the date, month, and year.
    -   The script validates the input for correctness.
-   **Output**:
    -   Returns the day of the week corresponding to the input date.

------------------------------------------------------------------------
