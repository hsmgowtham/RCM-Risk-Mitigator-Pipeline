-- Total Charge Amount per provider by department
select
  concat(p.firstname, ' ', p.LastName) Provider_Name,
  dd.Name Dept_Name,
  sum(ft.Amount)
from
  gold.fact_transactions ft
  left join gold.dim_provider p on p.ProviderID = ft.FK_ProviderID
  left join gold.dim_department dd on dd.Dept_Id = p.DeptID
group by
  all 
  
  
-- Total Charge Amount per provider by department for each month for year 2024
select
  concat(p.firstname, ' ', p.LastName) Provider_Name,
  dd.Name Dept_Name,
  date_format(servicedate, 'yyyyMM') YYYYMM,
  sum(ft.Amount) Total_Charge_Amt,
  sum(ft.paidamount) Total_Paid_Amt
from
  gold.fact_transactions ft
  left join gold.dim_provider p on p.ProviderID = ft.FK_ProviderID
  left join gold.dim_department dd on dd.Dept_Id = p.DeptID
where
  year(ft.ServiceDate) = 2024
group by
  all
order by
  1,
  3

-- Accounts Receivable (AR) > 90 Days
-- calculate the percentage of AR that is older than 90 days.
SELECT 
  SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) > 90 THEN Amount - PaidAmount ELSE 0 END) AS AR_Over_90_Days,
  SUM(Amount - PaidAmount) AS Total_AR,
  (SUM(CASE WHEN DATEDIFF(CURRENT_DATE(), PaidDate) > 90 THEN Amount - PaidAmount ELSE 0 END) / SUM(Amount - PaidAmount)) * 100 AS AR_Over_90_Percentage
FROM gold.fact_transactions
WHERE Amount - PaidAmount > 0;

-- Days in AR Calculation
-- calculate the average number of days it takes to collect payments.
SELECT 
  SUM(Amount - PaidAmount) / NULLIF(SUM(Amount) / COUNT(DISTINCT ServiceDate), 0) AS Days_In_AR
FROM gold.fact_transactions
WHERE Amount - PaidAmount > 0;

-- Claim Acceptance Rate by Insurance Provider
-- Measure how many claims are fully accepted versus denied.
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

-- Monthly Payment Trends
-- Display how payments have trended over time.
SELECT 
  DATE_FORMAT(ServiceDate, 'yyyy-MM') AS YYYYMM,
  SUM(Amount) AS Total_Billed,
  SUM(PaidAmount) AS Total_Paid,
  (SUM(PaidAmount) * 100.0 / NULLIF(SUM(Amount), 0)) AS Payment_Collection_Percentage
FROM gold.fact_transactions
GROUP BY YYYYMM
ORDER BY YYYYMM;

-- Top 10 Providers by Revenue
-- Identify the highest-earning providers.
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

