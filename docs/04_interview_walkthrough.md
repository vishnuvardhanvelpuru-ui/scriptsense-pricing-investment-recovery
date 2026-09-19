# Interview walkthrough

“I built a simulated 36-customer case for ScriptSense, a B2B movie-script analysis platform. I used MySQL to calculate customer economics, then built an Excel dashboard and tiered-pricing scenarios. I found that high support costs weakened some contracts and that usage allowances could make pricing more consistent. Repricing improved modelled operating surplus, but it did not meet a five-year recovery benchmark for the assumed ₹2.5 crore seed investment. I recommended testing renewal prices and fixing weak service economics before promising investment recovery.”

## Explain the numbers
- One row is one customer at a single snapshot. Annual contract value is 12 times the monthly run rate, not historical bookings.
- Gross profit subtracts hosting and attributable service-support costs. Total company cost adds fixed overhead. Payback uses operating surplus, not revenue or gross profit.
- C001 pays ₹12,000, costs ₹2,500 and earns ₹9,500 gross profit. Its 15 runs are within the proposed 25-run allowance, so proposed price is ₹12,960.
- C012 pays ₹9,600, costs ₹14,600 and loses ₹5,000. It has 40 runs, so its proposed price is ₹10,368 + 15 × ₹200 = ₹13,368. It still loses ₹1,232 before overhead: the proposal does not magically fix every account.
- A JOIN attaches tier settings without adding customer rows. SUM and GROUP BY explain segment/tier performance. CASE assigns review reasons. CROSS JOIN evaluates the same customers under each scenario.
- Portfolio gross margin is SUM(gross profit)/SUM(revenue). An average of customer percentages would misweight small accounts.
- 95% retention is a sensitivity assumption, not predicted churn. It is applied once, not every month. Fractional customer equivalents are expected values.
- The seed amount is assumed unrecovered at month zero. Estimated payback does not mean an investor receives that money or that a valuation has been calculated.

## Defend the recommendations
Why these prices? They are bounded hypotheses tied to usage and workflow value; a pilot is needed to establish acceptance. Why only 36? To demonstrate an understandable analysis, not make a statistical market claim. Why no CAC/LTV? There is no acquisition/cohort evidence. Why no machine learning? The decision needs transparent unit economics and sensitivities.

Open Dashboard for the baseline, Pricing for the scenario selector, Assumptions for editable inputs, Customers for the 36 row calculations, Analysis for rankings and segment totals, and Recovery for cash checkpoints. Explain a formula yourself before claiming mastery. Be transparent that AI assisted with implementation and that the data is fictional.
