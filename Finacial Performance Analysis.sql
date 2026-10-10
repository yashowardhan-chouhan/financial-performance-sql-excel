-- ============================================================
-- Financial Performance Analysis
-- ============================================================


-- ============================================================
-- 1. DATA COMPLETENESS CHECK
-- ============================================================

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Date) AS Dates,
    COUNT(Month) AS Months,
    COUNT(City) AS Cities,
    COUNT(Category) AS Categories,
    COUNT("Category I") AS Category_I,
    COUNT("Budgeted Income") AS Budgeted_Income,
    COUNT("Actual Income") AS Actual_Income,
    COUNT("Cateogry II") AS Category_II
FROM Income_Items;


SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Date) AS Dates,
    COUNT(Month) AS Months,
    COUNT(City) AS Cities,
    COUNT(Category) AS Categories,
    COUNT("Sub-category") AS Sub_Category,
    COUNT("Budgeted Expense") AS Budgeted_Expense,
    COUNT("Actual Expense") AS Actual_Expense
FROM Expense_Items;


-- ============================================================
-- 2. INCOME: BUDGET VS ACTUAL
-- ============================================================

SELECT
    SUM("Budgeted Income") AS Budgeted_Income,
    SUM("Actual Income") AS Actual_Income,
    ROUND(
        SUM("Actual Income") - SUM("Budgeted Income"),
        2
    ) AS Income_Variance
FROM Income_Items;


-- ============================================================
-- 3. EXPENSE: BUDGET VS ACTUAL
-- ============================================================

SELECT
    SUM("Budgeted Expense") AS Budgeted_Expense,
    SUM("Actual Expense") AS Actual_Expense,
    ROUND(
        SUM("Actual Expense") - SUM("Budgeted Expense"),
        2
    ) AS Expense_Variance
FROM Expense_Items;


-- ============================================================
-- 4. OVERALL PROFIT AND PROFIT MARGIN
-- ============================================================

SELECT
    i.Actual_Income,
    e.Actual_Expense,
    ROUND(
        i.Actual_Income - e.Actual_Expense,
        2
    ) AS Profit,
    ROUND(
        (i.Actual_Income - e.Actual_Expense)
        / i.Actual_Income * 100,
        2
    ) AS Profit_Margin_Percent
FROM
    (
        SELECT SUM("Actual Income") AS Actual_Income
        FROM Income_Items
    ) i
CROSS JOIN
    (
        SELECT SUM("Actual Expense") AS Actual_Expense
        FROM Expense_Items
    ) e;


-- ============================================================
-- 5. QUARTERLY REVENUE
-- ============================================================

SELECT
    CASE
        WHEN Month IN ('January', 'February', 'March') THEN 'Q1'
        WHEN Month IN ('April', 'May', 'June') THEN 'Q2'
        WHEN Month IN ('July', 'August', 'September') THEN 'Q3'
        WHEN Month IN ('October', 'November', 'December') THEN 'Q4'
    END AS Quarter,
    ROUND(
        SUM("Actual Income"),
        2
    ) AS Total_Revenue
FROM Income_Items
GROUP BY Quarter
ORDER BY
    CASE Quarter
        WHEN 'Q1' THEN 1
        WHEN 'Q2' THEN 2
        WHEN 'Q3' THEN 3
        WHEN 'Q4' THEN 4
    END;


-- ============================================================
-- 6. INCOME BY CATEGORY
-- ============================================================

SELECT
    Category,
    "Category I",
    "Cateogry II",
    ROUND(
        SUM("Actual Income"),
        2
    ) AS Actual_Income
FROM Income_Items
GROUP BY
    Category,
    "Category I",
    "Cateogry II"
ORDER BY Actual_Income DESC;


-- ============================================================
-- 7. INCOME BY SOURCE
-- ============================================================

SELECT
    "Category I" AS Income_Group,
    ROUND(
        SUM("Actual Income"),
        2
    ) AS Actual_Income
FROM Income_Items
GROUP BY "Category I"
ORDER BY Actual_Income DESC;


-- ============================================================
-- 8. EXPENSE PERFORMANCE BY CATEGORY
-- ============================================================

SELECT
    Category,
    ROUND(
        SUM("Budgeted Expense"),
        2
    ) AS Budgeted_Expense,
    ROUND(
        SUM("Actual Expense"),
        2
    ) AS Actual_Expense,
    ROUND(
        SUM("Actual Expense") - SUM("Budgeted Expense"),
        2
    ) AS Expense_Variance
FROM Expense_Items
GROUP BY Category
ORDER BY Actual_Expense DESC;


-- ============================================================
-- 9. MONTHLY INCOME, EXPENSE, PROFIT AND MARGIN
-- ============================================================

WITH Monthly_Income AS (
    SELECT
        Month,
        ROUND(
            SUM("Actual Income"),
            2
        ) AS Actual_Income
    FROM Income_Items
    GROUP BY Month
),

Monthly_Expense AS (
    SELECT
        Month,
        ROUND(
            SUM("Actual Expense"),
            2
        ) AS Actual_Expense
    FROM Expense_Items
    GROUP BY Month
)

SELECT
    i.Month,
    i.Actual_Income,
    e.Actual_Expense,
    ROUND(
        i.Actual_Income - e.Actual_Expense,
        2
    ) AS Profit,
    ROUND(
        (i.Actual_Income - e.Actual_Expense)
        / i.Actual_Income * 100,
        2
    ) AS Profit_Margin_Percent
FROM Monthly_Income i
JOIN Monthly_Expense e
    ON i.Month = e.Month
ORDER BY
    CASE i.Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;


-- ============================================================
-- 10. MONTHLY REVENUE
-- ============================================================

SELECT
    Month,
    ROUND(
        SUM("Actual Income"),
        2
    ) AS Monthly_Revenue
FROM Income_Items
GROUP BY Month
ORDER BY
    CASE Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;


-- ============================================================
-- 11. MONTHLY PROFIT MARGIN
-- ============================================================

WITH Monthly_Income AS (
    SELECT
        Month,
        SUM("Actual Income") AS Actual_Income
    FROM Income_Items
    GROUP BY Month
),

Monthly_Expense AS (
    SELECT
        Month,
        SUM("Actual Expense") AS Actual_Expense
    FROM Expense_Items
    GROUP BY Month
)

SELECT
    i.Month,
    ROUND(
        (i.Actual_Income - e.Actual_Expense)
        / i.Actual_Income * 100,
        2
    ) AS Profit_Margin_Percent
FROM Monthly_Income i
JOIN Monthly_Expense e
    ON i.Month = e.Month
ORDER BY
    CASE i.Month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;