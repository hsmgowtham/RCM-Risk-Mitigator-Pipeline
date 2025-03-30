# RCM-Risk-Mitigator-Pipeline
A data-driven project to analyze and improve healthcare revenue cycle performance by identifying high-risk accounts receivables and optimizing patient payment timelines.

**Domain:** Health Care **Revenue Cycle Management** (RCM)

**RCM** is the process used by hospitals to manage the financial aspect from the time the patient schedules an appointment until the provider gets paid.

### Process:
1. The patient visits the hospital.
2. Patient details are collected (Mainly insurance). This ensures the provider (hospital) knows who will pay (patient, insurer, or both) for the services.
3. Services are provided.
4. Billing occurs: The hospital generates a bill.
5. Claims are reviewed: The insurance company reviews the bill (accept in full, partial, or decline).
6. Payments and follow-ups: The insurer pays, and the patient may cover the remaining balance.
7. Tracking and improvements: Continuous monitoring to optimize financial health.

**RCM** ensures hospitals can provide quality care while maintaining financial stability.

---

## KPI

### Two Key Aspects of RCM:
- **Accounts Receivable (AR):** Payments hospitals need to collect.
- **Accounts Payable:** Payments hospitals need to make.

### Risk Factors in AR:
Patient payments are a significant risk. Poor AR management can strain cash flow and result in lost revenue. 

### Common Scenarios Where Patients Bear the Payment Burden:
- **Low Insurance Coverage** – High out-of-pocket costs for patients.
- **Private Clinics** – Certain insurance policies may not be accepted.
- **Dental Treatments** – Insurance often does not cover these services.

### Objectives for Healthy AR:
1. **Maximize Collections** – Ensure payments are received from patients.
2. **Minimize Collection Period** – Reduce delays in payments.

The probability of collecting the full amount decreases over time:
- **93%** of payments are collected within **30 days**.
- **85%** of payments are collected within **60 days**.
- **73%** of payments are collected within **90 days**.

---

## KPI (Key Performance Indicators) to Measure AR Health

### 1. **AR Aging > 90 Days**
   - AR older than 90 days is likely to remain uncollected.
   - **Example Calculation:**
     - Total AR: **$1,000,000**
     - AR > 90 days: **$100,000**
     - **AR > 90 days / Total AR = 10%**
   - If AR > 90 days remains around **10% or higher**, it indicates inefficiencies in collections.
   - **Action:** Investigate the cause and address process gaps.

### 2. **Days in AR**
   - Measures how long it takes to collect outstanding revenue.
   - **Example Calculation:**
     - Revenue: **$1M in 100 days** → **$10,000 per day**
     - Outstanding AR: **$400,000**
     - **Estimated Collection Time = 400,000 / 10,000 = 40 days**
   - If AR extends beyond this timeframe, alerts should be triggered for intervention.

---

## References
- [Healthcare Accounts Receivable Management](https://mdmanagementgroup.com/healthcare-accounts-receivable-management/)
- [Revenue Cycle Metrics & RCM KPIs](https://www.mdclarity.com/blog/revenue-cycle-metrics-rcm-kpis/)
