-- ================================================
-- Accounts Receivable (AR) Analysis
-- ================================================

-- ++ AR Aging Buckets
-- Overview: Breaks down outstanding AR into standard aging buckets to evaluate risk and liquidity.
SELECT 
  SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) BETWEEN 0 AND 30 THEN Amount - PaidAmount ELSE 0 END) AS AR_0_30_Days,
  SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) BETWEEN 31 AND 60 THEN Amount - PaidAmount ELSE 0 END) AS AR_31_60_Days,
  SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) BETWEEN 61 AND 90 THEN Amount - PaidAmount ELSE 0 END) AS AR_61_90_Days,
  SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) > 90 THEN Amount - PaidAmount ELSE 0 END) AS AR_Over_90_Days,
  (SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) > 90 THEN Amount - PaidAmount ELSE 0 END) / NULLIF(SUM(Amount - PaidAmount), 0)) * 100 AS AR_Over_90_Percentage
FROM gold.fact_transactions
WHERE Amount - PaidAmount > 0;

-- ++ AR Over 90 Days Percentage
-- Overview: Calculates percentage of AR balance that is overdue by more than 90 days, flagging financial risk.
SELECT 
  SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) > 90 THEN Amount - PaidAmount ELSE 0 END) AS AR_Over_90_Days,
  SUM(Amount - PaidAmount) AS Total_AR,
  (SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) > 90 THEN Amount - PaidAmount ELSE 0 END) / SUM(Amount - PaidAmount)) * 100 AS AR_Over_90_Percentage
FROM gold.fact_transactions
WHERE Amount - PaidAmount > 0;

-- ++ Days in AR Calculation
-- Overview: Derives the average number of days it takes to collect payment, a key RCM performance metric.
SELECT 
  SUM(Amount - PaidAmount) / NULLIF(SUM(Amount) / COUNT(DISTINCT ServiceDate), 0) AS Days_In_AR
FROM gold.fact_transactions
WHERE Amount - PaidAmount > 0;

-- ++ Average Days to Collect Payments
-- Overview: Tracks the average payment delay in days, revealing cash flow efficiency.
SELECT 
  AVG(DATEDIFF(PaidDate, ServiceDate)) AS Avg_Days_To_Collect
FROM gold.fact_transactions
WHERE PaidAmount > 0;

-- ++ Predicting Future AR Risk
-- Overview: Uses historical AR aging to forecast risk of uncollected payments in the next 90 days.
WITH Historical_Trend AS (
  SELECT 
    DATEDIFF(CURRENT_DATE(), PaidDate) AS Days_Old,
    Amount - PaidAmount AS Pending_AR
  FROM gold.fact_transactions
  WHERE Amount - PaidAmount > 0
)
SELECT 
  SUM(CASE WHEN Days_Old + 90 > 90 THEN Pending_AR * 0.73 ELSE Pending_AR END) AS Estimated_Uncollected_AR
FROM Historical_Trend;

-- ================================================
-- Revenue & Performance Analytics
-- ================================================

-- ++ Total Charge Amount per Provider by Department
-- Overview: Calculates total billed amount by provider and department to understand billing contribution across teams.
SELECT
  CONCAT(p.firstname, ' ', p.LastName) AS Provider_Name,
  dd.Name AS Dept_Name,
  SUM(ft.Amount) AS Total_Charges
FROM gold.fact_transactions ft
LEFT JOIN gold.dim_provider p ON p.ProviderID = ft.FK_ProviderID
LEFT JOIN gold.dim_department dd ON dd.Dept_Id = p.DeptID
GROUP BY ALL;

-- ++ Monthly Provider Billing Summary for 2024
-- Overview: Tracks monthly billing and payment trends for providers by department for the year 2024.

-- Zordering the Frequently queried column ServiceDate to fetch the results faster
OPTIMIZE gold.fact_transactions
ZORDER BY (ServiceDate);

SELECT
  CONCAT(p.firstname, ' ', p.LastName) AS Provider_Name,
  dd.Name AS Dept_Name,
  DATE_FORMAT(ServiceDate, 'yyyyMM') AS YYYYMM,
  SUM(ft.Amount) AS Total_Charge_Amt,
  SUM(ft.PaidAmount) AS Total_Paid_Amt
FROM gold.fact_transactions ft
LEFT JOIN gold.dim_provider p ON p.ProviderID = ft.FK_ProviderID
LEFT JOIN gold.dim_department dd ON dd.Dept_Id = p.DeptID
WHERE YEAR(ft.ServiceDate) = 2024
GROUP BY ALL
ORDER BY 1, 3;

-- ++ Top 10 Providers by Revenue
-- Overview: Highlights top-performing providers by total revenue across departments.
SELECT 
  CONCAT(p.FirstName, ' ', p.LastName) AS Provider_Name,
  d.Name AS Department_Name,
  SUM(ft.Amount) AS Total_Revenue
FROM gold.fact_transactions ft
JOIN gold.dim_provider p ON p.ProviderID = ft.FK_ProviderID
JOIN gold.dim_department d ON d.Dept_Id = p.DeptID
GROUP BY Provider_Name, Department_Name
ORDER BY Total_Revenue DESC
LIMIT 10;

-- ================================================
-- Payment Collection & Efficiency
-- ================================================

-- ++ Payment Collection Efficiency by Provider
-- Overview: Measures collection effectiveness per provider by comparing charges to payments.
SELECT 
  CONCAT(p.FirstName, ' ', p.LastName) AS Provider_Name,
  SUM(ft.Amount) AS Total_Charge,
  SUM(ft.PaidAmount) AS Total_Paid,
  (SUM(ft.PaidAmount) * 100.0 / NULLIF(SUM(ft.Amount), 0)) AS Collection_Efficiency
FROM gold.fact_transactions ft
JOIN gold.dim_provider p ON p.ProviderID = ft.FK_ProviderID
GROUP BY Provider_Name
ORDER BY Collection_Efficiency DESC;

-- ++ Monthly Payment Trends
-- Overview: Monitors monthly revenue trends and payment collection rates.
SELECT 
  DATE_FORMAT(ServiceDate, 'yyyy-MM') AS YYYYMM,
  SUM(Amount) AS Total_Billed,
  SUM(PaidAmount) AS Total_Paid,
  (SUM(PaidAmount) * 100.0 / NULLIF(SUM(Amount), 0)) AS Payment_Collection_Percentage
FROM gold.fact_transactions
GROUP BY YYYYMM
ORDER BY YYYYMM;



-- ================================================
-- Claims & Denial Analytics
-- ================================================

-- ++ Claim Acceptance Rate
-- Overview: Categorizes claims into accepted, partially accepted, or denied, highlighting payer reliability.
SELECT 
  ClaimID,
  COUNT(*) AS Total_Claims,
  SUM(CASE WHEN PaidAmount = Amount THEN 1 ELSE 0 END) AS Fully_Accepted_Claims,
  SUM(CASE WHEN PaidAmount < Amount AND PaidAmount > 0 THEN 1 ELSE 0 END) AS Partially_Accepted_Claims,
  SUM(CASE WHEN PaidAmount = 0 THEN 1 ELSE 0 END) AS Denied_Claims,
  (SUM(CASE WHEN PaidAmount = Amount THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Acceptance_Rate
FROM gold.fact_transactions
GROUP BY ClaimID
ORDER BY Acceptance_Rate DESC;

-- ++ Claim Rejection Patterns by Procedure Code
-- Overview: Identifies which procedure codes (CPT) have the highest denial rates, useful for revenue optimization.
SELECT 
  ft.ProcedureCode, 
  dc.procedure_code_descriptions, 
  COUNT(ft.ClaimID) AS Total_Claims,
  SUM(CASE WHEN ft.PaidAmount = 0 THEN 1 ELSE 0 END) AS Denied_Claims,
  (SUM(CASE WHEN ft.PaidAmount = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(ft.ClaimID)) AS Denial_Rate
FROM gold.fact_transactions ft
JOIN gold.dim_cpt_code dc ON ft.ProcedureCode = dc.cpt_codes
GROUP BY ft.ProcedureCode, dc.procedure_code_descriptions
ORDER BY Denial_Rate DESC
LIMIT 10;
