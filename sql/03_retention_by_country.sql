
-- ============================================================
-- Project: Mercado Libre | Conversion Funnel & Retention Analysis
-- Analysis: User Retention by Country
-- Period: January 1 - August 31, 2025
-- Dataset: Simulated Mercado Libre retention data
-- ============================================================

-- PART 1: ACTIVE USER COUNTS
--
-- Objective:
-- Count distinct users with recorded activity on or after
-- D7, D14, D21, and D28, grouped by country.

SELECT
    country,

    COUNT(DISTINCT CASE
        WHEN active = 1 AND day_after_signup >= 7
        THEN user_id
    END) AS users_d7,

    COUNT(DISTINCT CASE
        WHEN active = 1 AND day_after_signup >= 14
        THEN user_id
    END) AS users_d14,

    COUNT(DISTINCT CASE
        WHEN active = 1 AND day_after_signup >= 21
        THEN user_id
    END) AS users_d21,

    COUNT(DISTINCT CASE
        WHEN active = 1 AND day_after_signup >= 28
        THEN user_id
    END) AS users_d28

FROM mercadolibre_retention

WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'

GROUP BY country
ORDER BY country;


-- ============================================================
-- PART 2: RETENTION RATES BY COUNTRY
--
-- Objective:
-- Calculate the percentage of distinct users with recorded
-- activity on or after each retention milestone.
--
-- Methodological note:
-- These metrics do not represent exact-day retention.
-- The denominator is the number of distinct users with
-- activity records in the filtered analysis period.
-- ============================================================

SELECT
    country,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN day_after_signup >= 7 AND active = 1
            THEN user_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d7_pct,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN day_after_signup >= 14 AND active = 1
            THEN user_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d14_pct,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN day_after_signup >= 21 AND active = 1
            THEN user_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d21_pct,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN day_after_signup >= 28 AND active = 1
            THEN user_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT user_id), 0), 1
    ) AS retention_d28_pct

FROM mercadolibre_retention

WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'

GROUP BY country
ORDER BY country;
