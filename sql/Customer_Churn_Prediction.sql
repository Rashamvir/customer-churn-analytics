SELECT VERSION();

CREATE DATABASE IF NOT EXISTS churn_analytics;
USE churn_analytics;

SHOW DATABASES;

USE churn_analytics;
SELECT COUNT(*) FROM customers_raw;
SELECT * FROM customers_raw LIMIT 5;

SELECT COUNT(*)
FROM customers_raw
WHERE TotalCharges = '';

UPDATE customers_raw
SET TotalCharges = NULL
WHERE TotalCharges = '';

ALTER TABLE customers_raw
MODIFY TotalCharges DECIMAL(10,2);

CREATE TABLE customers_clean AS
SELECT
  customerID,
  gender,
  SeniorCitizen,
  tenure,
  Contract,
  PaymentMethod,
  MonthlyCharges,
  TotalCharges,
  Churn
FROM customers_raw;

# Tenure-Based Churn Analysis
SELECT
  CASE
    WHEN tenure <= 12 THEN '0–12 months'
    WHEN tenure BETWEEN 13 AND 24 THEN '13–24 months'
    WHEN tenure BETWEEN 25 AND 48 THEN '25–48 months'
    ELSE '49+ months'
  END AS tenure_bucket,
  Churn,
  COUNT(*) AS customer_count
FROM customers_clean
GROUP BY tenure_bucket, Churn
ORDER BY tenure_bucket;

# convert counts into percentages
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
GROUP BY tenure_bucket
ORDER BY tenure_bucket;

# Save This as an Analytics View
CREATE VIEW churn_by_tenure AS
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

SELECT * FROM churn_by_tenure;


#Churn Rate by Contract Type

SELECT
  Contract,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percentage
FROM customers_clean
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;

CREATE VIEW churn_by_contract AS
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

SELECT * FROM churn_by_contract;

#Churn by Payment Method

SELECT
  PaymentMethod,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percentage
FROM customers_clean
GROUP BY PaymentMethod
ORDER BY churn_rate_percentage DESC;

CREATE VIEW churn_by_payment_method AS
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

SELECT * FROM churn_by_payment_method;

#Revenue Loss Due to Churn

SELECT
  ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue_lost
FROM customers_clean
WHERE Churn = 'Yes';

CREATE VIEW revenue_lost_due_to_churn AS
SELECT
  ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue_lost
FROM customers_clean
WHERE Churn = 'Yes';

SELECT * FROM revenue_lost_due_to_churn;

SELECT * FROM customers_clean;





