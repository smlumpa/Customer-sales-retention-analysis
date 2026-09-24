# Data validation and KPI reconciliation

## Dataset status

This project uses **synthetic sample data**. Names and records do not represent
real customers. The raw source files are retained unchanged under `data/raw/`.

## Record counts

| Table | Rows |
|---|---:|
| Customers | 60 |
| Orders | 253 |
| Products | 12 |

Order-status distribution:

| Status | Orders |
|---|---:|
| Completed | 189 |
| Returned | 32 |
| Cancelled | 32 |

## Published dashboard KPIs

The original Power BI model was inspected through its VPAX export.

| KPI | Verified result | Calculation basis |
|---|---:|---|
| Total Revenue | £104,317.21 | All recorded order values |
| Average Order Value | £412.32 | £104,317.21 / 253 orders |
| Repeat Customers | 57 | Customer appears after initial cohort month |
| Average Monthly Retention Rate | 78.03% | Average monthly retention measure |

The website rounds these values to £104.32K, £412.32, 57 and 78.0%.

## Secondary completed-order view

| KPI | Result |
|---|---:|
| Completed-order sales | £82,397.95 |
| Completed orders | 189 |
| Average completed-order value | £435.97 |
| Repeat completed-order customers | 48 |
| Repeat completed-order customer rate | 80.0% |

The two KPI sets are not contradictory: the published dashboard uses all
recorded transactions for its headline revenue and order cards, while the
secondary analysis filters to completed orders as realised sales.

## Repair applied

The raw dataset contained 89 orders dated before the associated customer's
signup date, affecting 44 customers. Three customers also appeared to have
last-active dates before signup because of the same signup-date issue.

The reproducible repair in `python/repair_data.py` moves an inconsistent signup
date back to the earliest recorded customer activity. Transaction dates,
quantities, values, statuses and identifiers are not modified.

## Post-repair integrity checks

| Check | Result |
|---|---:|
| Signup dates repaired | 44 |
| Orders before signup | 0 |
| Orders after last-active date | 0 |
| Duplicate primary identifiers | 0 |
| Unmatched customer keys | 0 |
| Unmatched product keys | 0 |
| Missing values | 0 |
| Non-positive quantities | 0 |
| Negative order values or discounts | 0 |

## Retention-measure note

The published `Average Retention Rate` iterates over
`customer_transactions[Month Name]`. This reproduces 78.03%, but month names
can combine matching months from different years. A future model revision could
use Year-Month while retaining the published measure for historical comparison.
