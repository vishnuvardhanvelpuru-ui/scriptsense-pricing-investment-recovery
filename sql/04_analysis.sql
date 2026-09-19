USE scriptsense_strategy;
-- Q1. Company KPIs: total cost includes both direct service cost and fixed overhead.
SELECT expected_customers AS customer_count,monthly_revenue_inr,monthly_direct_cost_inr,
 monthly_total_cost_inr,monthly_gross_profit_inr,gross_margin,monthly_operating_surplus_inr,
 average_annual_contract_inr FROM scenario_results WHERE scenario_name='Current';
-- Q2. Segment economics. Gross profit is before unallocated company overhead.
SELECT segment,COUNT(*) AS customers,SUM(contracted_monthly_inr) AS revenue_inr,
 SUM(direct_cost_inr) AS direct_cost_inr,SUM(gross_profit_inr) AS gross_profit_inr,
 SUM(gross_profit_inr)/SUM(contracted_monthly_inr) AS gross_margin
FROM customer_economics GROUP BY segment ORDER BY gross_profit_inr DESC;
-- Q3. Tier economics and weighted discount; do not average customer margins.
SELECT tier_name,COUNT(*) AS customers,SUM(contracted_monthly_inr) AS revenue_inr,
 SUM(gross_profit_inr) AS gross_profit_inr,
 SUM(gross_profit_inr)/SUM(contracted_monthly_inr) AS gross_margin,
 1-SUM(contracted_monthly_inr)/SUM(list_monthly_inr) AS weighted_discount
FROM customer_economics GROUP BY tier_name ORDER BY gross_profit_inr DESC;
-- Q4. Lowest and highest gross-profit contracts.
SELECT customer_id,segment,tier_name,contracted_monthly_inr,direct_cost_inr,gross_profit_inr,gross_margin
FROM customer_economics ORDER BY gross_profit_inr,customer_id LIMIT 5;
SELECT customer_id,segment,tier_name,gross_profit_inr FROM customer_economics
ORDER BY gross_profit_inr DESC,customer_id LIMIT 5;
-- Q5. Potential underpricing is a review signal, not evidence of willingness to pay.
SELECT customer_id,review_reason,monthly_script_runs,included_script_runs,
 effective_price_per_run_inr,cost_to_revenue,discount_rate,gross_margin,
 contracted_monthly_inr,proposed_monthly_inr,
 proposed_monthly_inr-contracted_monthly_inr AS proposed_increase_inr
FROM customer_economics WHERE review_reason<>'No flag' ORDER BY gross_margin,customer_id;
-- Q6. Customer and tier concentration.
SELECT SUM(contracted_monthly_inr)/(SELECT SUM(contracted_monthly_inr) FROM customers) AS top5_revenue_share
FROM (SELECT contracted_monthly_inr FROM customers ORDER BY contracted_monthly_inr DESC,customer_id LIMIT 5) top5;
SELECT tier_name,COUNT(*)/36.0 AS customer_share,
 SUM(contracted_monthly_inr)/(SELECT SUM(contracted_monthly_inr) FROM customers) AS revenue_share
FROM customer_economics GROUP BY tier_name;
-- Q7. Proposed prices by tier before any retention loss or delayed adoption.
SELECT tier_name,SUM(contracted_monthly_inr) AS current_revenue_inr,
 SUM(proposed_monthly_inr) AS proposed_revenue_inr,SUM(overage_inr) AS usage_charge_inr,
 SUM(proposed_gross_profit_inr) AS proposed_gross_profit_inr
FROM customer_economics GROUP BY tier_name;
-- Q8. Alternative steady-state scenarios. Never sum these rows.
SELECT * FROM scenario_results ORDER BY scenario_id;
-- Q9. Retention threshold to cover costs and recover within 60 months.
-- A target_retention above 1 means pricing alone cannot achieve the target.
SELECT fixed_monthly_cost_inr/monthly_gross_profit_inr AS break_even_retention,
 (fixed_monthly_cost_inr+initial_investment_inr/target_payback_months)/monthly_gross_profit_inr AS target_retention
FROM scenario_results WHERE scenario_name='Upside';
-- Q10. Annual checkpoints, in months: not historical cash flow.
WITH RECURSIVE months AS (SELECT 0 AS month UNION ALL SELECT month+12 FROM months WHERE month<240)
SELECT s.scenario_name,m.month,-s.initial_investment_inr+m.month*s.monthly_operating_surplus_inr AS cumulative_net_cash_inr
FROM scenario_results s CROSS JOIN months m ORDER BY s.scenario_id,m.month;
