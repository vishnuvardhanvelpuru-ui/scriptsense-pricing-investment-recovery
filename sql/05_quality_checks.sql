USE scriptsense_strategy;
-- Expected: 36 / 36 / 1 and 12 customers per tier.
SELECT COUNT(*) AS rows_loaded,COUNT(DISTINCT customer_id) AS unique_customers,
 COUNT(DISTINCT snapshot_date) AS snapshot_dates FROM customers;
SELECT tier_id,COUNT(*) AS customers FROM customers GROUP BY tier_id;
-- Expected 36, 3, 1, 4. Missing assumptions would remove all scenario rows.
SELECT (SELECT COUNT(*) FROM customer_economics) AS joined_rows,
 (SELECT COUNT(*) FROM tiers) AS tiers,(SELECT COUNT(*) FROM assumptions) AS assumptions,
 (SELECT COUNT(*) FROM scenarios) AS scenarios;
-- Both differences must be zero, across every scenario.
SELECT scenario_name,monthly_revenue_inr-monthly_direct_cost_inr-monthly_gross_profit_inr AS gp_difference,
 monthly_revenue_inr-monthly_total_cost_inr-monthly_operating_surplus_inr AS surplus_difference FROM scenario_results;
-- Expected zero. Low-margin or negative-GP accounts must remain in the data.
SELECT COUNT(*) AS above_list FROM customer_economics WHERE contracted_monthly_inr>list_monthly_inr;
SELECT customer_id,gross_profit_inr FROM customer_economics WHERE gross_profit_inr<0;
