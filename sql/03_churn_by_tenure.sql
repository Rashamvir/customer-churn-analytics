USE churn_analytics;

-- Churn rate by tenure bucket
SELECT
  tenure_bucket,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percentage,
  COUNT(*) AS total_customers
FROM (
  SELECT
    CASE
      WHEN tenure <= 12 THEN '0–12 months'
      WHEN tenure BETWEEN 13 AND 24 THEN '13–24 months'
      WHEN tenure BETWEEN 25 AND 48 THEN '25–48 months'
      ELSE '49+ months'
    END AS tenure_bucket,
    Churn
  FROM customers_clean
) t
GROUP BY tenure_bucket;
