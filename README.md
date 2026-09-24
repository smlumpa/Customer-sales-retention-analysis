# Customer Sales & Retention Analysis

**SQL · BigQuery · Power BI · DAX · Customer Analytics**

An end-to-end portfolio project that models synthetic customer, order and
product data in BigQuery and analyses sales, customer status, repeat purchasing
and commercial performance in Power BI.

> **Data declaration:** All records are synthetic sample data. Names are
> fictitious and no confidential client or employer information is included.

## Business questions

- Which customer segments and product categories generate the most sales?
- What proportion of customers are active, at risk or churned?
- How many purchasing customers return for another completed order?
- Which acquisition channels generate the most completed-order sales?
- How do completed sales and orders change over time?

## Verified headline findings

The figures below were reproduced from the repaired source files and count only
orders whose status is `Completed`:

| Metric | Result |
|---|---:|
| Completed-order sales | £82,397.95 |
| Completed orders | 189 |
| Average completed-order value | £435.97 |
| Purchasing customers | 60 |
| Repeat customers | 48 (80%) |
| Churned customers | 39 (65%) |
| At-risk customers | 7 (11.7%) |
| Active customers | 14 (23.3%) |

High Value customers generated £26,976.66, or 32.7% of completed-order sales.
Electronics produced £42,165.08, or 51.2% of completed-order sales. Social Media
was the highest-sales acquisition channel at £15,917.23. Laptop Pro 14 was the
highest-sales product at £26,372.78.

These are descriptive findings from synthetic data and should not be treated as
recommendations about a real organisation.

## Data quality repair

The raw sample contained 89 orders occurring before the associated signup date,
affecting 44 customers. The repair script moves only inconsistent signup dates
back to the customer's earliest recorded activity. It does not alter orders,
values, quantities, statuses or identifiers.

Both the unchanged source files and repaired analytical files are included:

- `data/raw/` — original selected source files
- `data/processed/` — chronologically consistent files used for analysis
- `python/repair_data.py` — reproducible repair and integrity checks
- `docs/validation_report.md` — repair rationale and check results

## Analytical model

```text
Customers (1) ─── (*) Orders (*) ─── (1) Products
                         |
                         *
                         |
                      (1) Date
```

Realised-sales measures include completed orders only. Cancelled and returned
orders remain available for operational analysis. The source `churn_flag`
contains three states—Active, At Risk and Churned—and the DAX measures preserve
that distinction.

## Repository structure

```text
├── data/
│   ├── raw/
│   └── processed/
├── docs/
│   ├── data_dictionary.md
│   └── validation_report.md
├── powerbi/
│   ├── Customer_Analysis.pbix
│   └── dax_measures.txt
├── python/
│   └── repair_data.py
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_data_quality_checks.sql
│   ├── 03_customer_sales_model.sql
│   ├── 04_customer_retention_summary.sql
│   └── 05_powerbi_kpi_queries.sql
└── requirements.txt
```

## Reproduce the project

1. Install Python dependencies with `pip install -r requirements.txt`.
2. Run `python python/repair_data.py` and confirm every post-repair integrity
   check is zero.
3. Upload the three files in `data/processed/` to BigQuery.
4. Replace `YOUR_PROJECT` in the SQL files with your Google Cloud project ID.
5. Run the SQL scripts in numerical order.
6. Connect Power BI to the resulting tables or views and create the documented
   relationships.
7. Add the measures from `powerbi/dax_measures.txt`.

## Power BI note

The included PBIX is a thin report connected to a Power BI Service semantic
model. The processed CSV files, SQL and DAX are the reproducible project assets;
opening the PBIX may require access to the associated online semantic model.

## Author

**Sophia Lumpa**  
Business Intelligence & Operations Analyst  
[Portfolio](https://www.virtavis.com/) · [GitHub](https://github.com/smlumpa)
