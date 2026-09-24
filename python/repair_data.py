"""Repair chronological inconsistencies in the synthetic portfolio dataset.

The script preserves transaction facts. If a customer's recorded signup date
falls after their earliest order or last-active date, it moves signup_date back
to the earliest recorded activity date. The original files remain unchanged in
data/raw and repaired outputs are written to data/processed.
"""

from pathlib import Path

import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
PROCESSED = ROOT / "data" / "processed"


def main() -> None:
    customers = pd.read_csv(
        RAW / "customers.csv", parse_dates=["signup_date", "last_active_date"]
    )
    orders = pd.read_csv(RAW / "orders.csv", parse_dates=["order_date"])
    products = pd.read_csv(RAW / "products.csv")

    order_dates = orders.groupby("customer_id")["order_date"].agg(
        earliest_order="min", latest_order="max"
    )
    customers = customers.merge(order_dates, on="customer_id", how="left")

    original_signup = customers["signup_date"].copy()
    customers["signup_date"] = customers[
        ["signup_date", "last_active_date", "earliest_order"]
    ].min(axis=1)
    customers["last_active_date"] = customers[
        ["last_active_date", "latest_order"]
    ].max(axis=1)

    changed_signup = int((customers["signup_date"] != original_signup).sum())
    customers = customers.drop(columns=["earliest_order", "latest_order"])

    PROCESSED.mkdir(parents=True, exist_ok=True)
    customers.to_csv(PROCESSED / "customers.csv", index=False, date_format="%Y-%m-%d")
    orders.to_csv(PROCESSED / "orders.csv", index=False, date_format="%Y-%m-%d")
    products.to_csv(PROCESSED / "products.csv", index=False)

    merged = orders.merge(
        customers[["customer_id", "signup_date", "last_active_date"]],
        on="customer_id",
        how="left",
    )
    checks = {
        "customers": len(customers),
        "orders": len(orders),
        "products": len(products),
        "signup_dates_repaired": changed_signup,
        "orders_before_signup": int(
            (merged["order_date"] < merged["signup_date"]).sum()
        ),
        "orders_after_last_active": int(
            (merged["order_date"] > merged["last_active_date"]).sum()
        ),
        "duplicate_customer_ids": int(customers["customer_id"].duplicated().sum()),
        "duplicate_order_ids": int(orders["order_id"].duplicated().sum()),
        "duplicate_product_ids": int(products["product_id"].duplicated().sum()),
        "orphan_customer_keys": int(
            (~orders["customer_id"].isin(customers["customer_id"])).sum()
        ),
        "orphan_product_keys": int(
            (~orders["product_id"].isin(products["product_id"])).sum()
        ),
        "missing_values": int(
            customers.isna().sum().sum()
            + orders.isna().sum().sum()
            + products.isna().sum().sum()
        ),
        "non_positive_quantities": int((orders["quantity"] <= 0).sum()),
        "negative_order_values": int((orders["order_value"] < 0).sum()),
        "negative_discounts": int((orders["discount_amount"] < 0).sum()),
    }
    for name, value in checks.items():
        print(f"{name}: {value}")


if __name__ == "__main__":
    main()
