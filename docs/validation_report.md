# Data validation report

## Dataset status

This project uses **synthetic sample data**. Names and records do not represent
real customers. The raw source files are retained unchanged under `data/raw/`.

## Repair applied

The raw dataset contained 89 orders dated before the associated customer's
signup date, affecting 44 of 60 customers. Three customers also appeared to
have last-active dates before signup because of the same signup-date issue.

The reproducible repair in `python/repair_data.py` moves an inconsistent signup
date back to the earliest recorded customer activity. Transaction dates,
quantities, values, statuses and identifiers are not modified. No last-active
date required adjustment after the signup-date repair.

## Post-repair checks

| Check | Result |
|---|---:|
| Customer rows | 60 |
| Order rows | 253 |
| Product rows | 12 |
| Signup dates repaired | 44 |
| Orders before signup | 0 |
| Orders after last active date | 0 |
| Duplicate primary identifiers | 0 |
| Unmatched customer keys | 0 |
| Unmatched product keys | 0 |
| Missing values | 0 |
| Non-positive quantities | 0 |
| Negative order values or discounts | 0 |

## Analysis convention

Only orders with `order_status = 'Completed'` contribute to realised sales,
order, unit and discount measures. Cancelled and returned orders remain in the
model for operational analysis.
