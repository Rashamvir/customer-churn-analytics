USE churn_analytics;

-- Fix empty TotalCharges values
UPDATE customers_raw
SET TotalCharges = NULL
WHERE TotalCharges = '';

-- Convert TotalCharges to numeric
ALTER TABLE customers_raw
MODIFY TotalCharges DECIMAL(10,2);

-- Create clean analytics table
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
