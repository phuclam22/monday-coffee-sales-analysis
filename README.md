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

## Key Business Insights & Recommendations
1. **The Cash Cow (Pune):** Highly profitable with low average rent and high customer spending. Ideal for maximizing net profit.
2. **The Scalable Giant (Delhi):** Massive untapped potential with 7.7 million estimated consumers. The prime target for aggressive expansion and marketing.
3. **The Volume Driver (Jaipur):** High foot traffic and customer count offset low margins, creating a highly stable market presence.
4. **Marketing Pivot:** With a near 100% retention rate, marketing budgets should shift from "Win-back" campaigns to "Frequency & Up-selling" strategies (e.g., loyalty programs).
