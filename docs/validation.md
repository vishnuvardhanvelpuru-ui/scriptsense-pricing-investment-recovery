# Validation status

Executed on 19 September 2026 against MySQL 8.0.46 using an isolated temporary instance bound to localhost. Existing user databases were not used. The temporary server was shut down after validation.

## Verified

- Final schema, views, all ten numbered analytical questions and quality-check queries executed successfully.
- Both import paths ran in separate test databases: SQL INSERT seed and actual LOAD DATA LOCAL INFILE from all four raw CSVs. CSV loading produced no warnings.
- Both imports produced identical 36-row customer-economics results. Every customer price, direct cost, gross profit, proposed price and review reason reconciled to an independent decimal calculation.
- All four scenarios reconciled to the supplied reference CSV; monetary totals matched within INR 0.00001, payback within 0.01 months/years, and margins within 0.00001. All six segment/tier summaries and all 84 annual recovery checkpoints reconciled.
- Zero/negative surplus returned NULL payback. Zero retained revenue returned NULL margin. A negative hosting-cost update was rejected by the MySQL CHECK constraint.
- Recovery checkpoints cover month zero through month 240. No user credentials were read or embedded.

## Excel and delivery status

The final Excel workbook was built, rendered and checked after construction. Power BI is outside the final scope. Repository visibility is private. This document records local artifact and SQL verification; GitHub commit history records uploaded versions.

The data is synthetic and the model depends on its documented assumptions. Execution validates implementation, not commercial realism.

## Final Excel verification

- Six populated sheets and four native charts with cell-range references; filterable customer table, frozen identifiers/headers and scenario dropdown.
- All 36 customer prices, direct costs, gross profits, margins, overages, proposed prices and priority flags reconcile to the independent calculation and SQL baseline.
- All four scenario revenues, direct costs, gross profits, margins, surpluses and payback estimates reconcile. All segment/tier summaries and 84 recovery checkpoints reconcile.
- Tested the selector with Current and restored Base. Tested zero retention and non-positive surplus: undefined margin/payback returns blank. Restored all saved baseline inputs.
- Checked the nine 20%-discount contracts explicitly. Discounts are rounded to four decimal places before comparisons to avoid floating-point boundary errors.
- Rendered and visually inspected all six sheets, including both halves of the wide customer table. Checked headings, units, charts, notes and negative-value formatting.
- Reopened the saved XLSX with a separate reader. Verified cached calculations, formula error absence, table/selector presence, four charts, and no macros/external links. No Excel desktop recalculation is claimed; the formula engine and exported file were validated independently.

## Reconciled results

| Metric | Current | Base |
|---|---:|---:|
| Monthly revenue, INR | 952650.00 | 1027317.65 |
| Monthly direct cost, INR | 345800.00 | 328510.00 |
| Monthly total cost, INR | 845800.00 | 828510.00 |
| Monthly gross profit, INR | 606850.00 | 698807.65 |
| Gross margin | 63.7013% | 68.0225% |
| Monthly operating surplus, INR | 106850.00 | 198807.65 |
| Payback years | 19.50 | 10.48 |

Base payback rises to 10.95 years when support costs stay fixed after customer loss, or 14.00 years with 10% higher overhead. Those are separate sensitivities, not combined stresses.

## Scope changes and repository status

Retained the same 36 IDs and baseline revenue/cost inputs. Adapted generic industries/seats into script-industry segments and monthly analysis runs. Replaced the earlier ₹24 lakh recovery assumption with the user's ₹2.5 crore case. Replaced the unfinished Power BI scope with the completed Excel dashboard. Superseded draft files were removed from the deliverable folder, not duplicated in the final package.

The repository must remain private unless its owner explicitly requests a visibility change. GitHub commit history records the delivered files and subsequent updates.
