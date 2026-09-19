# Case, data dictionary and assumptions

ScriptSense is a fictional early-stage B2B generative-AI platform that analyzes movie scripts. Its case narrative assumes approximately ₹2.5 crore seed funding for engineering, infrastructure, model deployment and business development. Initial pricing is described as cost-plus. No real fundraising, customer data, market prices or client outcomes are represented.

This portfolio uses exactly 36 simulated enterprise customer organizations, C001–C036. The final case preserves the earlier draft's IDs, monthly contract prices, hosting costs and support costs. Generic industries and seat counts have been adapted into movie-industry segments and script-analysis runs. Snapshot: 31 August 2026. All money is INR. One row means one active customer at the snapshot, not a transaction or monthly time series.

## Data model
`customers.tier_id → tiers.tier_id` is many-to-one. `assumptions` has one company-wide row. `scenarios` has four alternative planning cases. SQL views derive costs and pricing without changing the customer grain. Raw files contain only inputs; processed files contain checked results. These should not be appended together.

| Input | Definition |
|---|---|
| customer_id, customer_name | Unique ID and explicitly simulated organization label |
| segment | Independent Studios, Production Houses or Streaming Studios; customer business type, not subscription tier |
| tier_id | Core=1, Growth=2, Enterprise=3; 12 customers in each tier |
| snapshot_date | ISO date, 2026-08-31 |
| monthly_script_runs | Completed analysis runs per month, including repeated analysis of revised scripts |
| contracted_monthly_inr | Recurring monthly subscription fee after legacy discount |
| hosting_monthly_inr | Customer-attributable inference, hosting and delivery infrastructure cost/month |
| support_hours_monthly | Customer-attributable service-delivery hours/month |
| support_hourly_cost_inr | Assumed avoidable service-delivery cost/hour, ₹500 |
| tiers.list_monthly_inr | Current undiscounted account fee: ₹12,000 / ₹25,000 / ₹50,000 |
| proposed_increase | Renewal base-price increase: 8% / 10% / 12% |
| included_script_runs | Proposed monthly allowance: 25 / 80 / 250 |
| overage_per_run_inr | Proposed additional run fee: ₹200 / ₹150 / ₹100 |
| initial_investment_inr | ₹25,000,000 (₹2.5 crore) assumed unrecovered at model month zero |
| fixed_monthly_cost_inr | ₹500,000 monthly company overhead, excluding direct hosting and support |
| target_payback_months | 60-month comparison benchmark, a modelling choice, not an investor promise |
| review_margin | 50% gross-margin screening threshold; managerial assumption, not industry benchmark |
| adoption_rate | Proportion of retained accounts repriced at proposed terms, constant mix |
| retention_rate | One-time proportion of customer economics retained; not monthly churn |

## Formulas
Direct service cost = hosting + support hours × hourly cost. Gross profit = recurring revenue − direct service cost. Gross margin = total gross profit / total revenue. This case classifies attributable support as cost of service. It does not claim audited accounting treatment.

Total company cost = direct service cost + fixed overhead. Operating surplus = revenue − total company cost. Customer/segment gross profit excludes unallocated fixed overhead. Average annual contract value = 12 × monthly revenue / active customers, an annualized run rate, not observed annual bookings.

Proposed price = rounded(current contract × (1 + tier uplift), 2) + max(runs − proposed allowance, 0) × overage. Legacy base-price discounts are preserved in this scenario, and overage is not discounted. Existing contracts have no usage overage. Overage prices are incremental charges above an already paid base fee and are not equivalent to standalone prices per script.

Review signals: first flag margin below 50%, then usage above the proposed allowance, then discount of at least 20%. A customer appears once in the priority list. Signals overlap in reality; flags do not prove underpricing, excess willingness to pay, or the right to charge retroactively.

Scenario revenue = sum(current + adoption × (proposed − current)) × retention. Direct cost scales with retention. Fixed overhead remains unchanged. Pricing/usage changes are applied to the existing runs; no extra demand or customers are assumed. Fractional expected customer counts are weighted equivalents, not literal organizations.

Payback months = ₹25,000,000 / positive monthly operating surplus. Non-positive surplus has no finite payback. Whole recovery month rounds up. Cumulative net cash at month m = −₹25,000,000 + m × surplus. This is an undiscounted operating-cash proxy, not an equity investor's repayment schedule or valuation.

## Explicit simplifications and limitations
Cash collection is assumed in the billing month; no tax, debt, financing cash flow, working capital, future capex, terminal value or discounting. No growth, inflation, recurring churn or seasonality. All the seed amount is unrecovered at month zero; no historical revenue is deducted from it. Engineering/sales/business development are covered by fixed overhead; initial build investment is separate from ongoing costs. No acquisition funnel exists, so customer CAC and LTV/CAC are not invented.

Support is modelled as avoidable delivery cost. If it is salaried and sticky, lost customers will save less: use the fixed-cost sensitivity in Pricing. Steady-state prices/adoption apply from month one, so a gradual rollout would delay recovery. Long payback estimates are mathematical comparisons, not credible 20-year forecasts. Equal tier sizes and repeated discounts are synthetic construction choices.

## Workbook conventions
Blue input cells are editable. Currency on Dashboard and Pricing is in ₹ lakh, with investment in ₹ crore; working tables use INR. 1 lakh=100,000 and 1 crore=10,000,000. Formula summaries and native charts are used instead of PivotTables for a small, transparent model. Customer table filters and the Pricing scenario dropdown are functional. Model ranges intentionally cover exactly 36 customers; do not append extra rows without extending formulas and source scope.
