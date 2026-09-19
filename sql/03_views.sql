USE scriptsense_strategy;
-- Customer economics before fixed company overhead; one row per customer.
CREATE OR REPLACE VIEW customer_costs AS
SELECT c.*,t.tier_name,t.list_monthly_inr,t.proposed_increase,t.included_script_runs,t.overage_per_run_inr,
 c.hosting_monthly_inr+c.support_hours_monthly*c.support_hourly_cost_inr AS direct_cost_inr,
 GREATEST(c.monthly_script_runs-t.included_script_runs,0)*t.overage_per_run_inr AS overage_inr,
 1-c.contracted_monthly_inr/t.list_monthly_inr AS discount_rate
FROM customers c JOIN tiers t ON c.tier_id=t.tier_id;
CREATE OR REPLACE VIEW customer_economics AS
SELECT c.*,
 contracted_monthly_inr-direct_cost_inr AS gross_profit_inr,
 (contracted_monthly_inr-direct_cost_inr)/contracted_monthly_inr AS gross_margin,
 contracted_monthly_inr*12 AS annualized_contract_inr,
 contracted_monthly_inr/monthly_script_runs AS effective_price_per_run_inr,
 direct_cost_inr/contracted_monthly_inr AS cost_to_revenue,
 ROUND(contracted_monthly_inr*(1+proposed_increase),2)+overage_inr AS proposed_monthly_inr,
 ROUND(contracted_monthly_inr*(1+proposed_increase),2)+overage_inr-direct_cost_inr AS proposed_gross_profit_inr,
 CASE WHEN (contracted_monthly_inr-direct_cost_inr)/contracted_monthly_inr<a.review_margin THEN 'Margin review'
      WHEN monthly_script_runs>included_script_runs THEN 'Usage review'
      WHEN discount_rate>=0.20 THEN 'Discount review' ELSE 'No flag' END AS review_reason
FROM customer_costs c CROSS JOIN assumptions a;
-- Adoption is the proportion repriced among retained accounts, holding mix constant.
CREATE OR REPLACE VIEW scenario_totals AS
SELECT s.scenario_id,s.scenario_name,s.adoption_rate,s.retention_rate,
 COUNT(*)*s.retention_rate AS expected_customers,
 SUM(e.contracted_monthly_inr+s.adoption_rate*(e.proposed_monthly_inr-e.contracted_monthly_inr))*s.retention_rate AS monthly_revenue_inr,
 SUM(e.direct_cost_inr)*s.retention_rate AS monthly_direct_cost_inr
FROM customer_economics e CROSS JOIN scenarios s
GROUP BY s.scenario_id,s.scenario_name,s.adoption_rate,s.retention_rate;
CREATE OR REPLACE VIEW scenario_results AS
SELECT z.*,
 CASE WHEN monthly_operating_surplus_inr>0 THEN initial_investment_inr/monthly_operating_surplus_inr END AS payback_months,
 CASE WHEN monthly_operating_surplus_inr>0 THEN initial_investment_inr/monthly_operating_surplus_inr/12 END AS payback_years,
 CASE WHEN monthly_operating_surplus_inr>0 THEN CEILING(initial_investment_inr/monthly_operating_surplus_inr) END AS first_whole_recovery_month,
 monthly_operating_surplus_inr*target_payback_months-initial_investment_inr AS net_cash_at_target_inr
FROM (
 SELECT s.*,a.initial_investment_inr,a.fixed_monthly_cost_inr,a.target_payback_months,
 monthly_revenue_inr*12 AS annualized_revenue_inr,
 monthly_revenue_inr*12/NULLIF(expected_customers,0) AS average_annual_contract_inr,
 monthly_direct_cost_inr+a.fixed_monthly_cost_inr AS monthly_total_cost_inr,
 monthly_revenue_inr-monthly_direct_cost_inr AS monthly_gross_profit_inr,
 (monthly_revenue_inr-monthly_direct_cost_inr)/NULLIF(monthly_revenue_inr,0) AS gross_margin,
 monthly_revenue_inr-monthly_direct_cost_inr-a.fixed_monthly_cost_inr AS monthly_operating_surplus_inr
 FROM scenario_totals s CROSS JOIN assumptions a
) z;
