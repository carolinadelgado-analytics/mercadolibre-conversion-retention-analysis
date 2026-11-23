
-- ============================================================
-- Project: Mercado Libre | Conversion Funnel & Retention Analysis
-- Analysis: Monthly Cohort Retention
-- Period: January 1 - August 31, 2025
-- Dataset: Simulated Mercado Libre retention data
-- ============================================================

-- PART 1: MONTHLY COHORT DEFINITION
--
-- Objective:
-- Identify each user's earliest signup date and assign
-- a monthly registration cohort.
--
-- LIMIT 5 is used to preview the cohort assignments.

SELECT
    user_id,
    MIN(signup_date::date) AS signup_date,
    TO_CHAR(
        DATE_TRUNC('month', MIN(signup_date::date)),
        'YYYY-MM'
    ) AS cohort

FROM mercadolibre_retention

GROUP BY user_id
ORDER BY user_id
LIMIT 5;


-- ============================================================
-- PART 2: MONTHLY COHORT RETENTION RATES
--
-- Objective:
-- Calculate retention percentages for each monthly cohort
-- at D7, D14, D21, and D28.
--
-- Methodological considerations:
-- Activity is measured on or after each milestone, rather
-- than exclusively on the exact day.
-- The denominator includes distinct users with activity
-- records during the filtered observation period.
-- Recent cohorts may have incomplete observation windows.
-- ============================================================

WITH cohort AS (
    SELECT
        user_id,
        TO_CHAR(
            DATE_TRUNC('month', MIN(signup_date::date)),
            'YYYY-MM'
        ) AS cohort

    FROM mercadolibre_retention
    GROUP BY user_id
),

activity AS (
    SELECT
        r.user_id,
        c.cohort,
        r.day_after_signup,
        r.active

    FROM mercadolibre_retention r

    LEFT JOIN cohort c
        ON r.user_id = c.user_id

    WHERE r.activity_date BETWEEN '2025-01-01'
                              AND '2025-08-31'
)

SELECT
    cohort,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN day_after_signup >= 7 AND active = 1
            THEN user_id
        END) / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d7_pct,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN day_after_signup >= 14 AND active = 1
            THEN user_id
        END) / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d14_pct,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN day_after_signup >= 21 AND active = 1
            THEN user_id
        END) / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d21_pct,

    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN day_after_signup >= 28 AND active = 1
            THEN user_id
        END) / NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d28_pct

FROM activity

GROUP BY cohort
ORDER BY cohort;
