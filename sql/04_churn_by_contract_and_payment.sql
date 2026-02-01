USE churn_analytics;

-- Churn by contract type
SELECT
  Contract,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percentage
FROM customers_clean
GROUP BY Contract;

-- Churn by payment method
SELECT
  PaymentMethod,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percentage
FROM customers_clean
GROUP BY PaymentMethod;
