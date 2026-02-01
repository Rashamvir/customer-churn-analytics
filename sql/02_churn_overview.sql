USE churn_analytics;

-- Overall churn distribution
SELECT
  Churn,
  COUNT(*) AS customer_count,
  ROUND(
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_clean),
    2
  ) AS churn_percentage
FROM customers_clean
GROUP BY Churn;

-- Revenue lost due to churn
SELECT
  ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue_lost
FROM customers_clean
WHERE Churn = 'Yes';
