# Monday Coffee - Sales & Customer Behavior Analysis

## Project Overview
This project is an end-to-end data analysis portfolio designed to evaluate the business performance, market potential, and customer loyalty of **Monday Coffee**, a growing F&B chain. By utilizing advanced SQL techniques, this analysis uncovers actionable insights to guide future expansion and marketing strategies.

## Tools & Technologies
- **RDBMS:** Microsoft SQL Server
- **Core Techniques:** Common Table Expressions (CTEs), Window Functions (`RANK`, `LAG`, `NTILE`), Subqueries, Data Type Casting, and Cohort/Retention Logic.

## Analytical Framework (12 Queries)
The analysis is structured into 5 strategic phases to simulate a real-world Business Intelligence workflow:

### Phase 1: Market Size & Exploration
- Estimating total addressable market (TAM) based on city populations.
- Identifying hero products and baseline customer counts across different regions.

### Phase 2: Business Performance & Trends
- Measuring total revenue for Q4 2023.
- Calculating Month-over-Month (MoM) sales growth using `LAG()` window functions to track business momentum.

### Phase 3: Behavior & Unit Economics
- Analyzing average sales per customer (ARPU) versus average rent per customer to evaluate regional profitability.
- Identifying top-selling products by volume in each city using `DENSE_RANK()`.

### Phase 4: Strategic Recommendations
- Assessing market penetration (Current vs. Potential Customers).
- Recommending the top 3 cities for future investment based on a balanced scorecard of revenue, rent costs, and consumer base.

### Phase 5: Advanced Customer Intelligence
- **Customer Retention Analysis:** Discovered a massive **99.6% retention rate** from 2023 to 2024, indicating exceptional product-market fit.
- **RFM Customer Segmentation:** Automated a scoring model using `NTILE()` to categorize customers into *VIP*, *Regular*, and *At Risk* segments for targeted marketing campaigns.

## Key Business Insights & Strategic Recommendations

Instead of just reporting numbers, this analysis solves core business problems and provides actionable strategies for Monday Coffee's executive team:

### 1. Solving the Revenue Decline Paradox
* **The Problem:** The MoM Sales Growth analysis (Q9) indicated a significant revenue drop in early 2024, raising alarms about customer churn.
* **The Insight:** Advanced cohort analysis (Q11) revealed a staggering **99.6% customer retention rate** from 2023 to 2024. Customers did not abandon the brand; rather, their purchasing frequency and average basket size plummeted after the Q4 holiday season.
* **Strategic Recommendation:** Immediately halt expensive "Win-back" or "New Acquisition" marketing campaigns. Redirect the budget toward **Monetization and Frequency-building**. Implement a Loyalty Point System (e.g., "Buy 5 get 1 free"), aggressive morning combo deals, and limited-time offers to force customers to open their wallets more frequently.

### 2. Capital Allocation & Expansion Strategy
* **The Problem:** The company needs to decide where to allocate its limited expansion budget for the highest ROI without burning cash.
* **The Insight:** Market Potential Analysis (Q10) combined with Unit Economics (Q8) identified three distinct market archetypes:
  * **Pune (The Cash Cow):** Highest total sales + lowest rent per customer. Unit economics here are extremely healthy.
  * **Delhi (The Scalable Giant):** 7.7 million untapped consumers with an average rent per customer well within the safe threshold (<500).
* **Strategic Recommendation:** Adopt a **"Defend and Expand"** strategy. Treat Pune as the primary profit engine to fund system-wide operations. Funnel the majority of new expansion capital (Capex) into Delhi to aggressively capture market share in this massive blue ocean.

### 3. Transitioning to Automated, Personalized CRM
* **The Problem:** A "one-size-fits-all" marketing approach is wasting resources and failing to maximize Customer Lifetime Value (CLV).
* **The Insight:** The RFM Segmentation model (Q12) successfully categorized the entire database into *VIP*, *Regular*, and *At-Risk* buckets based on actual purchasing behavior (Recency, Frequency, Monetary).
* **Strategic Recommendation:** Integrate the RFM SQL logic directly into Monday Coffee's CRM system to automate targeted campaigns:
  * **VIPs:** Offer exclusive perks (e.g., secret menu, free up-size) to maintain brand advocacy.
  * **Regulars:** Push Cross-selling bundles (Coffee + Pastry) to elevate them to VIP status.
  * **At-Risk:** Trigger automated "We miss you" deep-discount vouchers to reactivate their habit before they officially churn.
