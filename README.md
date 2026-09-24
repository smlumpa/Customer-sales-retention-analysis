# Customer Sales & Retention Analysis

**SQL · BigQuery · Power BI · DAX · Customer Analytics**

An end-to-end portfolio project that analyses synthetic customer purchasing
behaviour, revenue performance, repeat purchasing, cohorts and retention. SQL
and BigQuery support the analytical pipeline, with the results presented in an
interactive Power BI dashboard.

> **Data declaration:** All records are synthetic sample data. Names are
> fictitious and no confidential client or employer information is included.

## Dashboard headline metrics

These figures match the published Power BI dashboard and were verified against
the original Power BI model exported in VPAX format:

| Dashboard KPI | Result | Definition |
|---|---:|---|
| Total Revenue | £104,317.21 | Sum of all recorded order values |
| Average Order Value | £412.32 | Total revenue divided by 253 distinct orders |
| Average Monthly Retention Rate | 78.03% | Average of the monthly retention-rate measure |
| Repeat Customers | 57 | Customers purchasing in a month after their cohort month |

The dashboard presents the first two values as **£104.32K** and **£412.32**, and
the retention measure as **78.0%**.

## Business questions

- Which customer segments generate the most value?
- How does revenue and order activity change over time?
- Which customers make purchases after their initial cohort month?
- How does retention vary across monthly cohorts?
- Which products, categories and acquisition channels perform most strongly?
- Where are potential churn or engagement risks visible?

## Dashboard measures

The headline measures are calculated from the `customer_transactions` view:

```DAX
Total Revenue =
SUM(customer_transactions[order_value])
```

```DAX
Avg Order Value =
DIVIDE(
    SUM(customer_transactions[order_value]),
    DISTINCTCOUNT(customer_transactions[order_id])
)
```

```DAX
Repeat Customers =
CALCULATE(
    DISTINCTCOUNT(customer_transactions[customer_id]),
    FILTER(
        customer_transactions,
        customer_transactions[Months Since Cohort] > 0
    )
)
```

```DAX
Average Retention Rate =
AVERAGEX(
    VALUES(customer_transactions[Month Name]),
    [Retention Rate]
)
```

See [the verified DAX measures](powerbi/dax_measures.txt) for the complete
portfolio measure set.

## Completed-order secondary analysis

The repository also includes a separate realised-sales convention that counts
only orders whose status is `Completed`. This produces:

| Secondary metric | Result |
|---|---:|
| Completed-order sales | £82,397.95 |
| Completed orders | 189 |
| Average completed-order value | £435.97 |
| Customers with more than one completed order | 48 (80% of purchasing customers) |

These figures answer a different question from the dashboard headline cards.
They are retained as a transparent secondary analysis rather than being
presented as replacements for the published dashboard figures.

## Data-quality repair

The raw sample contained 89 orders occurring before the associated signup date,
affecting 44 customers. The repair script moves only inconsistent signup dates
back to the customer's earliest recorded activity. It does not alter orders,
values, quantities, statuses or identifiers.

- `data/raw/` — unchanged selected source files
- `data/processed/` — chronologically consistent analytical files
- `python/repair_data.py` — reproducible repair and integrity checks
- `docs/validation_report.md` — definitions, reconciliation and check results

## Analytical model

```text
Customers (1) ─── (*) Orders (*) ─── (1) Products
                         |
                         └── Customer transaction and cohort views
```

The original Power BI model uses BigQuery tables and views including
`customer_transactions`, `customer_metrics`, `customer_cohorts` and
`customer_retention`.

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
2. Run `python python/repair_data.py` and confirm the integrity checks are zero.
3. Upload the three processed CSV files to BigQuery.
4. Replace `YOUR_PROJECT` in the SQL files with your Google Cloud project ID.
5. Run the SQL scripts in numerical order.
6. Connect Power BI to the resulting tables and views.
7. Create the documented relationships and add the verified DAX measures.

## Modelling note

The dashboard's average retention measure groups activity using
`Month Name`. Because the dataset spans 2023–2024, same-named months across
years can be combined. The published 78.03% result is reproducible from the
original model, but a future version could use a Year-Month field for more
precise chronological analysis.

## Author

**Sophia Lumpa**  
Business Intelligence & Operations Analyst  
[Portfolio](https://www.virtavis.com/) · [GitHub](https://github.com/smlumpa)
